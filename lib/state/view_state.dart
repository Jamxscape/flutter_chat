import '../config/constant.dart';

enum ViewState {
  idle,
  busy,
  empty,
  error,
}

enum ViewStateErrorType {
  defaultError,
  networkTimeOutError, //网络错误
  unauthorizedError //未授权(一般为未登录)
}

class ViewStateError {
  ViewStateError(
    this._errorType, {
    this.message = Constant.defaultErrorMessage,
    this.errorMessage = Constant.defaultErrorMessage,
  });

  final ViewStateErrorType _errorType;
  final String message;
  final String errorMessage;

  ViewStateErrorType get errorType => _errorType;

  bool get isDefaultError => _errorType == ViewStateErrorType.defaultError;
  bool get isNetworkTimeOut =>
      _errorType == ViewStateErrorType.networkTimeOutError;
  bool get isUnauthorized => _errorType == ViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'ViewStateError{errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}
