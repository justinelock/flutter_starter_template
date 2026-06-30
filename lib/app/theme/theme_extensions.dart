import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_glass_tokens.dart';
import 'app_gradients.dart';

extension AppThemeBuildContext on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  AppColorTokens get colors {
    return Theme.of(this).extension<AppColorTokens>() ??
        (Theme.of(this).brightness == Brightness.dark
            ? AppColorTokens.dark
            : AppColorTokens.light);
  }

  AppGlassTokens get glass {
    return Theme.of(this).extension<AppGlassTokens>() ??
        (Theme.of(this).brightness == Brightness.dark
            ? AppGlassTokens.dark
            : AppGlassTokens.light);
  }

  AppGradients get gradients {
    return Theme.of(this).extension<AppGradients>() ??
        (Theme.of(this).brightness == Brightness.dark
            ? AppGradients.dark
            : AppGradients.light);
  }

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
