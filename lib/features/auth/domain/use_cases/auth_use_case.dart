import '../../../../shared/domain/entities/result/result.dart';
import '../../../../shared/domain/entities/user/user_entity.dart';
import '../entities/login_credentials_entity.dart';
import '../repositories/auth_repository.dart';

abstract class AuthUseCase {
  Future<Result<UserEntity>> login(LoginCredentialsEntity credentials);
  Future<Result<void>> logout();
}

class AuthUseCaseImp implements AuthUseCase {
  final AuthRepository _repository;

  AuthUseCaseImp(this._repository);

  @override
  Future<Result<UserEntity>> login(LoginCredentialsEntity credentials) =>
      _repository.login(credentials);

  @override
  Future<Result<void>> logout() => _repository.logout();
}
