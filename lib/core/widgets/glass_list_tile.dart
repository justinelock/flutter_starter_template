import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

/// 项目统一分组列表行，使用 pub 包 [lg.GlassListTile] 以匹配 iOS 26 分组样式。
class AppGlassListTile extends StatelessWidget {
  const AppGlassListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isLast = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  /// 分组卡片内最后一行需标记为 true，以隐藏底部分隔线。
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return lg.GlassListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing,
      onTap: onTap,
      isLast: isLast,
    );
  }
}
