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

    final success = await container
        .read(authControllerProvider.notifier)
        .login('demo@example.com', 'password');

    final state = container.read(authControllerProvider);
    expect(success, isTrue);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, 'demo@example.com');
  });

  test('AuthController exposes failure message when login fails', () async {
    final container = _containerWith(_FakeAuthRepository(shouldFail: true));
    addTearDown(container.dispose);

    final success = await container
        .read(authControllerProvider.notifier)
        .login('demo@example.com', 'bad');

    final state = container.read(authControllerProvider);
    expect(success, isFalse);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.errorMessage, 'Invalid credentials');
  });

  test('AuthController logs out after authentication', () async {
    final container = _containerWith(_FakeAuthRepository());
    addTearDown(container.dispose);

    await container
        .read(authControllerProvider.notifier)
        .login('demo@example.com', 'password');

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
  Future<User> login({required String email, required String password}) async {
    if (shouldFail) {
      throw const RepositoryFailure(Failure(message: 'Invalid credentials'));
    }
    _user = User(id: 'u_1', email: email, displayName: email.split('@').first);
    return _user!;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    String? displayName,
  }) =>
      login(email: email, password: password);

  @override
  Future<void> logout() async {
    _user = null;
  }
}
