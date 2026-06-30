class Validators {
  const Validators._();

  static final _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) => _emailRegExp.hasMatch(value);

  static String? email(String value) {
    if (value.trim().isEmpty) return 'Email is required';
    if (!isValidEmail(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
