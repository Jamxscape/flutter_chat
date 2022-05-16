import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringUtils {
  static String toMD5(String data) {
    final Uint8List content =  const Utf8Encoder().convert(data);
    final Digest digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String? removeHtmlLabel(String? data) {
    return data?.replaceAll(RegExp('<[^>]+>'), '');
  }

  static bool isMacAddress(String? data) {
    if (data?.isEmpty ?? true) {
      return false;
    }
    return RegExp(r'([A-Fa-f0-9]{2}:){5}[A-Fa-f0-9]{2}')
            .firstMatch(data!)
            ?.groupCount ==
        1;
  }
}
