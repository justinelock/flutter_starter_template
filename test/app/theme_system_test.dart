import 'package:flutter/material.dart';
import 'package:flutter_starter_template/app/theme/app_color_tokens.dart';
import 'package:flutter_starter_template/app/theme/app_glass_tokens.dart';
import 'package:flutter_starter_template/app/theme/app_gradients.dart';
import 'package:flutter_starter_template/app/theme/app_theme.dart';
import 'package:flutter_starter_template/app/theme/theme_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('light theme registers all ThemeExtensions', () {
      final theme = AppTheme.light();
      expect(theme.extension<AppColorTokens>(), isNotNull);
      expect(theme.extension<AppGlassTokens>(), isNotNull);
      expect(theme.extension<AppGradients>(), isNotNull);
    });

    test('dark theme registers all ThemeExtensions', () {
      final theme = AppTheme.dark();
      expect(theme.extension<AppColorTokens>(), isNotNull);
      expect(theme.extension<AppGlassTokens>(), isNotNull);
      expect(theme.extension<AppGradients>(), isNotNull);
    });

    testWidgets('context extensions resolve light tokens', (tester) async {
      late AppColorTokens colors;
      late AppGlassTokens glass;
      late AppGradients gradients;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) {
              colors = context.colors;
              glass = context.glass;
              gradients = context.gradients;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(colors, AppColorTokens.light);
      expect(glass, AppGlassTokens.light);
      expect(gradients.auth, AppGradients.light.auth);
      expect(gradients.home, AppGradients.light.home);
      expect(gradients.settings, AppGradients.light.settings);
      expect(gradients.splash, AppGradients.light.splash);
    });

    testWidgets('context extensions resolve dark tokens', (tester) async {
      late AppGradients gradients;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              gradients = context.gradients;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(gradients.auth, AppGradients.dark.auth);
      expect(gradients.home, AppGradients.dark.home);
    });

    test('AppColorTokens copyWith overrides single field', () {
      const original = AppColorTokens.light;
      final updated = original.copyWith(destructive: const Color(0xFFFF0000));
      expect(updated.destructive, const Color(0xFFFF0000));
      expect(updated.textPrimary, original.textPrimary);
    });

    test('AppGlassTokens copyWith overrides blur sigma', () {
      const original = AppGlassTokens.light;
      final updated = original.copyWith(glassBlurSigma: 30);
      expect(updated.glassBlurSigma, 30);
      expect(updated.glassBackground, original.glassBackground);
    });

    test('AppGradients copyWith overrides auth gradient', () {
      const customAuth = LinearGradient(colors: [Color(0xFF000000)]);
      final updated = AppGradients.light.copyWith(auth: customAuth);
      expect(updated.auth, customAuth);
      expect(updated.home, AppGradients.light.home);
    });

    test('light theme includes navigation and bottom bar themes', () {
      final theme = AppTheme.light();
      expect(theme.navigationBarTheme.backgroundColor, isNotNull);
      expect(theme.navigationRailTheme.backgroundColor, isNotNull);
      expect(theme.bottomNavigationBarTheme.selectedItemColor, isNotNull);
      expect(theme.elevatedButtonTheme, isNotNull);
      expect(theme.floatingActionButtonTheme, isNotNull);
      expect(theme.sliderTheme, isNotNull);
      expect(theme.tooltipTheme, isNotNull);
      expect(theme.badgeTheme, isNotNull);
    });
  });
}
