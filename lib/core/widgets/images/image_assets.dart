import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageAssets extends StatelessWidget {
  const ImageAssets(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
    this.fromPackage = false,
  });

  final String? path;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;
  final bool fromPackage;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: path == null
              ? Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: 70.h, maxWidth: 70.h),
                    // child: AssetsPackage.icons.placeholderImageNew
                    //     .svg(height: height, width: width),
                  ),
                )
              : Image.asset(
                  path!,
                  fit: fit,
                  height: height,
                  width: width,
                  // package: fromPackage ? Assets.package : null,
                  errorBuilder: (context, url, error) => Center(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 70.h, maxWidth: 70.h),
                      // child: AssetsPackage.icons.placeholderImageNew.svg(
                      //   height: double.infinity,
                      //   width: double.infinity,
                      //   fit: BoxFit.scaleDown,
                      // ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
