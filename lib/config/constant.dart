class Constant {
  //--------------- 应用信息 ---------------

  static const String appName = '';

  //--------------- 服务端信息 ---------------

  static const String serverUrl = 'http://localhost/';

  static const String baseUrl = '${serverUrl}api/app/';

  static const String fileServerUrl = '${serverUrl}file/fileUpload';

  static const String fileGetUrl = '${serverUrl}file/get';

  static const int tokenErrorCode = 1000;

  //--------------- 网络请求信息 ---------------

  static const String defaultErrorMessage = '请求失败';

  static const String defaultNetworkErrorMessage = '请求超时，请检查网络后重试';

  static const String defaultIncorrectErrorMessage = '服务器繁忙，请稍后再试';

  static const String defaultCancelErrorMessage = '请求已取消';

  static const String defaultTokenErrorMessage = '身份过期，请重新登录';

  //--------------- 默认占位图 ---------------

  static const String normalAvatar = 'assets/images/img_normal_avatar.png';

  static const String imgPlaceholder = 'assets/images/img_placeholder.png';

  static const String imgErrorPlaceholder = imgPlaceholder;

  //--------------- 状态信息 ---------------

  static const String viewStateMessageError = '加载失败';

  static const String viewStateButtonRetry = '重试';

  static const String viewStateMessageNetworkError = '网络连接异常,请检查网络或稍后重试';

  static const String viewStateMessageEmpty = '空空如也';

  static const String viewStateButtonRefresh = '刷新一下';

  static const String viewStateMessageUnAuth = '登录后继续浏览';

  static const String viewStateButtonLogin = '立即登录';
}
