import '../../../domain/entities/auth/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        accessToken: json['access-token'] as String,
        refreshToken: json['refresh-token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'access-token': accessToken,
        'refresh-token': refreshToken,
      };
}
