import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
  });

  factory UserModel.fromEmail(String email) => UserModel(
        id: email.hashCode.abs().toString(),
        email: email,
        displayName: email.split('@').first,
      );

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackEmail,
  }) {
    final email = json['email']?.toString() ?? fallbackEmail ?? '';
    return UserModel(
      id: json['id']?.toString() ?? email.hashCode.abs().toString(),
      email: email,
      displayName: json['displayName']?.toString() ??
          json['name']?.toString() ??
          email.split('@').first,
    );
  }
}
