part of 'dio_app.dart';

// logic to simulate token return
Future<void> _mockTokenInterceptor(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  if (options.path.contains('refresh-token')) {
    final username = options.data['username'];
    final newToken = _createJwt({'username': username});
    final refreshToken = _createJwt(
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
          'refresh-token': refreshToken,
        },
      ),
    );
    return;
  } else if (options.path.contains('login')) {
    final token = _createJwt(options.data);
    final refreshToken = _createJwt(options.data, isRefresh: true);
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'id': 1,
          'username': options.data['username'],
          'access-token': token,
          'refresh-token': refreshToken,
        },
      ),
    );
  } else {
    handler.next(options);
  }
}

String _createJwt(dynamic data, {bool isRefresh = false}) {
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
        : DateTime.now().millisecondsSinceEpoch + 60000,
  };
  final payloadBase64 = base64UrlEncode(jsonEncode(payload).codeUnits);
  const secret = 'secret';
  final digest =
      Hmac(sha256, utf8.encode(secret)).convert('$headerBase64.$payloadBase64'.codeUnits);
  final sign = base64UrlEncode(digest.bytes);
  return '$headerBase64.$payloadBase64.$sign';
}
