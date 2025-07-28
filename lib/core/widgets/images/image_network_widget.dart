import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  final String? url;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;
  final Widget? placeholderBuilder;
  final Widget? errorBuilder;

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
          child: url == null
              ? placeholderBuilder ??
                  Center(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 70.h, maxWidth: 70.h),
                      // child: AssetsPackage.icons.placeholderImageNew.svg(
                      //   // color: context.colors.onTertiary,
                      //   height: double.infinity,
                      //   width: double.infinity,
                      //   fit: BoxFit.scaleDown,
                      // ),
                    ),
                  )
              : CachedNetworkImage(
                  imageUrl: url!,
                  fit: fit,
                  height: height,
                  width: width,
                  errorWidget: (context, url, error) =>
                      errorBuilder ??
                      Center(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 70.h, maxWidth: 70.h),
                          child: Padding(
                            padding: EdgeInsets.all(4.h),
                            // child: Assets.icons.placeholderImageNew.svg(
                            //   height: double.infinity,
                            //   width: double.infinity,
                            //   fit: BoxFit.scaleDown,
                            // ),
                          ),
                        ),
                      ),
                  placeholder: (context, url) =>
                      placeholderBuilder ??
                      ShimmerSkeletonizerWidget(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                ),
        ),
      ),
    );
  }
}
