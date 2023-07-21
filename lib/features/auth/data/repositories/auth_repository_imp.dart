import '../../../../shared/domain/entities/result/result.dart';
import '../../../../shared/domain/entities/user/user_entity.dart';
import '../../domain/entities/login_credentials_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_datasource.dart';
import '../models/login_credentials_model.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImp(this._authDataSource);

  @override
  Future<Result<UserEntity>> login(LoginCredentialsEntity credentials) =>
      _authDataSource.login(LoginCredentialsModel.fromEntity(credentials));
}
