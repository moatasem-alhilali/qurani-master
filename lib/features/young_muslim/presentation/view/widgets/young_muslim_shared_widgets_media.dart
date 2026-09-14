part of 'young_muslim_shared_widgets.dart';

/// صورة مصغّرة بزوايا لطيفة، وبديلها مربّع الأيقونة نفسه عند تعذّر التحميل.
///
/// قسم الأطفال يتحمّل صورًا أكبر قليلًا من بقية الشاشات — الصورة هنا هي ما
/// يتعرّف به الطفل على الحلقة قبل أن يقرأ عنوانها.
class YoungMuslimThumb extends StatelessWidget {
  const YoungMuslimThumb({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.radius,
    this.icon,
    super.key,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double? radius;
  final HugeIconData? icon;

  @override
  Widget build(BuildContext context) {
    final corner = radius ?? 12.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(corner),
      child: SizedBox(
        width: width,
        height: height,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: width,
          height: height,
          errorWidget: (context, url, error) => _ThumbFallback(icon: icon),
          placeholder: (context, url) => _ThumbFallback(icon: icon),
        ),
      ),
    );
  }
}

class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback({this.icon});

  final HugeIconData? icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return ColoredBox(
      color: skin.iconChip,
      child: Center(
        child: AppIcon(
          icon ?? AppIcons.play,
          color: skin.accent,
          size: 16.sp,
        ),
      ),
    );
  }
}

/// صورة تعريف الشاشة: لوح واحد بعرض المحتوى، بلا نصّ فوقه.
///
/// كان العنوان يُكتب أبيض فوق تدرّج داكن على الصورة، فيختلف عن لغة بقية
/// الشاشات ويصعب قراءته أحيانًا. صار العنوان نصًّا عاديًا تحت الصورة.
class YoungMuslimCover extends StatelessWidget {
  const YoungMuslimCover({
    required this.imageUrl,
    required this.title,
    this.description,
    this.height,
    this.chips = const [],
    super.key,
  });

  final String imageUrl;
  final String title;
  final String? description;
  final double? height;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSkin.gutter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return YoungMuslimThumb(
                imageUrl: imageUrl,
                width: constraints.maxWidth,
                height: height ?? 148.h,
                radius: 16.r,
                icon: AppIcons.bookOpen,
              );
            },
          ),
        ),
        SizedBox(height: 11.h),
        Padding(
          padding: AppSkin.gutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              if (description != null && description!.trim().isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin, size: 10.sp),
                ),
              ],
              if (chips.isNotEmpty) ...[
                SizedBox(height: 9.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: chips,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// صفّ قسم: صورة مصغّرة، اسم القسم ووصفه، وعدد سلاسله.
class YoungMuslimCategoryRow extends StatelessWidget {
  const YoungMuslimCategoryRow({
    required this.category,
    required this.onTap,
    this.isLast = false,
    super.key,
  });

  final YoungMuslimCategoryEntity category;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final audience = category.audience == 'kids' ? ' · للأطفال' : '';
    final meta = '${category.seriesIds.length} سلسلة$audience';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            YoungMuslimThumb(
              imageUrl: category.thumbnail.isEmpty
                  ? category.bannerImage
                  : category.thumbnail,
              width: 52.w,
              height: 40.w,
              radius: 12.r,
              icon: AppIcons.bookOpen,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.titleAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: youngMuslimRowTitle(skin, size: 13.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    category.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: youngMuslimRowSubtitle(skin),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: youngMuslimNumber(skin, size: 9.5.sp),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}
