import 'dart:async';

import 'package:flutter/foundation.dart';

import '../crash/crash_reporter.dart';
import '../logging/app_logger.dart';

/// 全局错误处理器 (GlobalErrorHandler)
/// 
/// 该类是应用稳定性的核心守护者，负责统一接收并处理来自 Flutter 框架、
/// 底层平台以及异步 Zone 的所有异常。
/// 它将错误分发到日志系统（本地排查）和崩溃报告系统（远程监控）。
class GlobalErrorHandler {
  /// 构造函数，注入日志工具和崩溃报告器。
  const GlobalErrorHandler({required this.logger, required this.crashReporter});

  /// 本地日志输出工具。
  final AppLogger logger;
  
  /// 远程崩溃报告服务（如 Sentry 或 Firebase Crashlytics 的抽象）。
  final CrashReporter crashReporter;

  /// 处理 Flutter 框架捕获的异常
  /// 
  /// 场景：Widget 构建失败、布局溢出、或者在渲染过程中抛出的异常。
  void handleFlutterError(FlutterErrorDetails details) {
    // 1. 调用 Flutter 官方默认实现，在控制台打印美化的错误信息（Debug 模式下非常有用）。
    FlutterError.presentError(details);

    // 2. 记录到本地日志系统，标记为 ERROR 级别。
    logger.error(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );

    // 3. 【策略原因】：异步上报至远程后台。
    // 使用 unawaited 是因为我们不希望错误处理逻辑阻塞当前的 UI 线程，
    // 同时也因为崩溃上报本身就是一个尽力而为的操作。
    unawaited(
      crashReporter.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        reason: 'Flutter framework error',
      ),
    );
  }

  /// 处理平台级异常
  /// 
  /// 场景：通过 PlatformDispatcher 捕获的异常，通常源自 Native 插件回调或底层虚拟机错误。
  /// 返回 true 表示错误已被处理。
  bool handlePlatformError(Object error, StackTrace stackTrace) {
    // 1. 使用 CRITICAL 级别记录，因为这类错误通常会导致应用无响应或闪退。
    logger.critical('Platform error', error: error, stackTrace: stackTrace);

    // 2. 同样需要进入崩溃预留层进行远程追踪。
    unawaited(
      crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Platform dispatcher error',
      ),
    );
    return true;
  }

  /// 处理异步 Zone 异常
  /// 
  /// 场景：在 [runZonedGuarded] 中捕获的异常，通常是那些没有被 try-catch 覆盖的异步操作（如 Timer 或 IO）。
  void handleZoneError(Object error, StackTrace stackTrace) {
    // 1. 记录未捕获的异步 Zone 错误。
    logger.critical(
      'Uncaught zone error',
      error: error,
      stackTrace: stackTrace,
    );

    // 2. 这种错误是应用的“最后一道防线”捕获到的，必须作为最高优先级的崩溃候选进行上报。
    unawaited(
      crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Uncaught zone error',
      ),
    );
  }
}
