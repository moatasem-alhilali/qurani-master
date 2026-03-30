part of 'young_muslim_shared_widgets.dart';

class YoungMuslimMediaBanner extends StatelessWidget {
  const YoungMuslimMediaBanner({
    required this.title,
    required this.imageUrl,
    required this.accentStart,
    required this.accentEnd,
    this.subtitle,
    this.badges = const [],
    this.height = 220,
    this.onTap,
    super.key,
  });

  final String title;
  final String imageUrl;
  final String accentStart;
  final String accentEnd;
  final String? subtitle;
  final List<Widget> badges;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = youngMuslimGradientColors(
      context,
      startHex: accentStart,
      endHex: accentEnd,
    );

    final banner = Ink(
      decoration: youngMuslimPanelDecoration(context, radius: 30),
      child: SizedBox(
        height: height.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.first.withValues(alpha: 0.18),
                    context.scrim.withValues(alpha: 0.18),
                    context.scrim.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (badges.isNotEmpty) ...[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: badges,
                    ),
                    SizedBox(height: 14.h),
                  ],
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return banner;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: banner,
    );
  }
}

class YoungMuslimCategoryCard extends StatelessWidget {
  const YoungMuslimCategoryCard({
    required this.category,
    required this.onTap,
    this.height = 190,
    super.key,
  });

  final YoungMuslimCategoryEntity category;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = youngMuslimGradientColors(
      context,
      startHex: category.accentStart,
      endHex: category.accentEnd,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Ink(
        decoration: youngMuslimPanelDecoration(context),
        child: SizedBox(
          height: height.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: CachedNetworkImage(
                    imageUrl: category.bannerImage,
                    fit: BoxFit.cover,
                    color: context.scrim.withValues(alpha: 0.1),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        colors.first.withValues(alpha: 0.3),
                        context.scrim.withValues(alpha: 0.18),
                        context.scrim.withValues(alpha: 0.68),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 14.w,
                top: 14.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '${category.seriesIds.length} سلسلة',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      category.titleAr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
