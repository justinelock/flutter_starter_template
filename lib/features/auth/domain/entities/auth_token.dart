class AuthToken {
  const AuthToken({required this.accessToken, this.expiresInSeconds});

  final String accessToken;
  final int? expiresInSeconds;
}
