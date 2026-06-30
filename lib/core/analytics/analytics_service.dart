import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/environment/env_provider.dart';
import '../logging/app_logger.dart';

final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => ref.watch(featureFlagsProvider).enableAnalytics
      ? RemoteAnalyticsService(ref.watch(appLoggerProvider))
      : NoopAnalyticsService(),
  name: 'analyticsServiceProvider',
);

abstract interface class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?> parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
}

class NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String? value) async {}
}

class RemoteAnalyticsService implements AnalyticsService {
  const RemoteAnalyticsService(this._logger);

  final AppLogger _logger;

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {
    _logger.debug({'analyticsEvent': name, 'parameters': parameters});
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logger.debug('Analytics user id reserved');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    _logger.debug({'analyticsUserProperty': name, 'value': value});
  }
}
