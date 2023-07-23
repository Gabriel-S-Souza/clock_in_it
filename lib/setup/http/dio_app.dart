import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../shared/data/data_sources/refresh_token/refresh_token_data_source.dart';
import '../../shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import '../service_locator/service_locator_imp.dart';

part 'interceptors/login_mock_interceptor.dart';
part 'interceptors/fix_images_interceptor.dart';
part 'interceptors/check_token_interceptor.dart';

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
      responseHeader: false,
      responseBody: true,
    ),
    InterceptorsWrapper(onRequest: _checkTokenInterceptor),
    InterceptorsWrapper(
      onRequest: _loginMockInterceptor,
      onResponse: _fixImagesInterceptor,
    ),
  ]);
