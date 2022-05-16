import 'package:dio/dio.dart';

import '/config/constant.dart';
import '/utils/easy_loading_utils.dart';
import '../app_exception.dart';
import '../app_response.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final appResponse = AppResponse.obtain(response);
    if (appResponse.success) {
      response.data = appResponse.body;
      handler.resolve(response);
    } else {
      showToast(appResponse.remsg ?? Constant.defaultErrorMessage);
      if (appResponse.recode == Constant.tokenErrorCode) {
        throw const UnAuthorizedException(); // 需要登录
      } else {
        throw NotSuccessException.fromRespData(appResponse);
      }
    }
  }
}
