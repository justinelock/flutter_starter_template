import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_button.dart';

/// 认证页主提交按钮：加载态固定高度，正常态使用 prominent 全宽玻璃按钮。
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.loading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  static const double _height = 48;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      // 加载时保持与按钮相同高度，避免表单布局跳动。
      return const SizedBox(
        height: _height,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }

    return AppGlassButton(
      label: label,
      onPressed: onPressed,
      expand: true,
      prominent: true,
      height: _height,
    );
  }
}
