import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/chat/chat_cell.dart';
import 'package:flutter_chat/ui/pages/chat/chat_controller.dart';
import 'package:flutter_chat/ui/widget/app_bar.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);
  TextEditingController textEditController = TextEditingController();
  ChatController controller = Get.put(ChatController(Get.arguments.toString()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: '聊天室'),
        body: Container(
            child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xfff2f2f2),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(children: <Widget>[
                    Obx(() {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.messageList.length,
                          itemBuilder: (context, i) {
                            return ChatCell(index: i);
                          });
                    }),
                  ]),
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 40,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 290,
                    height: 30,
                    child: TextField(
                      controller: textEditController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xD9FFFFFF),
                        hintText: '',
                        hintStyle: TextStyle(
                          color: Color(0x59000000),
                          fontSize: 16,
                        ), //修改颜色
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10), // 输入框的上下宽度
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: BeveledRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      child: const Text('发送',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          )),
                      onPressed: () {
                        controller
                            .sendMessageByWebSocket(textEditController.text);
                        textEditController.text = '';
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
