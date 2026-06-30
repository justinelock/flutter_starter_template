import 'package:flutter/material.dart';

import '../../app/localization/l10n_extensions.dart';
import '../../app/theme/theme_extensions.dart';
import '../../app/theme/typography_extensions.dart';
import '../constants/app_svg_assets.dart';
import 'app_svg_icon.dart';
import 'glass_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    // 错误视图只接收上层传入的用户友好文案，重试按钮文案统一走 destructive token。
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(
            assetPath: AppSvgAssets.danger,
            size: 48,
            color: colors.destructive,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: typography.errorText.copyWith(color: colors.destructive),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            AppGlassButton(
              label: l10n.retryAction,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
