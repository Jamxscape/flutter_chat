import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/chat/chat_controller.dart';
import 'package:get/get.dart';

class ChatCell extends StatelessWidget {
  ChatCell({Key? key, required this.index}) : super(key: key);
  final int index;
  ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: controller.messageList[index].user == controller.username
            ? Container(
                child: Row(
                children: [
                  Expanded(child: Container()),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              '我',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border:
                                      Border.all(color: Colors.transparent)),
                              child: Text(
                                controller.messageList[index].message!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ))
            : Container(
                child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              controller.messageList[index].user!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white)),
                              child: Text(
                                controller.messageList[index].message!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              )));
  }
}
