import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

/// 是否是生产环境
const bool inProduction = bool.fromEnvironment('dart.vm.product');

class PlatformUtils {
  static Future<PackageInfo> getAppPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNum() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      return deviceInfo.iosInfo;
    } else {
      return null;
    }
  }

  static bool _isWeb() {
    return kIsWeb == true;
  }

  static bool _isAndroid() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isAndroid;
    }
  }

  static bool _isIOS() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isIOS;
    }
  }

  static bool _isMacOS() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isMacOS;
    }
  }

  static bool _isWindows() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isWindows;
    }
  }

  static bool _isFuchsia() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isFuchsia;
    }
  }

  static bool _isLinux() {
    if (_isWeb()) {
      return false;
    } else {
      return Platform.isLinux;
    }
  }

  static bool get isWeb => _isWeb();

  static bool get isAndroid => _isAndroid();

  static bool get isIOS => _isIOS();

  static bool get isMacOS => _isMacOS();

  static bool get isWindows => _isWindows();

  static bool get isFuchsia => _isFuchsia();

  static bool get isLinux => _isLinux();
}
