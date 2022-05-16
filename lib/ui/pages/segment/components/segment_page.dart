import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/ui/pages/segment/segment_contronller.dart';

// ignore: must_be_immutable
class SegmentPage extends StatefulWidget {
  SegmentPage({Key? key, required this.labelText, required this.controller})
      : super(key: key);

  final List<String> labelText;
  late SegmentController controller;

  @override
  _SegmentPageState createState() => _SegmentPageState();
}

class _SegmentPageState extends State<SegmentPage> {
  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> segment = <int, Widget>{};
    for (int i = 0; i < widget.labelText.length; i++) {
      segment[i] = SegmentCell(text: widget.labelText[i]);
    }
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          CupertinoSegmentedControl(
            onValueChanged: (int v) {
              widget.controller.currectIndex.value = v;
            },
            pressedColor: const Color(0xff7c1c25),
            borderColor: const Color(0xffac172a),
            selectedColor: const Color(0xffac172a),
            groupValue: widget.controller.currectIndex.value,
            children: segment,
          )
        ],
      ),
    );
  }
}

class SegmentCell extends StatelessWidget {
  const SegmentCell({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center, width: 200.0, child: Text(text));
  }
}
