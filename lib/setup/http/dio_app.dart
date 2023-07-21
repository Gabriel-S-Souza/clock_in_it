import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';

const _baseUrl = 'https://carma.fun';
const _basePath = '/api/dasa';

final dioApp = Dio(
  BaseOptions(
    baseUrl: _baseUrl + _basePath,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
)..interceptors.add(InterceptorsWrapper(onRequest: _mockToken));

//
//
// logic to simulate token return
Future<void> _mockToken(RequestOptions options, RequestInterceptorHandler handler) async {
  if (options.path.contains('refresh-token')) {
    final username = options.data['username'];
    final newToken = _createToken({'username': username});
    final refreshToken = _createToken(
      {'username': username},
      isRefresh: true,
    );
    handler.resolve(
      Response(
        requestOptions: options,
        data: {
          'auth-token': newToken,
          'refresh-token': refreshToken,
        },
      ),
    );
    return;
  } else if (options.path.contains('login')) {
    final token = _createToken(options.data);
    final refreshToken = _createToken(options.data, isRefresh: true);
    handler.resolve(
      Response(
        requestOptions: options,
        data: {
          'auth-token': token,
          'refresh-token': refreshToken,
        },
      ),
    );
  }
}

String _createToken(dynamic data, {bool isRefresh = false}) {
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
  print('jwt: $headerBase64.$payloadBase64.$sign');
  return '$headerBase64.$payloadBase64.$sign';
}
