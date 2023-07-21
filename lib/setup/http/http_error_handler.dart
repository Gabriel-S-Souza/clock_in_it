import 'dart:io';

import 'package:dio/dio.dart';

import '../../shared/domain/entities/failure/failure.dart';

mixin HttpErrorHandler {
  Failure handleError(Object e) {
    if (e is! DioException) return UnmappedFailure(e.toString());

    if (e.response != null && e.response!.statusCode != null) {
      final error = _handleErrorByStatusCode(e.response!.statusCode);
      if (error != null) {
        return error;
      }
    }

    return _handleErrorByType(e);
  }

  Failure? _handleErrorByStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const BadRequestFailure();
      case 401:
        return const UnauthorizedFailure();
      case 404:
        return const NotFoundFailure();
      case 500:
        return const ServerFailure();
      default:
        return null;
    }
  }

  Failure _handleErrorByType(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const OfflineFailure();
      case DioExceptionType.cancel:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.badResponse:
        return ServerFailure(e.message);
      case DioExceptionType.unknown:
        if (e.error is SocketException &&
            e.error.toString().toLowerCase().contains('network is unreachable')) {
          return const OfflineFailure();
        }
        return UnmappedFailure(e.message);
      default:
        return UnmappedFailure(e.message);
    }
  }
}
