import 'app_response.dart';

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  NotSuccessException.fromRespData(AppResponse respData) {
    message = respData.remsg;
  }

  NotSuccessException.fromMessage(this.message);

  String? message;

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}
