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

/// 应用启动引导程序 (Bootstrap)
/// 
/// 该函数负责在 [runApp] 之前进行关键基建的初始化。
/// 采用 [runZonedGuarded] 包装以确保能够捕获到由于初始化异步任务导致的未处理异常。
/// 
/// [wrapApp] 用于集成测试或特殊环境下对根组件进行进一步装饰。
Future<void> bootstrap(Widget Function(Widget child) wrapApp) async {
  // 初始化全局日志工具。
  // 它会根据当前的环境变量（EnvConfig）决定日志的输出级别和格式。
  final logger = AppLogger.fromEnvironment();
  
  // 获取当前环境配置（Dev/Prod）。
  // 集中化配置管理确保了整个应用在不同环境下的行为是一致且可预测的。
  final env = EnvConfig.current();

  // 根据环境配置初始化崩溃报告器。
  // 在生产环境 (Prod) 开启真正的上报逻辑；而在开发环境使用 Noop（空操作）实现，避免干扰开发过程。
  final crashReporter = env.featureFlags.enableCrashReport
      ? RemoteCrashReporter(logger)
      : NoopCrashReporter();
      
  // 初始化全局错误处理器。
  // 它聚合了日志记录和崩溃上报的功能，是应用健壮性的第一道防线。
  final errorHandler = GlobalErrorHandler(
    logger: logger,
    crashReporter: crashReporter,
  );

  // 使用 runZonedGuarded 捕获 Flutter 框架外的异步异常（例如 Timer 或异步 I/O 错误）。
  await runZonedGuarded(() async {
    // 确保 Flutter 引擎与原生平台通信通道已建立。
    // 这是所有插件初始化（如 SharedPreference, Firebase）的前提。
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化 Liquid Glass 设计系统组件库。
    // 预热着色器或加载必要资源，以确保应用首屏渲染的平滑度。
    await LiquidGlassWidgets.initialize();

    // 注册框架级错误捕获：
    // 1. handleFlutterError: 处理 Flutter 构建、布局、绘制过程中的异常。
    FlutterError.onError = errorHandler.handleFlutterError;
    // 2. handlePlatformError: 处理底层虚拟机或原生代码通过 Platform Channel 抛出的错误。
    PlatformDispatcher.instance.onError = errorHandler.handlePlatformError;

    // 启动根应用。
    // ProviderScope 是 Riverpod 的核心，负责管理应用内所有 Provider 的生命周期。
    runApp(
      ProviderScope(
        // 注册观察者：实时监控所有状态（Provider）的创建、更新与失败，对调试和线上监控至关重要。
        observers: [AppProviderObserver(logger, crashReporter)],
        child: wrapApp(const StarterApp()),
      ),
    );
  }, 
  // 当 Zone 内发生未捕获的异步异常时，调用全局处理器。
  errorHandler.handleZoneError);
}

/// Riverpod 状态观察器
/// 
/// 负责追踪应用状态树的变化，并在发生错误时自动进行日志记录和崩溃上报。
final class AppProviderObserver extends ProviderObserver {
  AppProviderObserver(this._logger, this._crashReporter);

  final AppLogger _logger;
  final CrashReporter _crashReporter;

  /// 当新的 Provider 被初始化时触发。
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    // 仅在调试模式下打印初始化日志，避免生产环境日志泛滥。
    if (kDebugMode) {
      _logger.debug(
        'Provider initialized: ${context.provider.name ?? context.provider.runtimeType}',
      );
    }
    super.didAddProvider(context, value);
  }

  /// 当 Provider 抛出异常（例如在获取数据、解析 JSON 时）触发。
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // 1. 记录本地错误日志，方便开发者定位问题。
    _logger.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );

    // 2. 将异常上报至崩溃监控系统（如 Sentry/Firebase），以便线上排查。
    // 使用 unawaited 因为上报是后台任务，不应阻塞 UI 逻辑。
    unawaited(
      _crashReporter.recordError(
        error,
        stackTrace,
        reason: 'Riverpod provider failed: ${context.provider.name}',
      ),
    );
    super.providerDidFail(context, error, stackTrace);
  }
}
