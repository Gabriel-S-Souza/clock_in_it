import '../../../../setup/http/http_client.dart';
import '../../../../setup/utils/api_paths.dart';
import '../../../../shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/domain/entities/failure/failure.dart';
import '../../../../shared/domain/entities/result/result.dart';
import '../models/login_credentials_model.dart';
import 'auth_datasource.dart';

class AuthDataSourceImp implements AuthDataSource {
  final HttpClient _httpClient;
  final SecureLocalStorage _secureLocalStorage;

  AuthDataSourceImp({
    required HttpClient httpClient,
    required SecureLocalStorage secureLocalStorage,
  })  : _httpClient = httpClient,
        _secureLocalStorage = secureLocalStorage;

  @override
  Future<Result<UserModel>> login(LoginCredentialsModel credentials) async {
    try {
      final response = await _httpClient.post(
        ApiPaths.login,
        body: credentials.toJson(),
      );
      if (response.isSuccess) {
        _secureLocalStorage.set('accessToken', response.data['access-token']);
        _secureLocalStorage.set('refreshToken', response.data['refresh-token']);
        final user = UserModel.fromJson(response.data);
        return Result.success(user);
      } else {
        print('error not success ${response.statusCode}');
        return Result.failure(const ServerFailure());
      }
    } on Failure catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(UnmappedFailure(e.toString()));
    }
  }
}
