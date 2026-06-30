import 'package:flutter/widgets.dart';

import '../design/app_sizing.dart';

/// 主 Tab Shell 为底部浮动导航预留的内容区底部间距。
///
/// 子页面通过 [bottomInsetOf] 读取该值，避免列表/网格被 TabBar 遮挡或挤出视口。
class MainTabBarScope extends InheritedWidget {
  const MainTabBarScope({required super.child, super.key})
    : bottomInset = AppSizing.mainTabBarReserveHeight;

  final double bottomInset;

  static double bottomInsetOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<MainTabBarScope>()
            ?.bottomInset ??
        0;
  }

  @override
  bool updateShouldNotify(MainTabBarScope oldWidget) {
    return bottomInset != oldWidget.bottomInset;
  }
}
