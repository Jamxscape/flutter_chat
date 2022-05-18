import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_chat/model/message.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/state/base_getx_controller.dart';

class ChatController extends BaseGetxController {
  ChatController(this.username);
  final String username;
  late WebSocketChannel channel;
  RxList<Message> messageList = <Message>[].obs;
  RxString welcome = ''.obs;
  @override
  FutureOr<void> initData() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://8.142.76.204:8080/ws/$username'),
    );
    receiveMessage();
  }

  void receiveMessage() {
    channel.stream.listen((dynamic message) {
      log('接收的消息为 $message');
      if (message == '$username hello connection is success') {
        welcome.value = message.toString();
      } else {
        // 需要解析
        final String receiveMessage = message.toString();
        final Map<String, dynamic> map =
            jsonDecode(receiveMessage) as Map<String, dynamic>;
        final Message decodeMessage = Message.fromJson(map);
        log(decodeMessage.toString());
        messageList.add(decodeMessage);
      }
    });
  }

  void sendMessageByWebSocket(String message) {
    final Message messageObj = Message(user: username, message: message);
    // final Map<String, dynamic> sendJson = ;
    log('发送消息：' + messageObj.toString());
    channel.sink.add(messageObj.toString());
  }
}
