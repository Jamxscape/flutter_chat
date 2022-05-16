import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'constant.dart';

class FileHelper {
  static Future<String> readText(String url) async {
    return rootBundle.loadString('assets/files/$url');
  }
}

///
/// 这里存的资源管理工具
///
class ImageHelper {
  static String wrapAssets(String url) {
    return 'assets/images/$url';
  }

  static Widget normalAvatar({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ImageHelper.wrapAssets(Constant.normalAvatar)),
        fit: BoxFit.cover,
      )),
    );
  }

  static Widget placeHolder({double? width, double? height}) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(ImageHelper.wrapAssets(Constant.imgPlaceholder)),
          fit: BoxFit.cover,
        )),
        child: CupertinoActivityIndicator(radius: min(10.0, (width ?? 0) / 3)));
  }

  static Widget error({double? width, double? height, double? size}) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image:
              AssetImage(ImageHelper.wrapAssets(Constant.imgErrorPlaceholder)),
          fit: BoxFit.cover,
        )),
        child: Opacity(
          opacity: 0.5,
          child: Icon(
            Icons.error_outline,
            size: size,
          ),
        ));
  }
}

class IconHelper {
  static String wrapAssets(String url) {
    return 'assets/icons/$url';
  }
}

class IconFonts {
  IconFonts._();

  /// iconfont: 状态布局的图标 如: 空布局图标, 错误布局图标等
  static const String fontFamily = 'iconfont';

  /// 普通小图标
  static const String icon = 'icon';

  /// 状态图标
  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  static const IconData pageNetworkError =
      IconData(0xe678, fontFamily: fontFamily);
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);

  /// 操作图标
  static const IconData iconSetting = IconData(0xe642, fontFamily: icon);
}
