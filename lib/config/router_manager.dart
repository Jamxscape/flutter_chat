import 'package:get/get.dart';

import '/ui/pages/autosize/autosize_page.dart';
import '/ui/pages/splash_page.dart';
import '../ui/pages/home/home_page.dart';

class Routes {
  static const String autosize = '/autosize';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String webBrowser = '/browser';
  static const String login = '/login';
}

// ignore: avoid_classes_with_only_static_members
class RoutePages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<void>(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage<void>(
      name: Routes.home,
      page: () => HomePage(),
    ),
    GetPage<void>(
      name: Routes.autosize,
      page: () => const AutosizePage(
        title: '标题',
      ),
    ),
  ];
}
