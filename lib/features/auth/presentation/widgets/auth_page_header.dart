import 'package:flutter/material.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../shared/widgets/app_logo.dart';

/// 认证页顶部品牌区：Logo + 标题，与表单区分离以提升视觉层次。
class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    required this.title,
    this.showLogo = true,
    super.key,
  });

  final String title;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (showLogo) ...[
          const AppLogo(size: 84),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
