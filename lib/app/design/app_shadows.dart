import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> soft(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.14),
      blurRadius: 28,
      offset: const Offset(0, 16),
    ),
  ];
}
