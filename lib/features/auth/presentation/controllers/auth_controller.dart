import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

/// 认证状态枚举
enum AuthStatus { 
  /// 初始状态，尚未确定用户是否登录（如应用刚启动时）
  unknown, 
  /// 已登录
  authenticated, 
  /// 未登录
  unauthenticated 
}

/// 认证状态包装类
/// 
/// 聚合了 UI 所需的所有状态信息，包括状态枚举、用户信息、错误信息和加载状态。
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

  /// 辅助判断属性：是否已认证
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// 状态更新辅助方法，确保不可变性 (Immutability)
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? loading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      // 显式传入 null 或新消息以清除/更新错误状态
      errorMessage: errorMessage,
      loading: loading ?? this.loading,
    );
  }
}

/// 全局认证控制器 Provider
/// 
/// 使用 Notifier 管理认证逻辑，它是应用权限控制的核心。
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
  name: 'authControllerProvider',
);

/// 当前用户 Provider
/// 
/// 方便 UI 组件直接监听当前用户信息，无需处理复杂的 AuthState 对象。
final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(authControllerProvider).user,
  name: 'currentUserProvider',
);

/// 认证控制器 (AuthController)
/// 
/// 负责处理所有的身份验证业务逻辑，并根据结果更新 [AuthState]。
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // 【启动策略】：应用启动时自动尝试从本地存储恢复登录状态。
    // 使用 unawaited 因为 build 方法必须同步返回初始状态，恢复操作在后台异步进行。
    unawaited(restore());
    return const AuthState.unknown();
  }

  /// 恢复用户状态
  /// 
  /// 从持久化存储（如 SecureStorage）中读取 Token 并尝试转换回 User 对象。
  Future<void> restore() async {
    final User? user;
    try {
      user = await ref.read(authRepositoryProvider).restoreUser();
    } catch (_) {
      // 如果恢复过程中发生任何异常（如 Token 过期或数据损坏），视作未登录。
      state = const AuthState.unauthenticated();
      return;
    }
    
    // 根据是否获取到用户来更新状态。
    state = user == null
        ? const AuthState.unauthenticated()
        : AuthState(status: AuthStatus.authenticated, user: user);
  }

  /// 执行登录逻辑
  /// 
  /// [email] 用户输入的邮箱
  /// [password] 用户输入的密码
  /// 
  /// 返回 bool 值表示 UI 是否应继续后续跳转逻辑。
  Future<bool> login(String email, String password) async {
    // 1. 设置加载状态，驱动 UI 显示进度条。
    state = state.copyWith(loading: true);
    
    try {
      // 2. 调用 Repository 层执行网络请求。
      final user = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
          
      // 3. 登录成功，更新为已认证状态，并携带用户信息。
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } on RepositoryFailure catch (error) {
      // 4. 登录失败，更新为未认证状态，并向 UI 提供错误反馈。
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.failure.message,
      );
      return false;
    }
  }

  /// 执行注册逻辑
  /// 
  /// 参数与 login 类似，但在 Repository 层会分发到注册接口。
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

  /// 执行登出操作
  /// 
  /// 清除 Repository 中的持久化 Token，并将应用状态重置为未认证。
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }
}
