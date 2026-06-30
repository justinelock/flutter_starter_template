import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/theme_extensions.dart';
import '../../core/widgets/glass_scaffold.dart';
import '../../shared/widgets/app_bottom_navigation.dart';

/// 主 Tab 外壳：Shell 级 [AppGlassScaffold] 承载唯一底栏，保证 iOS 26 透明玻璃效果。
///
/// 底栏必须作为 [GlassScaffold.bottomBar] 渲染，才能与页面内容处于同一玻璃层并
/// 正确折射背景；若用 Stack 浮在外层，会出现不透明底衬和过大底部间距。
class MainTabShell extends StatelessWidget {
  const MainTabShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // 步骤 1：按当前 Tab 切换 Shell 背景渐变，与文档 home/settings 语义对齐。
    final gradients = context.gradients;
    final backgroundGradient = navigationShell.currentIndex == 0
        ? gradients.home
        : gradients.settings;

    return AppGlassScaffold(
      backgroundGradient: backgroundGradient,
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        key: const ValueKey('main_bottom_navigation'),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
