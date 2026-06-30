import 'package:flutter/material.dart';

void main() {
  _printScheme(
    'Light',
    ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B7CFF),
      brightness: Brightness.light,
    ),
  );
  _printScheme(
    'Dark',
    ColorScheme.fromSeed(
      seedColor: const Color(0xFF9FB5FF),
      brightness: Brightness.dark,
    ),
  );
}

void _printScheme(String name, ColorScheme s) {
  print('=== $name (seed) ===');
  final fields = <String, Color>{
    'primary': s.primary,
    'onPrimary': s.onPrimary,
    'primaryContainer': s.primaryContainer,
    'onPrimaryContainer': s.onPrimaryContainer,
    'secondary': s.secondary,
    'onSecondary': s.onSecondary,
    'secondaryContainer': s.secondaryContainer,
    'onSecondaryContainer': s.onSecondaryContainer,
    'tertiary': s.tertiary,
    'onTertiary': s.onTertiary,
    'surface': s.surface,
    'onSurface': s.onSurface,
    'surfaceContainerHighest': s.surfaceContainerHighest,
    'onSurfaceVariant': s.onSurfaceVariant,
    'outline': s.outline,
    'outlineVariant': s.outlineVariant,
    'error': s.error,
    'onError': s.onError,
    'inverseSurface': s.inverseSurface,
    'inversePrimary': s.inversePrimary,
  };
  for (final e in fields.entries) {
    final hex = e.value.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    print('${e.key}: #$hex');
  }
  print('');
}
