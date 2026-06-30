import '../../domain/entities/version_info.dart';

class VersionInfoModel extends VersionInfo {
  const VersionInfoModel({
    required super.currentVersion,
    required super.latestVersion,
    required super.buildNumber,
    required super.forceUpdate,
    required super.title,
    required super.description,
    required super.downloadUrl,
    required super.platform,
  });

  factory VersionInfoModel.fromApi({
    required Map<String, dynamic> data,
    required String currentVersion,
    required String buildNumber,
    required String platform,
  }) {
    return VersionInfoModel(
      currentVersion: currentVersion,
      latestVersion: data['version']?.toString() ?? currentVersion,
      buildNumber: buildNumber,
      forceUpdate: data['isForce'] == true,
      title: 'Update available',
      description: data['description']?.toString() ?? '',
      downloadUrl:
          data['downloadUrl']?.toString() ?? data['iosUrl']?.toString() ?? '',
      platform: platform,
    );
  }
}
