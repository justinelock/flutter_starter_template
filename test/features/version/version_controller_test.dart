import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/version/data/repositories/version_repository_impl.dart';
import 'package:flutter_starter_template/features/version/domain/entities/version_info.dart';
import 'package:flutter_starter_template/features/version/domain/repositories/version_repository.dart';
import 'package:flutter_starter_template/features/version/presentation/controllers/version_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VersionController starts with null data', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final value = await container.read(versionControllerProvider.future);
    expect(value, isNull);
  });

  test('VersionController reports no update', () async {
    final container = _containerWith(
      const VersionInfo(
        currentVersion: '1.0.0',
        latestVersion: '1.0.0',
        buildNumber: '1',
        forceUpdate: false,
        title: 'No update',
        description: 'Already latest',
        downloadUrl: '',
        platform: 'test',
      ),
    );
    addTearDown(container.dispose);

    // 步骤 1：手动触发检查，模拟设置页点击检查更新。
    final info = await container
        .read(versionControllerProvider.notifier)
        .checkLatest();

    // 步骤 2：无更新时 hasUpdate 为 false，设置页可据此显示“已是最新版”。
    expect(info.hasUpdate, isFalse);
    expect(container.read(versionControllerProvider).value?.hasUpdate, isFalse);
  });

  test('VersionController reports optional update', () async {
    final container = _containerWith(
      const VersionInfo(
        currentVersion: '1.0.0',
        latestVersion: '1.1.0',
        buildNumber: '1',
        forceUpdate: false,
        title: 'Update available',
        description: 'Optional update',
        downloadUrl: 'https://example.com',
        platform: 'test',
      ),
    );
    addTearDown(container.dispose);

    // 普通更新需要展示弹窗，但仍允许用户稍后处理。
    final info = await container
        .read(versionControllerProvider.notifier)
        .checkLatest();
    expect(info.hasUpdate, isTrue);
    expect(info.forceUpdate, isFalse);
  });

  test('VersionController reports force update', () async {
    final container = _containerWith(
      const VersionInfo(
        currentVersion: '1.0.0',
        latestVersion: '2.0.0',
        buildNumber: '1',
        forceUpdate: true,
        title: 'Required update',
        description: 'Force update',
        downloadUrl: 'https://example.com',
        platform: 'test',
      ),
    );
    addTearDown(container.dispose);

    // 强制更新会让 UpdateDialog 不可关闭。
    final info = await container
        .read(versionControllerProvider.notifier)
        .checkLatest();
    expect(info.hasUpdate, isTrue);
    expect(info.forceUpdate, isTrue);
  });
}

ProviderContainer _containerWith(VersionInfo info) {
  return ProviderContainer(
    overrides: [
      versionRepositoryProvider.overrideWithValue(_FakeVersionRepository(info)),
    ],
  );
}

final class _FakeVersionRepository implements VersionRepository {
  const _FakeVersionRepository(this.info);

  final VersionInfo info;

  @override
  Future<VersionInfo> checkLatest() async => info;
}
