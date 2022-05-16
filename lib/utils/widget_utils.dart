import 'package:flutter/material.dart';

class WidgetUtils {
  ///[value] : 文本内容；
  ///[fontSize] : 文字的大小；
  ///[fontWeight] : 文字权重；
  ///[maxWidth] : 文本框的最大宽度；
  ///[maxLines] : 文本支持最大多少行
  static double calculateTextHeight(
    BuildContext context,
    String value,
    double fontSize,
    FontWeight fontWeight,
    double maxWidth,
    int maxLines,
  ) {
    final TextPainter painter = TextPainter(

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(context),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }
}
