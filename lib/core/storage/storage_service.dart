import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(SharedPreferencesAsync()),
  name: 'storageServiceProvider',
);

class StorageService {
  const StorageService(this._prefs);

  final SharedPreferencesAsync _prefs;

  Future<String?> getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<bool?> getBool(String key) => _prefs.getBool(key);

  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clear() => _prefs.clear();
}
