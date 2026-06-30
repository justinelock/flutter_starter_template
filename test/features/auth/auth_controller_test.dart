import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/core/errors/failure.dart';
import 'package:flutter_starter_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_template/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_template/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthController starts with unknown state', () {
    final container = _containerWith(_FakeAuthRepository());
    addTearDown(container.dispose);

    expect(container.read(authControllerProvider).status, AuthStatus.unknown);
  });

  test('AuthController logs in successfully', () async {
    final container = _containerWith(_FakeAuthRepository());
    addTearDown(container.dispose);

    // 步骤 1：执行成功登录，Controller 应写入 authenticated 状态和当前用户。
    final success = await container
        .read(authControllerProvider.notifier)
        .login('13800138000', 'password');

    // 步骤 2：断言 UI 可依赖的状态已更新，而不是直接关心底层 token 存储。
    final state = container.read(authControllerProvider);
    expect(success, isTrue);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, '13800138000');
  });

  test('AuthController exposes failure message when login fails', () async {
    final container = _containerWith(_FakeAuthRepository(shouldFail: true));
    addTearDown(container.dispose);

    // 步骤 1：模拟 repository 失败，验证 Controller 会转为未登录状态。
    final success = await container
        .read(authControllerProvider.notifier)
        .login('13800138000', 'bad');

    // 步骤 2：错误信息保留给页面做本地化映射，不在测试中依赖具体 UI 文案。
    final state = container.read(authControllerProvider);
    expect(success, isFalse);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.errorMessage, 'Invalid credentials');
  });

  test('AuthController logs out after authentication', () async {
    final container = _containerWith(_FakeAuthRepository());
    addTearDown(container.dispose);

    // 步骤 1：先登录进入 authenticated，确保 logout 测试从真实状态转移开始。
    await container
        .read(authControllerProvider.notifier)
        .login('13800138000', 'password');

    // 步骤 2：退出后应清空用户并回到 unauthenticated。
    await container.read(authControllerProvider.notifier).logout();
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.unauthenticated,
    );
    expect(container.read(authControllerProvider).user, isNull);
  });
}

ProviderContainer _containerWith(AuthRepository repository) {
  return ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.shouldFail = false});

  final bool shouldFail;
  User? _user;

  @override
  Future<User?> restoreUser() async => _user;

  @override
  Future<User> login({required String mobile, required String password}) async {
    if (shouldFail) {
      throw const RepositoryFailure(Failure(message: 'Invalid credentials'));
    }
    _user = User(id: 'u_1', email: mobile, displayName: mobile);
    return _user!;
  }

  @override
  Future<User> register({
    required String username,
    required String password,
    required String realName,
    required String idCard,
    required String inviteCode,
  }) => login(mobile: username, password: password);

  @override
  Future<void> logout() async {
    _user = null;
  }
}
