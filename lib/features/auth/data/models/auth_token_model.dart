import '../../domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({required super.accessToken, super.expiresInSeconds});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
    accessToken: json['token']?.toString() ?? '',
    expiresInSeconds: int.tryParse(json['expire']?.toString() ?? ''),
  );
}
