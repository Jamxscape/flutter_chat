import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/state/view_state.dart';
import '/state/view_state_widget.dart';
import '/utils/as_t.dart';
import 'base_getx_controller.dart';

///
/// 普通的状态控制组件
///
class StateWidget<C extends BaseGetxController> extends GetView<C> {
  const StateWidget(
    this.widget, {
    Key? key,
  }) : super(key: key);

  final NotifierBuilder<ViewState?> widget;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      widget,
      onError: (String? msg) {
        if (controller.viewStateError?.isUnauthorized ?? false) {
          return ViewStateUnAuthWidgetCallback(onLoginSucceed: onRefreshTap);
        }
        return ViewStateErrorWidget(
          error: controller.viewStateError,
          onPressed: onRefreshTap,
        );
      },
      onLoading: const ViewStateBusyWidget(),
      onEmpty: ViewStateEmptyWidget(onPressed: onRefreshTap),
    );
  }

  ///
  /// 当`刷新按钮`被点击时，自动调用[controller]的`刷新方法`
  ///
  /// 当[controller]继承自[BaseGetxController]时调用[BaseGetxController.onInit]方法
  /// 当[controller]继承自[BaseRefreshGetxController]时调用[BaseRefreshGetxController.onRefresh]方法
  ///
  void onRefreshTap() {
    if (controller is BaseRefreshGetxController) {
      asT<BaseRefreshGetxController>(controller)?.onRefresh(true);
    } else {
      controller.onInit();
    }
  }
}

/// 带下拉刷新和上拉加载状态控制的组件
///
/// [C]需要继承自带有刷新控制的的[BaseRefreshGetxController]
///
class RefreshStateWidget<C extends BaseRefreshGetxController>
    extends StateWidget<C> {
  ///
  /// [enablePullUp]默认为`true`
  ///
  /// 当[enablePullUp]为`true`并且[controller]继承自[BaseRefreshListGetxController]时
  /// 启动[SmartRefresher]组件的上拉加载功能
  ///
  const RefreshStateWidget(
    NotifierBuilder<ViewState?> widget, {
    Key? key,
    this.enablePullUp = true,
  }) : super(widget, key: key);

  /// 是否启动上拉加载
  final bool enablePullUp;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (ViewState? state) {
        return SmartRefresher(
          controller: controller.controller,
          enablePullUp:
              enablePullUp && controller is BaseRefreshListGetxController,
          onLoading: () {
            asT<BaseRefreshListGetxController>(controller)?.onLoadMore(false);
          },
          onRefresh: () {
            controller.onRefresh(false);
          },
          child: widget.call(state),
        );
      },
      onError: (String? msg) {
        //未登录时的错误
        if (controller.viewStateError?.isUnauthorized ?? false) {
          return ViewStateUnAuthWidgetCallback(onLoginSucceed: onRefreshTap);
        }
        //其他错误
        return ViewStateErrorWidget(
          error: controller.viewStateError,
          onPressed: onRefreshTap,
        );
      },
      onLoading: const ViewStateBusyWidget(),
      onEmpty: ViewStateEmptyWidget(onPressed: onRefreshTap),
    );
  }
}
