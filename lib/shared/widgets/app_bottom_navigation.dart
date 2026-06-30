import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../app/design/app_radius.dart';
import '../../app/design/app_sizing.dart';
import '../../app/localization/l10n_extensions.dart';
import '../../core/constants/app_svg_assets.dart';
import '../../core/widgets/app_svg_icon.dart';

/// 应用底部主导航，使用 `liquid_glass_widgets` 的 iOS 26 液态玻璃 [GlassTabBar]。
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final verticalPadding = isIos
        ? AppSizing.tabBarVerticalPaddingIos
        : AppSizing.tabBarVerticalPaddingAndroid;

    // GlassTabBar.bottom 必须作为 Scaffold 底部栏使用，由 AppGlassScaffold 传入 bottomBar。
    return GlassTabBar.bottom(
      barBorderRadius: AppRadius.tabBar,
      // iOS 使用包默认 20pt 底边距，胶囊浮于 Home Indicator 上方；Android 略收紧。
      verticalPadding: verticalPadding,
      horizontalPadding: 20,
      selectedIndex: selectedIndex,
      onTabSelected: onDestinationSelected,
      selectedIconColor: colorScheme.primary,
      unselectedIconColor: colorScheme.onSurfaceVariant,
      selectedLabelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      tabs: [
        GlassTab(
          label: l10n.home,
          icon: const AppSvgIcon(assetPath: AppSvgAssets.home),
          activeIcon: const AppSvgIcon(assetPath: AppSvgAssets.homeActive),
          glowColor: colorScheme.primary,
        ),
        GlassTab(
          label: l10n.settings,
          icon: const AppSvgIcon(assetPath: AppSvgAssets.settings),
          activeIcon: const AppSvgIcon(assetPath: AppSvgAssets.settings),
          glowColor: colorScheme.secondary,
        ),
      ],
    );
  }
}
