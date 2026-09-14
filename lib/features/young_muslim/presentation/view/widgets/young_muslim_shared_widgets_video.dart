part of 'young_muslim_shared_widgets.dart';

/// زرّ تعليم صغير (مفضّلة أو «لاحقًا»).
///
/// المفعّل يمتلئ ذهبًا ويهتزّ الجهاز اهتزازة خفيفة، فيُحسّ الفعل لا يُرى فقط.
class YoungMuslimToggleButton extends StatelessWidget {
  const YoungMuslimToggleButton({
    required this.icon,
    required this.active,
    required this.onTap,
    required this.semanticLabel,
    this.size,
    super.key,
  });

  final HugeIconData icon;
  final bool active;
  final VoidCallback onTap;
  final String semanticLabel;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final dimension = size ?? 28.w;

    return Semantics(
      button: true,
      selected: active,
      label: semanticLabel,
      child: InkWell(
        onTap: () {
          if (active) {
            HapticFeedback.selectionClick();
          } else {
            HapticFeedback.mediumImpact();
          }
          onTap();
        },
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: dimension,
          height: dimension,
          decoration: BoxDecoration(
            color: active ? AppColors.gold : skin.iconChip,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: AppIcon(
              icon,
              color: active
                  ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                  : skin.accent,
              size: dimension * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// صفّ حلقة بعرض الصفحة: صورة، عنوان، حالة، ثم أزرار التعليم.
class YoungMuslimVideoRow extends StatelessWidget {
  const YoungMuslimVideoRow({
    required this.video,
    required this.seriesTitle,
    required this.onTap,
    this.onFavoriteToggle,
    this.onWatchLaterToggle,
    this.isLast = false,
    this.isCurrent = false,
    super.key,
  });

  final YoungMuslimVideoEntity video;
  final String seriesTitle;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onWatchLaterToggle;
  final bool isLast;

  /// الحلقة الجارية داخل المشغّل: هي وحدها من يرتفع في تلك الشاشة.
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final episode = video.episodeNumber;
    final meta = episode == null
        ? '$seriesTitle · ${youngMuslimDuration(video.durationSeconds)}'
        : 'حلقة $episode · ${youngMuslimDuration(video.durationSeconds)}';

    final row = Row(
      children: [
        YoungMuslimThumb(
          imageUrl: video.thumbnailUrl,
          width: isCurrent ? 74.w : 68.w,
          height: isCurrent ? 46.w : 42.w,
          radius: 12.r,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: youngMuslimRowTitle(
                  skin,
                  size: isCurrent ? 13.5.sp : 12.5.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: youngMuslimRowSubtitle(skin),
              ),
              if (video.hasProgress || video.isCompleted) ...[
                SizedBox(height: 6.h),
                YoungMuslimProgressBar(
                  value: video.isCompleted ? 1 : video.progressPercent,
                  height: 3.h,
                ),
                SizedBox(height: 4.h),
                Text(
                  youngMuslimVideoStatus(video),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimNumber(skin, size: 9.5.sp),
                ),
              ],
            ],
          ),
        ),
        if (onFavoriteToggle != null) ...[
          SizedBox(width: 8.w),
          YoungMuslimToggleButton(
            icon: video.isFavorite ? AppIcons.heartFilled : AppIcons.heart,
            active: video.isFavorite,
            semanticLabel: 'المفضلة',
            onTap: onFavoriteToggle!,
          ),
        ],
        if (onWatchLaterToggle != null) ...[
          SizedBox(width: 6.w),
          YoungMuslimToggleButton(
            icon: video.isWatchLater ? AppIcons.bookmark : AppIcons.bookmarkAdd,
            active: video.isWatchLater,
            semanticLabel: 'سأشاهد لاحقًا',
            onTap: onWatchLaterToggle!,
          ),
        ],
        if (onFavoriteToggle == null && onWatchLaterToggle == null) ...[
          SizedBox(width: 8.w),
          AppIcon(AppIcons.play, color: skin.accent, size: 15.sp),
        ],
      ],
    );

    if (isCurrent) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: skin.raised,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: skin.raisedBorder),
              boxShadow: skin.raisedShadow,
            ),
            child: row,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: row,
      ),
    );
  }
}

/// ملصق حلقة داخل شريط أفقي: صورة أكبر قليلًا يليها سطرا العنوان.
class YoungMuslimVideoPoster extends StatelessWidget {
  const YoungMuslimVideoPoster({
    required this.video,
    required this.seriesTitle,
    required this.onTap,
    this.onFavoriteToggle,
    this.onWatchLaterToggle,
    this.width,
    super.key,
  });

  final YoungMuslimVideoEntity video;
  final String seriesTitle;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onWatchLaterToggle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final posterWidth = width ?? 132.w;
    final showProgress = video.hasProgress || video.isCompleted;

    return SizedBox(
      width: posterWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                YoungMuslimThumb(
                  imageUrl: video.thumbnailUrl,
                  width: posterWidth,
                  height: posterWidth * 0.58,
                  radius: 14.r,
                ),
                PositionedDirectional(
                  top: 5.h,
                  start: 5.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onFavoriteToggle != null)
                        YoungMuslimToggleButton(
                          icon: video.isFavorite
                              ? AppIcons.heartFilled
                              : AppIcons.heart,
                          active: video.isFavorite,
                          semanticLabel: 'المفضلة',
                          size: 24.w,
                          onTap: onFavoriteToggle!,
                        ),
                      if (onWatchLaterToggle != null) ...[
                        SizedBox(width: 5.w),
                        YoungMuslimToggleButton(
                          icon: video.isWatchLater
                              ? AppIcons.bookmark
                              : AppIcons.bookmarkAdd,
                          active: video.isWatchLater,
                          semanticLabel: 'سأشاهد لاحقًا',
                          size: 24.w,
                          onTap: onWatchLaterToggle!,
                        ),
                      ],
                    ],
                  ),
                ),
                PositionedDirectional(
                  bottom: 5.h,
                  end: 5.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: skin.ground,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      youngMuslimDuration(video.durationSeconds),
                      style: youngMuslimNumber(
                        skin,
                        size: 9.sp,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h),
            Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: youngMuslimRowTitle(skin, size: 11.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              seriesTitle.isEmpty ? youngMuslimVideoStatus(video) : seriesTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: youngMuslimRowSubtitle(skin, size: 9.sp),
            ),
            if (showProgress) ...[
              SizedBox(height: 6.h),
              YoungMuslimProgressBar(
                value: video.isCompleted ? 1 : video.progressPercent,
                height: 3.h,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// شريط أفقي من ملصقات الحلقات.
///
/// حلّ محلّ الكاروسيل اللانهائي: التمرير هنا طبيعي ولا يتحرّك وحده، ولا
/// يغيب أي عنصر كان ظاهرًا قبلُ.
class YoungMuslimVideoRail extends StatelessWidget {
  const YoungMuslimVideoRail({
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

    final posterWidth = compact ? 116.w : 132.w;

    return SizedBox(
      // الارتفاع مشتقّ من عرض الملصق لا من ارتفاع الشاشة: الصورة وأحجام
      // الخطّ تتبع نسبة العرض، فيبقى الشريط متّسعًا لسطري العنوان وشريط
      // التقدّم على الأجهزة العريضة والطويلة معًا.
      height: posterWidth * (compact ? 1.46 : 1.36),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: videos.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final video = videos[index];
          return YoungMuslimVideoPoster(
            video: video,
            seriesTitle: seriesTitleBuilder(video),
            width: posterWidth,
            onTap: () => onTap(video.id),
            onFavoriteToggle: onFavoriteToggle == null
                ? null
                : () => onFavoriteToggle!(video.id),
            onWatchLaterToggle: onWatchLaterToggle == null
                ? null
                : () => onWatchLaterToggle!(video.id),
          );
        },
      ),
    );
  }
}

/// العنصر الوحيد المرتفع في شاشة الأطفال: الحلقة التي توقّف عندها الطفل.
class YoungMuslimResumeTile extends StatelessWidget {
  const YoungMuslimResumeTile({
    required this.video,
    required this.seriesTitle,
    required this.onTap,
    super.key,
  });

  final YoungMuslimVideoEntity video;
  final String seriesTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final percent = (video.progressPercent * 100).round();
    final remaining = video.durationSeconds - video.positionSeconds;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: skin.raised,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: skin.raisedBorder),
            boxShadow: skin.raisedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  YoungMuslimThumb(
                    imageUrl: video.thumbnailUrl,
                    width: 78.w,
                    height: 48.w,
                    radius: 12.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تابع من حيث توقفت',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.accent,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.ink,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        if (seriesTitle.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            seriesTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: youngMuslimRowSubtitle(skin),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const YoungMuslimIconChip(icon: AppIcons.play, active: true),
                ],
              ),
              SizedBox(height: 10.h),
              YoungMuslimProgressBar(value: video.progressPercent),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Text(
                    '$percent٪',
                    style: youngMuslimNumber(
                      skin,
                      size: 15.sp,
                      weight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    remaining > 0
                        ? 'يتبقّى ${youngMuslimDuration(remaining)}'
                        : 'اقتربت النهاية',
                    style: youngMuslimRowSubtitle(skin),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
