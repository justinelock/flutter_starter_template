import 'package:flutter/material.dart';

import '../design/app_breakpoints.dart';
import '../design/app_typography_scale.dart';
import 'app_typography_tokens.dart';

/// Typography 访问扩展，减少页面直接依赖 ThemeData 结构。
extension TypographyBuildContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  AppTypographyTokens get typography {
    final theme = Theme.of(this);
    return theme.extension<AppTypographyTokens>() ??
        AppTypographyTokens.build(
          colorScheme: theme.colorScheme,
          scale: AdaptiveTypographyScale.fromContext(this),
        );
  }

  double get textScale => MediaQuery.textScalerOf(this).scale(1);

  bool get isLargeText => textScale >= 1.2;

  AppLayoutSize get layoutClass {
    return AppBreakpoints.fromWidth(MediaQuery.sizeOf(this).width);
  }
}
