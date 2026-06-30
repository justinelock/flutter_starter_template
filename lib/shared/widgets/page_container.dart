import 'package:flutter/material.dart';

import '../../app/design/app_breakpoints.dart';
import '../../app/design/app_spacing.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    this.maxWidth = AppBreakpoints.desktopContentMaxWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: child,
        ),
      ),
    );
  }
}
