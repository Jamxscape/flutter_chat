import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/widget/app_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: '聊天室'),
        body: Container(
            child: Column(
          children: [
            Expanded(child: Container()),
            Row(
              children: [],
            ),
          ],
        )));
  }
}
