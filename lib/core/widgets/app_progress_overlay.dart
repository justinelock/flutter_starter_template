import 'package:flutter/material.dart';

import '../../app/theme/theme_extensions.dart';

class AppProgressOverlay extends StatelessWidget {
  const AppProgressOverlay({
    required this.loading,
    required this.child,
    super.key,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          ColoredBox(
            color: context.colors.scrimSoft,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
