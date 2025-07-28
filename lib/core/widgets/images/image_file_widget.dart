import 'dart:io';

import 'package:flutter/material.dart';

class ImageFileWidget extends StatelessWidget {
  const ImageFileWidget(
    this.path, {
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.color,
    this.border,
    super.key,
  });
  final String path;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }
}
