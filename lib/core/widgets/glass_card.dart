import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';
import '../../app/design/app_spacing.dart';
import '../../app/theme/theme_extensions.dart';

/// 项目统一玻璃卡片，圆角对齐 iOS 26 [AppRadius.card]（20pt）。
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;

    return lg.GlassCard(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      shape: const lg.LiquidRoundedSuperellipse(borderRadius: AppRadius.card),
      settings: glass.surfaceSettings,
      useOwnLayer: true,
      child: child,
    );
  }
}
