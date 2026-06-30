import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

@immutable
class AppGlassTokens extends ThemeExtension<AppGlassTokens> {
  const AppGlassTokens({
    required this.glassBackground,
    required this.glassBackgroundStrong,
    required this.glassBackgroundSubtle,
    required this.glassBackgroundUltraThin,
    required this.glassBackgroundThick,
    required this.glassStroke,
    required this.glassStrokeStrong,
    required this.glassStrokeSubtle,
    required this.glassTopHighlight,
    required this.glassBottomShadowLine,
    required this.glassHighlight,
    required this.glassHighlightStrong,
    required this.glassShadow,
    required this.glassShadowStrong,
    required this.glassInnerShadow,
    required this.glassAmbientGlow,
    required this.glassTint,
    required this.glassPrimaryTint,
    required this.glassSecondaryTint,
    required this.glassDangerTint,
    required this.glassSuccessTint,
    required this.glassHoverOverlay,
    required this.glassPressedOverlay,
    required this.glassFocusedStroke,
    required this.glassDisabledOverlay,
    required this.glassNoiseOpacity,
    required this.glassBlurSigma,
    required this.glassBlurSigmaStrong,
    required this.glassSaturation,
    required this.glassOpacity,
    required this.glassPressedOpacity,
    required this.glassHoverOpacity,
    required this.glassDisabledOpacity,
  });

  final Color glassBackground;
  final Color glassBackgroundStrong;
  final Color glassBackgroundSubtle;
  final Color glassBackgroundUltraThin;
  final Color glassBackgroundThick;
  final Color glassStroke;
  final Color glassStrokeStrong;
  final Color glassStrokeSubtle;
  final Color glassTopHighlight;
  final Color glassBottomShadowLine;
  final Color glassHighlight;
  final Color glassHighlightStrong;
  final Color glassShadow;
  final Color glassShadowStrong;
  final Color glassInnerShadow;
  final Color glassAmbientGlow;
  final Color glassTint;
  final Color glassPrimaryTint;
  final Color glassSecondaryTint;
  final Color glassDangerTint;
  final Color glassSuccessTint;
  final Color glassHoverOverlay;
  final Color glassPressedOverlay;
  final Color glassFocusedStroke;
  final Color glassDisabledOverlay;
  final double glassNoiseOpacity;
  final double glassBlurSigma;
  final double glassBlurSigmaStrong;
  final double glassSaturation;
  final double glassOpacity;
  final double glassPressedOpacity;
  final double glassHoverOpacity;
  final double glassDisabledOpacity;

  static const light = AppGlassTokens(
    glassBackground: Color(0xAFFFFFFF),
    glassBackgroundStrong: Color(0xD9FFFFFF),
    glassBackgroundSubtle: Color(0x7AFFFFFF),
    glassBackgroundUltraThin: Color(0x4DFFFFFF),
    glassBackgroundThick: Color(0xEFFFFFFF),
    glassStroke: Color(0x80FFFFFF),
    glassStrokeStrong: Color(0xCCFFFFFF),
    glassStrokeSubtle: Color(0x40FFFFFF),
    glassTopHighlight: Color(0xE6FFFFFF),
    glassBottomShadowLine: Color(0x1A0F172A),
    glassHighlight: Color(0x66FFFFFF),
    glassHighlightStrong: Color(0x99FFFFFF),
    glassShadow: Color(0x240F172A),
    glassShadowStrong: Color(0x3D0F172A),
    glassInnerShadow: Color(0x1AFFFFFF),
    glassAmbientGlow: Color(0x332F6BFF),
    glassTint: Color(0x1AFFFFFF),
    glassPrimaryTint: Color(0x332F6BFF),
    glassSecondaryTint: Color(0x336E7BFF),
    glassDangerTint: Color(0x33D92D20),
    glassSuccessTint: Color(0x3316A34A),
    glassHoverOverlay: Color(0x14FFFFFF),
    glassPressedOverlay: Color(0x220F172A),
    glassFocusedStroke: Color(0x992F6BFF),
    glassDisabledOverlay: Color(0x66E5E7EB),
    glassNoiseOpacity: 0.018,
    glassBlurSigma: 20,
    glassBlurSigmaStrong: 28,
    glassSaturation: 1.18,
    glassOpacity: 0.68,
    glassPressedOpacity: 0.78,
    glassHoverOpacity: 0.74,
    glassDisabledOpacity: 0.42,
  );

  static const dark = AppGlassTokens(
    glassBackground: Color(0x661B263A),
    glassBackgroundStrong: Color(0x99243149),
    glassBackgroundSubtle: Color(0x4D1B263A),
    glassBackgroundUltraThin: Color(0x331B263A),
    glassBackgroundThick: Color(0xB326344A),
    glassStroke: Color(0x33FFFFFF),
    glassStrokeStrong: Color(0x59FFFFFF),
    glassStrokeSubtle: Color(0x1FFFFFFF),
    glassTopHighlight: Color(0x4DFFFFFF),
    glassBottomShadowLine: Color(0x66000000),
    glassHighlight: Color(0x33FFFFFF),
    glassHighlightStrong: Color(0x59FFFFFF),
    glassShadow: Color(0x66000000),
    glassShadowStrong: Color(0x99000000),
    glassInnerShadow: Color(0x1AFFFFFF),
    glassAmbientGlow: Color(0x33AEC4FF),
    glassTint: Color(0x1A5B7CFF),
    glassPrimaryTint: Color(0x40AEC4FF),
    glassSecondaryTint: Color(0x40C6CBFF),
    glassDangerTint: Color(0x40FFB4AB),
    glassSuccessTint: Color(0x404ADE80),
    glassHoverOverlay: Color(0x1AFFFFFF),
    glassPressedOverlay: Color(0x29FFFFFF),
    glassFocusedStroke: Color(0x99AEC4FF),
    glassDisabledOverlay: Color(0x662A3446),
    glassNoiseOpacity: 0.022,
    glassBlurSigma: 22,
    glassBlurSigmaStrong: 30,
    glassSaturation: 1.12,
    glassOpacity: 0.48,
    glassPressedOpacity: 0.58,
    glassHoverOpacity: 0.54,
    glassDisabledOpacity: 0.36,
  );

  /// 传给 `liquid_glass_widgets` 的页面级渲染参数，只使用库已公开字段。
  LiquidGlassSettings get pageSettings => LiquidGlassSettings(
    thickness: GlassDefaults.thickness,
    blur: GlassDefaults.blur,
    refractiveIndex: GlassDefaults.refractiveIndex,
    lightIntensity: GlassDefaults.lightIntensity,
    chromaticAberration: GlassDefaults.chromaticAberration,
  );

  LiquidGlassSettings get surfaceSettings => LiquidGlassSettings(
    thickness: 24,
    blur: glassBlurSigma / 5,
    refractiveIndex: 1.15,
  );

  @override
  AppGlassTokens copyWith({
    Color? glassBackground,
    Color? glassBackgroundStrong,
    Color? glassBackgroundSubtle,
    Color? glassBackgroundUltraThin,
    Color? glassBackgroundThick,
    Color? glassStroke,
    Color? glassStrokeStrong,
    Color? glassStrokeSubtle,
    Color? glassTopHighlight,
    Color? glassBottomShadowLine,
    Color? glassHighlight,
    Color? glassHighlightStrong,
    Color? glassShadow,
    Color? glassShadowStrong,
    Color? glassInnerShadow,
    Color? glassAmbientGlow,
    Color? glassTint,
    Color? glassPrimaryTint,
    Color? glassSecondaryTint,
    Color? glassDangerTint,
    Color? glassSuccessTint,
    Color? glassHoverOverlay,
    Color? glassPressedOverlay,
    Color? glassFocusedStroke,
    Color? glassDisabledOverlay,
    double? glassNoiseOpacity,
    double? glassBlurSigma,
    double? glassBlurSigmaStrong,
    double? glassSaturation,
    double? glassOpacity,
    double? glassPressedOpacity,
    double? glassHoverOpacity,
    double? glassDisabledOpacity,
  }) {
    return AppGlassTokens(
      glassBackground: glassBackground ?? this.glassBackground,
      glassBackgroundStrong:
          glassBackgroundStrong ?? this.glassBackgroundStrong,
      glassBackgroundSubtle:
          glassBackgroundSubtle ?? this.glassBackgroundSubtle,
      glassBackgroundUltraThin:
          glassBackgroundUltraThin ?? this.glassBackgroundUltraThin,
      glassBackgroundThick:
          glassBackgroundThick ?? this.glassBackgroundThick,
      glassStroke: glassStroke ?? this.glassStroke,
      glassStrokeStrong: glassStrokeStrong ?? this.glassStrokeStrong,
      glassStrokeSubtle: glassStrokeSubtle ?? this.glassStrokeSubtle,
      glassTopHighlight: glassTopHighlight ?? this.glassTopHighlight,
      glassBottomShadowLine:
          glassBottomShadowLine ?? this.glassBottomShadowLine,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      glassHighlightStrong: glassHighlightStrong ?? this.glassHighlightStrong,
      glassShadow: glassShadow ?? this.glassShadow,
      glassShadowStrong: glassShadowStrong ?? this.glassShadowStrong,
      glassInnerShadow: glassInnerShadow ?? this.glassInnerShadow,
      glassAmbientGlow: glassAmbientGlow ?? this.glassAmbientGlow,
      glassTint: glassTint ?? this.glassTint,
      glassPrimaryTint: glassPrimaryTint ?? this.glassPrimaryTint,
      glassSecondaryTint: glassSecondaryTint ?? this.glassSecondaryTint,
      glassDangerTint: glassDangerTint ?? this.glassDangerTint,
      glassSuccessTint: glassSuccessTint ?? this.glassSuccessTint,
      glassHoverOverlay: glassHoverOverlay ?? this.glassHoverOverlay,
      glassPressedOverlay: glassPressedOverlay ?? this.glassPressedOverlay,
      glassFocusedStroke: glassFocusedStroke ?? this.glassFocusedStroke,
      glassDisabledOverlay: glassDisabledOverlay ?? this.glassDisabledOverlay,
      glassNoiseOpacity: glassNoiseOpacity ?? this.glassNoiseOpacity,
      glassBlurSigma: glassBlurSigma ?? this.glassBlurSigma,
      glassBlurSigmaStrong: glassBlurSigmaStrong ?? this.glassBlurSigmaStrong,
      glassSaturation: glassSaturation ?? this.glassSaturation,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassPressedOpacity: glassPressedOpacity ?? this.glassPressedOpacity,
      glassHoverOpacity: glassHoverOpacity ?? this.glassHoverOpacity,
      glassDisabledOpacity: glassDisabledOpacity ?? this.glassDisabledOpacity,
    );
  }

  @override
  AppGlassTokens lerp(ThemeExtension<AppGlassTokens>? other, double t) {
    if (other is! AppGlassTokens) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    double d(double a, double b) => a + (b - a) * t;
    return AppGlassTokens(
      glassBackground: c(glassBackground, other.glassBackground),
      glassBackgroundStrong: c(
        glassBackgroundStrong,
        other.glassBackgroundStrong,
      ),
      glassBackgroundSubtle: c(
        glassBackgroundSubtle,
        other.glassBackgroundSubtle,
      ),
      glassBackgroundUltraThin: c(
        glassBackgroundUltraThin,
        other.glassBackgroundUltraThin,
      ),
      glassBackgroundThick: c(glassBackgroundThick, other.glassBackgroundThick),
      glassStroke: c(glassStroke, other.glassStroke),
      glassStrokeStrong: c(glassStrokeStrong, other.glassStrokeStrong),
      glassStrokeSubtle: c(glassStrokeSubtle, other.glassStrokeSubtle),
      glassTopHighlight: c(glassTopHighlight, other.glassTopHighlight),
      glassBottomShadowLine: c(
        glassBottomShadowLine,
        other.glassBottomShadowLine,
      ),
      glassHighlight: c(glassHighlight, other.glassHighlight),
      glassHighlightStrong: c(glassHighlightStrong, other.glassHighlightStrong),
      glassShadow: c(glassShadow, other.glassShadow),
      glassShadowStrong: c(glassShadowStrong, other.glassShadowStrong),
      glassInnerShadow: c(glassInnerShadow, other.glassInnerShadow),
      glassAmbientGlow: c(glassAmbientGlow, other.glassAmbientGlow),
      glassTint: c(glassTint, other.glassTint),
      glassPrimaryTint: c(glassPrimaryTint, other.glassPrimaryTint),
      glassSecondaryTint: c(glassSecondaryTint, other.glassSecondaryTint),
      glassDangerTint: c(glassDangerTint, other.glassDangerTint),
      glassSuccessTint: c(glassSuccessTint, other.glassSuccessTint),
      glassHoverOverlay: c(glassHoverOverlay, other.glassHoverOverlay),
      glassPressedOverlay: c(glassPressedOverlay, other.glassPressedOverlay),
      glassFocusedStroke: c(glassFocusedStroke, other.glassFocusedStroke),
      glassDisabledOverlay: c(glassDisabledOverlay, other.glassDisabledOverlay),
      glassNoiseOpacity: d(glassNoiseOpacity, other.glassNoiseOpacity),
      glassBlurSigma: d(glassBlurSigma, other.glassBlurSigma),
      glassBlurSigmaStrong: d(glassBlurSigmaStrong, other.glassBlurSigmaStrong),
      glassSaturation: d(glassSaturation, other.glassSaturation),
      glassOpacity: d(glassOpacity, other.glassOpacity),
      glassPressedOpacity: d(glassPressedOpacity, other.glassPressedOpacity),
      glassHoverOpacity: d(glassHoverOpacity, other.glassHoverOpacity),
      glassDisabledOpacity: d(glassDisabledOpacity, other.glassDisabledOpacity),
    );
  }
}
