import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../app/design/app_radius.dart';
import '../../../../app/design/app_spacing.dart';

/// 认证表单输入框：占位符即标签，校验错误单独展示；文字对比度跟随 ColorScheme。
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 占位符用 onSurfaceVariant，输入正文用 onSurface，避免玻璃输入框里发灰看不清。
    final placeholderStyle = TextStyle(
      fontSize: 15,
      color: colorScheme.onSurfaceVariant,
    );
    final textStyle = TextStyle(
      fontSize: 16,
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    );

    return FormField<String>(
      validator: validator,
      builder: (field) {
        final input = obscureText
            ? GlassPasswordField(
                controller: controller,
                placeholder: label,
                placeholderStyle: placeholderStyle,
                textStyle: textStyle,
                onChanged: field.didChange,
              )
            : GlassTextField(
                controller: controller,
                placeholder: label,
                placeholderStyle: placeholderStyle,
                textStyle: textStyle,
                keyboardType: TextInputType.phone,
                onChanged: field.didChange,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            input,
            if (field.errorText != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                field.errorText!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
