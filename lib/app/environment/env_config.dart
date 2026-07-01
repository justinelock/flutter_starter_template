import 'app_environment.dart';
import 'feature_flags.dart';

/// 全局环境配置：聚合 API 主机、前缀、Mock、日志与 Feature Flags。
class EnvConfig {
  const EnvConfig({
    required this.appName,
    required this.environment,
    required this.baseUrl,
    required this.apiPrefix,
    required this.enableLog,
    required this.enableVerboseLog,
    required this.enableMock,
    required this.enableCrashReport,
    required this.enableAnalytics,
    required this.enableNetworkMonitor,
    required this.versionCheckUrl,
    required this.featureFlags,
  });

  factory EnvConfig.current() {
    final env = AppEnvironment.fromDartDefine();
    final isProd = env.isProd;

    return EnvConfig(
      appName: isProd ? 'Starter' : 'Starter Debug',
      environment: env,
      // 仅主机：域名或 IP:端口，不含 API 路径。
      baseUrl: isProd
          ? 'https://api.example.com'
          : 'http://192.168.254.127:8091',
      // API 版本/网关前缀，与 baseUrl 分离便于换环境与升级版本。
      apiPrefix: '/api/v1',
      enableLog: !isProd,
      enableVerboseLog: !isProd,
      enableMock: !isProd,
      enableCrashReport: isProd,
      enableAnalytics: isProd,
      enableNetworkMonitor: true,
      // 相对 [apiBaseUrl] 的业务路径。
      versionCheckUrl: '/app/versions/latest',
      featureFlags: FeatureFlags(
        enableVersionCheck: true,
        enableCrashReport: isProd,
        enableAnalytics: isProd,
        enableNetworkMonitor: true,
        enableLiquidGlassFallback: true,
        enableDebugPanel: !isProd,
        enableForceUpdateMock: false,
      ),
    );
  }

  final String appName;
  final AppEnvironment environment;

  /// 服务器主机，如 `https://api.example.com` 或 `http://192.168.1.10:8091`。
  final String baseUrl;

  /// API 路径前缀，以 `/` 开头，如 `/api/v1`。
  final String apiPrefix;

  final bool enableLog;
  final bool enableVerboseLog;
  final bool enableMock;
  final bool enableCrashReport;
  final bool enableAnalytics;
  final bool enableNetworkMonitor;

  /// 版本检查路径（相对 [apiBaseUrl]）。
  final String versionCheckUrl;
  final FeatureFlags featureFlags;

  /// Dio 使用的完整 API 根路径：`baseUrl` + `apiPrefix`。
  String get apiBaseUrl => joinApiBaseUrl(baseUrl: baseUrl, apiPrefix: apiPrefix);

  /// 规范化拼接主机与 API 前缀，避免重复或缺失斜杠。
  static String joinApiBaseUrl({
    required String baseUrl,
    required String apiPrefix,
  }) {
    final host = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    if (apiPrefix.isEmpty) return host;

    final prefix = apiPrefix.startsWith('/') ? apiPrefix : '/$apiPrefix';
    final normalizedPrefix =
        prefix.endsWith('/') ? prefix.substring(0, prefix.length - 1) : prefix;

    return '$host$normalizedPrefix';
  }
}
