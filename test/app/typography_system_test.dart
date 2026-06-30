import 'package:flutter/material.dart';
import 'package:flutter_starter_template/app/design/app_typography_scale.dart';
import 'package:flutter_starter_template/app/theme/app_theme.dart';
import 'package:flutter_starter_template/app/theme/app_typography_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AdaptiveTypographyScale uses iPhone 17 Pro width as 1x', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402 * 3, 874 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late AdaptiveTypographyScale scale;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Builder(
          builder: (context) {
            scale = AdaptiveTypographyScale.fromContext(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scale.content(16), 16);
    expect(scale.control(15), 15);
  });

  testWidgets('AdaptiveTypographyScale clamps small compact screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320 * 3, 690 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late AdaptiveTypographyScale scale;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Builder(
          builder: (context) {
            scale = AdaptiveTypographyScale.fromContext(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scale.content(16), 14.7);
  });

  test('AppTheme registers AppTypographyTokens', () {
    final theme = AppTheme.light();
    final tokens = theme.extension<AppTypographyTokens>();

    expect(tokens, isNotNull);
    expect(tokens!.inputText.fontSize, 16);
    expect(tokens.errorText.fontSize, 12.5);
  });

  test('AppTypographyTokens lerp returns interpolated text styles', () {
    final light = AppTheme.light().extension<AppTypographyTokens>()!;
    final dark = AppTheme.dark().extension<AppTypographyTokens>()!;

    final mixed = light.lerp(dark, 0.5);

    expect(mixed.cardTitle.fontSize, light.cardTitle.fontSize);
    expect(mixed.dialogBody.color, isNotNull);
  });
}
