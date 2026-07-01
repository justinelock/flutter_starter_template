import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/theme/typography_extensions.dart';

/// 认证表单输入框：样式来自 [AppTypographyTokens]，触摸无彩色光晕。
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;
    final typography = context.typography;

    return FormField<String>(
      validator: validator,
      builder: (field) {
        final input = obscureText
            ? GlassPasswordField(
                controller: controller,
                placeholder: label,
                placeholderStyle: typography.inputPlaceholder,
                textStyle: typography.inputText,
                onChanged: field.didChange,
                settings: glass.surfaceSettings,
                interactionBehavior: GlassInteractionBehavior.scaleOnly,
                glowColor: Colors.transparent,
              )
            : GlassTextField(
                controller: controller,
                placeholder: label,
                placeholderStyle: typography.inputPlaceholder,
                textStyle: typography.inputText,
                keyboardType: keyboardType ?? TextInputType.text,
                onChanged: field.didChange,
                settings: glass.surfaceSettings,
                interactionBehavior: GlassInteractionBehavior.scaleOnly,
                glowColor: Colors.transparent,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            input,
            if (field.errorText != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(field.errorText!, style: typography.errorText),
            ],
          ],
        );
      },
    );
  }
}
