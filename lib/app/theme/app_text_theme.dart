import 'package:flutter/material.dart';

import '../design/app_typography_scale.dart';

/// Material 3 TextTheme，基于 iOS 26 / iPhone 17 Pro compact 视觉密度。
class AppTextTheme {
  const AppTextTheme._();

  static const List<String> fontFamilyFallback = [
    'SF Pro Text',
    'SF Pro Display',
    'PingFang SC',
    'Roboto',
    'Noto Sans CJK SC',
    'Microsoft YaHei',
    'Segoe UI',
    'Arial',
    'sans-serif',
  ];

  static TextTheme build({
    required Brightness brightness,
    required AdaptiveTypographyScale scale,
  }) {
    final color = brightness == Brightness.dark
        ? const Color(0xFFE8ECF3)
        : const Color(0xFF111827);

    TextStyle style({
      required double size,
      required double height,
      required FontWeight weight,
      required double letterSpacing,
      bool isControl = false,
      bool isReading = false,
    }) {
      final scaledSize = isControl
          ? scale.control(size)
          : isReading
              ? scale.reading(size)
              : scale.content(size);

      return TextStyle(
        inherit: true,
        fontSize: scaledSize,
        height: height,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
        fontFamilyFallback: fontFamilyFallback,
      );
    }

    return TextTheme(
      displayLarge: style(
        size: 40,
        height: 1.12,
        weight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      displayMedium: style(
        size: 36,
        height: 1.13,
        weight: FontWeight.w800,
        letterSpacing: -0.7,
      ),
      displaySmall: style(
        size: 32,
        height: 1.15,
        weight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineLarge: style(
        size: 30,
        height: 1.16,
        weight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: style(
        size: 27,
        height: 1.18,
        weight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineSmall: style(
        size: 24,
        height: 1.20,
        weight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: style(
        size: 22,
        height: 1.24,
        weight: FontWeight.w700,
        letterSpacing: -0.25,
      ),
      titleMedium: style(
        size: 18,
        height: 1.30,
        weight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: style(
        size: 16,
        height: 1.32,
        weight: FontWeight.w600,
        letterSpacing: 0,
      ),
      bodyLarge: style(
        size: 17,
        height: 1.48,
        weight: FontWeight.w400,
        letterSpacing: 0,
        isReading: true,
      ),
      bodyMedium: style(
        size: 16,
        height: 1.48,
        weight: FontWeight.w400,
        letterSpacing: 0,
        isReading: true,
      ),
      bodySmall: style(
        size: 14,
        height: 1.42,
        weight: FontWeight.w400,
        letterSpacing: 0.05,
        isReading: true,
      ),
      labelLarge: style(
        size: 15,
        height: 1.22,
        weight: FontWeight.w600,
        letterSpacing: 0.1,
        isControl: true,
      ),
      labelMedium: style(
        size: 13,
        height: 1.24,
        weight: FontWeight.w600,
        letterSpacing: 0.15,
        isControl: true,
      ),
      labelSmall: style(
        size: 11.5,
        height: 1.28,
        weight: FontWeight.w600,
        letterSpacing: 0.2,
        isControl: true,
      ),
    );
  }
}
