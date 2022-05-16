import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../config/constant.dart';
import '../config/net/app_exception.dart';
import '../state/view_state.dart';
import '../utils/log_utils.dart';
import 'base_get_view.dart';

abstract class BaseGetxController extends GetxController
    with StateMixin<ViewState> {
  ViewStateError? viewStateError;
  ViewState _viewState = ViewState.idle;

  ViewState get viewState => _viewState;

  ///
  /// 修改当前任务状态，会与[StateMixin]联动
  ///
  /// [state] 要设置的状态
  ///
  set viewState(ViewState state) {
    _viewState = state;
    switch (state) {
      //加载中
      case ViewState.busy:
        change(null, status: RxStatus.loading());
        break;
      //空数据
      case ViewState.empty:
        change(null, status: RxStatus.empty());
        break;
      //错误
      case ViewState.error:
        change(null, status: RxStatus.error());
        break;
      //正常
      case ViewState.idle:
        change(null, status: RxStatus.success());
        break;
      default:
        break;
    }
  }

  ///
  /// 当数据为空时调用
  ///
  void setEmpty() => viewState = ViewState.empty;

  ///
  /// 当状态正常时调用
  ///
  void setIdle() => viewState = ViewState.idle;

  ///
  /// 当耗时任务进行的时候调用
  ///
  void setBusy() => viewState = ViewState.busy;

  ///
  /// 当发生异常需要将布局状态置为[ViewState.error]时调用
  ///
  /// [e] Error对象
  /// [s] Error堆栈
  ///
  void setError([dynamic e, dynamic s]) {
    viewState = ViewState.error;

    ViewStateErrorType errorType = ViewStateErrorType.defaultError;
    String? message;

    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // timeout
        errorType = ViewStateErrorType.networkTimeOutError;
        message = Constant.defaultNetworkErrorMessage;
      } else if (e.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        message = Constant.defaultIncorrectErrorMessage;
      } else if (e.type == DioErrorType.cancel) {
        // to be continue...
        message = Constant.defaultCancelErrorMessage;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          s = null;
          errorType = ViewStateErrorType.unauthorizedError;
          message = Constant.defaultTokenErrorMessage;
        } else if (e is NotSuccessException) {
          s = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = ViewStateErrorType.networkTimeOutError;
          message = Constant.defaultNetworkErrorMessage;
        } else {
          message = Constant.defaultErrorMessage;
        }
      }
    }
    if (message?.isEmpty ?? true) {
      message = Constant.defaultErrorMessage;
    }

    viewStateError = ViewStateError(
      errorType,
      message: message!,
      errorMessage: e.toString(),
    );

    error(e, showPath: false);
    if (s != null) {
      error(s, showPath: false);
    }
  }

  ///
  /// 使用时需要主动覆写
  /// 初始化数据的方法
  ///
  FutureOr<void> initData();

  @mustCallSuper
  @override
  FutureOr<void> onInit() async {
    super.onInit();
    await initData();
  }
}

abstract class BaseRefreshGetxController extends BaseGetxController {
  RefreshController controller = RefreshController();

  @mustCallSuper
  @override
  FutureOr<void> initData() async {
    await onRefresh(true);
  }

  @mustCallSuper
  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }

  ///
  /// 使用时需要主动覆写
  /// 当触发刷新时间时会调用该方法
  ///
  FutureOr<void> doRefresh();

  ///
  /// 当[showLoading]为`true`时将会将[viewState]置为[ViewState.busy]
  /// 当配合[StateWidget]或[RefreshStateWidget]时将自动显示`onLoading`布局
  ///
  /// 加载数据后若[list]仍为空，则将状态置为[ViewState.empty]
  /// 当配合[StateWidget]或[RefreshStateWidget]时将自动显示`onEmpty`布局
  ///
  /// 加载过程中若遇到意外错误，则将状态置为[ViewState.error]
  /// 当配合[StateWidget]或[RefreshStateWidget]时将自动显示`onError`布局
  ///
  FutureOr<void> onRefresh([bool showLoading = false]) async {
    if (showLoading) {
      setBusy();
    }
    try {
      await doRefresh();
      controller.refreshCompleted();
    } catch (e, s) {
      setError(e, s);
      return;
    }
    setIdle();
  }
}

abstract class BaseRefreshListGetxController<E>
    extends BaseRefreshGetxController {
  BaseRefreshListGetxController({
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  late RxList<E> list = <E>[].obs;

  int pageNumber;
  int pageSize;

  FutureOr<List<E>> loadData(int pageNumber);

  @mustCallSuper
  @override
  void onClose() {
    super.onClose();
  }

  ///
  /// 对于该场景并无作用
  ///
  @override
  FutureOr<void> doRefresh() {}

  ///
  /// 当触发刷新事件时清空[list]并且从`第一页`加载新数据
  ///
  @override
  FutureOr<void> onRefresh([bool showLoading = false]) async {
    if (showLoading) {
      setBusy();
    }

    controller.resetNoData();
    pageNumber = 1;
    List<E> current = <E>[];
    try {
      current = await loadData(pageNumber);
      list.clear();
      list.addAll(current);
    } catch (e, s) {
      controller.refreshFailed();
      setError(e, s);
      return;
    }
    controller.refreshCompleted();
    if (current.length < pageSize) {
      controller.loadNoData();
    }
    if (list.isEmpty) {
      setEmpty();
      return;
    }
    setIdle();
  }

  ///
  /// 当触发加载更多事件时拉取下一页数据，并且将新数据添加到[list]
  /// 若新数据不满一页，会将[SmartRefresher]置为[LoadStatus.noMore]
  ///
  /// 状态控制逻辑与[onRefresh]一致
  ///
  FutureOr<void> onLoadMore([bool showLoading = false]) async {
    if (showLoading) {
      setBusy();
    }
    pageNumber++;
    List<E> current = <E>[];
    try {
      current = await loadData(pageNumber);
      list.addAll(current);
    } catch (e, s) {
      controller.loadFailed();
      setError(e, s);
      return;
    }
    controller.loadComplete();
    if (current.length < pageSize) {
      controller.loadNoData();
    }
    if (list.isEmpty) {
      setEmpty();
      return;
    }
    setIdle();
  }
}
