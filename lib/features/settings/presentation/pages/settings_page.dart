import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/main_tab_navigation.dart';
import '../../../../core/constants/app_svg_assets.dart';
import '../../../../core/messaging/app_messenger.dart';
import '../../../../core/messaging/app_snackbar.dart';
import '../../../../core/widgets/app_tab_page.dart';
import '../../../../core/widgets/app_glass_app_bar.dart';
import '../../../../core/widgets/app_glass_icon_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/glass_list_tile.dart';
import '../../../../shared/providers/package_info_provider.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../version/presentation/widgets/update_dialog.dart';
import '../controllers/settings_controller.dart';
import '../widgets/locale_selector.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';

/// 设置页面 (SettingsPage)
/// 
/// 该页面聚合了应用级别的所有偏好设置，包括：
/// 1. 视觉：主题切换（亮色/暗色）。
/// 2. 国际化：语言切换。
/// 3. 系统：版本检查、缓存清理、环境信息展示。
/// 4. 账号：登出逻辑。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听环境配置（用于展示当前运行环境，如 Dev/Prod）
    final env = ref.watch(envConfigProvider);
    // 监听包信息（用于展示版本号）
    final packageInfo = ref.watch(packageInfoProvider);
    // 获取国际化资源快捷引用
    final l10n = context.l10n;

    // 使用 AppTabPage 统一样式，该组件自带了 Liquid Glass 设计系统的滚动和模糊效果。
    return AppTabPage(
      appBar: AppGlassAppBar(
        title: l10n.settings,
        leading: AppGlassIconButton(
          // 返回首页 Tab。使用 switchMainTab 而不是 context.pop，
          // 因为在 StatefulShellRoute 中切换分支比销毁页面更平滑。
          onPressed: () => switchMainTab(context, 0),
          icon: const AppSvgIcon(assetPath: AppSvgAssets.arrowBack),
        ),
      ),
      body: PageContainer(
        maxWidth: 760, // 限制最大宽度，确保在大屏或 Web 端具有良好的可阅读性。
        child: ListView(
          children: [
            // 主题设置区域
            SettingsSection(
              title: l10n.themeSection,
              children: const [ThemeSelector()],
            ),
            const SizedBox(height: 16),
            
            // 语言设置区域
            SettingsSection(
              title: l10n.languageSection,
              children: const [LocaleSelector()],
            ),
            const SizedBox(height: 16),
            
            // 应用系统区域
            SettingsSection(
              title: l10n.appSection,
              grouped: true, // 开启分组模式，子项目之间会自动添加分割线并处理圆角。
              children: [
                // 异步展示当前版本号
                packageInfo.when(
                  data: (info) => AppGlassListTile(
                    title: l10n.versionLabel,
                    subtitle: '${info.version}+${info.buildNumber}',
                  ),
                  error: (error, stackTrace) => AppGlassListTile(
                    title: l10n.versionLabel,
                    subtitle: l10n.packageInfoLoadFailed,
                  ),
                  loading: () => AppGlassListTile(
                    title: l10n.versionLabel,
                    subtitle: l10n.loading,
                  ),
                ),
                
                // 展示当前 API 环境
                AppGlassListTile(
                  title: l10n.environmentLabel,
                  subtitle: env.environment.name,
                ),
                
                // 检查更新功能
                AppGlassListTile(
                  title: l10n.checkUpdates,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.arrowRight),
                  onTap: () async {
                    try {
                      // 手动触发版本检查流程
                      final info = await ref
                          .read(settingsControllerProvider)
                          .checkUpdate();

                      if (!context.mounted) return;

                      // 如果当前已经是最新版本，通过提示框告知用户，避免交互反馈缺失。
                      if (!info.hasUpdate) {
                        ref.read(appMessengerProvider).show(l10n.noUpdates);
                        return;
                      }

                      // 发现新版本时弹出更新对话框。
                      // 如果是强制更新 (forceUpdate)，点击外部无法关闭。
                      await showDialog<UpdateDialogAction>(
                        context: context,
                        barrierDismissible: !info.forceUpdate,
                        builder: (context) => UpdateDialog(info: info),
                      );
                    } catch (_) {
                      // 网络或解析失败时，向用户展示错误提示。
                      if (context.mounted) {
                        ref
                            .read(appMessengerProvider)
                            .show(
                              l10n.updateCheckFailed,
                              type: AppSnackBarType.error,
                            );
                      }
                    }
                  },
                ),
                
                // 清理缓存功能
                AppGlassListTile(
                  title: l10n.clearCache,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.trash),
                  onTap: () async {
                    // 调用控制器清理本地持久化数据（如 SharedPreferences）。
                    await ref.read(settingsControllerProvider).clearCache();

                    if (context.mounted) {
                      ref
                          .read(appMessengerProvider)
                          .show(
                            l10n.cacheCleared,
                            type: AppSnackBarType.success,
                          );
                    }
                  },
                ),
                
                // 退出登录
                AppGlassListTile(
                  title: l10n.logout,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.exit),
                  isLast: true,
                  onTap: () async {
                    // 1. 清理 Session 和 Token。
                    await ref.read(settingsControllerProvider).logout();

                    // 2. 跳转回登录页。由于 routerProvider 监听了 Auth 状态，
                    // 此处即使不调用 go，路由守卫也会自动将用户踢回登录页，
                    // 但显式调用 go 可以确保路径切换的即时感。
                    if (context.mounted) {
                      ref
                          .read(appMessengerProvider)
                          .show(
                            l10n.logoutSuccess,
                            type: AppSnackBarType.success,
                          );
                      context.go(AppRoutes.login);
                    }
                  },
                ),
              ],
            ),
            
            // 调试面板：仅在非生产环境显示，用于快速查看功能旗标 (FeatureFlags) 状态。
            if (env.featureFlags.enableDebugPanel) ...[
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.debugFeatureFlags,
                grouped: true,
                children: env.featureFlags
                    .toMap(enableMock: env.enableMock)
                    .entries
                    .map(
                      (entry) => AppGlassListTile(
                        title: entry.key,
                        trailing: Text(entry.value.toString()),
                        isLast: entry.key ==
                            env.featureFlags
                                .toMap(enableMock: env.enableMock)
                                .entries
                                .last
                                .key,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
