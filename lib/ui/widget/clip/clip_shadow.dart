import 'package:flutter/material.dart';

class ClipPathShadow extends StatelessWidget {
  const ClipPathShadow({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipPathShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class _ClipPathShadowPainter extends CustomPainter {
  const _ClipPathShadowPainter({required this.shadow, required this.clipper});

  final Shadow shadow;
  final CustomClipper<Path> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = shadow.toPaint();
    final Path clipRect = clipper.getClip(size).shift(const Offset(0, 0));
    canvas.drawPath(clipRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipRectShadow extends StatelessWidget {
  const ClipRectShadow({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  final Shadow shadow;
  final CustomClipper<Rect> clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipRectShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipRect(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class _ClipRectShadowPainter extends CustomPainter {
  const _ClipRectShadowPainter({required this.shadow, required this.clipper});

  final Shadow shadow;
  final CustomClipper<Rect> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = shadow.toPaint();
    final Rect clipRect = clipper.getClip(size).shift(const Offset(0, 0));
    canvas.drawRect(clipRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipOvalShadow extends StatelessWidget {
  const ClipOvalShadow({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  final Shadow shadow;
  final CustomClipper<Rect> clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipOvalShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipOval(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class _ClipOvalShadowPainter extends CustomPainter {
  const _ClipOvalShadowPainter({required this.shadow, required this.clipper});

  final Shadow shadow;
  final CustomClipper<Rect> clipper;


  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = shadow.toPaint();
    final Rect clipRect = clipper.getClip(size).shift(const Offset(0, 0));
    canvas.drawOval(clipRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
