part of 'young_muslim_shared_widgets.dart';

class YoungMuslimVideoCard extends StatelessWidget {
  const YoungMuslimVideoCard({
    required this.video,
    required this.seriesTitle,
    required this.onTap,
    this.onFavoriteToggle,
    this.onWatchLaterToggle,
    this.compact = false,
    this.fillWidth = false,
    super.key,
  });

  final YoungMuslimVideoEntity video;
  final String seriesTitle;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onWatchLaterToggle;
  final bool compact;
  final bool fillWidth;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 158.w : 210.w;
    final cardWidth = fillWidth ? double.infinity : width;
    final imageHeight = compact ? 98.h : 126.h;
    final progress = video.progressPercent.clamp(0, 1);
    final borderRadius = BorderRadius.circular(18.r);

    return Container(
      width: cardWidth,
      decoration: youngMuslimPanelDecoration(context, radius: 18),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    width: cardWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.scrim.withValues(alpha: 0.02),
                            context.scrim.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: Row(
                      children: [
                        if (onFavoriteToggle != null)
                          _IconCircleButton(
                            onTap: onFavoriteToggle!,
                            icon: video.isFavorite
                                ? AppIcons.heartFilled
                                : AppIcons.heart,
                            active: video.isFavorite,
                          ),
                        if (onWatchLaterToggle != null) ...[
                          SizedBox(width: 8.w),
                          _IconCircleButton(
                            onTap: onWatchLaterToggle!,
                            icon: video.isWatchLater
                                ? AppIcons.bookmark
                                : AppIcons.bookmarkAdd,
                            active: video.isWatchLater,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10.w,
                    top: 10.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.scrim.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        youngMuslimDuration(video.durationSeconds),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12.w,
                    bottom: 12.h,
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: context.surfaceColor.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppIcon(
                        AppIcons.play,
                        size: 16.sp,
                        color: context.primaryColor,
                        strokeWidth: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w900,
                        color: context.onSurfaceColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      seriesTitle,
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: context.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          value: progress.toDouble(),
                          minHeight: 5.h,
                          backgroundColor:
                              context.outline.withValues(alpha: 0.15),
                          color: video.isCompleted
                              ? youngMuslimCompletionColor(context)
                              : context.primaryColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            video.isCompleted
                                ? 'مكتمل'
                                : video.hasProgress
                                    ? 'تقدّم ${(progress * 100).round()}%'
                                    : 'جاهز للمشاهدة',
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w800,
                              color: video.isCompleted
                                  ? youngMuslimCompletionColor(context)
                                  : context.primaryColor,
                            ),
                          ),
                        ),
                        if (video.episodeNumber != null)
                          Text(
                            'حلقة ${video.episodeNumber}',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: context.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
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

class YoungMuslimVideoCarousel extends StatelessWidget {
  const YoungMuslimVideoCarousel({
    required this.videos,
    required this.seriesTitleBuilder,
    required this.onTap,
    this.onFavoriteToggle,
    this.onWatchLaterToggle,
    this.compact = false,
    super.key,
  });

  final List<YoungMuslimVideoEntity> videos;
  final String Function(YoungMuslimVideoEntity video) seriesTitleBuilder;
  final ValueChanged<String> onTap;
  final ValueChanged<String>? onFavoriteToggle;
  final ValueChanged<String>? onWatchLaterToggle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardWidth = compact ? 158.w : 210.w;
    final itemPadding = 6.w;

    return CarouselSlider.builder(
      itemCount: videos.length,
      options: CarouselOptions(
        height: compact ? 226.h : 278.h,
        viewportFraction: youngMuslimCarouselViewportFraction(
          context,
          itemWidth: cardWidth + (itemPadding * 2),
          horizontalPadding: 36.w,
          minFraction: compact ? 0.2 : 0.24,
        ),
        enableInfiniteScroll: videos.length > 1,
      ),
      itemBuilder: (context, index, realIndex) {
        final video = videos[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: itemPadding),
          child: YoungMuslimVideoCard(
            video: video,
            seriesTitle: seriesTitleBuilder(video),
            compact: compact,
            onTap: () => onTap(video.id),
            onFavoriteToggle: onFavoriteToggle == null
                ? null
                : () => onFavoriteToggle!(video.id),
            onWatchLaterToggle: onWatchLaterToggle == null
                ? null
                : () => onWatchLaterToggle!(video.id),
          ),
        );
      },
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.onTap,
    required this.icon,
    required this.active,
  });

  final VoidCallback onTap;
  final HugeIconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: active
              ? context.primaryColor
              : context.surfaceColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: active
                ? Colors.white.withValues(alpha: 0.2)
                : context.outline.withValues(alpha: 0.2),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: context.primaryColor.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AppIcon(
          icon,
          size: 13.sp,
          color: active ? context.onPrimaryColor : context.onSurfaceVariant,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}
