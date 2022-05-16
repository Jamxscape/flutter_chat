import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/utils/as_t.dart';
import '/utils/easy_loading_utils.dart';
import '../helper/dialog_helper.dart';
import 'custom_tapped.dart';
import 'image.dart';

class GroupEditItem extends StatelessWidget {
  const GroupEditItem({
    Key? key,
    this.title,
    this.hint,
    this.maxLines = 1,
    this.minLines,
    this.maxLength = 15,
    this.controller,
    this.textInputAction,
    this.onEditingComplete,
    this.focusNode,
    this.obscureText,
    this.icon,
    this.keyboardType,
    this.alignment,
    this.inputFormatters,
  }) : super(key: key);

  final String? title;
  final String? hint;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool? obscureText;
  final Widget? icon;
  final TextInputType? keyboardType;
  final CrossAxisAlignment? alignment;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return GroupItem(
      title: title,
      icon: icon,
      alignment: alignment,
      child: Builder(builder: (context) {
        final Widget child = TextField(
          scrollPadding: EdgeInsets.zero,
          obscureText: obscureText ?? false,
          focusNode: focusNode,
          keyboardType: keyboardType ?? TextInputType.text,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction ?? TextInputAction.next,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          scrollPhysics: const BouncingScrollPhysics(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: hint ?? '请输入$title',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            counterText: '',
            hintStyle: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xffcccccc),
            ),
          ),
          style: const TextStyle(
            color: Color(0xff444444),
            fontSize: 14,
            height: 1.45,
          ),
          controller: controller,
        );
        if (keyboardType == TextInputType.multiline) {
          return Scrollbar(
            child: child,
          );
        }
        return child;
      }),
    );
  }
}

class SwitchGroupItem extends StatefulWidget {
  const SwitchGroupItem({
    Key? key,
    this.title,
    this.checked = false,
    required this.onCheckChanged,
  }) : super(key: key);

  final String? title;
  final bool checked;
  final Function(bool isChecked) onCheckChanged;

  @override
  _SwitchGroupItemState createState() => _SwitchGroupItemState();
}

class _SwitchGroupItemState extends State<SwitchGroupItem> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  void didUpdateWidget(SwitchGroupItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked != widget.checked) {
      setState(() {
        _checked = widget.checked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GroupItem(
      title: widget.title,
      icon: CupertinoSwitch(
        value: _checked,
        onChanged: (bool flag) {
          setState(() {
            _checked = flag;
            widget.onCheckChanged.call(flag);
          });
        },
      ),
    );
  }
}

class AvatarGroupItem extends StatelessWidget {
  const AvatarGroupItem({
    Key? key,
    this.title,
    this.url,
    this.onTap,
    this.icon,
    this.heroTag,
  }) : super(key: key);

  final String? title;
  final String? url;
  final GestureTapCallback? onTap;
  final Widget? icon;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return GroupItem(
      title: title,
      child: Builder(
        builder: (context) {
          final Widget child = RoundAvatarImage(
            url: url ?? '',
            size: 36,
          );
          if (heroTag == null) {
            return child;
          }
          return Hero(
            tag: heroTag!,
            child: child,
          );
        },
      ),
      onTap: onTap,
      icon: icon,
    );
  }
}

class TextGroupItem extends StatelessWidget {
  const TextGroupItem({
    Key? key,
    this.title,
    this.content,
    this.onTap,
    this.alignment,
    this.icon,
    this.contentFontSize,
    this.contentColor,
  }) : super(key: key);

  final String? title;
  final String? content;
  final GestureTapCallback? onTap;
  final CrossAxisAlignment? alignment;
  final Widget? icon;
  final double? contentFontSize;
  final Color? contentColor;

  @override
  Widget build(BuildContext context) {
    return GroupItem(
      title: title,
      child: Text(
        content ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: contentColor ?? const Color(0xff888888),
          fontSize: contentFontSize ?? 14,
          height: 1.45,
        ),
      ),
      onTap: onTap,
      childAlignment: alignment,
      icon: icon,
    );
  }
}

class GroupItem extends StatefulWidget {
  const GroupItem({
    Key? key,
    this.title,
    this.color = Colors.black,
    this.fontSize,
    this.child,
    this.icon,
    this.onTap,
    this.childAlignment,
    this.alignment,
    this.titlePadding,
  }) : super(key: key);

  final String? title;
  final Color? color;
  final double? fontSize;
  final Widget? child;
  final Widget? icon;
  final GestureTapCallback? onTap;
  final CrossAxisAlignment? childAlignment;
  final EdgeInsets? titlePadding;
  final CrossAxisAlignment? alignment;

  @override
  _GroupItemState createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final Widget child = Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.center,
            children: [
              Container(
                margin: widget.titlePadding,
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                    color: widget.color,
                    fontSize: widget.fontSize ?? 14,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      widget.childAlignment ?? CrossAxisAlignment.end,
                  children: [
                    widget.child ?? Container(),
                  ],
                ),
              ),
              widget.icon ??
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xffc7c7c7),
                  ),
            ],
          ),
        );
        if (widget.onTap != null) {
          return CustomTapped(
            child: child,
            onTap: widget.onTap,
          );
        }
        return child;
      },
    );
  }
}

class GroupSelectListWidget extends StatefulWidget {
  const GroupSelectListWidget({
    Key? key,
    required this.title,
    required this.items,
    this.onSelected,
  }) : super(key: key);

  final String title;
  final List<String> items;
  final Function(int index, String text)? onSelected;

  @override
  _GroupSelectListWidgetState createState() => _GroupSelectListWidgetState();
}

class _GroupSelectListWidgetState extends State<GroupSelectListWidget> {
  String? _selectItem;

  @override
  Widget build(BuildContext context) {
    return TextGroupItem(
      title: widget.title,
      alignment: CrossAxisAlignment.start,
      content: _selectItem ?? '请选择${widget.title}',
      contentFontSize: _selectItem != null ? 15 : 14,
      contentColor: _selectItem != null
          ? const Color(0xff444444)
          : const Color(0xff9b9b9b),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xff9b9b9b),
      ),
      onTap: () async {
        final List itemList = widget.items;
        if (itemList.isEmpty) {
          showToast('暂无可选项');
          return;
        }
        final Map? result = await DialogHelper.showListDialog(
          context,
          '请选择${widget.title}',
          widget.items,
        );
        if (result is Map) {
          setState(() {
            _selectItem = asT<String>(itemList[asT<int>(result['index'])!]);
            widget.onSelected?.call(
              asT<int>(result['index'])!,
              asT<String>(result['content'])!,
            );
          });
        }
      },
    );
  }
}

class GroupDivider extends StatelessWidget {
  const GroupDivider({Key? key, this.padding}) : super(key: key);

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.white,
      child: const Divider(
        color: Color(0xffdddddd),
        height: 1,
      ),
    );
  }
}
