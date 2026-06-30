import 'package:flutter/material.dart';

import '../design/app_typography_scale.dart';
import 'app_text_theme.dart';

/// App 业务语义 Typography token。
///
/// 页面和组件应优先从 [ThemeData.extension] 获取这些语义样式，避免硬编码字号。
@immutable
class AppTypographyTokens extends ThemeExtension<AppTypographyTokens> {
  const AppTypographyTokens({
    required this.heroTitle,
    required this.pageTitle,
    required this.sectionTitle,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.formLabel,
    required this.inputText,
    required this.inputPlaceholder,
    required this.buttonLarge,
    required this.buttonMedium,
    required this.buttonSmall,
    required this.navLabel,
    required this.tabLabel,
    required this.badgeText,
    required this.caption,
    required this.helperText,
    required this.errorText,
    required this.toastText,
    required this.dialogTitle,
    required this.dialogBody,
    required this.updateTitle,
    required this.updateVersion,
    required this.updateDescription,
    required this.codeText,
  });

  final TextStyle heroTitle;
  final TextStyle pageTitle;
  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle cardSubtitle;
  final TextStyle formLabel;
  final TextStyle inputText;
  final TextStyle inputPlaceholder;
  final TextStyle buttonLarge;
  final TextStyle buttonMedium;
  final TextStyle buttonSmall;
  final TextStyle navLabel;
  final TextStyle tabLabel;
  final TextStyle badgeText;
  final TextStyle caption;
  final TextStyle helperText;
  final TextStyle errorText;
  final TextStyle toastText;
  final TextStyle dialogTitle;
  final TextStyle dialogBody;
  final TextStyle updateTitle;
  final TextStyle updateVersion;
  final TextStyle updateDescription;
  final TextStyle codeText;

  static AppTypographyTokens build({
    required ColorScheme colorScheme,
    required AdaptiveTypographyScale scale,
  }) {
    final primary = colorScheme.onSurface;
    final secondary = colorScheme.onSurfaceVariant;
    final placeholder = colorScheme.onSurfaceVariant.withValues(alpha: 0.70);

    TextStyle style({
      required double size,
      required double height,
      required FontWeight weight,
      required double letterSpacing,
      required Color color,
      bool isControl = false,
      bool isReading = false,
      List<String>? fontFamilyFallback,
    }) {
      final scaledSize = isControl
          ? scale.control(size)
          : isReading
              ? scale.reading(size)
              : scale.content(size);

      return TextStyle(
        fontSize: scaledSize,
        height: height,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
        fontFamilyFallback:
            fontFamilyFallback ?? AppTextTheme.fontFamilyFallback,
      );
    }

    return AppTypographyTokens(
      heroTitle: style(
        size: 34,
        height: 1.14,
        weight: FontWeight.w800,
        letterSpacing: -0.7,
        color: primary,
      ),
      pageTitle: style(
        size: 28,
        height: 1.18,
        weight: FontWeight.w700,
        letterSpacing: -0.45,
        color: primary,
      ),
      sectionTitle: style(
        size: 20,
        height: 1.24,
        weight: FontWeight.w700,
        letterSpacing: -0.2,
        color: primary,
      ),
      cardTitle: style(
        size: 18,
        height: 1.30,
        weight: FontWeight.w700,
        letterSpacing: -0.1,
        color: primary,
      ),
      cardSubtitle: style(
        size: 14,
        height: 1.44,
        weight: FontWeight.w500,
        letterSpacing: 0,
        color: secondary,
        isReading: true,
      ),
      formLabel: style(
        size: 14,
        height: 1.25,
        weight: FontWeight.w600,
        letterSpacing: 0.05,
        color: secondary,
        isControl: true,
      ),
      inputText: style(
        size: 16,
        height: 1.30,
        weight: FontWeight.w500,
        letterSpacing: 0,
        color: primary,
        isControl: true,
      ),
      inputPlaceholder: style(
        size: 16,
        height: 1.30,
        weight: FontWeight.w400,
        letterSpacing: 0,
        color: placeholder,
        isControl: true,
      ),
      buttonLarge: style(
        size: 16,
        height: 1.20,
        weight: FontWeight.w700,
        letterSpacing: 0.1,
        color: primary,
        isControl: true,
      ),
      buttonMedium: style(
        size: 15,
        height: 1.20,
        weight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primary,
        isControl: true,
      ),
      buttonSmall: style(
        size: 13,
        height: 1.22,
        weight: FontWeight.w600,
        letterSpacing: 0.15,
        color: primary,
        isControl: true,
      ),
      navLabel: style(
        size: 12,
        height: 1.22,
        weight: FontWeight.w600,
        letterSpacing: 0.15,
        color: secondary,
        isControl: true,
      ),
      tabLabel: style(
        size: 13,
        height: 1.18,
        weight: FontWeight.w700,
        letterSpacing: 0.05,
        color: secondary,
        isControl: true,
      ),
      badgeText: style(
        size: 11,
        height: 1.15,
        weight: FontWeight.w700,
        letterSpacing: 0.1,
        color: primary,
        isControl: true,
      ),
      caption: style(
        size: 12,
        height: 1.35,
        weight: FontWeight.w500,
        letterSpacing: 0.05,
        color: secondary,
        isControl: true,
      ),
      helperText: style(
        size: 12,
        height: 1.38,
        weight: FontWeight.w500,
        letterSpacing: 0,
        color: secondary,
        isControl: true,
      ),
      errorText: style(
        size: 12.5,
        height: 1.36,
        weight: FontWeight.w600,
        letterSpacing: 0,
        color: colorScheme.error,
        isControl: true,
      ),
      toastText: style(
        size: 14,
        height: 1.36,
        weight: FontWeight.w600,
        letterSpacing: 0,
        color: primary,
        isReading: true,
      ),
      dialogTitle: style(
        size: 21,
        height: 1.22,
        weight: FontWeight.w700,
        letterSpacing: -0.25,
        color: primary,
      ),
      dialogBody: style(
        size: 15,
        height: 1.48,
        weight: FontWeight.w400,
        letterSpacing: 0,
        color: secondary,
        isReading: true,
      ),
      updateTitle: style(
        size: 22,
        height: 1.20,
        weight: FontWeight.w800,
        letterSpacing: -0.35,
        color: primary,
      ),
      updateVersion: style(
        size: 13,
        height: 1.25,
        weight: FontWeight.w600,
        letterSpacing: 0.05,
        color: secondary,
        isControl: true,
      ),
      updateDescription: style(
        size: 15,
        height: 1.48,
        weight: FontWeight.w500,
        letterSpacing: 0,
        color: primary,
        isReading: true,
      ),
      codeText: style(
        size: 13,
        height: 1.42,
        weight: FontWeight.w500,
        letterSpacing: 0,
        color: primary,
        fontFamilyFallback: const [
          'SF Mono',
          'Menlo',
          'Consolas',
          'Roboto Mono',
          'monospace',
        ],
      ),
    );
  }

  @override
  AppTypographyTokens copyWith({
    TextStyle? heroTitle,
    TextStyle? pageTitle,
    TextStyle? sectionTitle,
    TextStyle? cardTitle,
    TextStyle? cardSubtitle,
    TextStyle? formLabel,
    TextStyle? inputText,
    TextStyle? inputPlaceholder,
    TextStyle? buttonLarge,
    TextStyle? buttonMedium,
    TextStyle? buttonSmall,
    TextStyle? navLabel,
    TextStyle? tabLabel,
    TextStyle? badgeText,
    TextStyle? caption,
    TextStyle? helperText,
    TextStyle? errorText,
    TextStyle? toastText,
    TextStyle? dialogTitle,
    TextStyle? dialogBody,
    TextStyle? updateTitle,
    TextStyle? updateVersion,
    TextStyle? updateDescription,
    TextStyle? codeText,
  }) {
    return AppTypographyTokens(
      heroTitle: heroTitle ?? this.heroTitle,
      pageTitle: pageTitle ?? this.pageTitle,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      cardTitle: cardTitle ?? this.cardTitle,
      cardSubtitle: cardSubtitle ?? this.cardSubtitle,
      formLabel: formLabel ?? this.formLabel,
      inputText: inputText ?? this.inputText,
      inputPlaceholder: inputPlaceholder ?? this.inputPlaceholder,
      buttonLarge: buttonLarge ?? this.buttonLarge,
      buttonMedium: buttonMedium ?? this.buttonMedium,
      buttonSmall: buttonSmall ?? this.buttonSmall,
      navLabel: navLabel ?? this.navLabel,
      tabLabel: tabLabel ?? this.tabLabel,
      badgeText: badgeText ?? this.badgeText,
      caption: caption ?? this.caption,
      helperText: helperText ?? this.helperText,
      errorText: errorText ?? this.errorText,
      toastText: toastText ?? this.toastText,
      dialogTitle: dialogTitle ?? this.dialogTitle,
      dialogBody: dialogBody ?? this.dialogBody,
      updateTitle: updateTitle ?? this.updateTitle,
      updateVersion: updateVersion ?? this.updateVersion,
      updateDescription: updateDescription ?? this.updateDescription,
      codeText: codeText ?? this.codeText,
    );
  }

  @override
  AppTypographyTokens lerp(
    ThemeExtension<AppTypographyTokens>? other,
    double t,
  ) {
    if (other is! AppTypographyTokens) return this;
    return AppTypographyTokens(
      heroTitle: TextStyle.lerp(heroTitle, other.heroTitle, t)!,
      pageTitle: TextStyle.lerp(pageTitle, other.pageTitle, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      cardSubtitle: TextStyle.lerp(cardSubtitle, other.cardSubtitle, t)!,
      formLabel: TextStyle.lerp(formLabel, other.formLabel, t)!,
      inputText: TextStyle.lerp(inputText, other.inputText, t)!,
      inputPlaceholder:
          TextStyle.lerp(inputPlaceholder, other.inputPlaceholder, t)!,
      buttonLarge: TextStyle.lerp(buttonLarge, other.buttonLarge, t)!,
      buttonMedium: TextStyle.lerp(buttonMedium, other.buttonMedium, t)!,
      buttonSmall: TextStyle.lerp(buttonSmall, other.buttonSmall, t)!,
      navLabel: TextStyle.lerp(navLabel, other.navLabel, t)!,
      tabLabel: TextStyle.lerp(tabLabel, other.tabLabel, t)!,
      badgeText: TextStyle.lerp(badgeText, other.badgeText, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      helperText: TextStyle.lerp(helperText, other.helperText, t)!,
      errorText: TextStyle.lerp(errorText, other.errorText, t)!,
      toastText: TextStyle.lerp(toastText, other.toastText, t)!,
      dialogTitle: TextStyle.lerp(dialogTitle, other.dialogTitle, t)!,
      dialogBody: TextStyle.lerp(dialogBody, other.dialogBody, t)!,
      updateTitle: TextStyle.lerp(updateTitle, other.updateTitle, t)!,
      updateVersion: TextStyle.lerp(updateVersion, other.updateVersion, t)!,
      updateDescription:
          TextStyle.lerp(updateDescription, other.updateDescription, t)!,
      codeText: TextStyle.lerp(codeText, other.codeText, t)!,
    );
  }
}
