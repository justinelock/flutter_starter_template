import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/controllers/splash_controller.dart';
import '../../features/splash/presentation/pages/not_found_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';
import 'main_tab_shell.dart';

/// 全局根导航 Key Provider
/// 
/// 逻辑说明：
/// 使用 GlobalKey<NavigatorState> 可以让我们在不依赖 BuildContext 的情况下（例如在 Provider 或 Service 中）
/// 直接进行全局弹窗或路由跳转。
final rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
  name: 'rootNavigatorKeyProvider',
);

/// 核心路由配置 Provider
/// 
/// 该 Provider 负责初始化 GoRouter，并定义了应用内最关键的“重定向守卫”逻辑。
/// 通过监听 [authControllerProvider] 和 [appBootstrapProvider]，实现认证状态与 UI 的自动同步。
final routerProvider = Provider<GoRouter>((ref) {
  // 监听认证状态（登录、未登录、初始状态）
  final auth = ref.watch(authControllerProvider);
  // 监听应用启动引导状态（是否正在加载初始化数据）
  final bootstrap = ref.watch(appBootstrapProvider);
  // 获取根导航 Key
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    
    /// 路由重定向守卫 (Redirect Guard)
    /// 
    /// 这是应用的安全屏障，决定了用户在特定状态下能访问哪些页面。
    redirect: (context, state) {
      final location = state.matchedLocation;
      final publicRoutes = {AppRoutes.login, AppRoutes.register};

      // 1. 引导期策略：
      // 如果应用正在加载基础数据（如检查更新、加载品牌配置等），强制停留在 Splash 页。
      // 理由：确保应用进入业务逻辑前，必要的配置已经就绪，防止页面报错。
      if (bootstrap.isLoading || bootstrap.hasError) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // 2. 认证未知状态策略：
      // 刚启动时还没确定用户是否有 Token，暂时留在 Splash 等待 AuthController 初始化完成。
      if (auth.status == AuthStatus.unknown) {
        return AppRoutes.splash;
      }

      // 3. 未认证逻辑：
      // 如果用户未登录且当前正试图访问非公开页面（如首页、设置），强制跳转至登录页。
      if (auth.status == AuthStatus.unauthenticated &&
          location == AppRoutes.splash) {
        return AppRoutes.login;
      }
      
      if (!auth.isAuthenticated && !publicRoutes.contains(location)) {
        return AppRoutes.login;
      }

      // 4. 已认证逻辑：
      // 如果用户已登录，且当前试图访问登录页、注册页或启动页，则自动重定向至首页。
      // 理由：提升用户体验，避免用户在已登录状态下重复操作登录流程。
      if (auth.isAuthenticated &&
          (location == AppRoutes.login ||
              location == AppRoutes.register ||
              location == AppRoutes.splash)) {
        return AppRoutes.home;
      }

      // 返回 null 代表允许本次导航。
      return null;
    },
    
    /// 路由表定义
    routes: [
      // 启动页：负责品牌展示和初始化进度监控
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      // 身份认证相关页面
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      
      /// 主体功能区（采用 StatefulShellRoute 以支持底部 Tab 的状态保持）
      /// 
      /// 逻辑说明：
      /// 使用 IndexedStack 模式，切换 Tab 时不会销毁页面，用户回退或重新点击 Tab 时
      /// 仍能看到之前的页面滚动位置和输入状态。
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainTabShell(navigationShell: navigationShell),
        branches: [
          // 分支 1：首页
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // 分支 2：设置中心
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    
    // 全局 404 错误页
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}, name: 'routerProvider');
