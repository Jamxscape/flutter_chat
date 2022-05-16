import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widget/date_picker/date_ranger.dart';

class DialogHelper {
  static Future<Map?> showListDialog(
      BuildContext context, String title, List<String> items) async {
    FocusScope.of(context).requestFocus(FocusNode());
    return showDialog<Map?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: const Text('取消')),
        ],
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff4a4a4a),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: const Color(0xfff0f0f0),
              ),
              Container(
                  constraints: const BoxConstraints(maxHeight: 209),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            items[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff9b9b9b),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).maybePop(
                              {'content': items[index], 'index': index});
                        },
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          Container(
                        height: 1,
                        //color: const Color(0xfff0f0f0),
                      ),
                      itemCount: items.length,
                    ),
                  )),
              Container(
                height: 1,
                color: const Color(0xfff0f0f0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? content,
  }) async {
    FocusScope.of(context).requestFocus(FocusNode());
    return showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title ?? '提示',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          content: Text(
            content ?? '是否删除?',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text(
                '取消',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text(
                '确认',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<DateTimeRange?> showDatePicker({
    DateTime? initialDate,
    DateRangerType rangerType = DateRangerType.single,
  }) {
    final init = initialDate ?? DateTime.now();
    DateTimeRange? result = DateTimeRange(start: init, end: init);
    return Get.bottomSheet(
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: DateRanger(
              initialDate: initialDate,
              rangerType: rangerType,
              onRangeChanged: (range) {
                result = range;
              },
            ),
          ),
          SizedBox(
            width: 100,
            child: TextButton(
              onPressed: () {
                Get.back<DateTimeRange>(result: result);
              },
              child: const Text(
                '确认',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
