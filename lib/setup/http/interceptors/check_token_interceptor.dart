part of '../dio_app.dart';

Future<void> _checkTokenInterceptor(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  if (options.path.contains('login') || options.path.contains('refresh-token')) {
    handler.next(options);
    return;
  }

  log('path: ${options.path}');
  log('uri: ${options.uri}');
  log('headers: ${options.headers}');

  final authorization = options.headers['authorization'] as String?;
  log('authorization: $authorization');
  final token = authorization?.split(' ').lastOrNull;

  log('Token: $token');

  if (!_validateFormatToken(token)) {
    log('Invalid token');
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
      log('Expired token');
      final refreshTokenDataSource = ServiceLocatorImp.I.get<RefreshTokenDataSource>();

      final secureLocalStorage = ServiceLocatorImp.I.get<SecureLocalStorage>();

      final response = await refreshTokenDataSource.call();
      final newAccessToken = await secureLocalStorage.get('accessToken');

      if (response.isSuccess) {
        options.headers['authorization'] = 'Bearer $newAccessToken';
        log('Updated token: $newAccessToken');
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
  log('Is expired token: ${remainingTime < 0}');
  final String expiresIn = 'Expires In ${expireIn.difference(DateTime.now()).inSeconds} seconds';
  log(expiresIn);
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
