class FeatureFlags {
  const FeatureFlags({
    required this.enableMockLogin,
    required this.enableVersionCheck,
    required this.enableCrashReport,
    required this.enableAnalytics,
    required this.enableNetworkMonitor,
    required this.enableLiquidGlassFallback,
    required this.enableDebugPanel,
    required this.enableForceUpdateMock,
  });

  final bool enableMockLogin;
  final bool enableVersionCheck;
  final bool enableCrashReport;
  final bool enableAnalytics;
  final bool enableNetworkMonitor;
  final bool enableLiquidGlassFallback;
  final bool enableDebugPanel;
  final bool enableForceUpdateMock;

  Map<String, bool> toMap() => {
    'enableMockLogin': enableMockLogin,
    'enableVersionCheck': enableVersionCheck,
    'enableCrashReport': enableCrashReport,
    'enableAnalytics': enableAnalytics,
    'enableNetworkMonitor': enableNetworkMonitor,
    'enableLiquidGlassFallback': enableLiquidGlassFallback,
    'enableDebugPanel': enableDebugPanel,
    'enableForceUpdateMock': enableForceUpdateMock,
  };
}
