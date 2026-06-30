import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/theme/theme_controller.dart';
import 'package:flutter_starter_template/core/constants/app_storage_keys.dart';
import 'package:flutter_starter_template/core/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  test('ThemeController defaults to system', () {
    final container = _containerWith(_FakeStorageService());
    addTearDown(container.dispose);

    expect(container.read(themeControllerProvider), ThemeMode.system);
  });

  test('ThemeController switches theme and persists value', () async {
    final storage = _FakeStorageService();
    final container = _containerWith(storage);
    addTearDown(container.dispose);

    // 步骤 1：切换到暗色主题，Controller 需要立即更新内存状态。
    await container
        .read(themeControllerProvider.notifier)
        .setThemeMode(ThemeMode.dark);

    // 步骤 2：同时写入存储，保证下次启动可以恢复用户选择。
    expect(container.read(themeControllerProvider), ThemeMode.dark);
    expect(
      await storage.getString(AppStorageKeys.themeMode),
      ThemeMode.dark.name,
    );
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
  // 每个测试都创建独立的内存存储，避免主题持久化状态跨测试污染。
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  return SharedPreferencesAsync();
}
