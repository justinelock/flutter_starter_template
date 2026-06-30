import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';

final brandingServiceProvider = Provider<BrandingService>(
  (ref) => BrandingService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
  ),
  name: 'brandingServiceProvider',
);

class BrandingInfo {
  const BrandingInfo({
    required this.revision,
    required this.splashEnabled,
    this.splashImageUrl,
  });

  final String revision;
  final bool splashEnabled;
  final String? splashImageUrl;
}

class BrandingService {
  const BrandingService({required this.apiClient, required this.logger});

  final ApiClient apiClient;
  final AppLogger logger;

  Future<BrandingInfo?> fetch() async {
    logger.info('Branding request started: /app/branding');

    // 步骤 1：请求文档给出的启动品牌配置接口，用于后续扩展远端 splash 图。
    final response = await apiClient.get('/app/branding');
    final json = response.data;
    if (json is! Map || json['code'] != 0) {
      logger.warning('Branding request returned invalid response');
      return null;
    }

    // 步骤 2：接口 data 结构允许 splash.imageUrl 为空，因此解析时保持空值安全。
    final data = Map<String, dynamic>.from(json['data'] as Map);
    final splash = data['splash'] is Map
        ? Map<String, dynamic>.from(data['splash'] as Map)
        : const <String, dynamic>{};
    final info = BrandingInfo(
      revision: data['revision']?.toString() ?? '',
      splashEnabled: splash['enabled'] == true,
      splashImageUrl: splash['imageUrl']?.toString(),
    );

    // 步骤 3：记录解析结果，方便启动阶段排查远端配置是否生效。
    logger.info(
      'Branding request completed: revision=${info.revision}, splashEnabled=${info.splashEnabled}',
    );
    return info;
  }
}
