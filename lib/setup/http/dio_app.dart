import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../shared/data/data_sources/refresh_token/refresh_token_data_source.dart';
import '../service_locator/service_locator_imp.dart';

const _baseUrl = 'https://carma.fun';
const _basePath = '/api/dasa';

final dioApp = Dio(
  BaseOptions(
    baseUrl: _baseUrl + _basePath,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
)..interceptors.addAll([
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ),
    InterceptorsWrapper(onRequest: _checkToken),
    InterceptorsWrapper(onRequest: _mockToken),
  ]);

Future<void> _checkToken(RequestOptions options, RequestInterceptorHandler handler) async {
  if (options.path.contains('login') || options.path.contains('refresh-token')) {
    handler.next(options);
    return;
  }
  final authorization = options.headers['Authorization'] as String?;
  final token = authorization?.split(' ').lastOrNull;
  if (token == null || !validateToken(token)) {
    print('Token not found');
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
    if (JwtDecoder.isExpired(token)) {
      final RefreshTokenDataSource refreshTokenDataSource =
          ServiceLocatorImp.I.get<RefreshTokenDataSource>();
      final response = await refreshTokenDataSource.call();
      if (!response.isSuccess) {
        handler.reject(
          DioException.badResponse(
            statusCode: 500,
            requestOptions: options,
            response: Response(data: response.failure.message, requestOptions: options),
          ),
        );
      }
      handler.next(options);
    }
  }
}

bool validateToken(String token) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken.runtimeType == Map<String, dynamic>;
  } catch (e) {
    return false;
  }
}

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
    final token = _createToken(options.data);
    final refreshToken = _createToken(options.data, isRefresh: true);
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
  return '$headerBase64.$payloadBase64.$sign';
}
