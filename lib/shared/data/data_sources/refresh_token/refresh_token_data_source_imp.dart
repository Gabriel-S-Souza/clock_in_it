import '../../../../setup/http/http_client.dart';
import '../../../domain/entities/failure/failure.dart';
import '../../../domain/entities/result/result.dart';
import '../../models/auth/auth_model.dart';
import '../secure_local_storage/secure_local_storage.dart';
import 'refresh_token_data_source.dart';

class RefreshTokenDataSourceImp implements RefreshTokenDataSource {
  final HttpClient _httpClient;
  final SecureLocalStorage _secureLocalStorage;

  RefreshTokenDataSourceImp({
    required HttpClient httpClient,
    required SecureLocalStorage secureLocalStorage,
  })  : _httpClient = httpClient,
        _secureLocalStorage = secureLocalStorage;

  @override
  Future<Result<AuthModel>> call() async {
    try {
      final response = await _httpClient.post(
        '/refresh-token',
        body: {
          'refresh-token': _secureLocalStorage.get('refreshToken'),
        },
      );

      if (response.isSuccess) {
        final auth = AuthModel.fromJson(response.data);
        _secureLocalStorage.set('accessToken', auth.accessToken);
        _secureLocalStorage.set('refreshToken', auth.refreshToken);
        return Result.success(auth);
      } else {
        return Result.failure(const ServerFailure());
      }
    } on Failure catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(UnmappedFailure(e.toString()));
    }
  }
}
