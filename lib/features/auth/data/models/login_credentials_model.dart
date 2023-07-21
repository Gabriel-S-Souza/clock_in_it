import '../../domain/entities/login_credentials_entity.dart';

class LoginCredentialsModel extends LoginCredentialsEntity {
  LoginCredentialsModel({
    required super.username,
    required super.password,
  });

  factory LoginCredentialsModel.fromEntity(LoginCredentialsEntity entity) => LoginCredentialsModel(
        username: entity.username,
        password: entity.password,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
