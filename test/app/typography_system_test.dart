import 'package:flutter/material.dart';
import 'package:flutter_starter_template/app/design/app_breakpoints.dart';
import 'package:flutter_starter_template/app/design/app_typography_scale.dart';
import 'package:flutter_starter_template/app/theme/app_color_schemes.dart';
import 'package:flutter_starter_template/app/theme/app_text_theme.dart';
import 'package:flutter_starter_template/app/theme/app_theme.dart';
import 'package:flutter_starter_template/app/theme/app_typography_tokens.dart';
import 'package:flutter_starter_template/app/theme/typography_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

/// iPhone 17 Pro compact 逻辑宽度，作为 1x 基准。
const _iphone17ProWidth = 402.0;

/// 文档 §六 推荐的 App 语义 token 基准字号（1x 未缩放）。
const _semanticBaseSizes = <String, double>{
  'heroTitle': 34,
  'pageTitle': 28,
  'sectionTitle': 20,
  'cardTitle': 18,
  'cardSubtitle': 14,
  'formLabel': 14,
  'inputText': 16,
  'inputPlaceholder': 16,
  'buttonLarge': 16,
  'buttonMedium': 15,
  'buttonSmall': 13,
  'navLabel': 12,
  'tabLabel': 13,
  'badgeText': 11,
  'caption': 12,
  'helperText': 12,
  'errorText': 12.5,
  'toastText': 14,
  'dialogTitle': 21,
  'dialogBody': 15,
  'updateTitle': 22,
  'updateVersion': 13,
  'updateDescription': 15,
  'codeText': 13,
};

void main() {
  group('AdaptiveTypographyScale', () {
    testWidgets('uses iPhone 17 Pro width as 1x on iOS compact', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(_iphone17ProWidth * 3, 874 * 3);
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

    testWidgets('clamps small compact screens below 1x', (tester) async {
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

    testWidgets('Android compact stays near iOS baseline', (tester) async {
      tester.view.physicalSize = const Size(_iphone17ProWidth * 3, 874 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late AdaptiveTypographyScale iosScale;
      late AdaptiveTypographyScale androidScale;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Builder(
            builder: (context) {
              iosScale = AdaptiveTypographyScale.fromContext(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Builder(
            builder: (context) {
              androidScale = AdaptiveTypographyScale.fromContext(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(androidScale.content(16), closeTo(iosScale.content(16) * 0.99, 0.2));
    });

    testWidgets('tablet width does not over-scale content', (tester) async {
      tester.view.physicalSize = const Size(834 * 3, 1194 * 3);
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

      expect(scale.content(16), lessThan(18));
      expect(scale.content(16), greaterThan(16));
    });

    test('web platform factor is slightly above iOS', () {
      final webFactor = AdaptiveTypographyScale(
        screenWidth: _iphone17ProWidth,
        platform: TargetPlatform.iOS,
        layoutSize: AppLayoutSize.compact,
        systemTextScale: 1,
        platformScale: 1.02,
        contentScale: 1.02,
        controlTextScale: 1.02,
        readingTextScale: 1.02,
        isWeb: true,
      );

      expect(webFactor.content(16), greaterThan(16));
      expect(webFactor.content(16), lessThan(17));
    });
  });

  group('AppTypographyTokens §六 基准字号', () {
    late AppTypographyTokens tokens;

    setUp(() {
      tokens = AppTypographyTokens.build(
        colorScheme: AppColorSchemes.light,
        scale: AdaptiveTypographyScale.fallback(),
      );
    });

    test('all semantic tokens match documented base sizes at 1x', () {
      final actual = <String, double>{
        'heroTitle': tokens.heroTitle.fontSize!,
        'pageTitle': tokens.pageTitle.fontSize!,
        'sectionTitle': tokens.sectionTitle.fontSize!,
        'cardTitle': tokens.cardTitle.fontSize!,
        'cardSubtitle': tokens.cardSubtitle.fontSize!,
        'formLabel': tokens.formLabel.fontSize!,
        'inputText': tokens.inputText.fontSize!,
        'inputPlaceholder': tokens.inputPlaceholder.fontSize!,
        'buttonLarge': tokens.buttonLarge.fontSize!,
        'buttonMedium': tokens.buttonMedium.fontSize!,
        'buttonSmall': tokens.buttonSmall.fontSize!,
        'navLabel': tokens.navLabel.fontSize!,
        'tabLabel': tokens.tabLabel.fontSize!,
        'badgeText': tokens.badgeText.fontSize!,
        'caption': tokens.caption.fontSize!,
        'helperText': tokens.helperText.fontSize!,
        'errorText': tokens.errorText.fontSize!,
        'toastText': tokens.toastText.fontSize!,
        'dialogTitle': tokens.dialogTitle.fontSize!,
        'dialogBody': tokens.dialogBody.fontSize!,
        'updateTitle': tokens.updateTitle.fontSize!,
        'updateVersion': tokens.updateVersion.fontSize!,
        'updateDescription': tokens.updateDescription.fontSize!,
        'codeText': tokens.codeText.fontSize!,
      };

      expect(actual, _semanticBaseSizes);
    });

    test('§12: inputText is at least 16 for TextField legibility', () {
      expect(tokens.inputText.fontSize, greaterThanOrEqualTo(16));
    });

    test('§12: labelSmall equivalent badgeText is at least 11', () {
      expect(tokens.badgeText.fontSize, greaterThanOrEqualTo(11));
    });

    test('§12: errorText is at least 12', () {
      expect(tokens.errorText.fontSize, greaterThanOrEqualTo(12));
    });

    test('errorText uses ColorScheme.error', () {
      expect(tokens.errorText.color, AppColorSchemes.light.error);
    });

    test('secondary tokens use onSurfaceVariant', () {
      expect(tokens.cardSubtitle.color, AppColorSchemes.light.onSurfaceVariant);
      expect(tokens.formLabel.color, AppColorSchemes.light.onSurfaceVariant);
    });
  });

  group('AppTextTheme Material 3 基准字号', () {
    late TextTheme textTheme;

    setUp(() {
      textTheme = AppTextTheme.build(
        colorScheme: AppColorSchemes.light,
        scale: AdaptiveTypographyScale.fallback(),
      );
    });

    test('matches documented M3 base sizes at 1x', () {
      expect(textTheme.displayLarge!.fontSize, 40);
      expect(textTheme.displayMedium!.fontSize, 36);
      expect(textTheme.displaySmall!.fontSize, 32);
      expect(textTheme.headlineLarge!.fontSize, 30);
      expect(textTheme.headlineMedium!.fontSize, 27);
      expect(textTheme.headlineSmall!.fontSize, 24);
      expect(textTheme.titleLarge!.fontSize, 22);
      expect(textTheme.titleMedium!.fontSize, 18);
      expect(textTheme.titleSmall!.fontSize, 16);
      expect(textTheme.bodyLarge!.fontSize, 17);
      expect(textTheme.bodyMedium!.fontSize, 16);
      expect(textTheme.bodySmall!.fontSize, 14);
      expect(textTheme.labelLarge!.fontSize, 15);
      expect(textTheme.labelMedium!.fontSize, 13);
      expect(textTheme.labelSmall!.fontSize, 11.5);
    });

    test('§12: labelSmall is at least 11', () {
      expect(textTheme.labelSmall!.fontSize, greaterThanOrEqualTo(11));
    });

    test('uses ColorScheme.onSurface for primary text color', () {
      expect(textTheme.bodyMedium!.color, AppColorSchemes.light.onSurface);
    });
  });

  group('AppTheme integration', () {
    test('registers AppTypographyTokens extension', () {
      final theme = AppTheme.light();
      final tokens = theme.extension<AppTypographyTokens>();

      expect(tokens, isNotNull);
      expect(tokens!.inputText.fontSize, 16);
      expect(tokens.errorText.fontSize, 12.5);
    });

    test('AppTypographyTokens lerp interpolates text styles', () {
      final light = AppTheme.light().extension<AppTypographyTokens>()!;
      final dark = AppTheme.dark().extension<AppTypographyTokens>()!;

      final mixed = light.lerp(dark, 0.5);

      expect(mixed.cardTitle.fontSize, light.cardTitle.fontSize);
      expect(mixed.dialogBody.color, isNotNull);
    });

    testWidgets('context.typography resolves from theme', (tester) async {
      late AppTypographyTokens tokens;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) {
              tokens = context.typography;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(tokens.pageTitle.fontSize, 28);
      expect(tokens.sectionTitle.fontSize, 20);
    });

    testWidgets('dark mode secondary text is not pure white', (tester) async {
      late AppTypographyTokens tokens;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              tokens = context.typography;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        tokens.cardSubtitle.color,
        AppColorSchemes.dark.onSurfaceVariant,
      );
      expect(tokens.cardSubtitle.color, isNot(equals(Colors.white)));
    });
  });
}
