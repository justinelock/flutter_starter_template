import 'package:flutter/material.dart';

/// 页面背景渐变：清透、低饱和，色值与 [AppColorTokens] 对齐。
///
/// 禁止高饱和蓝紫大面积渐变，避免与插件 demo 冷蓝背景混淆。
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
        Color(0xFFF7F9FE), // backgroundBase
        Color(0xFFEFF4FC), // backgroundSubtle
        Color(0xFFF7F9FE),
      ],
      stops: [0, 0.55, 1],
    ),
    splash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFFFFF), // backgroundElevated
        Color(0xFFF7F9FE),
        Color(0xFFEFF4FC),
      ],
    ),
    auth: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F9FE),
        Color(0xFFEFF4FC),
        Color(0xFFF7F9FE),
      ],
    ),
    home: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F9FE),
        Color(0xFFF3F6FC),
        Color(0xFFEFF4FC),
      ],
    ),
    settings: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF7F9FE),
        Color(0xFFEFF4FC),
        Color(0xFFF5F7FB),
      ],
    ),
    dialogBackdrop: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x66FFFFFF), // backgroundOverlay
        Color(0x99EFF4FC),
      ],
    ),
    premium: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2F6BFF), Color(0xFFB96CFF)],
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
        Color(0xFF0F1724),
        Color(0xFF121A2A),
        Color(0xFF0F1724),
      ],
      stops: [0, 0.5, 1],
    ),
    splash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF121A2A),
        Color(0xFF0F1724),
        Color(0xFF121A2A),
      ],
    ),
    auth: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F1724),
        Color(0xFF121A2A),
        Color(0xFF141E30),
      ],
    ),
    home: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F1724),
        Color(0xFF121E2E),
        Color(0xFF121A2A),
      ],
    ),
    settings: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F1724),
        Color(0xFF121A2A),
        Color(0xFF101A28),
      ],
    ),
    dialogBackdrop: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x660A1020), Color(0x99121A2A)],
    ),
    premium: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFAEC4FF), Color(0xFFE9D5FF)],
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
