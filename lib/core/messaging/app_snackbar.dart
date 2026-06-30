import 'package:flutter/material.dart';

import '../../app/theme/theme_extensions.dart';
import '../../app/theme/typography_extensions.dart';

enum AppSnackBarType { success, error, warning, info }

class AppSnackBar {
  const AppSnackBar._();

  static SnackBar build(
    BuildContext context,
    String message,
    AppSnackBarType type,
  ) {
    final colors = context.colors;
    final background = switch (type) {
      AppSnackBarType.success => colors.success,
      AppSnackBarType.error => colors.destructive,
      AppSnackBarType.warning => colors.warning,
      AppSnackBarType.info => colors.info,
    };
    final foreground = switch (type) {
      AppSnackBarType.success => colors.onSuccess,
      AppSnackBarType.error => colors.onDestructive,
      AppSnackBarType.warning => colors.onWarning,
      AppSnackBarType.info => colors.onInfo,
    };
    return SnackBar(
      content: Text(
        message,
        style: context.typography.toastText.copyWith(color: foreground),
      ),
      backgroundColor: background,
      width: 520,
    );
  }
}
