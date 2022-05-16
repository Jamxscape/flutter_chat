import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';
import 'package:flutter_autosize_screen/binding.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/config/constant.dart';
import 'config/router_manager.dart';
import 'config/scroll_behavior_config.dart';
import 'ui/theme/app_theme.dart';
import 'utils/dependency_injection.dart';

Future<void> main() async {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    // ..progressColor = Colors.yellow
    // ..backgroundColor = Colors.green
    // ..indicatorColor = Colors.yellow
    // ..textColor = Colors.yellow
    // ..maskColor = Colors.blue.withOpacity(0.5)
    // ..userInteractions = false
    ..dismissOnTap = false;

  AutoSizeUtil.setStandard(375, isAutoTextSize: false);
  runAutoApp(const MyApp());

  await DenpendencyInjection.init();

  const SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constant.appName,
      initialRoute: Routes.splash,
      getPages: RoutePages.pages,
      defaultTransition: Transition.fade,
      //移除滚动水波纹
      builder: (context, child) {
        return AutoSizeUtil.appBuilder(
          context,
          RefreshConfiguration(
            headerBuilder: () => const WaterDropHeader(),
            footerBuilder: () => const ClassicFooter(),
            hideFooterWhenNotFull: false,
            child: KeyboardDismisser(
              gestures: const <GestureType>[
                GestureType.onTap,
                GestureType.onPanUpdateDownDirection,
              ],
              child: FlutterEasyLoading(
                child: ScrollConfiguration(
                  behavior: ScrollBehaviorConfig(),
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      darkTheme: appDarkThemeData,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
      ],
    );
  }
}
