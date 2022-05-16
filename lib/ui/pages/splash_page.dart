import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '/config/constant.dart';
import '/config/router_manager.dart';
import '/ui/widget/custom_tapped.dart';
import '../helper/permission_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

///
/// TickerProviderStateMixin 用于动画实现
///
/// Splash启动页
/// 主要是图标的动画
///
class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _countdownController;

  bool isTooOld = false;

  @override
  void initState() {
    _countdownController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    super.initState();
    prepare();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  List<PermissionItem> permissionItemList = [
    const PermissionItem(
      icon: Icon(
        Icons.sd_storage,
        size: 18,
      ),
      title: '储存权限',
      description: '储存/选取资源',
      permission: [Permission.storage, Permission.photos],
    ),
    //const PermissionItem(
    //   icon: Icon(
    //     Icons.location_on,
    //     size: 18,
    //   ),
    //   title: '位置权限',
    //   description: '获取位置信息',
    //   permission: [
    //     Permission.location,
    //     //PermissionGroup.locationAlways,
    //     Permission.locationWhenInUse
    //   ],
    // ),
    //const PermissionItem(
    //   icon: Icon(
    //     Icons.camera_alt,
    //     size: 18,
    //   ),
    //   title: '拍照权限',
    //   description: '直播课互动提问',
    //   permission: [Permission.camera],
    // ),
    //const PermissionItem(
    //   icon: Icon(
    //     Icons.mic,
    //     size: 18,
    //   ),
    //   title: '录音权限',
    //   description: '直播课语音对话',
    //   permission: [Permission.microphone],
    // ),
  ];

  bool prepared = false;

  Future<void> prepare() async {
    final bool flag = await PermissionHelper.requestPermissions(
      context,
      Constant.appName,
      permissionItemList,
    );
    if (flag) {
      _countdownController.forward();
      prepared = true;
    }
  }

  ///
  ///
  /// 各平台的启动图需要单独配置
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          // Positioned(
          //   top: 50,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     ImageHelper.wrapAssets("img_splash.png"),
          //   ),
          // ),
          Align(
            alignment: const Alignment(0.0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Text(
                  Constant.appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Visibility(
                visible: !isTooOld,
                child: Container(
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  child: CustomTapped(
                    onTap: () {
                      if (!prepared) {
                        return;
                      }
                      nextPage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black.withAlpha(100),
                      ),
                      child: AnimatedCountdown(
                        animation: StepTween(begin: 3, end: 0)
                            .animate(_countdownController),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class AnimatedCountdown extends AnimatedWidget {
  AnimatedCountdown({Key? key, required this.animation})
      : super(key: key, listenable: animation) {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        nextPage();
      }
    });
  }

  final Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    final int value = animation.value + 1;
    return Text(
      (value == 0 ? '' : '$value | ') + '跳过',
      style: const TextStyle(color: Colors.white),
    );
  }
}

///
/// 跳转到首页
///
bool isCompleted = false;

void nextPage() {
  if (!isCompleted) {
    isCompleted = true;
    Get.offNamed<void>(Routes.home);
  }
}
