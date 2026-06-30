import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/environment/env_provider.dart';
import '../logging/app_logger.dart';

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => ref.watch(featureFlagsProvider).enableCrashReport
      ? RemoteCrashReporter(ref.watch(appLoggerProvider))
      : NoopCrashReporter(),
  name: 'crashReporterProvider',
);

abstract interface class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  });
  Future<void> setUserId(String? userId);
  Future<void> setCustomKey(String key, Object value);
}

class NoopCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}

class RemoteCrashReporter implements CrashReporter {
  const RemoteCrashReporter(this._logger);

  final AppLogger _logger;

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    _logger.warning(
      'Crash reporter placeholder: ${reason ?? 'recordError'}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    _logger.debug('Crash custom key reserved: $key');
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logger.debug('Crash user id reserved');
  }
}
