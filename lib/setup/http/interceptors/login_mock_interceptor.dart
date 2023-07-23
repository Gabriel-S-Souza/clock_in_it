part of '../dio_app.dart';

// simulates the authentication requests (login and refresh token)
Future<void> _loginMockInterceptor(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  if (options.path.contains('refresh-token') || options.path.contains('login')) {
    final refreshToken = await options.data['refresh-token'];
    final isRefreshEndpoint = options.path.contains('refresh-token');
    if (isRefreshEndpoint && !_validateFormatToken(refreshToken)) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            statusCode: 401,
            data: 'Invalid token format',
            requestOptions: options,
          ),
        ),
      );
      return;
    }

    final username = isRefreshEndpoint //
        ? JwtDecoder.decode(refreshToken)['username']
        : options.data['username'];

    final newToken = _generateJwt({'username': username});
    final newRefreshToken = _generateJwt(
      {'username': username},
      isRefresh: true,
    );
    if (!isRefreshEndpoint) {
      await Future.delayed(const Duration(seconds: 1));
    }
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'id': 1,
          'username': username,
          'access-token': newToken,
          'refresh-token': newRefreshToken,
        },
      ),
    );
    return;
  } else {
    handler.next(options);
  }
}

String _generateJwt(dynamic data, {bool isRefresh = false}) {
  final header = {
    'alg': 'HS256',
    'typ': 'JWT',
  };
  final headerBase64 = base64UrlEncode(utf8.encode(jsonEncode(header)));

  final payload = {
    'sub': 1,
    'name': data['username'],
    'exp': isRefresh //
        ? null
        : DateTime.now().add(const Duration(seconds: 60)).millisecondsSinceEpoch,
  };
  final payloadBase64 = base64UrlEncode(jsonEncode(payload).codeUnits);

  const secret = 'secret';
  final digest =
      Hmac(sha256, utf8.encode(secret)).convert('$headerBase64.$payloadBase64'.codeUnits);
  final sign = base64UrlEncode(digest.bytes);

  return '$headerBase64.$payloadBase64.$sign';
}
