import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/theme/theme_extensions.dart';

/// Tab 分支页脚手架：透明背景，不重复铺底栏。
///
/// 与 [MainTabShell] 的外层 [AppGlassScaffold] 配合，共享同一玻璃层与底部导航，
/// 避免 Stack 叠加导致底栏不透明、底部留白过大。
class AppTabPage extends StatelessWidget {
  const AppTabPage({
    required this.body,
    this.appBar,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return lg.GlassScaffold(
      backgroundColor: context.colorScheme.surface.withValues(alpha: 0),
      body: body,
      appBar: appBar,
      // 顶/底边缘淡化由 Shell 级脚手架统一处理。
      edgeFade: false,
    );
  }
}
