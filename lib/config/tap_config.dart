import 'dart:async';

/// 函数防抖
/// 在一定时间内只响应第一次点击
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
Function() debounce(
  Function? func, [
  Duration delay = const Duration(milliseconds: 500),
]) {
  Timer? timer;
  void target() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func?.call();
    });
  }

  return target;
}

/// 函数节流
/// 在一个异步任务进行时不会再次响应点击
///
/// [func]: 要执行的方法
Function() throttle(
  Function? func, [
  Duration delay = const Duration(milliseconds: 500),
]) {
  Timer? timer;
  bool canClick = true;
  void target() {
    if (canClick) {
      canClick = false;
      func?.call();
    }
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      canClick = true;
    });
  }

  return target;
}
