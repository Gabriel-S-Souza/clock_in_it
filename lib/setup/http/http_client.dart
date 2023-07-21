import 'dart:io';

import 'package:dio/dio.dart';

import '../../shared/domain/entities/response/response.dart';
import 'http_error_handler.dart';

class HttpClient with HttpErrorHandler {
  final Dio _dio;

  HttpClient(this._dio);

  Future<ResponseApp> get(
    String url, {
    String? token,
  }) async {
    try {
      final response = await _dio.get(
        url,
        options: token != null
            ? Options(
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                },
              )
            : null,
      );
      return ResponseApp(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<ResponseApp> post(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: token != null
            ? Options(
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                },
              )
            : null,
      );
      return ResponseApp(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<ResponseApp> put(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        options: token != null
            ? Options(
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                },
              )
            : null,
      );
      return ResponseApp(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<ResponseApp> delete(
    String path, {
    String? token,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        options: token != null
            ? Options(
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                },
              )
            : null,
      );
      return ResponseApp(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw handleError(e);
    }
  }
}
