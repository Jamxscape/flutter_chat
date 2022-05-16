import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '/utils/easy_loading_utils.dart';
import '../../config/scroll_behavior_config.dart';

class PermissionItem {
  const PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.permission,
  });

  /// 权限图标
  final Icon icon;

  /// 权限名
  final String title;

  /// 权限描述
  final String description;

  /// 要申请的权限列表
  final List<Permission> permission;
}

class PermissionHelper {
  ///
  /// 检查权限完整性
  ///
  static Future<bool> permissionsCheck(
      List<PermissionItem> permissionItemList) async {
    for (int i = 0; i < permissionItemList.length; i++) {
      final PermissionItem item = permissionItemList[i];
      final List<Permission> permissionList = item.permission;
      for (int i = 0; i < permissionList.length; i++) {
        final Permission permission = permissionList[i];
        final PermissionStatus status = await permission.status;
        if (!status.isGranted) {
          return false;
        }
      }
    }
    return true;
    // PermissionStatus storageStatus = await Permission.storage.status;
    // return storageStatus.isGranted;
  }

  ///
  /// 权限申请
  ///
  static Future<bool> requestPermissions(
    BuildContext context,
    String appName,
    List<PermissionItem> permissionItemList,
  ) async {
    bool flag = await permissionsCheck(permissionItemList);
    if (flag) {
      return true;
    }
    final bool confirm = await showPermissionDialog(
      context,
      appName,
      permissionItemList,
    );
    if (!confirm) {
      print('用户拒绝了权限请求');
      exit(0);
    }
    int count = 0;
    int maxCount = 0;
    final List<Permission> pList = <Permission>[];
    for (int i = 0; i < permissionItemList.length; i++) {
      final List<Permission> list = permissionItemList[i].permission;
      maxCount += list.length;
      pList.addAll(list);
    }

    final Map<Permission, PermissionStatus> result = await pList.request();
    for (final Permission permission in pList) {
      final PermissionStatus? status = result[permission];

      if (!(status?.isGranted ?? true)) {
        final PermissionStatus result = await permission.request();
        if (result.isPermanentlyDenied && Platform.isAndroid) {
          showToast('权限被拒绝请在应用设置中允许程序使用权限');
          await openAppSettings();
        }
        if (!result.isGranted && !result.isPermanentlyDenied) {
          showToast('权限被拒绝');
          continue;
        }
      }
      count++;
    }

    if (count >= maxCount) {
      return true;
    } else {
      flag = await permissionsCheck(permissionItemList);
      if (flag) {
        showToast('部分权限被拒绝, 这可能会导致无法正常使用该应用');
      } else {
        showToast('必要权限被拒绝, 应用即将自动关闭');
        Future<void>.delayed(const Duration(seconds: 3), () async {
          print('用户拒绝了权限请求');
          exit(0);
        });
      }
    }
    return false;
  }

  ///
  /// 弹出申请权限对话框
  ///
  static Future<bool> showPermissionDialog(
    BuildContext context,
    String appName,
    List<PermissionItem> permissionItemList,
  ) async {
    await AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      dialogType: DialogType.INFO,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text(
              '提示',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '为确保您能够正常使用$appName, 需要开启以下权限, 请选择允许/确认, 如拒绝可能会导致无法正常使用$appName',
              style: const TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            ScrollConfiguration(
              behavior: ScrollBehaviorConfig(),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: permissionItemList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        height: 10,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    final PermissionItem item = permissionItemList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          border: Border.all(
                            color: const Color(0xffcccccc),
                            width: 1,
                          )),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          item.icon,
                          const SizedBox(width: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff333333),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item.description,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff999999),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              elevation: 0,
              highlightElevation: 0,
              color: Colors.blueAccent,
              minWidth: 200,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: const Text(
                '确认',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            const SizedBox(height: 5),
            GestureDetector(
              child: const Text(
                '拒绝并退出',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 14,
                ),
              ),
              onTap: () {
                exit(0);
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    ).show();
    return true;
  }
}
