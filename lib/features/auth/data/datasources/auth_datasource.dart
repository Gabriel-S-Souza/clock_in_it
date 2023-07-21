import '../../../../shared/domain/entities/result/result.dart';
import '../../../../shared/domain/entities/user/user_entity.dart';
import '../models/login_credentials_model.dart';

abstract class AuthDataSource {
  Future<Result<UserEntity>> login(LoginCredentialsModel credentials);
  Future<Result<void>> logout();
}
