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
}
