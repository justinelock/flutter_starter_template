import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/main_tab_navigation.dart';
import '../../../../app/theme/typography_extensions.dart';
import '../../../../core/constants/app_svg_assets.dart';
import '../../../../core/widgets/app_tab_page.dart';
import '../../../../core/widgets/app_glass_app_bar.dart';
import '../../../../core/widgets/app_glass_icon_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/home_info_card.dart';

/// 首页占位：展示欢迎文案与当前用户，业务内容请在 fork 后替换。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final l10n = context.l10n;
    final typography = context.typography;

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
        child: ListView(
          children: [
            Text(l10n.homeWelcomeTitle, style: typography.pageTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.homeWelcomeSubtitle, style: typography.cardSubtitle),
            const SizedBox(height: AppSpacing.lg),
            HomeInfoCard(
              title: l10n.userLabel,
              value: user?.displayName ?? l10n.guestUser,
              iconAsset: AppSvgAssets.user,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.homeGettingStartedHint, style: typography.helperText),
          ],
        ),
      ),
    );
  }
}
