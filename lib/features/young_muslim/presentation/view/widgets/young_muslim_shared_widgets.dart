import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';

part 'young_muslim_shared_widgets_basics.dart';
part 'young_muslim_shared_widgets_media.dart';
part 'young_muslim_shared_widgets_video.dart';

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
  double radius = 16,
  Color? color,
  bool useGradient = false,
}) {
  final accent = Theme.of(context).primaryColor;
  return BoxDecoration(
    color: useGradient ? null : (color ?? context.cardColor),
    borderRadius: BorderRadius.circular(radius.r),
    gradient: useGradient
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.surfaceColor,
              context.surfaceVariant.withOpacity(0.4),
            ],
          )
        : null,
    border: Border.all(
      color: accent.withOpacity(0.12),
    ),
    boxShadow: [
      BoxShadow(
        color: context.shadow.withOpacity(0.04),
        blurRadius: 12.r,
        offset: Offset(0, 4.h),
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

double youngMuslimCarouselViewportFraction(
  BuildContext context, {
  required double itemWidth,
  double horizontalPadding = 0,
  double minFraction = 0.24,
}) {
  final viewportWidth = MediaQuery.sizeOf(context).width - horizontalPadding;
  if (viewportWidth <= 0) {
    return 1;
  }
  return (itemWidth / viewportWidth).clamp(minFraction, 1.0);
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
