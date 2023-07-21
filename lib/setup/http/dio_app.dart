import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../shared/data/data_sources/refresh_token/refresh_token_data_source.dart';
import '../../shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import '../service_locator/service_locator_imp.dart';

part 'mock_token_interceptor.dart';

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
    InterceptorsWrapper(onRequest: _checkTokenInterceptor),
    InterceptorsWrapper(onRequest: _mockTokenInterceptor),
  ]);

Future<void> _checkTokenInterceptor(
    RequestOptions options, RequestInterceptorHandler handler) async {
  if (options.path.contains('login') || options.path.contains('refresh-token')) {
    handler.next(options);
    return;
  }

  final authorization = options.headers['Authorization'] as String?;
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
    if (JwtDecoder.isExpired(token!)) {
      final refreshTokenDataSource = ServiceLocatorImp.I.get<RefreshTokenDataSource>();

      final secureLocalStorage = ServiceLocatorImp.I.get<SecureLocalStorage>();

      final response = await refreshTokenDataSource.call();
      final newAccessToken = await secureLocalStorage.get('accessToken');

      if (response.isSuccess) {
        options.headers['Authorization'] = 'Bearer $newAccessToken';
        print('Updated token: $newAccessToken');
        handler.next(options);
        return;
      }
    }
    handler.next(options);
  }
}

bool _validateFormatToken(String? token) {
  try {
    if (token == null) return false;
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken.runtimeType == Map<String, dynamic>;
  } catch (e) {
    return false;
  }
}
