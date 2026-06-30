import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../app/environment/env_provider.dart';
import 'log_sanitizer.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(envConfigProvider);
  return AppLogger(
    enableVerbose: env.enableVerboseLog,
    prodMode: env.environment.isProd,
  );
}, name: 'appLoggerProvider');

class AppLogger {
  AppLogger({required this.enableVerbose, required this.prodMode})
    : _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  factory AppLogger.fromEnvironment() =>
      AppLogger(enableVerbose: true, prodMode: false);

  final bool enableVerbose;
  final bool prodMode;
  final Logger _logger;

  void debug(Object? message) {
    if (!prodMode && enableVerbose) _logger.d(LogSanitizer.sanitize(message));
  }

  void info(Object? message) {
    if (!prodMode) _logger.i(LogSanitizer.sanitize(message));
  }

  void warning(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }

  void error(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }

  void critical(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(
      LogSanitizer.sanitize(message),
      error: LogSanitizer.sanitize(error),
      stackTrace: stackTrace,
    );
  }
}
