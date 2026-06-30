class LogSanitizer {
  const LogSanitizer._();

  static const _sensitiveKeys = [
    'password',
    'token',
    'authorization',
    'cookie',
    'set-cookie',
    'refreshToken',
  ];

  static Object? sanitize(Object? value) {
    if (value is Map) {
      return value.map((key, entry) {
        final keyText = key.toString();
        final shouldMask = _sensitiveKeys.any(
          (sensitive) =>
              keyText.toLowerCase().contains(sensitive.toLowerCase()),
        );
        return MapEntry(key, shouldMask ? '***' : sanitize(entry));
      });
    }
    if (value is Iterable) return value.map(sanitize).toList();
    if (value is String) {
      var sanitized = value;
      for (final key in _sensitiveKeys) {
        sanitized = sanitized.replaceAll(
          RegExp('($key[=: ]+)[^,}\\s]+', caseSensitive: false),
          r'$1***',
        );
      }
      return sanitized;
    }
    return value;
  }
}
