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

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envConfigProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final l10n = context.l10n;

    return AppTabPage(
      appBar: AppGlassAppBar(
        title: l10n.settings,
        leading: AppGlassIconButton(
          onPressed: () => switchMainTab(context, 0),
          icon: const AppSvgIcon(assetPath: AppSvgAssets.arrowBack),
        ),
      ),
      body: PageContainer(
        maxWidth: 760,
        child: ListView(
          children: [
            SettingsSection(
              title: l10n.themeSection,
              children: const [ThemeSelector()],
            ),
            const SizedBox(height: 16),
            SettingsSection(
              title: l10n.languageSection,
              children: const [LocaleSelector()],
            ),
            const SizedBox(height: 16),
            SettingsSection(
              title: l10n.appSection,
              grouped: true,
              children: [
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
                AppGlassListTile(
                  title: l10n.environmentLabel,
                  subtitle: env.environment.name,
                ),
                AppGlassListTile(
                  title: l10n.checkUpdates,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.arrowRight),
                  onTap: () async {
                    try {
                      // 步骤 1：触发版本检查；设置页手动检查使用当前页面 context 弹出更新对话框。
                      final info = await ref
                          .read(settingsControllerProvider)
                          .checkUpdate();

                      if (!context.mounted) return;

                      // 步骤 2：没有更新时主动反馈，避免用户误以为点击无效。
                      if (!info.hasUpdate) {
                        ref.read(appMessengerProvider).show(l10n.noUpdates);
                        return;
                      }

                      // 步骤 3：发现更新时阻塞当前操作，用户选择后对话框自行关闭或保持强制更新。
                      await showDialog<UpdateDialogAction>(
                        context: context,
                        barrierDismissible: !info.forceUpdate,
                        builder: (context) => UpdateDialog(info: info),
                      );
                    } catch (_) {
                      // 步骤 3：检查失败时显示用户友好消息，不暴露底层网络或解析异常。
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
                AppGlassListTile(
                  title: l10n.clearCache,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.trash),
                  onTap: () async {
                    // 步骤 1：先清理普通缓存；安全存储由退出登录等认证流程单独控制。
                    await ref.read(settingsControllerProvider).clearCache();

                    // 步骤 2：清理完成后给用户明确反馈。
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
                AppGlassListTile(
                  title: l10n.logout,
                  trailing: const AppSvgIcon(assetPath: AppSvgAssets.exit),
                  isLast: true,
                  onTap: () async {
                    // 步骤 1：先交给 SettingsController 清理认证状态和本地缓存。
                    await ref.read(settingsControllerProvider).logout();

                    // 步骤 2：页面仍然挂载时再跳转，避免异步完成后使用失效 context。
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
            if (env.featureFlags.enableDebugPanel) ...[
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.debugFeatureFlags,
                grouped: true,
                children: env.featureFlags
                    .toMap()
                    .entries
                    .map(
                      (entry) => AppGlassListTile(
                        title: entry.key,
                        trailing: Text(entry.value.toString()),
                        isLast: entry.key ==
                            env.featureFlags.toMap().entries.last.key,
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
