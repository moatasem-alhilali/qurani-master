import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'young_muslim_shared_widgets_basics.dart';
part 'young_muslim_shared_widgets_media.dart';
part 'young_muslim_shared_widgets_video.dart';

/// أيقونة الإنجاز حسب اسمها القادم من البيانات.
HugeIconData youngMuslimAchievementIcon(String iconName) {
  switch (iconName) {
    case 'play_circle':
      return AppIcons.play;
    case 'movie_filter':
      return AppIcons.play;
    case 'auto_awesome':
      return AppIcons.heart;
    case 'emoji_events':
      return AppIcons.target;
    case 'bookmark_added':
      return AppIcons.bookmark;
    default:
      return AppIcons.heart;
  }
}

/// مدّة الحلقة بصيغة عربية قصيرة.
String youngMuslimDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  if (duration.inHours > 0) {
    return L10nService.current.youngMuslimDurationHoursMinutes(
      duration.inHours,
      duration.inMinutes.remainder(60),
    );
  }
  return L10nService.current.youngMuslimDurationMinutes(duration.inMinutes);
}

/// متى شوهدت الحلقة آخر مرّة، بصيغة يقرأها الطفل.
String youngMuslimRelative(DateTime? dateTime) {
  final l10n = L10nService.current;
  if (dateTime == null) {
    return l10n.youngMuslimNotWatchedYet;
  }
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inMinutes < 1) {
    return l10n.youngMuslimJustNow;
  }
  if (difference.inHours < 1) {
    return l10n.youngMuslimMinutesAgo(difference.inMinutes);
  }
  if (difference.inDays < 1) {
    return l10n.youngMuslimHoursAgo(difference.inHours);
  }
  if (difference.inDays < 7) {
    return l10n.youngMuslimDaysAgo(difference.inDays);
  }
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

/// سطر حالة الحلقة: مكتملة، أو نسبة التقدّم، أو أنّها لم تبدأ.
String youngMuslimVideoStatus(YoungMuslimVideoEntity video) {
  final l10n = L10nService.current;
  if (video.isCompleted) {
    return l10n.youngMuslimWatched;
  }
  if (video.hasProgress) {
    return l10n.youngMuslimProgressPercent(
      (video.progressPercent * 100).round(),
    );
  }
  return l10n.youngMuslimReadyToWatch;
}

/// عنوان صفّ: المقاس الأساسي في كل قوائم القسم.
///
/// قسم الأطفال يسمح بزيادة طفيفة على `12.5.sp` حين يكون العنوان هو بطل
/// الصفّ، لكن من عائلة المقاسات نفسها لا من لوحة ثانية.
TextStyle youngMuslimRowTitle(AppSkin skin, {double? size}) {
  return TextStyle(
    color: skin.ink,
    fontSize: size ?? 12.5.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
}

/// وصف ثانوي تحت عنوان الصفّ.
TextStyle youngMuslimRowSubtitle(AppSkin skin, {double? size}) {
  return TextStyle(
    color: skin.inkSoft.withValues(alpha: 0.78),
    fontSize: size ?? 9.5.sp,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );
}

/// أرقام بعرض ثابت حتى لا ترقص الأرقام عند تغيّرها.
TextStyle youngMuslimNumber(
  AppSkin skin, {
  double? size,
  Color? color,
  FontWeight weight = FontWeight.w600,
}) {
  return TextStyle(
    color: color ?? skin.accent,
    fontSize: size ?? 12.5.sp,
    fontWeight: weight,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// [screenName] إلزامي: كل الشاشات هنا تُمرَّر ملفوفة بـ
/// `YoungMuslimRouteScope.inherit`، فاسم صنف [child] لا يدلّ على الشاشة، و
/// `FirebaseAnalyticsObserver` لا يسجّل مسارًا بلا اسم.
PageRouteBuilder<T> youngMuslimPageRoute<T>({
  required Widget child,
  required String screenName,
}) {
  return PageRouteBuilder<T>(
    settings: RouteSettings(name: screenName),
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
