import 'package:dio/dio.dart';

class RequestInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    ///超时
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;

    handler.next(options);
  }
}
