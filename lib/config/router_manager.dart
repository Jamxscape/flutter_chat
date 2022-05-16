import 'package:flutter_chat/ui/pages/chat/chat_page.dart';
import 'package:get/get.dart';

import '/ui/pages/splash_page.dart';
import '../ui/pages/home/home_page.dart';

class Routes {
  static const String autosize = '/autosize';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String webBrowser = '/browser';
  static const String login = '/login';
  static const String chatPage = '/chat_page';
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
      name: Routes.chatPage,
      page: () => ChatPage(),
    ),
  ];
}
