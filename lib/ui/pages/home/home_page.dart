import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/helper/dialog_helper.dart';
import 'package:flutter_chat/ui/widget/app_bar.dart';
import 'package:flutter_chat/ui/widget/date_picker/date_ranger.dart';
import 'package:flutter_chat/utils/easy_loading_utils.dart';
import 'package:get/get.dart';

import '/config/router_manager.dart';
import '/state/base_get_view.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Text('输入属于自己的昵称'),
            const SizedBox(height: 10),
            TextField(
              controller: _controller.textEditController,
              onChanged: (str) {
                _controller.checkTextEdit();
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                hintText: '',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Obx(() {
              return ElevatedButton(
                child: const Text('提交'),
                onPressed: () {
                  if (!_controller.isTextEditingNull.value) {
                    Get.offNamed<void>(Routes.chatPage,
                        arguments: _controller.textEditController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: _controller.isTextEditingNull.value
                      ? Colors.grey
                      : Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
