import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/providers/package_info_provider.dart';
import '../../../../shared/providers/platform_provider.dart';
import '../../domain/entities/version_info.dart';
import '../../domain/repositories/version_repository.dart';
import '../services/mock_version_service.dart';
import '../services/remote_version_service.dart';
import '../services/version_service.dart';

final versionServiceProvider = Provider<VersionService>((ref) {
  final env = ref.watch(envConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  if (env.enableMock) {
    logger.info('Version service selected: mock');
    return MockVersionService(
      forceUpdate: env.featureFlags.enableForceUpdateMock,
    );
  }

  logger.info('Version service selected: remote ${env.versionCheckUrl}');
  return RemoteVersionService(
    apiClient: ref.watch(apiClientProvider),
    endpoint: env.versionCheckUrl,
  );
}, name: 'versionServiceProvider');

final versionRepositoryProvider = Provider<VersionRepository>(
  (ref) => VersionRepositoryImpl(ref),
  name: 'versionRepositoryProvider',
);

class VersionRepositoryImpl implements VersionRepository {
  const VersionRepositoryImpl(this._ref);

  final Ref _ref;

  @override
  Future<VersionInfo> checkLatest() async {
    final packageInfo = await _ref.read(packageInfoProvider.future);
    final platform = _ref.read(platformNameProvider);
    return _ref.read(versionServiceProvider).latest(
          currentVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
          platform: platform,
        );
  }
}
