import 'package:intl/intl.dart';

class NumberUtils {
  static String? removeDecimalZeroFormat(double? num, [int position = 2]) {
    if (num == null) {
      return null;
    }
    if (num.truncateToDouble() == num) {
      return num.toStringAsFixed(0);
    }
    final String str = num.toString();
    if ((str.length - str.lastIndexOf('.') - 1) <= position) {
      return num.toStringAsFixed(position);
    }
    return str
        .substring(0, num.toString().lastIndexOf('.') + position + 1)
        .toString();
  }

  static final format = NumberFormat('0,000');

  ///
  /// 将数字转为千分位加 , 的文本
  /// [number] 要转换的数字
  /// 例如 10,000,000
  ///
  static String getFormatNumber(int number) {
    if (number < 1000) {
      return '$number';
    }
    return format.format(number);
  }
}
