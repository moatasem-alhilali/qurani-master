import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// صورة المحطة: مربّع صغير بزوايا لطيفة، بلا حدّ ولا تدرّج فوقها.
///
/// التدرّج الداكن الذي كان يغطّيها كان يعتم الصور في الوضع الفاتح بلا داعٍ،
/// والصورة الآن بحجم مربّع الأيقونة نفسه فلا تحتاج ما يفصلها عن الأرضية.
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
    final dimension = size ?? 34.w;
    final radius = borderRadius ?? 11.r;
    final hasFixedSize = size != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
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
    );
  }
}

/// بديل الصورة عند تعذّر تحميلها: مربّع الأيقونة نفسه المستخدم في كل الصفوف.
class _FallbackArtwork extends StatelessWidget {
  const _FallbackArtwork({
    required this.size,
    this.expand = false,
  });

  final double size;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final child = ColoredBox(
      color: skin.iconChip,
      child: Center(
        child: AppIcon(
          AppIcons.radio,
          color: skin.accent,
          size: (size * 0.42).clamp(12.0, 34.0),
        ),
      ),
    );

    if (expand) {
      return SizedBox.expand(child: child);
    }

    return child;
  }
}
