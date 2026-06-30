import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app/app.dart';
import 'app/environment/env_config.dart';
import 'core/crash/crash_reporter.dart';
import 'core/errors/global_error_handler.dart';
import 'core/logging/app_logger.dart';

Future<void> bootstrap(Widget Function(Widget child) wrapApp) async {
  final logger = AppLogger.fromEnvironment();
  final env = EnvConfig.current();

  // 在 ProviderScope 创建前先准备崩溃上报预留实现，确保启动早期错误也能进入同一处理链。
  // debug 默认使用 Noop，prod 或开启开关后切换到 RemoteCrashReporter 占位实现。
  final crashReporter = env.featureFlags.enableCrashReport
      ? RemoteCrashReporter(logger)
      : NoopCrashReporter();
  final errorHandler = GlobalErrorHandler(
    logger: logger,
    crashReporter: crashReporter,
  );

  // 必须在同一 Zone 内完成 Binding 初始化与 runApp，否则会触发 Zone mismatch。
  await runZonedGuarded(() async {
    // 步骤 1：初始化 Flutter Binding（与后续 runApp 保持同一 Zone）。
    WidgetsFlutterBinding.ensureInitialized();

    await LiquidGlassWidgets.initialize();

    // 步骤 2：注册全局错误回调，确保初始化与运行期异常均可被捕获。
    FlutterError.onError = errorHandler.handleFlutterError;
    PlatformDispatcher.instance.onError = errorHandler.handlePlatformError;

    // 步骤 4：挂载 ProviderScope 并启动应用根 Widget。
    runApp(
      ProviderScope(
        observers: [AppProviderObserver(logger, crashReporter)],
        child: wrapApp(const StarterApp()),
      ),
    );
  }, errorHandler.handleZoneError);
}

final class AppProviderObserver extends ProviderObserver {
  AppProviderObserver(this._logger, this._crashReporter);

  final AppLogger _logger;
  final CrashReporter _crashReporter;

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (kDebugMode) {
      _logger.debug(
        'Provider initialized: ${context.provider.name ?? context.provider.runtimeType}',
      );
    }
    super.didAddProvider(context, value);
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );

    // Provider 异常通常代表状态初始化或异步控制器失败，需要进入崩溃预留层便于线上排查。
    unawaited(
      _crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Riverpod provider failed',
      ),
    );
    super.providerDidFail(context, error, stackTrace);
  }
}
