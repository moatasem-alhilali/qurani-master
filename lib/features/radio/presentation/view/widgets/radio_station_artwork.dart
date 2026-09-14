import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// صورة المحطة: مربّع بزوايا لطيفة، بلا حدّ ولا تدرّج فوقها.
///
/// كانت تطلب `heroTag` إلزاميًّا ولا تستعمله في البناء أبدًا، فيخترع كل
/// مُنادٍ نصًّا لا أثر له. حُذف.
class RadioStationArtwork extends StatelessWidget {
  const RadioStationArtwork({
    required this.imageUrl,
    required this.size,
    this.initials,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final double size;

  /// حرفان يظهران حين تتعذّر الصورة.
  ///
  /// البديل السابق كان أيقونة راديو واحدة، فتتحوّل كل المحطات المتعذّرة إلى
  /// مربّعات متطابقة لا يُفرّق بينها.
  final String? initials;

  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 11.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          fadeInDuration: const Duration(milliseconds: 220),
          errorWidget: (context, url, error) =>
              _FallbackArtwork(size: size, initials: initials),
          placeholder: (context, url) =>
              _FallbackArtwork(size: size, initials: initials),
        ),
      ),
    );
  }
}

class _FallbackArtwork extends StatelessWidget {
  const _FallbackArtwork({required this.size, this.initials});

  final double size;
  final String? initials;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final label = initials;

    return ColoredBox(
      color: skin.iconChip,
      child: Center(
        child: label == null || label.isEmpty
            ? const SizedBox.shrink()
            : Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: (size * 0.34).clamp(9.0, 30.0),
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
      ),
    );
  }
}
