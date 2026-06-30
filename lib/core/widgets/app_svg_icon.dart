import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 统一封装 SVG 图标渲染，支持按主题色着色以适配亮色/暗色模式。
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    required this.assetPath,
    this.size = 24,
    this.color,
    super.key,
  });

  final String assetPath;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // 未显式传色时优先读取 IconTheme（如 GlassTabBar 会为选中/未选中注入颜色），
    // 再回退到主题前景色，保证 SVG 与 Material Icon 在玻璃导航栏中表现一致。
    final effectiveColor = color ??
        IconTheme.of(context).color ??
        Theme.of(context).colorScheme.onSurface;

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
