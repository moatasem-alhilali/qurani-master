import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class RadioStationArtwork extends StatelessWidget {
  const RadioStationArtwork({
    required this.imageUrl,
    required this.heroTag,
    this.size,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final String heroTag;
  final double? size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 72.w;
    final radius = borderRadius ?? 24.r;
    final hasFixedSize = size != null;

    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              SizedBox(
                width: hasFixedSize ? dimension : null,
                height: hasFixedSize ? dimension : null,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: hasFixedSize ? dimension : double.infinity,
                  height: hasFixedSize ? dimension : double.infinity,
                  errorWidget: (context, url, error) => _FallbackArtwork(
                    size: dimension,
                    expand: !hasFixedSize,
                  ),
                  placeholder: (context, url) => _FallbackArtwork(
                    size: dimension,
                    expand: !hasFixedSize,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        context.scrim.withValues(alpha: 0.12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackArtwork extends StatelessWidget {
  const _FallbackArtwork({
    required this.size,
    this.expand = false,
  });

  final double size;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            context.primaryContainer,
            context.secondaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.graphic_eq_rounded,
          color: context.onPrimaryContainer,
          size: size * 0.34,
        ),
      ),
    );

    if (expand) {
      return SizedBox.expand(child: child);
    }

    return child;
  }
}
