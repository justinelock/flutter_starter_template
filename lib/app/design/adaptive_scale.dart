import 'dart:math' as math;

class AdaptiveScale {
  const AdaptiveScale._();

  static const double iPhone17ProLogicalWidth = 402;

  static double factor(double width) {
    final raw = width / iPhone17ProLogicalWidth;
    return raw.clamp(0.92, width >= 1024 ? 1.14 : 1.08).toDouble();
  }

  static double size(double width, double value) => value * factor(width);

  static double contentWidth(double width, double maxWidth) {
    return math.min(width, maxWidth);
  }
}
