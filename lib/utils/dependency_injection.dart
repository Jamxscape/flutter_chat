import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    await initSharedPreference();
    initNetwork();
  }

  static Future<void> initSharedPreference() async {
    Get.lazyPut(() => LocalStorage('LocalStorage'));
    await Get.putAsync(() => SharedPreferences.getInstance());
  }

  static void initNetwork() {}
}
