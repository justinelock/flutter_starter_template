enum AppLayoutSize { compact, medium, expanded }

class AppBreakpoints {
  const AppBreakpoints._();

  static const double compactMax = 599;
  static const double mediumMax = 1023;
  static const double desktopContentMaxWidth = 1120;
  static const double formMaxWidth = 460;

  static AppLayoutSize fromWidth(double width) {
    if (width <= compactMax) return AppLayoutSize.compact;
    if (width <= mediumMax) return AppLayoutSize.medium;
    return AppLayoutSize.expanded;
  }
}
