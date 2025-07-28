import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageSvgAsset extends StatelessWidget {
  const ImageSvgAsset(
    this.assetName, {
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.fit,
    this.border,
    this.fromPackage = true,
    super.key,
  });

  final String assetName;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final BoxBorder? border;
  final bool fromPackage;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: SvgPicture.asset(
            assetName,
            height: height,
            width: width,
            colorFilter: color == null
                ? null
                : ColorFilter.mode(color!, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
