import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';
import '../../app/design/app_spacing.dart';
import '../../app/theme/theme_extensions.dart';
import '../../app/theme/typography_extensions.dart';

/// 项目统一玻璃按钮：无彩色按压光晕，标签样式来自 [AppTypographyTokens]。
class AppGlassButton extends StatelessWidget {
  const AppGlassButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.prominent = false,
    this.height = 48,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  /// 为 true 时按钮横向铺满父级，适合表单主操作。
  final bool expand;
  /// 主操作按钮使用 prominent 玻璃样式，视觉更重、更易识别。
  final bool prominent;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return FilledButton(onPressed: null, child: Text(label));
    }

    final glass = context.glass;
    final typography = context.typography;
    // prominent 主操作用大号按钮 token + 白字；次级按钮跟随系统 label 色。
    final textStyle = prominent
        ? typography.buttonLarge.copyWith(color: CupertinoColors.white)
        : typography.buttonMedium.copyWith(
            color: CupertinoColors.label.resolveFrom(context),
          );

    return lg.GlassButton.custom(
      onTap: onPressed!,
      label: label,
      width: expand ? double.infinity : null,
      height: height,
      style: prominent
          ? lg.GlassButtonStyle.prominent
          : lg.GlassButtonStyle.filled,
      stretch: 0.08,
      interactionScale: 1.02,
      shape: lg.LiquidRoundedSuperellipse(
        borderRadius: AppRadius.capsule(height),
      ),
      glowColor: Colors.transparent,
      glowOpacity: 0,
      glowBlurRadius: 0,
      settings: glass.surfaceSettings,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.xs)],
          Text(label, style: textStyle),
        ],
      ),
    );
  }
}
