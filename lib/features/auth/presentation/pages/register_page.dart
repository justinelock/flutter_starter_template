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
import '../../../../core/utils/validators.dart';
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
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).register(
          email: _email.text.trim(),
          password: _password.text,
        );
    if (!mounted) return;

    ref.read(appMessengerProvider).show(
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
                          controller: _email,
                          label: l10n.emailLabel,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final error = Validators.email(value ?? '');
                            return error == null
                                ? null
                                : _localizedAuthError(error, l10n);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AuthTextField(
                          controller: _password,
                          label: l10n.passwordLabel,
                          obscureText: true,
                          validator: (value) {
                            final error = Validators.password(value ?? '');
                            return error == null
                                ? null
                                : _localizedAuthError(error, l10n);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AuthTextField(
                          controller: _confirm,
                          label: l10n.confirmPasswordLabel,
                          obscureText: true,
                          validator: (value) {
                            return value == _password.text
                                ? null
                                : l10n.passwordMismatch;
                          },
                        ),
                        if (auth.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _localizedAuthError(auth.errorMessage!, l10n),
                            style: context.typography.errorText,
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
  if (message == 'Email is required') return l10n.emailRequired;
  if (message == 'Enter a valid email') return l10n.emailInvalid;
  if (message == 'Password is required') return l10n.passwordRequired;
  if (message == 'Password must be at least 6 characters') {
    return l10n.passwordMinLength;
  }
  if (message == 'Invalid credentials') return l10n.invalidCredentials;
  return l10n.genericError;
}
