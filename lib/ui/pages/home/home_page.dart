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
      appBar: const CustomAppBar(
        title: '首页',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _controller.setIdle();
                  },
                  child: const Text('Idle'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.setBusy();
                  },
                  child: const Text('Busy'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.setError();
                  },
                  child: const Text('Error'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.setEmpty();
                  },
                  child: const Text('Empty'),
                ),
              ]
                  .map(
                    (e) => Expanded(
                      child: Container(
                        child: e,
                        padding: const EdgeInsets.all(5),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed<void>(Routes.autosize);
                  },
                  child: const Text('适配页'),
                ),
                TextButton(
                  onPressed: () async {
                    final dateTime = await DialogHelper.showDatePicker(
                        rangerType: DateRangerType.range);
                    if (dateTime == null) {
                      showToast('未选择日期');
                      return;
                    }
                    showToast(dateTime.toString());
                  },
                  child: const Text('弹出日期对话框'),
                ),
              ]
                  .map(
                    (e) => Expanded(
                      child: Container(
                        child: e,
                        padding: const EdgeInsets.all(5),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: RefreshStateWidget<HomeController>(
                (state) => ListView.separated(
                  itemBuilder: (context, index) => SizedBox(
                    height: 48,
                    child: Center(
                      child: Text('${_controller.list[index]}'),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _controller.list.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
