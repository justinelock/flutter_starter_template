import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../version/presentation/controllers/update_gate_controller.dart';
import '../../../version/presentation/controllers/version_controller.dart';
import '../../data/services/branding_service.dart';

/// 启动页最短展示时长；测试可通过 override 设为 [Duration.zero]。
final splashMinimumDurationProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 2),
  name: 'splashMinimumDurationProvider',
);

class SplashController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    final minimumVisibleFuture = Future<void>.delayed(
      ref.read(splashMinimumDurationProvider),
    );

    // 步骤 2：并行执行启动恢复流程，让 UI 展示时间和实际初始化时间取较长者。
    final bootstrapFuture = _runBootstrapTasks();

    // 步骤 3：两个任务都完成后才允许路由根据认证状态跳转到登录页或首页。
    await Future.wait<void>([minimumVisibleFuture, bootstrapFuture]);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> _runBootstrapTasks() async {
    // 步骤 1：请求启动品牌配置接口；失败不阻塞本地 splash 展示和后续跳转。
    await _loadBranding();

    // 步骤 2：恢复登录态，决定 Splash 后进入首页还是登录页。
    await ref.read(authControllerProvider.notifier).restore();

    // 步骤 3：启动时检查版本更新，后续由监听方决定是否弹出更新对话框。
    try {
      final info = await ref
          .read(versionControllerProvider.notifier)
          .checkLatest();

      // 步骤 4：发现新版本时阻塞启动流程，等待用户选择更新或跳过。
      await ref
          .read(updateGateControllerProvider.notifier)
          .waitForDecision(info);
    } catch (error, stackTrace) {
      // 版本接口失败不应阻塞用户进入登录页/首页，只记录日志并允许后续在设置页重试。
      ref
          .read(appLoggerProvider)
          .warning(
            'Startup version check skipped after failure',
            error: error,
            stackTrace: stackTrace,
          );
    }
  }

  Future<void> _loadBranding() async {
    final env = ref.read(envConfigProvider);
    // mock 环境不请求远端品牌配置，避免未配置 API 时启动阶段产生无意义网络错误。
    if (env.enableMock) return;

    try {
      await ref.read(brandingServiceProvider).fetch();
    } catch (error, stackTrace) {
      // 品牌配置是启动增强能力，接口失败时保留本地 assets/images/splash.png 作为兜底。
      ref
          .read(appLoggerProvider)
          .warning(
            'Startup branding request skipped after failure',
            error: error,
            stackTrace: stackTrace,
          );
    }
  }
}

final appBootstrapProvider = AsyncNotifierProvider<SplashController, void>(
  SplashController.new,
  name: 'appBootstrapProvider',
);
