import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/state/base_getx_controller.dart';

class HomeController extends BaseGetxController {
  TextEditingController textEditController = TextEditingController();
  RxBool isTextEditingNull = true.obs;
  @override
  FutureOr<void> initData() {}

  void checkTextEdit() {
    if (textEditController.text == '') {
      isTextEditingNull.value = true;
    } else {
      isTextEditingNull.value = false;
    }
  }
}
