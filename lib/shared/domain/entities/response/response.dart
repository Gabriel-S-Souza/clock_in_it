class ResponseApp<T> {
  final T? data;
  final int? statusCode;
  final String? statusMessage;

  ResponseApp({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}
