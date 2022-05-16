import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '/ui/pages/segment/components/segment_page.dart';
import '/ui/pages/segment/segment_contronller.dart';

class SegmentExamplePage extends StatefulWidget {
  const SegmentExamplePage({Key? key}) : super(key: key);
  @override
  _SegmentExamplePageState createState() => _SegmentExamplePageState();
}

class _SegmentExamplePageState extends State<SegmentExamplePage> {
  final SegmentController _controller = Get.put(SegmentController());
  List<Widget> listView = <Widget>[const Text('页面1'), const Text('页面二')];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Obx(() {
            print('${_controller.currectIndex}');
            return SegmentPage(
              labelText: const ['申请中', '已处理'],
              controller: _controller,
            );
          }),
          Obx(() {
            print('${_controller.currectIndex}');
            return listView[_controller.currectIndex.value];
          }),
        ],
      ),
    );
  }
}
