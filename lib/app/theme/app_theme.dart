import 'package:flutter/material.dart';

import '../design/app_radius.dart';
import '../design/app_typography_scale.dart';
import 'app_color_schemes.dart';
import 'app_color_tokens.dart';
import 'app_glass_tokens.dart';
import 'app_gradients.dart';
import 'app_text_theme.dart';
import 'app_typography_tokens.dart';

/// 应用 Material 主题：手写 [ColorScheme] + ThemeExtension token + 组件级主题。
class AppTheme {
  const AppTheme._();

  static ThemeData light([BuildContext? context]) {
    return _build(
      AppColorSchemes.light,
      scale: _scaleFor(context, Brightness.light),
    );
  }

  static ThemeData dark([BuildContext? context]) {
    return _build(
      AppColorSchemes.dark,
      scale: _scaleFor(context, Brightness.dark),
    );
  }

  static AdaptiveTypographyScale _scaleFor(
    BuildContext? context,
    Brightness brightness,
  ) {
    return context == null
        ? AdaptiveTypographyScale.fallback(brightness: brightness)
        : AdaptiveTypographyScale.fromContext(context);
  }

  static ThemeData _build(
    ColorScheme colorScheme, {
    required AdaptiveTypographyScale scale,
  }) {
    final textTheme = AppTextTheme.build(
      colorScheme: colorScheme,
      scale: scale,
    );
    final typographyTokens = AppTypographyTokens.build(
      colorScheme: colorScheme,
      scale: scale,
    );
    final colorTokens = colorScheme.brightness == Brightness.dark
        ? AppColorTokens.dark
        : AppColorTokens.light;
    final glassTokens = colorScheme.brightness == Brightness.dark
        ? AppGlassTokens.dark
        : AppGlassTokens.light;
    final gradients = colorScheme.brightness == Brightness.dark
        ? AppGradients.dark
        : AppGradients.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorTokens.backgroundBase,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: [colorTokens, glassTokens, gradients, typographyTokens],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: typographyTokens.pageTitle,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorTokens.cardBackground,
        shadowColor: colorTokens.cardShadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: colorTokens.cardBorder),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorTokens.backgroundFloating,
        barrierColor: colorTokens.modalBarrier,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        titleTextStyle: typographyTokens.dialogTitle,
        contentTextStyle: typographyTokens.dialogBody,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorTokens.backgroundFloating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.toast),
          side: BorderSide(color: colorTokens.cardBorder),
        ),
        contentTextStyle: typographyTokens.toastText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorTokens.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorTokens.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorTokens.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorTokens.inputFocusedBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colorTokens.inputErrorBorder),
        ),
        labelStyle: typographyTokens.formLabel,
        hintStyle: typographyTokens.inputPlaceholder,
        errorStyle: typographyTokens.errorText,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: typographyTokens.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: typographyTokens.buttonMedium,
          side: BorderSide(color: colorTokens.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorTokens.link,
          textStyle: typographyTokens.buttonMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          focusColor: colorTokens.focusRing,
          hoverColor: colorTokens.hoverOverlay,
          highlightColor: colorTokens.pressedOverlay,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHigh,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorTokens.cardBackgroundMuted,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorTokens.disabledBackground,
        labelStyle: typographyTokens.formLabel,
        secondaryLabelStyle: typographyTokens.formLabel.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        side: BorderSide(color: colorTokens.cardBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      dividerTheme: DividerThemeData(
        color: colorTokens.divider,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorTokens.backgroundFloating,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorTokens.textSecondary;
          return typographyTokens.navLabel.copyWith(color: color);
        }),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorTokens.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorTokens.backgroundFloating,
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorTokens.textSecondary),
        selectedLabelTextStyle: typographyTokens.navLabel.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelTextStyle: typographyTokens.navLabel.copyWith(
          color: colorTokens.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          textStyle: typographyTokens.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorTokens.focusRing,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorTokens.backgroundElevated,
          borderRadius: BorderRadius.circular(AppRadius.control),
          border: Border.all(color: colorTokens.cardBorder),
        ),
        textStyle: typographyTokens.caption.copyWith(
          color: colorTokens.textPrimary,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: typographyTokens.badgeText,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorTokens.backgroundFloating,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorTokens.textSecondary,
        selectedLabelStyle: typographyTokens.navLabel,
        unselectedLabelStyle: typographyTokens.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
