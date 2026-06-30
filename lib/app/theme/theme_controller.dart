import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_storage_keys.dart';
import '../../core/storage/storage_service.dart';

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
  name: 'themeControllerProvider',
);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    unawaited(_restore());
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(storageServiceProvider)
        .setString(AppStorageKeys.themeMode, mode.name);
  }

  Future<void> _restore() async {
    String? value;
    try {
      value = await ref
          .read(storageServiceProvider)
          .getString(AppStorageKeys.themeMode);
    } catch (_) {
      return;
    }
    if (value == null) return;
    state = ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
