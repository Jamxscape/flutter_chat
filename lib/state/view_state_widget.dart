import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/state/base_getx_controller.dart';
import '/utils/as_t.dart';
import '/utils/event_bus_utils.dart';
import '../config/constant.dart';
import '../config/resource_mananger.dart';
import '../config/router_manager.dart';
import '../ui/theme/app_theme.dart';
import 'view_state.dart';

class StandardRefreshWidget extends StatelessWidget {
  const StandardRefreshWidget({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final BaseRefreshGetxController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StandardViewStateWidget(
        viewState: controller.viewState,
        controller: controller,
        onRefreshTap: () {
          controller.onRefresh(true);
        },
        child: SmartRefresher(
          controller: controller.controller,
          onRefresh: () {
            controller.onRefresh(false);
          },
          child: child,
        ),
      ),
    );
  }
}

class StandardRefreshLoadMoreWidget extends StatelessWidget {
  const StandardRefreshLoadMoreWidget({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final BaseRefreshListGetxController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StandardViewStateWidget(
        viewState: controller.viewState,
        controller: controller,
        onRefreshTap: () {
          controller.onRefresh(true);
        },
        child: SmartRefresher(
          controller: controller.controller,
          enablePullUp: true,
          onLoading: () {
            controller.onLoadMore(false);
          },
          onRefresh: () {
            controller.onRefresh(false);
          },
          child: child,
        ),
      ),
    );
  }
}

class StandardViewStateWidget extends StatelessWidget {
  const StandardViewStateWidget({
    Key? key,
    required this.controller,
    required this.viewState,
    required this.child,
    this.onRefreshTap,
  }) : super(key: key);

  final BaseGetxController controller;
  final ViewState viewState;
  final Widget child;
  final Function()? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(
        builder: (context) {
          final ViewStateError? viewStateError = controller.viewStateError;
          final Function() callback = onRefreshTap ??
              () {
                if (controller is BaseRefreshGetxController) {
                  asT<BaseRefreshGetxController>(controller)?.onRefresh(true);
                } else {
                  controller.onInit();
                }
              };
          if (viewState == ViewState.busy) {
            return const ViewStateBusyWidget();
          } else if (viewState == ViewState.empty) {
            return ViewStateEmptyWidget(onPressed: callback);
          } else if (viewState == ViewState.error) {
            if (viewStateError?.isUnauthorized ?? false) {
              return ViewStateUnAuthWidgetCallback(onLoginSucceed: callback);
            }
            return ViewStateErrorWidget(
              error: viewStateError,
              onPressed: callback,
            );
          }
          return child;
        },
      ),
    );
  }
}

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  const ViewStateBusyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 80,
        child: LoadingIndicator(
          indicatorType: Indicator.ballSpinFadeLoader,
          colors: [
            kPrimaryColor,
            kPrimaryVariantColor,
          ],
        ),
      ),
    );
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  const ViewStateWidget({
    Key? key,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    @required this.onPressed,
    this.buttonTextData,
    this.hasButton,
  }) : super(key: key);

  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback? onPressed;
  final bool? hasButton;

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle =
        Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey);
    final TextStyle? messageStyle = titleStyle?.copyWith(
        color: titleStyle.color?.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(IconFonts.pageError, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? Constant.viewStateMessageError,
                style: titleStyle,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 200, minHeight: 50),
                child: SingleChildScrollView(
                  child: Text(message ?? '', style: messageStyle),
                ),
              ),
            ],
          ),
        ),
        if (hasButton ?? true)
          Center(
            child: ViewStateButton(
              child: buttonText,
              textData: buttonTextData,
              onPressed: onPressed,
            ),
          ),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  const ViewStateErrorWidget({
    Key? key,
    required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  final ViewStateError? error;
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget defaultImage;
    String defaultTitle;
    final String errorMessage = error?.message ?? Constant.defaultErrorMessage;
    const String defaultTextData = Constant.viewStateButtonRetry;
    switch (error?.errorType ?? ViewStateErrorType.networkTimeOutError) {
      case ViewStateErrorType.networkTimeOutError:
        defaultImage = Transform.translate(
          offset: const Offset(-50, 0),
          child: const Icon(IconFonts.pageNetworkError,
              size: 100, color: Colors.grey),
        );
        defaultTitle = Constant.viewStateMessageNetworkError;
        // errorMessage = ''; // 网络异常移除message提示
        break;
      case ViewStateErrorType.defaultError:
        defaultImage =
            const Icon(IconFonts.pageError, size: 100, color: Colors.grey);
        defaultTitle = Constant.viewStateMessageError;
        break;

      case ViewStateErrorType.unauthorizedError:
        return ViewStateUnAuthWidget(
          image: image,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
    }

    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  const ViewStateEmptyWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    required this.onPressed,
    this.hasButton,
  }) : super(key: key);

  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback onPressed;
  final bool? hasButton;

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image: image ??
          const Icon(IconFonts.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? Constant.viewStateMessageEmpty,
      buttonText: buttonText,
      buttonTextData: Constant.viewStateButtonRefresh,
      hasButton: hasButton,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidgetNoButton extends StatelessWidget {
  const ViewStateEmptyWidgetNoButton({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
  }) : super(key: key);

  final String? message;
  final Widget? image;
  final Widget? buttonText;

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: () {},
      image: image ??
          const Icon(IconFonts.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? Constant.viewStateMessageEmpty,
      buttonText: buttonText,
      buttonTextData: Constant.viewStateButtonRefresh,
      hasButton: false,
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  const ViewStateUnAuthWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    this.buttonTextData,
    required this.onPressed,
  }) : super(key: key);

  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? const ViewStateUnAuthImage(),
      title: message ?? Constant.viewStateMessageUnAuth,
      buttonText: buttonText,
      buttonTextData: buttonTextData ?? Constant.viewStateButtonLogin,
    );
  }
}

class ViewStateUnAuthWidgetSample extends StatelessWidget {
  const ViewStateUnAuthWidgetSample({
    Key? key,
    required this.onLoginSucceed,
    this.image,
    this.message,
    this.buttonText,
    this.buttonTextData,
  }) : super(key: key);

  final VoidCallback onLoginSucceed;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;

  @override
  Widget build(BuildContext context) {
    return ViewStateUnAuthWidget(
      onPressed: () async {
        final bool? result = await Get.offNamedUntil<bool?>(
            Routes.login, (route) => route.settings.name != Routes.login);
        if (result ?? false) {
          onLoginSucceed.call();
        }
      },
      buttonText: buttonText,
      buttonTextData: buttonTextData,
      message: message,
      image: image,
    );
  }
}

/// 自带登录状态处理的未登录布局
///
/// 使用时需要配合[eventBus]发送字符串`login`
/// 表示已登录成功，布局会自动响应刷新操作
class ViewStateUnAuthWidgetCallback extends StatefulWidget {
  ///
  /// 当收到消息`login`时，将自动调用 [onLoginSucceed]
  ///
  ///
  const ViewStateUnAuthWidgetCallback({
    Key? key,
    required this.onLoginSucceed,
    this.image,
    this.message,
    this.buttonText,
    this.buttonTextData,
  }) : super(key: key);

  final VoidCallback onLoginSucceed;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;

  @override
  _ViewStateUnAuthWidgetCallbackState createState() =>
      _ViewStateUnAuthWidgetCallbackState();
}

class _ViewStateUnAuthWidgetCallbackState
    extends State<ViewStateUnAuthWidgetCallback> {
  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    return ViewStateUnAuthWidget(
      onPressed: () {
        Get.offNamedUntil<void>(
            Routes.login, (route) => route.settings.name != Routes.login);
      },
      buttonText: widget.buttonText,
      buttonTextData: widget.buttonTextData,
      message: widget.message,
      image: widget.image,
    );
  }

  @override
  void initState() {
    _subscription = eventBus.on<String>().listen((event) {
      if ('login' == event) {
        widget.onLoginSucceed.call();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  const ViewStateUnAuthImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(16),
      //   boxShadow: [
      //     BoxShadow(
      //       offset: Offset(0, 2.h),
      //       color: const Color(0x1A000000),
      //       blurRadius: 10.h,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SvgPicture.asset(
          IconHelper.wrapAssets('ncov_blue.svg'),
          width: 300,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  const ViewStateButton(
      {Key? key, @required this.onPressed, this.child, this.textData})
      : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final String? textData;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return OutlineButton(
      child: child ??
          Text(
            textData ?? Constant.viewStateButtonRetry,
            style: const TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
