import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/localization/locale_controller.dart';
import 'package:flutter_starter_template/core/constants/app_storage_keys.dart';
import 'package:flutter_starter_template/core/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  test('LocaleController defaults to system locale', () {
    final container = _containerWith(_FakeStorageService());
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider), isNull);
  });

  test('LocaleController switches locale and persists value', () async {
    final storage = _FakeStorageService();
    final container = _containerWith(storage);
    addTearDown(container.dispose);

    // 步骤 1：切换到中文 Locale，Controller 需要立即更新 UI 状态。
    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('zh'));

    // 步骤 2：语言代码持久化后，后续启动可恢复到相同语言。
    expect(container.read(localeControllerProvider)?.languageCode, 'zh');
    expect(await storage.getString(AppStorageKeys.locale), 'zh');
  });

  test('LocaleController clears locale when following system', () async {
    final storage = _FakeStorageService();
    final container = _containerWith(storage);
    addTearDown(container.dispose);

    // 步骤 1：先设置固定语言，再切回系统语言。
    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('en'));
    await container.read(localeControllerProvider.notifier).setLocale(null);

    // 步骤 2：状态和持久化值都应清空，避免继续覆盖系统语言。
    expect(container.read(localeControllerProvider), isNull);
    expect(await storage.getString(AppStorageKeys.locale), isNull);
  });
}

ProviderContainer _containerWith(StorageService storage) {
  return ProviderContainer(
    overrides: [storageServiceProvider.overrideWithValue(storage)],
  );
}

final class _FakeStorageService extends StorageService {
  _FakeStorageService() : super(_createTestPreferences());
}

SharedPreferencesAsync _createTestPreferences() {
  // 每个测试都使用新的内存存储，确保语言持久化断言互不影响。
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  return SharedPreferencesAsync();
}
