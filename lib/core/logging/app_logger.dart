import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../app/environment/env_provider.dart';
import 'log_sanitizer.dart';

/// 全局日志服务 Provider
/// 
/// 逻辑说明：
/// 根据当前的环境配置 (EnvConfig) 实例化 AppLogger。
/// 在 Riverpod 中作为全局单例使用，确保整个应用的日志输出逻辑统一。
final appLoggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(envConfigProvider);
  return AppLogger(
    enableVerbose: env.enableVerboseLog,
    prodMode: env.environment.isProd,
  );
}, name: 'appLoggerProvider');

/// 应用日志封装类 (AppLogger)
/// 
/// 对第三方日志库 [Logger] 进行二次包装。
/// 主要职责：
/// 1. 控制不同环境下的日志输出权限（如生产环境屏蔽部分日志）。
/// 2. 强制执行日志脱敏 ([LogSanitizer])，防止敏感数据泄露到控制台或日志文件。
class AppLogger {
  /// 构造函数
  /// 
  /// [enableVerbose] 是否开启详细调试信息。
  /// [prodMode] 是否为生产模式，在生产模式下会通过权限控制减少非必要日志。
  AppLogger({required this.enableVerbose, required this.prodMode})
    : _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// 静态工厂方法，用于在应用启动早期（Provider 未就绪时）提供基础日志能力。
  factory AppLogger.fromEnvironment() =>
      AppLogger(enableVerbose: true, prodMode: false);

  final bool enableVerbose;
  final bool prodMode;
  final Logger _logger;

  /// 打印调试日志
  /// 
  /// 逻辑说明：仅在非生产环境且开启 Verbose 标志时打印。常用于追踪细碎的逻辑流。
  void debug(Object? message) {
    if (!prodMode && enableVerbose) _logger.d(LogSanitizer.sanitize(message));
  }

  /// 打印普通信息日志
  /// 
  /// 逻辑说明：非生产环境下可见，用于标记关键业务节点。
  void info(Object? message) {
    if (!prodMode) _logger.i(LogSanitizer.sanitize(message));
  }

  /// 打印警告日志
  /// 
  /// 场景：发生了一些非预期的行为，但尚未导致功能不可用。
  void warning(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }

  /// 打印错误日志
  /// 
  /// 场景：功能执行失败，通常需要结合异常对象和堆栈信息进行排查。
  void error(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }

  /// 打印致命错误日志
  /// 
  /// 场景：严重的系统崩溃或核心配置缺失，通常会导致应用无法继续运行。
  void critical(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }
}
