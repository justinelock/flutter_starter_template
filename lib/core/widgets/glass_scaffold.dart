import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/theme/theme_extensions.dart';

/// 项目统一脚手架：背景渐变 + `liquid_glass_widgets` 的 [lg.GlassScaffold]。
class AppGlassScaffold extends StatelessWidget {
  const AppGlassScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    /// 页面级渐变；未指定时回退到 [AppGradients.appBackground]。
    this.backgroundGradient,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Gradient? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;
    final gradient = backgroundGradient ?? context.gradients.appBackground;

    final background = DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
    );

    return lg.GlassScaffold(
      background: background,
      settings: glass.pageSettings,
      body: body,
      appBar: appBar,
      bottomBar: bottomNavigationBar,
    );
  }
}
