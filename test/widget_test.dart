import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter_starter_template/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starter template smoke placeholder', () {
    expect(true, isTrue);
  });

  testWidgets('SplashPage renders configured splash image', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // 测试只验证 Splash UI 结构，因此让启动任务立即完成，避免 pending timer 干扰测试收尾。
          appBootstrapProvider.overrideWith(() => _CompletedSplashController()),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashPage(),
        ),
      ),
    );

    // 首帧应展示用户提供的 assets/images/splash.png。
    expect(find.byType(Image), findsOneWidget);
  });
}

class _CompletedSplashController extends SplashController {
  @override
  Future<void> build() async {}
}
