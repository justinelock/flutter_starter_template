import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/version_info_model.dart';
import 'version_service.dart';

class RemoteVersionService implements VersionService {
  const RemoteVersionService({required this.apiClient, required this.endpoint});

  final ApiClient apiClient;
  final String endpoint;

  @override
  Future<VersionInfoModel> latest({
    required String currentVersion,
    required String buildNumber,
    required String platform,
  }) async {
    // 版本接口路径来自 EnvConfig，方便 debug/prod 指向不同后端环境。
    final response = await apiClient.get(endpoint);
    final json = response.data;
    if (json is! Map || json['code'] != 0) {
      throw const VersionException('Version check failed');
    }
    return VersionInfoModel.fromApi(
      data: Map<String, dynamic>.from(json['data'] as Map),
      currentVersion: currentVersion,
      buildNumber: buildNumber,
      platform: platform,
    );
  }
}
