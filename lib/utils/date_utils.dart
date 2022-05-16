import 'package:intl/intl.dart';

class DatePattern {
  /// 标准日期格式：yyyy-MM-dd
  static const String normDatePattern = 'yyyy-MM-dd';

  /// 标准日期格式 {@link DateFormat}：yyyy-MM-dd
  static DateFormat normDateFormat = DateFormat(normDatePattern);

  /// 标准时间格式：HH:mm:ss
  static String normTimePattern = 'HH:mm:ss';

  /// 标准时间格式 {@link DateFormat}：HH:mm:ss
  static DateFormat normTimeFormat = DateFormat(normTimePattern);

  /// 标准日期时间格式，精确到分：yyyy-MM-dd HH:mm
  static String normDateTimeMinutePattern = 'yyyy-MM-dd HH:mm';

  /// 标准日期时间格式，精确到分 {@link DateFormat}：yyyy-MM-dd HH:mm
  static DateFormat normDateTimeMinuteFormat =
      DateFormat(normDateTimeMinutePattern);

  /// 标准日期时间格式，时与分：HH:mm
  static String normHourMinutePattern = 'HH:mm';

  /// 标准日期时间格式，精确到分 {@link DateFormat}：yyyy-MM-dd HH:mm
  static DateFormat normHourMinuteFormat = DateFormat(normHourMinutePattern);

  /// 标准日期时间格式，精确到秒：yyyy-MM-dd HH:mm:ss
  static String normDateTimePattern = 'yyyy-MM-dd HH:mm:ss';

  /// 标准日期时间格式，精确到秒 {@link DateFormat}：yyyy-MM-dd HH:mm:ss
  static DateFormat normDateTimeFormat = DateFormat(normDateTimePattern);

  /// 标准日期时间格式，精确到毫秒：yyyy-MM-dd HH:mm:ss.SSS
  static String normDateTimeMsPattern = 'yyyy-MM-dd HH:mm:ss.SSS';

  /// 标准日期时间格式，精确到毫秒 {@link DateFormat}：yyyy-MM-dd HH:mm:ss.SSS
  static DateFormat normDateTimeMsFormat = DateFormat(normDateTimeMsPattern);

  /// 标准日期格式：yyyy年MM月dd日
  static String chineseDatePattern = 'yyyy年MM月dd日';

  /// 标准日期格式 {@link DateFormat}：yyyy年MM月dd日
  static DateFormat chineseDateFormat = DateFormat(chineseDatePattern);

  //-------------------------------------------------------------------------------------------------------------------------------- Pure
  /// 标准日期格式：yyyyMMdd
  static String pureDatePattern = 'yyyyMMdd';

  /// 标准日期格式 {@link DateFormat}：yyyyMMdd
  static DateFormat pureDateFormat = DateFormat(pureDatePattern);

  /// 标准日期格式：HHmmss
  static String pureTimePattern = 'HHmmss';

  /// 标准日期格式 {@link DateFormat}：HHmmss
  static DateFormat pureTimeFormat = DateFormat(pureTimePattern);

  /// 标准日期格式：yyyyMMddHHmmss
  static String pureDateTimePattern = 'yyyyMMddHHmmss';

  /// 标准日期格式 {@link DateFormat}：yyyyMMddHHmmss
  static DateFormat pureDateTimeFormat = DateFormat(pureDateTimePattern);

  /// 标准日期格式：yyyyMMddHHmmssSSS
  static String pureDateTimeMsPattern = 'yyyyMMddHHmmssSSS';

  /// 标准日期格式 {@link DateFormat}：yyyyMMddHHmmssSSS
  static DateFormat pureDateTimeMsFormat =
      DateFormat(pureDateTimeMsPattern);
}

class DateUtils {
  static String format(DateTime time) {
    return DatePattern.normDateFormat.format(time);
  }
}
