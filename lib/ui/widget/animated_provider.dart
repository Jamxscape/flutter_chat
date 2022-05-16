import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ScaleAnimatedSwitcher extends StatelessWidget {
  const ScaleAnimatedSwitcher({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: child,
    );
  }
}

class EmptyAnimatedSwitcher extends StatelessWidget {
  const EmptyAnimatedSwitcher({Key? key, this.display = true, this.child})
      : super(key: key);

  final bool display;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ScaleAnimatedSwitcher(
      child: display ? child : const SizedBox.shrink(),
    );
  }
}

class NormalListViewAnimation extends StatelessWidget {
  const NormalListViewAnimation({
    Key? key,
    required this.index,
    required this.child,
    this.horizontalOffset = 50.0,
    this.verticalOffset = 50.0,
  }) : super(key: key);

  final int index;
  final Widget child;
  final double horizontalOffset;
  final double verticalOffset;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}

class NormalGridViewAnimation extends StatelessWidget {
  const NormalGridViewAnimation({
    Key? key,
    required this.count,
    required this.index,
    required this.child,
    this.horizontalOffset = 50.0,
    this.verticalOffset = 50.0,
  }) : super(key: key);

  final int count;
  final int index;
  final Widget child;
  final double horizontalOffset;
  final double verticalOffset;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      columnCount: count,
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
