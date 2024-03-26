import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BaseFadeImage extends StatelessWidget {
  const BaseFadeImage({
    super.key,
    required this.image,
    this.fit,
    this.height,
    this.width,
  });
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          const Center(child: CircularProgressIndicator()),
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      errorWidget: (context, error, stackTrace) {
        return const Center(child: CircularProgressIndicator());
        // return Image.asset(
        //   fit: fit,
        // );
      },
    );
  }
}

class BaseFadeImageAsset extends StatelessWidget {
  const BaseFadeImageAsset({
    super.key,
    required this.image,
    this.fit,
    this.height,
    this.width,
  });
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: height,
      width: width,
      fit: fit,
      // color: const Colors,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
