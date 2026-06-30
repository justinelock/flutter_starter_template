import '../../domain/entities/version_info.dart';

abstract interface class VersionService {
  Future<VersionInfo> latest({
    required String currentVersion,
    required String buildNumber,
    required String platform,
  });
}
