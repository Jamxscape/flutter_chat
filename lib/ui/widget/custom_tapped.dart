import 'package:flutter/material.dart';

class CustomTapped extends StatelessWidget {
  const CustomTapped({
    Key? key,
    this.onTap,
    this.onLongTap,
    this.padding,
    this.child,
    this.margin,
  }) : super(key: key);

  final Widget? child;
  final Function? onTap;
  final Function? onLongTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: margin,
      child: Tapped(
        onTap: onTap,
        onLongTap: onLongTap,
        child: Container(
          padding: padding,
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}

class Tapped extends StatefulWidget {
  const Tapped({Key? key, this.child, this.onTap, this.onLongTap})
      : super(key: key);
  final Widget? child;
  final Function? onTap;
  final Function? onLongTap;

  @override
  _TappedState createState() => _TappedState();
}

class _TappedState extends State<Tapped> with TickerProviderStateMixin {
  bool _isChangeAlpha = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(value: 1, vsync: this);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool _tapDown = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 50);
    const Duration showDuration = Duration(milliseconds: 660);

    return GestureDetector(
      onTap: () async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        widget.onTap?.call();
      },
      onLongPress: widget.onLongTap == null
          ? null
          : () async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              widget.onLongTap?.call();
            },
      onTapDown: (detail) async {
        _tapDown = true;
        _isChangeAlpha = true;
        await _controller.animateTo(0.4, duration: duration);
        if (!_tapDown) {
          await _controller.animateTo(1, duration: showDuration);
        }
        _tapDown = false;
        _isChangeAlpha = false;
      },
      onTapUp: (detail) async {
        _tapDown = false;
        if (_isChangeAlpha == true) {
          return;
        }
        await _controller.animateTo(1, duration: showDuration);
        _isChangeAlpha = false;
      },
      onTapCancel: () async {
        _tapDown = false;
        _controller.value = 1;
        _isChangeAlpha = false;
      },
      child: Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }
}
