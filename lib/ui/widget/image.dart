import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../config/resource_mananger.dart';

class RoundAvatarImage extends StatelessWidget {
  const RoundAvatarImage({
    Key? key,
    required this.url,
    required this.size,
    this.borderColor,
    this.borderWidth = 1,
  }) : super(key: key);

  final String url;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? const Color(0xffcccccc),
              width: borderWidth),
          borderRadius: BorderRadius.circular(size / 2)),
      child: ClipOval(
        child: WrapperImage(
          url: url,
          height: size - borderWidth,
          width: size - borderWidth,
          fit: BoxFit.cover,
          placeholder: ImageHelper.normalAvatar(width: size, height: size),
          errorWidget: ImageHelper.normalAvatar(width: size, height: size),
        ),
      ),
    );
  }
}

class WrapperImage extends StatefulWidget {
  const WrapperImage({
    Key? key,
    this.url,
    this.file,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  final String? url;
  final File? file;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  _WrapperImageState createState() => _WrapperImageState();
}

class _WrapperImageState extends State<WrapperImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        value: 0, duration: const Duration(milliseconds: 0), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // ignore: avoid_slow_async_io
      future: widget.file?.exists(),
      builder: (context, AsyncSnapshot<bool> s) {
        if (s.data ?? false) {
          return Image.file(
            widget.file!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
        return ExtendedImage.network(
          widget.url ?? '',
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                {
                  _controller.reset();
                  return widget.placeholder ??
                      ImageHelper.placeHolder(
                          width: widget.width, height: widget.height);
                }
              case LoadState.completed:
                {
                  _controller.forward();
                  return FadeTransition(
                    opacity: _controller,
                    child: ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: widget.fit,
                    ),
                  );
                }
              case LoadState.failed:
                {
                  _controller.reset();
                  return widget.errorWidget ??
                      ImageHelper.error(
                          width: widget.width, height: widget.height);
                }
            }
          },
          fit: widget.fit,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
