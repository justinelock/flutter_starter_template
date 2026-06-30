import 'package:flutter/material.dart';

import '../../core/constants/app_svg_assets.dart';
import '../../core/widgets/app_svg_icon.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
      ),
      // Logo 使用 SVG 资源，在渐变背景上以 onPrimary 着色保证对比度。
      child: Center(
        child: AppSvgIcon(
          assetPath: AppSvgAssets.logo,
          size: size * 0.46,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
