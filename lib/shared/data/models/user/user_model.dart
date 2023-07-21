import '../../../domain/entities/user/user_entity.dart';
import '../auth/auth_model.dart';

class UserModel extends UserEntity {
  final AuthModel? auth;

  UserModel({
    required super.id,
    required super.name,
    this.auth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['username'] as String,
        auth: json['access-token'] != null //
            ? AuthModel.fromJson(json)
            : null,
      );
}
