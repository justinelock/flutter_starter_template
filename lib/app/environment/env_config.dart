import 'app_environment.dart';
import 'feature_flags.dart';

class EnvConfig {
  const EnvConfig({
    required this.appName,
    required this.environment,
    required this.baseUrl,
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
      baseUrl: isProd
          ? 'https://api.example.com/api/v1'
          : 'http://192.168.254.127:8091/api/v1',
      enableLog: !isProd,
      enableVerboseLog: !isProd,
      enableMock: !isProd,
      enableCrashReport: isProd,
      enableAnalytics: isProd,
      enableNetworkMonitor: true,
      versionCheckUrl: '/app/versions/latest',
      featureFlags: FeatureFlags(
        enableMockLogin: false,
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
  final String baseUrl;
  final bool enableLog;
  final bool enableVerboseLog;
  final bool enableMock;
  final bool enableCrashReport;
  final bool enableAnalytics;
  final bool enableNetworkMonitor;
  final String versionCheckUrl;
  final FeatureFlags featureFlags;
}
