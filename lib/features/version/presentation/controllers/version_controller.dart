import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../data/repositories/version_repository_impl.dart';
import '../../domain/entities/version_info.dart';

/// 版本控制器 Provider
/// 
/// 逻辑说明：
/// 使用 AsyncNotifier 管理异步的版本检查结果。
/// 该 Provider 通常在启动流程 (Splash) 或设置页面的“检查更新”按钮中被触发。
final versionControllerProvider =
    AsyncNotifierProvider<VersionController, VersionInfo?>(
      VersionController.new,
      name: 'versionControllerProvider',
    );

/// 版本控制器 (VersionController)
/// 
/// 负责与版本仓库通信，获取最新的应用版本信息，并管理相关的异步加载状态。
class VersionController extends AsyncNotifier<VersionInfo?> {
  @override
  Future<VersionInfo?> build() async => null;

  /// 执行版本检查逻辑
  /// 
  /// 逻辑流程：
  /// 1. 将状态设为 [AsyncLoading]，驱动 UI 显示加载动画（如设置页的进度环）。
  /// 2. 调用 Repository 获取版本数据。
  /// 3. 成功后更新状态为 [AsyncData]，失败则捕获异常并转为 [AsyncError]。
  Future<VersionInfo> checkLatest() async {
    // 设置加载状态，告知监听方操作已开始。
    state = const AsyncLoading();
    final logger = ref.read(appLoggerProvider);
    logger.info('Version check started');

    try {
      // 通过仓库层获取数据。此处屏蔽了是走 Mock 还是 Remote 的细节。
      final info = await ref.read(versionRepositoryProvider).checkLatest();

      // 记录版本对比结果，方便调试排查。
      logger.info(
        'Version check completed: current=${info.currentVersion}, latest=${info.latestVersion}, force=${info.forceUpdate}',
      );
      
      // 更新成功状态，UI 监听者会根据 info.hasUpdate 决定是否显示更新小红点或弹窗。
      state = AsyncData(info);
      return info;
    } catch (error, stackTrace) {
      // 容错逻辑：将异常包装并记录，同时将状态标记为错误。
      logger.warning(
        'Version check failed',
        error: error,
        stackTrace: stackTrace,
      );
      state = AsyncError(error, stackTrace);
      // 向外抛出异常，让调用方（如 UI）决定是否弹出 Toast 提示用户。
      rethrow;
    }
  }
}
