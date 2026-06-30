import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

/// 项目统一顶部栏，使用 pub 包 [lg.GlassAppBar] 承载标题与玻璃交互按钮。
class AppGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppGlassAppBar({
    required this.title,
    this.leading,
    this.actions,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return lg.GlassAppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
    );
  }
}
