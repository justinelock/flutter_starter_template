import 'app_environment.dart';
import 'feature_flags.dart';

/// 全局环境配置类 (EnvConfig)
/// 
/// 该类用于聚合应用在不同运行环境下的所有配置项，包括 API 地址、日志开关、功能开关等。
/// 通过统一的配置中心，避免了在代码中散落 `if (isProd)` 的判断。
class EnvConfig {
  /// 构造函数，包含应用运行所需的所有硬编码或动态生成的配置。
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

  /// 静态工厂方法：根据当前的 Dart Define 或编译环境生成配置实例。
  factory EnvConfig.current() {
    // 从环境变量（--dart-define）解析当前环境（dev/prod/test）
    final env = AppEnvironment.fromDartDefine();
    final isProd = env.isProd;

    return EnvConfig(
      // 应用显示名称：生产环境使用正式名，调试环境添加后缀以便测试人员区分。
      appName: isProd ? 'Starter' : 'Starter Debug',
      environment: env,
      
      // API 根路径：
      // Fork 项目后，应在此处根据环境配置真实的服务器地址。
      baseUrl: isProd
          ? 'https://api.example.com/api/v1'
          : 'https://api.example.com/api/v1',
      
      // 日志控制：非生产环境默认开启，生产环境关闭以保护用户隐私和提升性能。
      enableLog: !isProd,
      enableVerboseLog: !isProd,
      
      // Mock 开关逻辑：
      // 在 Debug 模式下默认开启 Mock，这样开发者即使在没有后端 API 的情况下也能跑通 UI。
      // 在生产模式下必须强制关闭，确保用户连接的是真实服务器。
      enableMock: !isProd,
      
      // 监控与分析：仅在生产环境中上报，避免调试数据污染业务报表。
      enableCrashReport: isProd,
      enableAnalytics: isProd,
      
      // 网络监听：用于在应用内显示网络流量，默认开启以便调试请求。
      enableNetworkMonitor: true,
      
      // 版本检查接口路径，相对于 baseUrl。
      versionCheckUrl: '/app/versions/latest',
      
      // 细粒度的功能开关配置。
      featureFlags: FeatureFlags(
        enableVersionCheck: true,
        enableCrashReport: isProd,
        enableAnalytics: isProd,
        enableNetworkMonitor: true,
        enableLiquidGlassFallback: true, // 当高端视觉效果由于性能原因失败时的降级开关
        enableDebugPanel: !isProd,        // 调试面板：仅在非生产环境显示
        enableForceUpdateMock: false,     // 用于本地测试强制更新流程的开关
      ),
    );
  }

  /// 应用名称
  final String appName;
  
  /// 当前环境枚举 (dev/prod)
  final AppEnvironment environment;
  
  /// API 基础 URL
  final String baseUrl;
  
  /// 是否允许打印基础日志
  final bool enableLog;
  
  /// 是否允许打印详细（如原始请求体）日志
  final bool enableVerboseLog;
  
  /// 是否启用本地 Mock 服务
  final bool enableMock;
  
  /// 是否启用崩溃日志上报
  final bool enableCrashReport;
  
  /// 是否启用业务埋点分析
  final bool enableAnalytics;
  
  /// 是否启用内置网络请求监控器
  final bool enableNetworkMonitor;
  
  /// 远程版本检查地址
  final String versionCheckUrl;
  
  /// 详细的功能旗标
  final FeatureFlags featureFlags;
}
