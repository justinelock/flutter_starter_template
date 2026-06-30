import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';

/// 项目统一玻璃图标按钮，默认圆形；方角形态对齐 iOS 26 [AppRadius.button]。
class AppGlassIconButton extends StatelessWidget {
  const AppGlassIconButton({
    required this.icon,
    required this.onPressed,
    this.shape = lg.GlassIconButtonShape.circle,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final lg.GlassIconButtonShape shape;

  @override
  Widget build(BuildContext context) {
    return lg.GlassIconButton(
      icon: icon,
      onPressed: onPressed,
      shape: shape,
      borderRadius: AppRadius.button,
      glowColor: Colors.transparent,
    );
  }
}
