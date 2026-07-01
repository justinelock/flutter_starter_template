import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/app.dart';
import 'package:flutter_starter_template/app/environment/env_config.dart';
import 'package:flutter_starter_template/app/environment/env_provider.dart';
import 'package:flutter_starter_template/app/router/app_router.dart';
import 'package:flutter_starter_template/app/theme/app_glass_theme.dart';
import 'package:flutter_starter_template/core/errors/failure.dart';
import 'package:flutter_starter_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_template/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_template/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter_starter_template/shared/providers/package_info_provider.dart';
import 'package:flutter_starter_template/shared/providers/platform_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await LiquidGlassWidgets.initialize();
  });

  group('App flow integration', () {
    testWidgets('splash bootstrap navigates to login when unauthenticated', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(repository: _FlowAuthRepository()));

      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('successful login navigates to home', (tester) async {
      await tester.pumpWidget(_buildTestApp(repository: _FlowAuthRepository()));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.enterText(
        find.byType(GlassTextField).first,
        'demo@example.com',
      );
      await tester.enterText(
        find.byType(GlassPasswordField),
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Replace this screen with your product home after forking the template.'),
          findsOneWidget);
    });

    testWidgets('unauthenticated deep link to home redirects to login', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(repository: _FlowAuthRepository()));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      final context = tester.element(find.byType(StarterApp));
      ProviderScope.containerOf(context).read(routerProvider).go('/home');
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);
    });
  });
}

Widget _buildTestApp({required AuthRepository repository}) {
  final env = EnvConfig.current();

  return ProviderScope(
    overrides: [
      envConfigProvider.overrideWithValue(env),
      splashMinimumDurationProvider.overrideWithValue(Duration.zero),
      authRepositoryProvider.overrideWithValue(repository),
      packageInfoProvider.overrideWith(
        (ref) async => PackageInfo(
          appName: 'Starter',
          packageName: 'com.example.starter',
          version: '1.0.0',
          buildNumber: '1',
        ),
      ),
      platformNameProvider.overrideWith((ref) => 'test'),
    ],
    child: LiquidGlassWidgets.wrap(
      theme: AppGlassTheme.data,
      child: const StarterApp(),
    ),
  );
}

final class _FlowAuthRepository implements AuthRepository {
  User? _user;

  @override
  Future<User?> restoreUser() async => _user;

  @override
  Future<User> login({required String email, required String password}) async {
    if (password.length < 6) {
      throw const RepositoryFailure(Failure(message: 'Invalid credentials'));
    }
    _user = User(
      id: 'u_flow',
      email: email,
      displayName: email.split('@').first,
    );
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
