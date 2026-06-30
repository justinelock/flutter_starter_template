import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/theme/typography_extensions.dart';
import '../../../../core/messaging/app_messenger.dart';
import '../../../../core/messaging/app_snackbar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../shared/widgets/page_container.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_page_header.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _realName = TextEditingController();
  final _idCard = TextEditingController();
  final _inviteCode = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    _realName.dispose();
    _idCard.dispose();
    _inviteCode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 步骤 1：先执行邮箱、密码和确认密码校验，阻止无效注册请求。
    if (!_formKey.currentState!.validate()) return;

    // 步骤 2：页面只提交已校验的数据，注册状态和错误转换由 AuthController 负责。
    final success = await ref
        .read(authControllerProvider.notifier)
        .register(
          username: _username.text.trim(),
          password: _password.text,
          realName: _realName.text.trim(),
          idCard: _idCard.text.trim(),
          inviteCode: _inviteCode.text.trim(),
        );
    if (!mounted) return;

    // 步骤 3：注册完成后统一通过 AppMessenger 给用户结果反馈。
    ref
        .read(appMessengerProvider)
        .show(
          success ? context.l10n.registerSuccess : context.l10n.registerFailed,
          type: success ? AppSnackBarType.success : AppSnackBarType.error,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final l10n = context.l10n;
    return AppGlassScaffold(
      backgroundGradient: context.gradients.auth,
      body: PageContainer(
        maxWidth: 460,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.page,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthPageHeader(title: l10n.registerTitle, showLogo: false),
                const SizedBox(height: AppSpacing.lg),
                AppGlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    AuthTextField(
                      controller: _username,
                      label: l10n.usernameLabel,
                      validator: (value) {
                        // username 对应真实注册接口字段，必须由用户显式填写。
                        final username = (value ?? '').trim();
                        return username.isEmpty ? l10n.usernameRequired : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _realName,
                      label: l10n.realNameLabel,
                      validator: (value) {
                        // realName 是后端 UserRegisterReq 的必填资料字段。
                        final realName = (value ?? '').trim();
                        return realName.isEmpty ? l10n.realNameRequired : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _idCard,
                      label: l10n.idCardLabel,
                      validator: (value) {
                        // idCard 先做必填校验，具体证件规则由真实后端统一校验。
                        final idCard = (value ?? '').trim();
                        return idCard.isEmpty ? l10n.idCardRequired : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _inviteCode,
                      label: l10n.inviteCodeLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _password,
                      label: l10n.passwordLabel,
                      obscureText: true,
                      validator: (value) {
                        // 步骤 1：密码为空时提示用户补全必填项。
                        final password = value ?? '';
                        if (password.isEmpty) return l10n.passwordRequired;

                        // 步骤 2：保持 mock 与真实服务前置校验一致，至少 6 位。
                        return password.length >= 6
                            ? null
                            : l10n.passwordMinLength;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _confirm,
                      label: l10n.confirmPasswordLabel,
                      obscureText: true,
                      validator: (value) {
                        // 确认密码只负责与首次输入比对，不重复做复杂密码策略。
                        return value == _password.text
                            ? null
                            : l10n.passwordMismatch;
                      },
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _localizedAuthError(auth.errorMessage!, l10n),
                        style: context.typography.errorText.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    AuthSubmitButton(
                      label: l10n.register,
                      loading: auth.loading,
                      onPressed: _submit,
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(l10n.backToLoginAction),
                    ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _localizedAuthError(String message, AppLocalizations l10n) {
  // 步骤 1：将 service/repository 层的已知英文错误映射为当前 Locale 文案。
  if (message == 'Email is required') return l10n.emailRequired;
  if (message == 'Enter a valid email') return l10n.emailInvalid;
  if (message == 'Password is required') return l10n.passwordRequired;
  if (message == 'Password must be at least 6 characters') {
    return l10n.passwordMinLength;
  }
  if (message == 'Invalid credentials') return l10n.invalidCredentials;

  // 步骤 2：其他错误统一隐藏底层细节，符合生产环境友好错误提示要求。
  return l10n.genericError;
}
