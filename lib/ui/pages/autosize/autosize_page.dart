import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';
import '/ui/widget/app_bar.dart';

class AutosizePage extends StatefulWidget {
  const AutosizePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _AutosizePageState createState() => _AutosizePageState();
}

class _AutosizePageState extends State<AutosizePage> {
  final TextStyle _style = const TextStyle(color: Colors.white);
  final GlobalKey _keyGreen = GlobalKey();
  final GlobalKey _keyBlue = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
      final Rect renderBox =
          _keyGreen.currentContext!.findRenderObject()!.paintBounds;
      final Size sizeGreen = renderBox.size;
      print('${sizeGreen.width} ----- ${sizeGreen.height}');

      final Rect renderBlu =
          _keyBlue.currentContext!.findRenderObject()!.paintBounds;
      final Size sizeBlue = renderBlu.size;
      print('${sizeBlue.width} ----- ${sizeBlue.height}');
      print('${AutoSizeUtil.getScreenSize()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size originalSize = window.physicalSize / window.devicePixelRatio;
    final double nowDevicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Autosize Demo',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    key: _keyGreen,
                    height: 60,
                    color: Colors.redAccent,
                    child: Text(
                      '使用Expanded平分屏幕',
                      style: _style,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    color: Colors.blue,
                    child: Text(
                      '使用Expanded平分屏幕',
                      style: _style,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  key: _keyBlue,
                  width: 187.5,
                  height: 60,
                  color: Colors.teal,
                  child: Text(
                    '宽度写的是 187.5',
                    style: _style,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 187.5,
                  height: 60,
                  color: Colors.grey,
                  child: Text(
                    '宽度写的是 187.5',
                    style: _style,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: 375,
              height: 60,
              color: Colors.purple,
              child: Text(
                '宽度写的是 375',
                style: _style,
              ),
            ),
            const SizedBox(height: 50),
            Text('原始的 size: $originalSize '),
            Text('原始的 分辨率: ${window.physicalSize} '),
            Text('原始的 devicePixelRatio: ${window.devicePixelRatio} '),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              width: 375,
              height: 10,
              color: Colors.grey,
            ),
            Text('更改后 size: ${MediaQuery.of(context).size}  '),
            Text('更改后 devicePixelRatio: $nowDevicePixelRatio'),
          ],
        ),
      ),
    );
  }
}
