import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/app/theme/app_theme.dart';
import 'package:flutter_starter_template/core/widgets/glass_button.dart';
import 'package:flutter_starter_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_template/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_template/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() {
  testWidgets('LoginPage validates form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: LiquidGlassWidgets.wrap(
          child: MaterialApp(
            theme: AppTheme.light(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LoginPage(),
          ),
        ),
      ),
    );

    // 步骤 1：确认页面基础文案来自 l10n 并正常渲染。
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // 步骤 2：留空手机号并输入过短密码，触发表单本地校验。
    await tester.enterText(find.byType(GlassTextField).first, '');
    await tester.enterText(find.byType(GlassPasswordField), '123');
    await tester.tap(find.byType(AppGlassButton));
    await tester.pump();

    // 步骤 3：错误提示应来自 l10n，而不是底层 service 或硬编码中文。
    expect(find.text('Mobile is required'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}

final class _FakeAuthRepository implements AuthRepository {
  @override
  Future<User?> restoreUser() async => null;

  @override
  Future<User> login({required String mobile, required String password}) async {
    return User(id: 'u_1', email: mobile, displayName: mobile);
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
  Future<void> logout() async {}
}
