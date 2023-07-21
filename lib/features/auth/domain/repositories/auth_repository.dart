import '../../../../shared/domain/entities/result/result.dart';
import '../../../../shared/domain/entities/user/user_entity.dart';
import '../entities/login_credentials_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login(LoginCredentialsEntity credentials);
  Future<Result<void>> logout();
}
