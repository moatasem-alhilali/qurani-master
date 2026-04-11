import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';

class SmartOutreachAlarmAlertScreen extends StatefulWidget {
  const SmartOutreachAlarmAlertScreen({
    required this.scheduleId,
    super.key,
  });

  final int scheduleId;

  @override
  State<SmartOutreachAlarmAlertScreen> createState() =>
      _SmartOutreachAlarmAlertScreenState();
}

class _SmartOutreachAlarmAlertScreenState
    extends State<SmartOutreachAlarmAlertScreen> {
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  late DateTime _now;
  Timer? _clockTimer;

  String _scheduleTitle = 'مهمة التواصل';
  bool _isSnoozing = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _now = DateTime.now();
      });
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadScheduleTitle();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('HH:mm', 'ar').format(_now);
    final dateLabel = DateFormat('EEEE، d MMMM', 'ar').format(_now);
    const accentGold = Color(0xFFE4C98A);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              Color(0xFF0A3C33),
              Color(0xFF0F5144),
              Color(0xFF123A35),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -200.h,
              left: -200.w,
              child: Container(
                width: 500.w,
                height: 500.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE4C98A).withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -180.h,
              right: -130.w,
              child: Container(
                width: 380.w,
                height: 380.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        onPressed: _dismiss,
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم',
                      style: TextStyle(
                        color: accentGold,
                        fontSize: 24.sp,
                        fontFamily: 'uthmanic2',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        color: accentGold,
                        fontSize: 76.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        fontFamily: 'kufi',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'kufi',
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.mosque_rounded,
                            color: accentGold,
                            size: 40.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            _scheduleTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'kufi',
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'اجعل نيتك لله وابدأ مهمة التواصل بلطف ورحمة.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16.sp,
                              height: 1.6,
                              fontFamily: 'kufi',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '﴿ وَقُولُوا لِلنَّاسِ حُسْنًا ﴾',
                            style: TextStyle(
                              color: accentGold,
                              fontSize: 24.sp,
                              fontFamily: 'uthmanic2',
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'اجعل هذا التواصل بابًا للخير والرفق وصلة الرحم.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14.sp,
                              fontFamily: 'kufi',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: accentGold,
                          foregroundColor: const Color(0xFF0B3D33),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'kufi',
                          ),
                        ),
                        onPressed: _isSnoozing ? null : _startMission,
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('ابدأ المهمة الآن'),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: accentGold.withValues(alpha: 0.65),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'kufi',
                          ),
                        ),
                        onPressed: _isSnoozing ? null : _snoozeFiveMinutes,
                        icon: _isSnoozing
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.snooze),
                        label: const Text('تأخير 5 دقائق'),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'اللهم بارك في وقتنا وأعمالنا',
                      style: TextStyle(
                        color: accentGold.withValues(alpha: 0.95),
                        fontSize: 18.sp,
                        fontFamily: 'uthmanic2',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton.icon(
                      onPressed: _dismiss,
                      icon: const Icon(Icons.close, color: Colors.white70),
                      label: Text(
                        'إغلاق التنبيه',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'kufi',
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadScheduleTitle() async {
    final bundle = await _repository.getScheduleById(widget.scheduleId);
    if (!mounted || bundle == null) {
      return;
    }

    setState(() {
      _scheduleTitle = bundle.schedule.title;
    });
  }

  Future<void> _snoozeFiveMinutes() async {
    setState(() {
      _isSnoozing = true;
    });

    final scheduled =
        await _repository.scheduleSnoozeNotification(widget.scheduleId);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            scheduled
                ? 'تم تأجيل التنبيه 5 دقائق.'
                : 'تعذر تأجيل التنبيه حاليًا.',
          ),
        ),
      );

    if (scheduled) {
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _isSnoozing = false;
    });
  }

  void _startMission() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SmartOutreachExecutionScreen(
          scheduleId: widget.scheduleId,
          launchedFromNotification: true,
        ),
      ),
    );
  }

  void _dismiss() {
    Navigator.of(context).maybePop();
  }
}
