/// iOS 26 / `liquid_glass_widgets` 对齐的圆角设计 token（logical pt）。
///
/// 所有玻璃组件与 Material 回退样式应优先使用此处语义常量，
/// 避免在 Widget 内硬编码圆角数值。
class AppRadius {
  const AppRadius._();

  /// 导航栏、工具栏等贴边表面（[GlassAppBar] / [GlassToolbar]）。
  static const double bar = 0;

  /// 文本输入框（[GlassTextField]、[GlassPasswordField]、[GlassPicker]）。
  static const double input = 10;

  /// 分组列表行、独立 [GlassListTile]、[GlassGroupedSection]。
  static const double listTile = 12;

  /// 对话框操作按钮、[GlassIconButton] 方角变体。
  static const double button = 12;

  /// [GlassActionSheet]。
  static const double actionSheet = 14;

  /// 分段控件、[GlassContainer]（对应 [GlassDefaults.borderRadius]）。
  static const double control = 16;

  /// 大卡片 [GlassCard]（对应 [GlassDefaults.borderRadiusLarge]）。
  static const double card = 20;

  /// [GlassButtonGroup] 无分隔时的外轮廓。
  static const double buttonGroup = 22;

  /// [GlassToast]、[GlassMenuItem]。
  static const double toast = 24;

  /// [GlassTabBar.bottom] 浮动胶囊底栏。
  static const double tabBar = 32;

  /// [GlassSheet] 顶部圆角。
  static const double sheetTop = 32;

  /// [GlassSheet] 全圆角浮动形态。
  static const double sheet = 54;

  /// 胶囊形控件：高度的一半（主操作 [GlassButton.custom] 等）。
  static double capsule(double height) => height / 2;

  /// Chip、PageControl 等全圆 pill。
  static const double pill = 999;
}
