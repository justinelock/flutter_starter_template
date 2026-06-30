import 'dart:async';

import 'package:flutter/foundation.dart';

import '../crash/crash_reporter.dart';
import '../logging/app_logger.dart';

class GlobalErrorHandler {
  const GlobalErrorHandler({required this.logger, required this.crashReporter});

  final AppLogger logger;
  final CrashReporter crashReporter;

  void handleFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.error(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );

    // Flutter 框架错误需要同时进入崩溃预留层，后续接入 Crashlytics/Sentry 时可复用此入口。
    unawaited(
      crashReporter.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        reason: 'Flutter framework error',
      ),
    );
  }

  bool handlePlatformError(Object error, StackTrace stackTrace) {
    logger.critical('Platform error', error: error, stackTrace: stackTrace);

    // PlatformDispatcher 捕获的是平台通道或异步边界错误，同样需要进入崩溃上报。
    unawaited(
      crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Platform dispatcher error',
      ),
    );
    return true;
  }

  void handleZoneError(Object error, StackTrace stackTrace) {
    logger.critical(
      'Uncaught zone error',
      error: error,
      stackTrace: stackTrace,
    );

    // Zone 捕获的是未被业务层处理的兜底异常，必须作为崩溃候选上报。
    unawaited(
      crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Uncaught zone error',
      ),
    );
  }
}
