import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/main_tab_navigation.dart';
import '../../../../core/constants/app_svg_assets.dart';
import '../../../../core/widgets/app_tab_page.dart';
import '../../../../core/widgets/app_glass_app_bar.dart';
import '../../../../core/widgets/app_glass_icon_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_glass_icon_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../shared/providers/package_info_provider.dart';
import '../../../../shared/providers/platform_provider.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../../shared/providers/platform_provider.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/home_info_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final env = ref.watch(envConfigProvider);
    final platform = ref.watch(platformNameProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final l10n = context.l10n;

    // 首页聚合展示运行环境信息，所有卡片标题通过 l10n 获取以支持运行时语言切换。
    return AppTabPage(
      appBar: AppGlassAppBar(
        title: l10n.home,
        actions: [
          AppGlassIconButton(
            onPressed: () => switchMainTab(context, 1),
            icon: const AppSvgIcon(assetPath: AppSvgAssets.settings),
          ),
        ],
      ),
      body: PageContainer(
        child: packageInfo.when(
          data: (info) {
            final cards = <Widget>[
              HomeInfoCard(
                title: l10n.userLabel,
                value: user?.email ?? l10n.guestUser,
                iconAsset: AppSvgAssets.user,
              ),
              HomeInfoCard(
                title: l10n.environmentLabel,
                value: env.environment.name,
                iconAsset: AppSvgAssets.plugin,
              ),
              HomeInfoCard(
                title: l10n.platformLabel,
                value: platform,
                iconAsset: AppSvgAssets.phone,
              ),
              HomeInfoCard(
                title: l10n.versionLabel,
                value: '${info.version}+${info.buildNumber}',
                iconAsset: AppSvgAssets.download,
              ),
              if (env.featureFlags.enableDebugPanel)
                HomeInfoCard(
                  title: l10n.featureFlags,
                  value: env.featureFlags
                      .toMap()
                      .entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join('\n'),
                  iconAsset: AppSvgAssets.stars,
                ),
            ];

            // 使用 ListView 按内容自适应高度，避免 Grid 固定行高导致卡片内文字溢出。
            return ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => cards[index],
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
