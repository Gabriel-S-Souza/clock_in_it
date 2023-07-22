part of '../dio_app.dart';

// logic to simulate token return
Future<void> _mockTokenInterceptor(
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
        : DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch,
  };
  final payloadBase64 = base64UrlEncode(jsonEncode(payload).codeUnits);
  const secret = 'secret';
  final digest =
      Hmac(sha256, utf8.encode(secret)).convert('$headerBase64.$payloadBase64'.codeUnits);
  final sign = base64UrlEncode(digest.bytes);
  if (!isRefresh) {
    log('generated token now: $headerBase64.$payloadBase64.$sign');
    final expireIn = DateTime.fromMillisecondsSinceEpoch(payload['exp'] as int);
    log('expire in: ${expireIn.difference(DateTime.now()).inSeconds} seconds');
  }
  return '$headerBase64.$payloadBase64.$sign';
}
