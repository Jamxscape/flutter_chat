import '/config/constant.dart';
import '/utils/as_t.dart';

class AppResponse {
  factory AppResponse.obtain(dynamic response) {
    try {
      if (response.data != null && response.data['reCode'] == 200) {
        return AppResponse._success(
            asT<Map<String, dynamic>>(response.data['body']));
      }
      if (response.data != null && response.data['reCode'] != 200) {
        return AppResponse._failure(
          recode: asT<int>(response.data['reCode']),
          remsg: asT<String>(response.data['reMsg']) ??
              Constant.defaultErrorMessage,
        );
      }
      return AppResponse._failure(
        recode: asT<int>(response.statusCode),
        remsg: asT<String>(response.statusMessage),
      );
    } catch (e) {
      print('AppResponse==obtain=' + e.toString());
      return AppResponse._failure(remsg: e.toString());
    }
  }

  AppResponse._success([this.body]) {
    recode = 200;
  }

  AppResponse._failure({int? recode, String? remsg}) {
    this.recode = recode ?? 0;
    this.remsg = remsg ?? Constant.defaultErrorMessage;
  }

  int? recode;
  String? remsg;
  Map<String, dynamic>? body;

  bool get success => 200 == recode;
}
