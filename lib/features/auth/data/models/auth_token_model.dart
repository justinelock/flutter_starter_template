import '../../domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({required super.accessToken, super.expiresInSeconds});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
        accessToken: json['accessToken']?.toString() ??
            json['token']?.toString() ??
            '',
        expiresInSeconds: int.tryParse(
          json['expiresIn']?.toString() ?? json['expire']?.toString() ?? '',
        ),
      );
}
