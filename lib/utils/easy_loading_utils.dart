import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> showToast(
  String status, {
  Duration? duration,
  EasyLoadingToastPosition? toastPosition,
  EasyLoadingMaskType? maskType = EasyLoadingMaskType.none,
  bool? dismissOnTap,
}) {
  return EasyLoading.showToast(
    status,
    duration: duration,
    toastPosition: toastPosition,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}
