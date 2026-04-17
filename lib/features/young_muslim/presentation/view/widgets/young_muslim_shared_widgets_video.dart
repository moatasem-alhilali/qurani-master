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
    final borderRadius = BorderRadius.circular(26.r);

    return Container(
      width: cardWidth,
      decoration: youngMuslimPanelDecoration(context, radius: 26, useGradient: true),
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
                    bottom: -15.h,
                    left: -15.w,
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
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
                          fontSize: 10.sp,
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
                        color: context.surfaceColor.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: context.onSurfaceColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      seriesTitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: context.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          value: progress.toDouble(),
                          minHeight: 7.h,
                          backgroundColor: context.outline.withValues(alpha: 0.15),
                          color: video.isCompleted
                              ? youngMuslimCompletionColor(context)
                              : context.primaryColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ],
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
                            style: TextStyle(
                              fontSize: 11.sp,
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
                              fontSize: 10.sp,
                              color: context.onSurfaceVariant.withValues(alpha: 0.6),
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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 38.w,
        height: 38.w,
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
          boxShadow: active ? [
            BoxShadow(
              color: context.primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: active ? context.onPrimaryColor : context.onSurfaceVariant,
        ),
      ),
    );
  }
}
