import 'package:flutter/material.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../app/theme/typography_extensions.dart';
import '../../../../shared/widgets/app_logo.dart';

/// 认证页顶部品牌区：Logo + [pageTitle] 标题。
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
    final typography = context.typography;

    return Column(
      children: [
        if (showLogo) ...[
          const AppLogo(size: 84),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: typography.pageTitle,
        ),
      ],
    );
  }
}
