import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';
import '../../app/design/app_spacing.dart';

/// 项目统一玻璃按钮，文本类操作使用 [lg.GlassButton.custom] 正确渲染标签。
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

    final colorScheme = Theme.of(context).colorScheme;
    // 跟随 iOS 26 / liquid_glass_widgets 对话框配色：次级用 label，主操作用白字。
    final labelColor = prominent
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);
    final textStyle = TextStyle(
      fontSize: 15,
      fontWeight: prominent ? FontWeight.w700 : FontWeight.w600,
      color: labelColor,
    );
    final glowColor = prominent
        ? colorScheme.primary.withValues(alpha: 0.38)
        : CupertinoColors.label.resolveFrom(context).withValues(alpha: 0.14);

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
      glowColor: glowColor,
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
