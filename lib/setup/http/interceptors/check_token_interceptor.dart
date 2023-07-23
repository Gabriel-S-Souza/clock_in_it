part of '../dio_app.dart';

Future<void> _checkTokenInterceptor(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  if (options.path.contains('login') || options.path.contains('refresh-token')) {
    handler.next(options);
    return;
  }

  final authorization = options.headers['authorization'] as String?;
  final token = authorization?.split(' ').lastOrNull;

  if (!_validateFormatToken(token)) {
    handler.reject(
      DioException(
        requestOptions: options,
        response: Response(
          statusCode: 401,
          data: 'Token not found',
          requestOptions: options,
        ),
      ),
    );
  } else {
    final isExpired = _isTokenExpired(token);
    if (isExpired) {
      final refreshTokenDataSource = ServiceLocatorImp.I.get<RefreshTokenDataSource>();

      final secureLocalStorage = ServiceLocatorImp.I.get<SecureLocalStorage>();

      final response = await refreshTokenDataSource.call();
      final newAccessToken = await secureLocalStorage.get('accessToken');

      if (response.isSuccess) {
        options.headers['authorization'] = 'Bearer $newAccessToken';
        handler.next(options);
        return;
      }
    }
    handler.next(options);
  }
}

bool _isTokenExpired(String? token) {
  final decodedToken = JwtDecoder.decode(token!);
  final expireIn = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] as int);
  final remainingTime = expireIn.difference(DateTime.now()).inSeconds;
  return remainingTime < 0;
}

bool _validateFormatToken(String? token) {
  try {
    if (token == null) return false;
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken.isNotEmpty;
  } catch (e) {
    rethrow;
  }
}
