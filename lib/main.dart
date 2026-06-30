import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'bootstrap.dart';

/// 应用入口：所有 Binding 初始化与 runApp 均在 bootstrap 的同一 Zone 内执行。
Future<void> main() async {
  await bootstrap((child) => LiquidGlassWidgets.wrap(child: child));
}
