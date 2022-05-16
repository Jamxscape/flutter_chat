import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'activity_indicator.dart';
import 'custom_tapped.dart';

/// 由于app不管明暗模式,都是有底色
/// 所以将indicator颜色为亮色
class AppBarIndicator extends StatelessWidget {
  const AppBarIndicator({Key? key, this.radius}) : super(key: key);

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ActivityIndicator(
      brightness: Brightness.dark,
      radius: radius,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.fontSize = 18,
    this.color = Colors.white,
    this.toolbarHeight,
    this.bottom,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.leadingWidth,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.brightness = Brightness.dark,
  }) : super(key: key);

  final String? title;
  final Widget? titleWidget;
  final double fontSize;
  final Color color;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final double? titleSpacing;
  final double? leadingWidth;
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      actions: actions,
      systemOverlayStyle: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      title: titleWidget ??
          Text(
            title ?? '',
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
      titleSpacing: titleSpacing,
      centerTitle: true,
      leadingWidth: leadingWidth,
      leading: Builder(builder: (context) {
        final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
        final bool canPop = parentRoute?.canPop ?? false;
        if (canPop) {
          return CustomTapped(
            margin: const EdgeInsets.only(left: 23),
            child: Icon(
              Icons.arrow_back_ios,
              color:
                  brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            onTap: () => Get.back<void>(),
          );
        }
        return Container();
      }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
