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

final rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
  name: 'rootNavigatorKeyProvider',
);

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final bootstrap = ref.watch(appBootstrapProvider);
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final publicRoutes = {AppRoutes.login, AppRoutes.register};

      if (bootstrap.isLoading || bootstrap.hasError) {
        // Splash 初始化未完成或失败时，路由必须停留在启动页，确保 2 秒品牌展示和重试入口可见。
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (auth.status == AuthStatus.unknown) {
        return AppRoutes.splash;
      }
      if (auth.status == AuthStatus.unauthenticated &&
          location == AppRoutes.splash) {
        // Splash 初始化完成且没有恢复到登录态时，明确进入登录页，避免停留在启动图。
        return AppRoutes.login;
      }
      if (!auth.isAuthenticated && !publicRoutes.contains(location)) {
        return AppRoutes.login;
      }
      if (auth.isAuthenticated &&
          (location == AppRoutes.login ||
              location == AppRoutes.register ||
              location == AppRoutes.splash)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      // 首页 / 设置共用 IndexedStack 分支，底部 Tab 切换无左右翻页过渡。
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainTabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
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
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}, name: 'routerProvider');
