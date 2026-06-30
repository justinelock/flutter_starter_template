import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../data/repositories/version_repository_impl.dart';
import '../../domain/entities/version_info.dart';

final versionControllerProvider =
    AsyncNotifierProvider<VersionController, VersionInfo?>(
      VersionController.new,
      name: 'versionControllerProvider',
    );

class VersionController extends AsyncNotifier<VersionInfo?> {
  @override
  Future<VersionInfo?> build() async => null;

  Future<VersionInfo> checkLatest() async {
    // 步骤 1：进入 loading 状态，让监听方可以展示加载或禁用重复操作。
    state = const AsyncLoading();
    final logger = ref.read(appLoggerProvider);
    logger.info('Version check started');

    // 步骤 2：通过 Repository 获取最新版本信息，保持 Controller 不直接依赖网络或 mock 实现。
    try {
      final info = await ref.read(versionRepositoryProvider).checkLatest();

      // 步骤 3：将结果写回 AsyncValue，供设置页监听弹窗或无更新提示。
      logger.info(
        'Version check completed: current=${info.currentVersion}, latest=${info.latestVersion}, force=${info.forceUpdate}',
      );
      state = AsyncData(info);
      return info;
    } catch (error, stackTrace) {
      // 步骤 4：检查失败时记录日志并把错误交给调用方决定是否提示用户。
      logger.warning(
        'Version check failed',
        error: error,
        stackTrace: stackTrace,
      );
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
