import '../entities/version_info.dart';

abstract interface class VersionRepository {
  Future<VersionInfo> checkLatest();
}
