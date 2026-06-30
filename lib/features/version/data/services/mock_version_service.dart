import '../models/version_info_model.dart';
import 'version_service.dart';

class MockVersionService implements VersionService {
  const MockVersionService({this.forceUpdate = false});

  final bool forceUpdate;

  @override
  Future<VersionInfoModel> latest({
    required String currentVersion,
    required String buildNumber,
    required String platform,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return VersionInfoModel(
      currentVersion: currentVersion,
      latestVersion: forceUpdate ? '2.0.0' : '1.5.6',
      buildNumber: buildNumber,
      forceUpdate: forceUpdate,
      title: forceUpdate ? 'Required update' : 'Update available',
      description: 'IOS 26 UI, improved glass components, and stability fixes.',
      downloadUrl: 'https://app.example.com/download',
      platform: platform,
    );
  }
}
