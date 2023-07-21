import '../../../../setup/http/http_client.dart';
import '../../../domain/entities/failure/failure.dart';
import '../../../domain/entities/result/result.dart';
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
  Future<VoidSuccess> call() async {
    try {
      final response = await _httpClient.post(
        '/refresh-token',
        body: {
          'refresh-token': _secureLocalStorage.get('refreshToken'),
        },
      );

      if (response.isSuccess) {
        await _secureLocalStorage.set('accessToken', response.data['access-token']);
        await _secureLocalStorage.set('refreshToken', response.data['refresh-token']);
        return Result.voidSuccess();
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
