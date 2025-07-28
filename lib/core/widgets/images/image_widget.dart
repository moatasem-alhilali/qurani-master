import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/images/image_assets.dart';
import 'package:quran_app/core/widgets/images/image_file_widget.dart';
import 'package:quran_app/core/widgets/images/image_network_widget.dart';
import 'package:quran_app/core/widgets/images/image_svg_asset.dart';
import 'package:quran_app/core/widgets/images/image_svg_network_cache.dart';

enum ImageType { asset, network, svgAsset, svgNetwork, file, unknown }

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.path, {
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.color,
    this.border,
    this.isCircle = false,
    this.fromPackage = true,
    this.placeholderBuilder,
    this.errorBuilder,
    super.key,
  });

  final String? path;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;
  final bool isCircle;
  final bool fromPackage;
  final Widget? placeholderBuilder;
  final Widget? errorBuilder;

  ImageType _determineImageType(String path) {
    final isSvg = path.endsWith('.svg');

    final isNetwork = Uri.tryParse(path)?.scheme == 'http' ||
        Uri.tryParse(path)?.scheme == 'https';
    final isAsset = !isNetwork;

    if (isSvg) {
      return isNetwork ? ImageType.svgNetwork : ImageType.svgAsset;
    }
    if (path.startsWith('/')) {
      return ImageType.file;
    }
    if (isAsset) {
      return ImageType.asset;
    }
    if (isNetwork) {
      return ImageType.network;
    }
    return ImageType.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final imageType = _determineImageType(path ?? '');

    switch (imageType) {
      case ImageType.asset:
        return ImageAssets(
          path,
          width: width,
          height: height,
          borderRadius: borderRadius ??
              (isCircle
                  ? BorderRadius.all(
                      Radius.circular(360.r),
                    )
                  : null),
          fit: fit,
          color: color,
          border: border,
          fromPackage: fromPackage,
        );
      case ImageType.network:
        return ImageNetworkWidget(
          path,
          width: width,
          height: height,
          color: color,
          borderRadius: borderRadius ??
              (isCircle
                  ? BorderRadius.all(
                      Radius.circular(360.r),
                    )
                  : null),
          fit: fit,
          border: border,
          errorBuilder: errorBuilder,
          placeholderBuilder: placeholderBuilder,
        );
      case ImageType.svgAsset:
        return ImageSvgAsset(
          path!,
          width: width,
          height: height,
          borderRadius: borderRadius ??
              (isCircle
                  ? BorderRadius.all(
                      Radius.circular(360.r),
                    )
                  : null),
          fit: fit,
          color: color,
          border: border,
          // fromPackage: fromPackage,
        );
      case ImageType.svgNetwork:
        return ImageCacheNetworkSVG(
          path!,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: color,
          placeholderBuilder: (context) =>
              placeholderBuilder ?? const SizedBox.shrink(),
          errorWidget: errorBuilder,
        );
      case ImageType.file:
        return ImageFileWidget(
          path!,
          width: width,
          height: height,
          borderRadius: borderRadius ??
              (isCircle
                  ? BorderRadius.all(
                      Radius.circular(360.r),
                    )
                  : null),
          fit: fit,
          color: color,
          border: border,
        );
      case ImageType.unknown:
        return Container();
    }
  }
}
