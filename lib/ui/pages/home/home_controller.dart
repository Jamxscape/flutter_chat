import 'dart:async';

import '/state/base_getx_controller.dart';
import '/utils/log_utils.dart';

class HomeController extends BaseRefreshListGetxController<int> {
  @override
  FutureOr<List<int>> loadData(int pageNumber) {
    return Future<List<int>>(() async {
      info('模拟数据加载 -> 开始');
      await Future<void>.delayed(const Duration(seconds: 1));
      final result = List.generate(
          pageSize, (index) => (pageNumber - 1) * pageSize + index);
      info('模拟数据加载 -> 结束');
      return result;
    });
  }
}
