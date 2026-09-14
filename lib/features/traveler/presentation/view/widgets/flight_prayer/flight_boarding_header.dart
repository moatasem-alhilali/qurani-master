import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';

/// رأس الرحلة: بطاقة صعود تقول أين أنت منها وما الصلاة القادمة على متنها.
///
/// الصفحة كانت تفتح على خريطة بارتفاع ١٨٦ نقطة — حتى قبل إدخال رقم رحلة —
/// فيُدفع الجواب (خطّ المواقيت) تحت الطيّة. والمسار على شريط بهذا الارتفاع
/// لا يُقرأ منه شيء أصلًا.
///
/// هنا يأتي أوّلًا ما يُسأل عنه فعلًا: كم مضى من الرحلة، وما أقرب صلاة
/// ستدركك في الجوّ، وبأي توقيت محلّي — وهي الحسبة الصعبة التي يحسبها
/// التطبيق ثم يخفيها.
class FlightBoardingHeader extends StatefulWidget {
  const FlightBoardingHeader({required this.timeline, super.key});

  final FlightPrayerTimelineResult timeline;

  @override
  State<FlightBoardingHeader> createState() => _FlightBoardingHeaderState();
}

class _FlightBoardingHeaderState extends State<FlightBoardingHeader> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // دقيقة واحدة تكفي: العدّ بالدقائق لا بالثواني، وتحديثه كل ثانية إنفاق
    // بلا فرق يُرى.
    _ticker = Timer.periodic(
      const Duration(minutes: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// الصلاة القادمة على متن الرحلة، أو `null` إن مضت كلّها.
  FlightPrayerEvent? _nextAboard(DateTime nowUtc) {
    for (final event in widget.timeline.prayerEvents) {
      if (event.eventUtc.isAfter(nowUtc)) return event;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final track = widget.timeline.track;
    final nowUtc = DateTime.now().toUtc();

    final total = track.arrivalUtc.difference(track.departureUtc);
    final elapsed = nowUtc.difference(track.departureUtc);
    final progress = total.inSeconds <= 0
        ? 0.0
        : (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);

    final hasDeparted = progress > 0;
    final hasLanded = progress >= 1;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 13.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: skin.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppIcon(AppIcons.flight, color: skin.accent, size: 16.sp),
              SizedBox(width: 7.w),
              Text(
                track.flightNumber,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                track.isLiveSource ? 'مسار مباشر' : track.sourceLabel,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.6),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Endpoint(
                label: track.originLabel,
                time: track.departureUtc,
                caption: 'الإقلاع',
                alignment: CrossAxisAlignment.start,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: _ProgressTrack(progress: progress),
                ),
              ),
              _Endpoint(
                label: track.destinationLabel,
                time: track.arrivalUtc,
                caption: 'الهبوط',
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, thickness: 1, color: skin.hairline),
          SizedBox(height: 10.h),
          _NextAboard(
            event: _nextAboard(nowUtc),
            nowUtc: nowUtc,
            hasDeparted: hasDeparted,
            hasLanded: hasLanded,
            total: widget.timeline.prayerEvents.length,
          ),
        ],
      ),
    );
  }
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({
    required this.label,
    required this.time,
    required this.caption,
    required this.alignment,
  });

  final String label;
  final DateTime time;
  final String caption;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: 78.w,
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('HH:mm').format(time.toLocal()),
            style: TextStyle(
              color: skin.ink,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignment == CrossAxisAlignment.end
                ? TextAlign.end
                : TextAlign.start,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.85),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          Text(
            caption,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.55),
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// مسار الرحلة وطائرةٌ عليه في موضع الآن.
class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      height: 22.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // في العربية يُقرأ المشهد من اليمين لليسار، فالمنشأ يمينًا.
          final travelled = width * progress;

          return Stack(
            alignment: Alignment.centerRight,
            children: [
              Align(
                child: Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 2.h,
                  width: travelled,
                  decoration: BoxDecoration(
                    color: skin.accent,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Positioned(
                right: (travelled - 8).clamp(0.0, width - 16),
                child: Transform.rotate(
                  // الأيقونة تشير يمينًا أصلًا، والسير يسارًا.
                  angle: 3.14159,
                  child: AppIcon(
                    AppIcons.flight,
                    color: skin.accent,
                    size: 15.sp,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// الصلاة القادمة وأنت في الجوّ.
class _NextAboard extends StatelessWidget {
  const _NextAboard({
    required this.event,
    required this.nowUtc,
    required this.hasDeparted,
    required this.hasLanded,
    required this.total,
  });

  final FlightPrayerEvent? event;
  final DateTime nowUtc;
  final bool hasDeparted;
  final bool hasLanded;
  final int total;

  /// «+٣:٣٠» — إزاحة التوقيت فوق موضع الطائرة.
  String _offsetLabel(int minutes) {
    final sign = minutes < 0 ? '-' : '+';
    final abs = minutes.abs();
    final hours = abs ~/ 60;
    final rest = abs % 60;
    return rest == 0
        ? '$sign$hours'
        : '$sign$hours:${rest.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final next = event;

    if (next == null) {
      return Text(
        hasLanded
            ? 'انتهت الرحلة — لم تبقَ مواقيت على متنها.'
            : total == 0
                ? 'لم تقع أي صلاة ضمن مدّة هذه الرحلة.'
                : 'مضت كل مواقيت هذه الرحلة.',
        style: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.75),
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      );
    }

    final remaining = next.eventUtc.difference(nowUtc);
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final countdown =
        hours > 0 ? 'بعد $hours س و$minutes د' : 'بعد $minutes دقيقة';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(AppIcons.prayerRug, color: skin.accent, size: 15.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hasDeparted
                    ? '${next.prayerNameAr} على متن الرحلة — $countdown'
                    : 'أوّل صلاة على متن الرحلة: ${next.prayerNameAr}',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${DateFormat('HH:mm').format(next.eventLocal)} '
                'بتوقيت موضع الطائرة (${_offsetLabel(next.utcOffsetMinutes)})',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
