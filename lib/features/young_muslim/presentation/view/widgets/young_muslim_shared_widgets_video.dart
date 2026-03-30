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
    final width = compact ? 170.w : 220.w;
    final cardWidth = fillWidth ? double.infinity : width;
    final imageHeight = compact ? 110.h : 138.h;
    final progress = video.progressPercent.clamp(0, 1);
    return SizedBox(
      width: cardWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26.r),
        child: Ink(
          decoration: youngMuslimPanelDecoration(context, radius: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
                child: Stack(
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
                              context.scrim.withValues(alpha: 0.04),
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
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              active: video.isFavorite,
                            ),
                          if (onWatchLaterToggle != null) ...[
                            SizedBox(width: 8.w),
                            _IconCircleButton(
                              onTap: onWatchLaterToggle!,
                              icon: video.isWatchLater
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
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
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.scrim.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          youngMuslimDuration(video.durationSeconds),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12.w,
                      bottom: 12.h,
                      child: Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color: context.cardColor.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 28.sp,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      seriesTitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.gray1,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    LinearProgressIndicator(
                      value: progress.toDouble(),
                      minHeight: 7.h,
                      backgroundColor: context.outline.withValues(alpha: 0.25),
                      color: video.isCompleted
                          ? youngMuslimCompletionColor(context)
                          : context.primaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            video.isCompleted
                                ? 'مكتمل'
                                : video.hasProgress
                                    ? 'تقدّم ${(progress * 100).round()}%'
                                    : 'جاهز للمشاهدة',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: video.isCompleted
                                      ? youngMuslimCompletionColor(context)
                                      : context.primaryColor,
                                ),
                          ),
                        ),
                        if (video.episodeNumber != null)
                          Text(
                            'حلقة ${video.episodeNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: context.gray1,
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

    final cardWidth = compact ? 170.w : 220.w;
    final itemPadding = 6.w;

    return CarouselSlider.builder(
      itemCount: videos.length,
      options: CarouselOptions(
        height: compact ? 252.h : 305.h,
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
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: active
              ? context.primaryColor.withValues(alpha: 0.95)
              : context.scaffoldBackgroundColor.withValues(alpha: 0.26),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: context.onPrimaryColor,
        ),
      ),
    );
  }
}
