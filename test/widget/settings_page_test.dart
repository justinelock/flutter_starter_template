import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/theme/theme_controller.dart';
import 'package:flutter_starter_template/core/storage/storage_service.dart';
import 'package:flutter_starter_template/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:flutter_starter_template/shared/providers/package_info_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('SettingsPage switches theme from segmented control', (
    tester,
  ) async {
    final storage = _FakeStorageService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          packageInfoProvider.overrideWith(
            (ref) async => PackageInfo(
              appName: 'Starter',
              packageName: 'com.example.starter',
              version: '1.0.0',
              buildNumber: '1',
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 步骤 1：确认设置页基础文案来自 l10n 并正常渲染。
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Theme'), findsOneWidget);

    // 步骤 2：点击 Dark 选项，验证 UI 交互会驱动 ThemeController 状态变化。
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(themeControllerProvider), ThemeMode.dark);
  });
}

final class _FakeStorageService extends StorageService {
  _FakeStorageService() : super(_createTestPreferences());
}

SharedPreferencesAsync _createTestPreferences() {
  // Widget 测试使用独立内存 preferences，避免真实平台插件参与。
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  return SharedPreferencesAsync();
}
