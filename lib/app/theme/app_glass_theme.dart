import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// 插件级玻璃主题：关闭语义色光晕，保留模糊/折射/形变等液态玻璃本体。
///
/// 项目交互规范要求按钮按压、底栏滑动时不出现主色/辅色光晕；
/// 通过 [GlassGlowColors.glowOpacity] 与透明语义色全局压制 [GlassGlow]。
class AppGlassTheme {
  const AppGlassTheme._();

  static const _noGlow = GlassGlowColors(
    primary: Colors.transparent,
    secondary: Colors.transparent,
    success: Colors.transparent,
    warning: Colors.transparent,
    danger: Colors.transparent,
    info: Colors.transparent,
    glowBlurRadius: 0,
    glowSpreadRadius: 0,
    glowOpacity: 0,
  );

  /// 根节点 [LiquidGlassWidgets.wrap] 注入，与 Material 亮暗模式同步。
  static const GlassThemeData data = GlassThemeData(
    light: GlassThemeVariant(glowColors: _noGlow),
    dark: GlassThemeVariant(glowColors: _noGlow),
  );
}
