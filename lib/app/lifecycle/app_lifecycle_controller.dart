import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/version/presentation/controllers/version_controller.dart';
import '../environment/env_provider.dart';

final appLifecycleControllerProvider =
    NotifierProvider<AppLifecycleController, AppLifecycleState?>(
      AppLifecycleController.new,
      name: 'appLifecycleControllerProvider',
    );

class AppLifecycleController extends Notifier<AppLifecycleState?> {
  @override
  AppLifecycleState? build() => null;

  void didChangeState(AppLifecycleState state) {
    this.state = state;
    ref.read(appLoggerProvider).info('App lifecycle changed: ${state.name}');

    // 生命周期回调必须尽快返回；需要异步执行的恢复和检查流程放到独立任务中处理。
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_handleResumed());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _handleBackgroundLikeState(state);
    }
  }

  Future<void> _handleResumed() async {
    final logger = ref.read(appLoggerProvider);
    logger.info('App resumed: start foreground refresh');

    try {
      // 步骤 1：回到前台先恢复登录态，避免 token 或本地用户状态在后台期间变化后 UI 不一致。
      await ref.read(authControllerProvider.notifier).restore();

      // 步骤 2：版本检查受 Feature Flags 控制，便于 debug/prod 环境独立开关。
      final flags = ref.read(featureFlagsProvider);
      if (flags.enableVersionCheck) {
        await ref.read(versionControllerProvider.notifier).checkLatest();
      }
    } catch (error, stackTrace) {
      // 步骤 3：前台刷新失败不应中断 App，只记录日志并保留当前页面状态。
      logger.warning(
        'Foreground refresh failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleBackgroundLikeState(AppLifecycleState state) {
    // 后台相关状态当前只记录日志；后续可在这里接入锁屏、token 刷新暂停或安全检查。
    ref.read(appLoggerProvider).info('App entered ${state.name} state');
  }
}
