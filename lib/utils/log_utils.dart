import 'dart:developer' as _dev;

///日志等级
///* [DEBUD] 调试
///* [INFO] 信息
///* [WARNING] 警告
///* [ERROR] 错误
enum LOGLEVEL { DEBUD, INFO, WARNING, ERROR }

///日志等级枚举扩展
extension LogLevelExtension on LOGLEVEL {
  ///获取tag
  String get tag {
    switch (this) {
      case LOGLEVEL.DEBUD:
        return '[DEBUG]   ';
      case LOGLEVEL.INFO:
        return '[INFO]    ';
      case LOGLEVEL.WARNING:
        return '[WARNING] ';
      case LOGLEVEL.ERROR:
        return '[ERROR]   ';
    }
  }

  ///获取颜色代码
  int get code {
    switch (this) {
      case LOGLEVEL.DEBUD:
        return 5;
      case LOGLEVEL.INFO:
        return 2;
      case LOGLEVEL.WARNING:
        return 3;
      case LOGLEVEL.ERROR:
        return 1;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
///日志输出封装
class L {
  static bool enable = true;

  ///顶部图案
  static String get _pic {
    return '''

         ┌─┐       ┌─┐
      ┌──┘ ┴───────┘ ┴──┐
      │                 │
      │       ───       │
      │  ─┬┘       └┬─  │
      │                 │
      │       ─┴─       │
      │                 │
      └───┐         ┌───┘
          │         │ 神兽保佑
          │         │ 永无BUG
          │         │
          │         └──────────────┐
          │                        │
          │                        ├─┐
          │                        ┌─┘
          │                        │
          └─┐  ┐  ┌───────┬──┐  ┌──┘
            │ ─┤ ─┤       │ ─┤ ─┤
            └──┴──┘       └──┴──┘
  ''';
  }

  ///开发者标识
  static String _tag = 'DEFAULT';

  ///初始化函数
  static void init({String? tag}) {
    _tag = tag ?? _tag;
    info(_pic, showPath: false);
  }

  ///日志着色
  static String _logColor(String info, {int color = 7}) {
    return '\x1B[9${color}m$info\x1B[0m';
  }

  ///打印信息
  static void _log(dynamic content,
      {LOGLEVEL lv = LOGLEVEL.INFO, bool showPath = true}) {
    if (!enable) {
      return;
    }
    assert(() {
      final String _time = DateTime.now().toString().split('.')[0];
      final String _currentStack = 'package' +
          StackTrace.current.toString().split('\n')[3].split('package')[1];

      _dev.log(
        _logColor('[$_tag] ', color: 6) +
            _logColor(lv.tag, color: lv.code) +
            _logColor(content?.toString() ?? '',
                color: lv == LOGLEVEL.ERROR ? lv.code : 7) +
            '''
                ${showPath ? StackTrace.fromString('\t$_currentStack').toString().replaceAll(')', '') : ''}
            ''',
        name: _time,
      );

      return true;
    }());
  }
}

///info级别日志
void debug(dynamic msg, {bool showPath = true}) =>
    L._log(msg, lv: LOGLEVEL.INFO, showPath: showPath);

///debug级别日志
void info(dynamic msg, {bool showPath = true}) =>
    L._log(msg, lv: LOGLEVEL.DEBUD, showPath: showPath);

///warning级别日志
void warning(dynamic msg, {bool showPath = true}) =>
    L._log(msg, lv: LOGLEVEL.WARNING, showPath: showPath);

///error级别日志
void error(dynamic msg, {bool showPath = true}) =>
    L._log(msg, lv: LOGLEVEL.ERROR);
