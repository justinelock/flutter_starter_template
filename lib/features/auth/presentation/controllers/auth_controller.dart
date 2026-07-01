import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.loading = false,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool loading;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? loading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      loading: loading ?? this.loading,
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
  name: 'authControllerProvider',
);

final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(authControllerProvider).user,
  name: 'currentUserProvider',
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    unawaited(restore());
    return const AuthState.unknown();
  }

  Future<void> restore() async {
    final User? user;
    try {
      user = await ref.read(authRepositoryProvider).restoreUser();
    } catch (_) {
      state = const AuthState.unauthenticated();
      return;
    }
    state = user == null
        ? const AuthState.unauthenticated()
        : AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } on RepositoryFailure catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.failure.message,
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(loading: true);
    try {
      final user = await ref.read(authRepositoryProvider).register(
            email: email,
            password: password,
            displayName: displayName,
          );
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } on RepositoryFailure catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.failure.message,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }
}
