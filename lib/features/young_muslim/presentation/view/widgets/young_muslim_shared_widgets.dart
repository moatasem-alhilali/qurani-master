import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';

Color youngMuslimHex(String hex) {
  final sanitized = hex.replaceFirst('#', '');
  final buffer = StringBuffer();
  if (sanitized.length == 6) {
    buffer.write('ff');
  }
  buffer.write(sanitized);
  return Color(int.parse(buffer.toString(), radix: 16));
}

Color youngMuslimAccentColor(
  BuildContext context,
  String hex, {
  bool useSecondary = false,
  double blend = 0.32,
}) {
  final themeBase =
      useSecondary ? context.secondaryColor : context.primaryColor;
  return Color.lerp(themeBase, youngMuslimHex(hex), blend) ?? themeBase;
}

List<Color> youngMuslimGradientColors(
  BuildContext context, {
  required String startHex,
  required String endHex,
}) {
  return [
    youngMuslimAccentColor(context, startHex),
    youngMuslimAccentColor(
      context,
      endHex,
      useSecondary: true,
      blend: 0.38,
    ),
  ];
}

Color youngMuslimCompletionColor(BuildContext context) {
  return Color.lerp(context.secondaryColor, Colors.green, 0.42) ??
      context.secondaryColor;
}

Color youngMuslimRewardColor(BuildContext context) {
  return Color.lerp(context.secondaryColor, Colors.amber, 0.48) ??
      context.secondaryColor;
}

IconData youngMuslimAchievementIcon(String iconName) {
  switch (iconName) {
    case 'play_circle':
      return Icons.play_circle_rounded;
    case 'movie_filter':
      return Icons.movie_filter_rounded;
    case 'auto_awesome':
      return Icons.auto_awesome_rounded;
    case 'emoji_events':
      return Icons.emoji_events_rounded;
    case 'bookmark_added':
      return Icons.bookmark_added_rounded;
    default:
      return Icons.stars_rounded;
  }
}

BoxDecoration youngMuslimPanelDecoration(
  BuildContext context, {
  double radius = 28,
  Color? color,
}) {
  return BoxDecoration(
    color: color ?? context.cardColor,
    borderRadius: BorderRadius.circular(radius.r),
    border: Border.all(
      color: context.outlineVariant.withValues(alpha: 0.45),
    ),
    boxShadow: [
      BoxShadow(
        color: context.shadow.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

String youngMuslimDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return '${duration.inHours}س ${duration.inMinutes.remainder(60)}د';
  }
  return '${duration.inMinutes}د';
}

String youngMuslimRelative(DateTime? dateTime) {
  if (dateTime == null) {
    return 'لم يُشاهد بعد';
  }
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inMinutes < 1) {
    return 'الآن';
  }
  if (difference.inHours < 1) {
    return 'منذ ${difference.inMinutes} دقيقة';
  }
  if (difference.inDays < 1) {
    return 'منذ ${difference.inHours} ساعة';
  }
  if (difference.inDays < 7) {
    return 'منذ ${difference.inDays} يوم';
  }
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

PageRouteBuilder<T> youngMuslimPageRoute<T>({
  required Widget child,
}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, routeChild) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: Tween<double>(begin: 0.92, end: 1).animate(curvedAnimation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: routeChild,
        ),
      );
    },
  );
}

class YoungMuslimSectionHeader extends StatelessWidget {
  const YoungMuslimSectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class YoungMuslimMetricChip extends StatelessWidget {
  const YoungMuslimMetricChip({
    required this.label,
    required this.icon,
    this.color,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.primaryColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: resolvedColor == Colors.white
            ? Colors.white.withValues(alpha: 0.18)
            : resolvedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp, color: resolvedColor),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: resolvedColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class YoungMuslimEmptyState extends StatelessWidget {
  const YoungMuslimEmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: context.primaryContainer.withValues(alpha: 0.75),
            child: Icon(icon, color: context.primaryColor, size: 28.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.gray1,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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
