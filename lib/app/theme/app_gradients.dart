import 'package:flutter/material.dart';

/// 页面背景渐变：色值与 [AppColorTokens] / 文档颜色基准对齐。
///
/// 亮色为雾白层次；暗色以 #070A0F 为底，避免纯黑并保留 OLED 深邃层级。
@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.appBackground,
    required this.splash,
    required this.auth,
    required this.home,
    required this.settings,
    required this.dialogBackdrop,
    required this.premium,
    required this.error,
    required this.success,
  });

  final LinearGradient appBackground;
  final LinearGradient splash;
  final LinearGradient auth;
  final LinearGradient home;
  final LinearGradient settings;
  final LinearGradient dialogBackdrop;
  final LinearGradient premium;
  final LinearGradient error;
  final LinearGradient success;

  static const light = AppGradients(
    appBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFF7F8FB),
        Color(0xFFF3F4F6),
        Color(0xFFF7F8FB),
      ],
      stops: [0, 0.55, 1],
    ),
    splash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF7F8FB),
        Color(0xFFF3F4F6),
      ],
    ),
    auth: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F8FB),
        Color(0xFFF3F4F6),
        Color(0xFFF7F8FB),
      ],
    ),
    home: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F8FB),
        Color(0xFFFFFFFF),
        Color(0xFFF3F4F6),
      ],
    ),
    settings: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F8FB),
        Color(0xFFF3F4F6),
        Color(0xFFF7F8FB),
      ],
    ),
    dialogBackdrop: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x66FFFFFF),
        Color(0x99F3F4F6),
      ],
    ),
    premium: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0A84FF), Color(0xFF7C5CFF)],
    ),
    error: LinearGradient(
      colors: [Color(0xFFFFF1EF), Color(0xFFFFE2DE)],
    ),
    success: LinearGradient(
      colors: [Color(0xFFEAFBF0), Color(0xFFDDFBE8)],
    ),
  );

  static const dark = AppGradients(
    appBackground: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF070A0F),
        Color(0xFF0D1117),
        Color(0xFF070A0F),
      ],
      stops: [0, 0.5, 1],
    ),
    splash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF151A23),
        Color(0xFF070A0F),
        Color(0xFF0D1117),
      ],
    ),
    auth: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF070A0F),
        Color(0xFF0D1117),
        Color(0xFF151A23),
      ],
    ),
    home: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF070A0F),
        Color(0xFF0D1117),
        Color(0xFF151A23),
      ],
    ),
    settings: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF070A0F),
        Color(0xFF0D1117),
        Color(0xFF10151D),
      ],
    ),
    dialogBackdrop: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x66070A0F), Color(0x990D1117)],
    ),
    premium: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2997FF), Color(0xFF9B8CFF)],
    ),
    error: LinearGradient(colors: [Color(0xFF3F0806), Color(0xFF5F1612)]),
    success: LinearGradient(colors: [Color(0xFF052E16), Color(0xFF123B25)]),
  );

  @override
  AppGradients copyWith({
    LinearGradient? appBackground,
    LinearGradient? splash,
    LinearGradient? auth,
    LinearGradient? home,
    LinearGradient? settings,
    LinearGradient? dialogBackdrop,
    LinearGradient? premium,
    LinearGradient? error,
    LinearGradient? success,
  }) {
    return AppGradients(
      appBackground: appBackground ?? this.appBackground,
      splash: splash ?? this.splash,
      auth: auth ?? this.auth,
      home: home ?? this.home,
      settings: settings ?? this.settings,
      dialogBackdrop: dialogBackdrop ?? this.dialogBackdrop,
      premium: premium ?? this.premium,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    return t < 0.5 || other is! AppGradients ? this : other;
  }
}
