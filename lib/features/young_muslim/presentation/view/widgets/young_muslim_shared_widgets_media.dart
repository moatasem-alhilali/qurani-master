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
    final borderRadius = BorderRadius.circular(20.r);

    final banner = Container(
      decoration: youngMuslimPanelDecoration(context, radius: 20),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          height: height.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.first.withValues(alpha: 0.18),
                      context.scrim.withValues(alpha: 0.18),
                      context.scrim.withValues(alpha: 0.68),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
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
                      SizedBox(height: 10.h),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 5.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 10.5.sp,
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
      ),
    );

    if (onTap == null) {
      return banner;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
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
    final borderRadius = BorderRadius.circular(18.r);

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        decoration: youngMuslimPanelDecoration(context, radius: 18),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            height: height.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: category.bannerImage,
                    fit: BoxFit.cover,
                    color: context.scrim.withValues(alpha: 0.1),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
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
                  right: 12.w,
                  top: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      '${category.seriesIds.length} سلسلة',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        category.titleAr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 10.5.sp,
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
      ),
    );
  }
}
