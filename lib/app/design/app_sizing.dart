class AppSizing {
  const AppSizing._();

  static const double buttonHeight = 52;
  static const double inputHeight = 56;
  static const double icon = 24;
  static const double logo = 72;
  static const double dialogMaxWidth = 420;

  /// [GlassTabBar.bottom] 胶囊本体高度。
  static const double tabBarHeight = 64;

  /// iOS 26 标准：胶囊与屏幕底边留白，与 Home Indicator 区域重叠约 20pt。
  static const double tabBarVerticalPaddingIos = 20;

  /// Android 手势/三键导航区略紧凑一些。
  static const double tabBarVerticalPaddingAndroid = 12;

  /// 主 Tab 子页面内容区底部预留高度（胶囊 + 底边距），避免列表被底栏遮挡。
  static const double mainTabBarReserveHeight =
      tabBarHeight + tabBarVerticalPaddingIos + 16;
}
