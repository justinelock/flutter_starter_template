import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../version/domain/entities/version_info.dart';
import '../../../version/presentation/controllers/version_controller.dart';

final settingsControllerProvider = Provider<SettingsController>(
  (ref) => SettingsController(ref),
  name: 'settingsControllerProvider',
);

class SettingsController {
  const SettingsController(this._ref);

  final Ref _ref;

  Future<void> clearCache() => _ref.read(storageServiceProvider).clear();

  Future<void> logout() => _ref.read(authControllerProvider.notifier).logout();

  Future<VersionInfo> checkUpdate() async {
    // Settings 页面只表达“用户发起检查更新”，具体版本来源仍由 VersionController 管理。
    final info = await _ref
        .read(versionControllerProvider.notifier)
        .checkLatest();
    return info;
  }
}
