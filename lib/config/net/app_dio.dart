import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

import '/config/constant.dart';
import '/utils/as_t.dart';
import 'interceptors/request_interceptor.dart';
import 'interceptors/response_interceptor.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultSendTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class AppDio with DioMixin implements Dio {
  AppDio._([BaseOptions? options]) {
    options ??= BaseOptions(
      baseUrl: Constant.baseUrl,
      contentType: 'application/json',
      connectTimeout: _defaultConnectTimeout,
      sendTimeout: _defaultSendTimeout,
      receiveTimeout: _defaultReceiveTimeout,
    );

    this.options = options;

    //DioCacheManager
    interceptors.add(
      asT<Interceptor>(DioCacheManager(
        CacheConfig(
          baseUrl: Constant.baseUrl,
        ),
      ).interceptor)!,
    );

    interceptors.add(RequestInterceptor());

    //Cookie管理
    interceptors.add(CookieManager(PersistCookieJar(storage: FileStorage())));

    if (kDebugMode) {
      interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true));
    }

    interceptors.add(ResponseInterceptor());

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  void setProxy(String proxy) {
    asT<DefaultHttpClientAdapter>(httpClientAdapter)?.onHttpClientCreate =
        (HttpClient client) {
      // config the http client
      client.findProxy = (Uri uri) {
        //proxy all request to localhost:8888
        return 'PROXY $proxy';
      };
      // you can also create a HttpClient to dio
      // return HttpClient();
    };
  }

  static AppDio getInstance() => AppDio._();

  static AppDio get instance => getInstance();
}

Future<Response<Map<String, dynamic>?>> get(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
}) {
  return AppDio.instance.get<Map<String, dynamic>?>(
    path,
    queryParameters: queryParameters,
    options: options,
    onReceiveProgress: onReceiveProgress,
    cancelToken: cancelToken,
  );
}

Future<Response<Map<String, dynamic>?>> post(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
}) {
  return AppDio.instance.post<Map<String, dynamic>?>(
    path,
    data: data,
    options: options,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );
}
