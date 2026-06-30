import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

/// iOS 26 / iPhone 17 Pro 基准的自适应字号缩放。
///
/// 设计目标：
/// - compact 以 iPhone 17 Pro 约 402 logical px 为 1x。
/// - 平板、桌面、Web 只做克制增益，避免把手机字号简单等比放大。
/// - 用户系统字号通过 [MediaQuery.textScalerOf] 保留，同时给关键控件提供安全上限。
class AdaptiveTypographyScale {
  const AdaptiveTypographyScale({
    required this.screenWidth,
    required this.platform,
    required this.layoutSize,
    required this.systemTextScale,
    required this.platformScale,
    required this.contentScale,
    required this.controlTextScale,
    required this.readingTextScale,
    required this.isWeb,
  });

  static const double baseWidth = 402;
  static const double compactMinScale = 0.92;
  static const double compactMaxScale = 1.08;
  static const double mediumMinScale = 1.04;
  static const double mediumMaxScale = 1.12;
  static const double expandedMinScale = 1.0;
  static const double expandedMaxScale = 1.10;

  final double screenWidth;
  final TargetPlatform platform;
  final AppLayoutSize layoutSize;
  final double systemTextScale;
  final double platformScale;
  final double contentScale;
  final double controlTextScale;
  final double readingTextScale;
  final bool isWeb;

  bool get isCompact => layoutSize == AppLayoutSize.compact;
  bool get isMedium => layoutSize == AppLayoutSize.medium;
  bool get isExpanded => layoutSize == AppLayoutSize.expanded;

  /// 从运行时上下文生成字号缩放配置。
  factory AdaptiveTypographyScale.fromContext(BuildContext context) {
    // MaterialApp 构建 theme 时可能还没有上层 MediaQuery；此时从 View 读取
    // 窗口尺寸和平台文字缩放，保证首帧主题也能按真实设备生成。
    final mediaQuery =
        MediaQuery.maybeOf(context) ?? MediaQueryData.fromView(View.of(context));
    final width = mediaQuery.size.width;
    final layoutSize = AppBreakpoints.fromWidth(width);
    final platform = Theme.of(context).platform;
    final systemScale = MediaQuery.textScalerOf(context).scale(1);

    final platformFactor = _platformFactor(platform, isWeb: kIsWeb);
    final widthFactor = _widthFactor(width, layoutSize);
    final baseScale = (widthFactor * platformFactor).clamp(
      _minFor(layoutSize),
      _maxFor(layoutSize),
    );

    // 普通内容尊重系统字号，但限制极端值避免页面结构崩坏；阅读正文可更宽松。
    final safeSystemScale = systemScale.clamp(0.90, 1.35).toDouble();
    final controlSystemScale = systemScale.clamp(0.90, 1.22).toDouble();
    final readingSystemScale = systemScale.clamp(0.90, 1.50).toDouble();

    return AdaptiveTypographyScale(
      screenWidth: width,
      platform: platform,
      layoutSize: layoutSize,
      systemTextScale: systemScale,
      platformScale: platformFactor,
      contentScale: baseScale * safeSystemScale,
      controlTextScale: baseScale * controlSystemScale,
      readingTextScale: baseScale * readingSystemScale,
      isWeb: kIsWeb,
    );
  }

  /// 无 [BuildContext] 时使用的 iPhone 17 Pro 1x 基准。
  factory AdaptiveTypographyScale.fallback({
    TargetPlatform platform = TargetPlatform.iOS,
    Brightness brightness = Brightness.light,
  }) {
    return AdaptiveTypographyScale(
      screenWidth: baseWidth,
      platform: platform,
      layoutSize: AppLayoutSize.compact,
      systemTextScale: 1,
      platformScale: _platformFactor(platform, isWeb: false),
      contentScale: 1,
      controlTextScale: 1,
      readingTextScale: 1,
      isWeb: false,
    );
  }

  double content(double value) => _round(value * contentScale);
  double control(double value) => _round(value * controlTextScale);
  double reading(double value) => _round(value * readingTextScale);

  static double _widthFactor(double width, AppLayoutSize layoutSize) {
    return switch (layoutSize) {
      AppLayoutSize.compact => (width / baseWidth).clamp(
          compactMinScale,
          compactMaxScale,
        ),
      AppLayoutSize.medium => math
          .sqrt(width / AppBreakpoints.compactMax)
          .clamp(mediumMinScale, mediumMaxScale),
      AppLayoutSize.expanded => math
          .sqrt(width / AppBreakpoints.mediumMax)
          .clamp(expandedMinScale, expandedMaxScale),
    }.toDouble();
  }

  static double _platformFactor(
    TargetPlatform platform, {
    required bool isWeb,
  }) {
    if (isWeb) return 1.02;
    return switch (platform) {
      TargetPlatform.iOS => 1.0,
      TargetPlatform.macOS => 1.02,
      TargetPlatform.android => 0.99,
      TargetPlatform.windows => 1.0,
      TargetPlatform.linux => 0.98,
      TargetPlatform.fuchsia => 1.0,
    };
  }

  static double _minFor(AppLayoutSize layoutSize) {
    return switch (layoutSize) {
      AppLayoutSize.compact => compactMinScale,
      AppLayoutSize.medium => mediumMinScale,
      AppLayoutSize.expanded => expandedMinScale,
    };
  }

  static double _maxFor(AppLayoutSize layoutSize) {
    return switch (layoutSize) {
      AppLayoutSize.compact => compactMaxScale,
      AppLayoutSize.medium => mediumMaxScale,
      AppLayoutSize.expanded => expandedMaxScale,
    };
  }

  static double _round(double value) {
    return (value * 10).roundToDouble() / 10;
  }
}
