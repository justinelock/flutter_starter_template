import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/environment/env_config.dart';
import 'package:flutter_starter_template/app/environment/env_provider.dart';
import 'package:flutter_starter_template/core/widgets/glass_scaffold.dart';
import 'package:flutter_starter_template/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_starter_template/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_starter_template/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:flutter_starter_template/shared/providers/package_info_provider.dart';
import 'package:flutter_starter_template/shared/providers/platform_provider.dart';
import 'package:flutter_starter_template/shared/widgets/app_bottom_navigation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUp(() {
    // 测试期间将 RenderFlex 溢出视为失败，便于回归捕获布局问题。
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) {
        throw TestFailure(details.exceptionAsString());
      }
      originalOnError?.call(details);
    };
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        envConfigProvider.overrideWithValue(EnvConfig.current()),
        packageInfoProvider.overrideWith(
          (ref) async => PackageInfo(
            appName: 'Starter',
            packageName: 'com.example.starter',
            version: '1.0.0',
            buildNumber: '1',
          ),
        ),
        platformNameProvider.overrideWith((ref) => 'iOS'),
        currentUserProvider.overrideWith((ref) => const User(
              id: 'u_1',
              email: 'demo@example.com',
              displayName: 'Demo',
            )),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppGlassScaffold(
          body: child,
          bottomNavigationBar: AppBottomNavigation(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('HomePage has no overflow on iPhone 17 Pro logical size', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402 * 3, 874 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(const HomePage()));
    await tester.pumpAndSettle();
  });

  testWidgets('SettingsPage has no overflow on iPhone 17 Pro logical size', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402 * 3, 874 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(const SettingsPage()));
    await tester.pumpAndSettle();
  });
}
