import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';

/// مواقيت الرحلة كخطّ زمن رأسي: نقاط على سكّة واحدة من الإقلاع إلى الهبوط.
///
/// كانت المواقيت شريطًا أفقيًا من البطاقات، فلا يُقرأ منه ترتيب الرحلة ولا
/// أين أنت منها الآن. السكّة تقول الاثنين معًا: ما مضى ذهبيّ، والقادم باهت،
/// والمحطّة التالية وحدها هي التي ترتفع.
class FlightJourneyRail extends StatelessWidget {
  const FlightJourneyRail({
    required this.timeline,
    required this.onFocusPoint,
    super.key,
  });

  final FlightPrayerTimelineResult timeline;
  final void Function(LatLng center, double zoom) onFocusPoint;

  List<_JourneyStop> _stops() {
    final points = timeline.track.trackPoints;
    final stops = <_JourneyStop>[];

    if (points.isNotEmpty) {
      final first = points.first;
      stops.add(
        _JourneyStop(
          title: 'الإقلاع',
          subtitle: timeline.track.originLabel,
          whenUtc: timeline.track.departureUtc,
          latitude: first.latitude,
          longitude: first.longitude,
          icon: AppIcons.flight,
          isEdge: true,
        ),
      );
    }

    for (final event in timeline.prayerEvents) {
      stops.add(
        _JourneyStop(
          title: event.prayerNameAr,
          subtitle: 'بالتوقيت المحلي فوق موضع الطائرة',
          whenUtc: event.eventUtc,
          whenLocal: event.eventLocal,
          latitude: event.latitude,
          longitude: event.longitude,
          icon: AppIcons.prayerRug,
        ),
      );
    }

    if (points.isNotEmpty) {
      final last = points.last;
      stops.add(
        _JourneyStop(
          title: 'الهبوط',
          subtitle: timeline.track.destinationLabel,
          whenUtc: timeline.track.arrivalUtc,
          latitude: last.latitude,
          longitude: last.longitude,
          icon: AppIcons.mapPin,
          isEdge: true,
        ),
      );
    }

    return stops;
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final stops = _stops();

    if (stops.isEmpty) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now().toUtc();
    // المحطّة التالية: أوّل محطّة لم تمضِ بعد. لو انتهت الرحلة كلّها فلا
    // محطّة مرتفعة — ولا نرفع شيئًا بلا سبب.
    final nextIndex = stops.indexWhere((stop) => stop.whenUtc.isAfter(now));

    return Column(
      children: [
        for (var i = 0; i < stops.length; i++)
          _JourneyStopRow(
            stop: stops[i],
            isFirst: i == 0,
            isLast: i == stops.length - 1,
            passed: nextIndex < 0 || i < nextIndex,
            isNext: i == nextIndex,
            onTap: () => onFocusPoint(
              LatLng(stops[i].latitude, stops[i].longitude),
              7.2,
            ),
          ),
        SizedBox(height: 4.h),
        Text(
          'اضغط على أي محطّة لترى موضعها على الخريطة',
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.7),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

/// محطّة واحدة على سكّة الرحلة.
class _JourneyStop {
  const _JourneyStop({
    required this.title,
    required this.subtitle,
    required this.whenUtc,
    required this.latitude,
    required this.longitude,
    required this.icon,
    this.whenLocal,
    this.isEdge = false,
  });

  final String title;
  final String subtitle;
  final DateTime whenUtc;

  /// التوقيت المحلي لموضع الطائرة — لا يتوفّر لطرفَي الرحلة.
  final DateTime? whenLocal;

  final double latitude;
  final double longitude;
  final HugeIconData icon;

  /// الإقلاع والهبوط: طرفا السكّة، لا موقيت صلاة.
  final bool isEdge;

  String get primaryTime => DateFormat('HH:mm').format(whenLocal ?? whenUtc);

  String get utcTime => DateFormat('HH:mm').format(whenUtc);
}

class _JourneyStopRow extends StatelessWidget {
  const _JourneyStopRow({
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.passed,
    required this.isNext,
    required this.onTap,
  });

  final _JourneyStop stop;
  final bool isFirst;
  final bool isLast;
  final bool passed;
  final bool isNext;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 22.w,
              child: CustomPaint(
                painter: _JourneyRailPainter(
                  track: skin.hairline,
                  isFirst: isFirst,
                  isLast: isLast,
                  passed: passed,
                  isNext: isNext,
                ),
              ),
            ),
            Expanded(
              child: isNext
                  ? _RaisedStopBody(stop: stop, skin: skin)
                  : _PlainStopBody(stop: stop, isLast: isLast, skin: skin),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlainStopBody extends StatelessWidget {
  const _PlainStopBody({
    required this.stop,
    required this.isLast,
    required this.skin,
  });

  final _JourneyStop stop;
  final bool isLast;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.fromLTRB(4.w, 10.h, 2.w, 10.h),
      child: Row(
        children: [
          AppIcon(stop.icon, color: skin.accent, size: 15.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stop.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink.withValues(alpha: 0.88),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                Text(
                  stop.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          _StopTime(primary: stop.primaryTime, utc: stop.utcTime, skin: skin),
        ],
      ),
    );
  }
}

/// المحطّة التالية: العنصر الوحيد المرتفع في هذه الشاشة.
class _RaisedStopBody extends StatelessWidget {
  const _RaisedStopBody({required this.stop, required this.skin});

  final _JourneyStop stop;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
      ),
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(stop.icon, color: skin.accent, size: 16.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  stop.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: skin.accent,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  stop.isEdge ? 'قادم' : 'التالية',
                  style: TextStyle(
                    color: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Text(
                  stop.primaryTime,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '${stop.subtitle} · جرينتش ${stop.utcTime}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopTime extends StatelessWidget {
  const _StopTime({
    required this.primary,
    required this.utc,
    required this.skin,
  });

  final String primary;
  final String utc;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            primary,
            style: TextStyle(
              color: skin.ink.withValues(alpha: 0.88),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.2,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
          Text(
            'UTC $utc',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.7),
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// يرسم سكّة الرحلة: الخطّ العمودي ونقطة هذه المحطّة عليه.
class _JourneyRailPainter extends CustomPainter {
  const _JourneyRailPainter({
    required this.track,
    required this.isFirst,
    required this.isLast,
    required this.passed,
    required this.isNext,
  });

  final Color track;
  final bool isFirst;
  final bool isLast;
  final bool passed;
  final bool isNext;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.52;
    final cy = size.height * 0.5;
    const gap = 7.0;

    final trackPaint = Paint()
      ..color = track
      ..strokeWidth = 2;
    final livePaint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2;

    if (!isFirst) {
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, cy - gap),
        passed || isNext ? livePaint : trackPaint,
      );
    }

    if (!isLast) {
      canvas.drawLine(
        Offset(cx, cy + gap),
        Offset(cx, size.height),
        passed ? livePaint : trackPaint,
      );
    }

    if (isNext) {
      // محطّة «التالية»: هالة ثم قرص ذهبي مصمت — أوضح علامة في السكّة.
      canvas
        ..drawCircle(
          Offset(cx, cy),
          9,
          Paint()..color = AppColors.gold.withValues(alpha: 0.16),
        )
        ..drawCircle(Offset(cx, cy), 5, Paint()..color = AppColors.gold);
      return;
    }

    canvas.drawCircle(
      Offset(cx, cy),
      3.4,
      Paint()..color = passed ? AppColors.gold : track,
    );
  }

  @override
  bool shouldRepaint(covariant _JourneyRailPainter oldDelegate) =>
      oldDelegate.passed != passed ||
      oldDelegate.isNext != isNext ||
      oldDelegate.track != track;
}
