import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_template/app/theme/app_color_schemes.dart';

void main() {
  test('print color schemes', () {
    _printScheme('Light', AppColorSchemes.light);
    _printScheme('Dark', AppColorSchemes.dark);
  });
}

void _printScheme(String name, ColorScheme s) {
  // ignore: avoid_print
  print('=== $name ===');
  final fields = <String, Color>{
    'primary': s.primary,
    'onPrimary': s.onPrimary,
    'primaryContainer': s.primaryContainer,
    'onPrimaryContainer': s.onPrimaryContainer,
    'secondary': s.secondary,
    'secondaryContainer': s.secondaryContainer,
    'tertiary': s.tertiary,
    'surface': s.surface,
    'onSurface': s.onSurface,
    'surfaceContainerHighest': s.surfaceContainerHighest,
    'onSurfaceVariant': s.onSurfaceVariant,
    'outline': s.outline,
    'outlineVariant': s.outlineVariant,
    'error': s.error,
  };
  for (final e in fields.entries) {
    final argb = e.value.toARGB32();
    final hex = argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
    // ignore: avoid_print
    print('${e.key}: #$hex');
  }
}
