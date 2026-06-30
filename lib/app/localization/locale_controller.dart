import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_storage_keys.dart';
import '../../core/storage/storage_service.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
  name: 'localeControllerProvider',
);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    unawaited(_restore());
    return null;
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final storage = ref.read(storageServiceProvider);
    if (locale == null) {
      await storage.remove(AppStorageKeys.locale);
    } else {
      await storage.setString(AppStorageKeys.locale, locale.languageCode);
    }
  }

  Future<void> _restore() async {
    String? value;
    try {
      value = await ref
          .read(storageServiceProvider)
          .getString(AppStorageKeys.locale);
    } catch (_) {
      return;
    }
    if (value == null) return;
    state = Locale(value);
  }
}
