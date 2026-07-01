import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../version/presentation/controllers/update_gate_controller.dart';
import '../../../version/presentation/controllers/version_controller.dart';
import '../../data/services/branding_service.dart';

/// 启动页最短展示时长 Provider
/// 
/// 逻辑说明：
/// 为了避免在高性能设备上启动页“一闪而过”导致视觉上的跳跃感，我们设定了一个最小展示时长（通常为 2 秒）。
/// 在集成测试中，可以通过 override 此 Provider 为 [Duration.zero] 来加速测试运行。
final splashMinimumDurationProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 2),
  name: 'splashMinimumDurationProvider',
);

/// 启动流程控制器 (SplashController)
/// 
/// 该控制器是应用启动时的总调度官。它负责并行处理所有初始化任务，
/// 并确保在任务完成且满足最小展示时长后，才允许路由层进行页面跳转。
class SplashController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // 1. 创建一个最小展示时长的延时 Future。
    final minimumVisibleFuture = Future<void>.delayed(
      ref.read(splashMinimumDurationProvider),
    );

    // 2. 并行执行真正的业务启动恢复流程。
    // 逻辑设计：让 UI 展示时间与实际初始化时间取较长者，保证视觉平滑度和业务就绪。
    final bootstrapFuture = _runBootstrapTasks();

    // 3. 使用 Future.wait 等待两个任务全部完成。
    // 只有当数据加载完毕且用户看够了启动图，路由守卫（app_router.dart）中的 bootstrap.isLoading 才会变为 false。
    await Future.wait<void>([minimumVisibleFuture, bootstrapFuture]);
  }

  /// 初始化重试
  /// 
  /// 场景：当网络彻底断开导致初始化关键任务失败时，UI 可以调用此方法手动重触发。
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  /// 具体的启动任务列表
  /// 
  /// 逻辑说明：此处聚合了应用运行所需的所有前提条件。
  Future<void> _runBootstrapTasks() async {
    // 步骤 1：加载品牌配置。
    // 逻辑原因：获取动态的启动图背景、Slogan 等，失败不应影响进入主程序。
    await _loadBranding();

    // 步骤 2：恢复登录态。
    // 逻辑原因：必须在 Splash 结束前确定用户身份，以便路由守卫决定是去 LoginPage 还是 HomePage。
    await ref.read(authControllerProvider.notifier).restore();

    // 步骤 3：版本检查与强制更新拦截。
    try {
      final info = await ref
          .read(versionControllerProvider.notifier)
          .checkLatest();

      // 步骤 4：拦截逻辑。
      // 如果发现强更版本，此 Future 将会一直挂起直到用户点击更新，从而阻塞后续的路由跳转。
      await ref
          .read(updateGateControllerProvider.notifier)
          .waitForDecision(info);
    } catch (error, stackTrace) {
      // 容错策略：如果版本检查接口挂了，我们选择让用户继续使用应用，而不是卡在启动页。
      // 仅记录警告，不中断流程。
      ref
          .read(appLoggerProvider)
          .warning(
            'Startup version check skipped after failure',
            error: error,
            stackTrace: stackTrace,
          );
    }
  }

  /// 加载远程品牌配置
  Future<void> _loadBranding() async {
    final env = ref.read(envConfigProvider);
    
    // 【Mock 策略】：如果开启了 Mock，跳过网络请求，防止由于未配置后端导致的启动报错。
    if (env.enableMock) return;

    try {
      await ref.read(brandingServiceProvider).fetch();
    } catch (error, stackTrace) {
      // 品牌配置是增强体验，失败时保留本地兜底资源即可，不影响核心功能。
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

/// 全局应用引导状态 Provider
final appBootstrapProvider = AsyncNotifierProvider<SplashController, void>(
  SplashController.new,
  name: 'appBootstrapProvider',
);
