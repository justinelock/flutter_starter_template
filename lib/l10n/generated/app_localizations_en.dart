// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Starter Template';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get emailLabel => 'Email';

  @override
  String get mobileLabel => 'Mobile';

  @override
  String get usernameLabel => 'Username';

  @override
  String get realNameLabel => 'Real name';

  @override
  String get idCardLabel => 'ID card';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get backToLoginAction => 'Back to login';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get mobileRequired => 'Mobile is required';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get realNameRequired => 'Real name is required';

  @override
  String get idCardRequired => 'ID card is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get loginSuccess => 'Signed in successfully';

  @override
  String get loginFailed => 'Sign in failed';

  @override
  String get registerSuccess => 'Account created successfully';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get logoutSuccess => 'Signed out successfully';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get noUpdates => 'You\'re already on the latest version';

  @override
  String get updateCheckFailed => 'Unable to check for updates';

  @override
  String get themeSection => 'Theme';

  @override
  String get languageSection => 'Language';

  @override
  String get appSection => 'App';

  @override
  String get versionLabel => 'Version';

  @override
  String get loading => 'Loading';

  @override
  String get environmentLabel => 'Environment';

  @override
  String get checkUpdates => 'Check updates';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get logout => 'Logout';

  @override
  String get debugFeatureFlags => 'Debug Feature Flags';

  @override
  String get systemOption => 'System';

  @override
  String get lightOption => 'Light';

  @override
  String get darkOption => 'Dark';

  @override
  String get chineseOption => 'Chinese';

  @override
  String get englishOption => 'English';

  @override
  String get userLabel => 'User';

  @override
  String get guestUser => 'Guest';

  @override
  String get platformLabel => 'Platform';

  @override
  String get featureFlags => 'Feature Flags';

  @override
  String get requiredUpdateTitle => 'Required update';

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String get updateDialogSubtitle =>
      'Update to the latest version for a better experience.';

  @override
  String get updateContentTitle => 'What\'s new';

  @override
  String get latestVersionShortLabel => 'Latest';

  @override
  String get currentVersionShortLabel => 'Current';

  @override
  String currentVersionLabel(Object version) {
    return 'Current: $version';
  }

  @override
  String latestVersionLabel(Object version) {
    return 'Latest: $version';
  }

  @override
  String get laterAction => 'Later';

  @override
  String get refreshAction => 'Refresh';

  @override
  String get updateNowAction => 'Update now';

  @override
  String get backHomeAction => 'Back home';

  @override
  String get retryAction => 'Retry';

  @override
  String get packageInfoLoadFailed => 'Unable to load app version';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get initializing => 'Initializing...';
}
