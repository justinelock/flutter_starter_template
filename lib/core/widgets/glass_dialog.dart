import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// 项目统一玻璃对话框，基于 pub 包 [GlassDialog] 构建。
class AppGlassDialog extends StatelessWidget {
  const AppGlassDialog({
    required this.actions,
    this.title,
    this.message,
    this.content,
    super.key,
  });

  final String? title;
  /// 正文说明，使用 GlassDialog 内置 14px 次级文字样式（iOS Alert 风格）。
  final String? message;
  final Widget? content;
  final List<GlassDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: title,
      message: message,
      content: content,
      actions: actions,
    );
  }
}
