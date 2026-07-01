import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app/theme/app_glass_theme.dart';
import 'bootstrap.dart';

/// 应用执行的唯一入口点
/// 
/// 该函数非常精简，核心初始化逻辑被封装在 [bootstrap] 中。
/// 这种设计便于在集成测试中重用启动逻辑，或者在不同环境下注入不同的根包装器。
Future<void> main() async {
  // 调用引导程序并传入应用根组件包装器。
  await bootstrap(
    (child) => LiquidGlassWidgets.wrap(
      // [LiquidGlassWidgets.wrap] 负责在整个应用顶层注入全局的设计系统参数（如模糊度、透明度等）。
      // AppGlassTheme.data 定义了该模版特有的“液态玻璃”视觉规格。
      theme: AppGlassTheme.data,
      child: child,
    ),
  );
}
