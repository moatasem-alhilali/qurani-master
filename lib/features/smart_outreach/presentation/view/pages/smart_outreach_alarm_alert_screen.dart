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

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF090C2B),
              Color(0xFF121B45),
              Color(0xFF1E1C4E),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -180.h,
              right: -180.w,
              child: Container(
                width: 460.w,
                height: 460.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
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
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 70.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      _scheduleTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'حان وقت التنفيذ. ابدأ المهمة الآن أو قم بتأجيلها لخمس دقائق.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        width: 92.w,
                        height: 92.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 4,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: 48.sp,
                          color: const Color(0xFF6468E8),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF131B47),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
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
                          side: const BorderSide(color: Colors.white70),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
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
