import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';
import '../../app/design/app_spacing.dart';
import '../../app/theme/theme_extensions.dart';

/// 项目统一玻璃按钮：无彩色按压光晕，仅保留液态玻璃形变与模糊。
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
    // 跟随 iOS 26 / liquid_glass_widgets 对话框配色：次级用 label，主操作用白字。
    final labelColor = prominent
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);
    final textStyle = TextStyle(
      fontSize: 15,
      fontWeight: prominent ? FontWeight.w700 : FontWeight.w600,
      color: labelColor,
    );

    // iOS 26 主操作按钮为胶囊形（圆角 = 高度 / 2），与系统 CTA 一致。
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
      // 关闭 GlassGlow 彩色光晕；玻璃 shader 侧 glowIntensity 亦置 0。
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
