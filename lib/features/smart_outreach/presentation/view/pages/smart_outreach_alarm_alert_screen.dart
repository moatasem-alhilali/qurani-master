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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF0B3D34),
              Color(0xFF0E4C3F),
              Color(0xFF112D29),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = (constraints.maxHeight / 760).clamp(0.76, 1.0);

              double h(double value) => value * scale;
              double fs(double value) => (value * scale).sp;

              return Padding(
                padding: EdgeInsets.fromLTRB(14.w, h(8), 14.w, h(10)),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: _dismiss,
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ),
                    Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم',
                      style: TextStyle(
                        color: accentGold,
                        fontSize: fs(19),
                        fontFamily: 'uthmanic2',
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: h(9)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: h(10),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.19),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              timeLabel,
                              maxLines: 1,
                              style: TextStyle(
                                color: accentGold,
                                fontSize: fs(58),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'kufi',
                                height: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: h(3)),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: fs(14),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'kufi',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h(9)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: h(10),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.23),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.mosque_rounded,
                            color: accentGold,
                            size: fs(26),
                          ),
                          SizedBox(height: h(5)),
                          Text(
                            _scheduleTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fs(20),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'kufi',
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: h(5)),
                          Text(
                            'ابدأ مهمتك بنية صالحة ورفق بالكلمة.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: fs(12.5),
                              height: 1.5,
                              fontFamily: 'kufi',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h(8)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: h(8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '﴿ وَقُولُوا لِلنَّاسِ حُسْنًا ﴾',
                        style: TextStyle(
                          color: accentGold,
                          fontSize: fs(18),
                          fontFamily: 'uthmanic2',
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: accentGold,
                          foregroundColor: const Color(0xFF0D3F36),
                          padding: EdgeInsets.symmetric(vertical: h(11)),
                          textStyle: TextStyle(
                            fontSize: fs(14),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'kufi',
                          ),
                        ),
                        onPressed: _isSnoozing ? null : _startMission,
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('ابدأ المهمة الآن'),
                      ),
                    ),
                    SizedBox(height: h(7)),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: accentGold.withValues(alpha: 0.7),
                          ),
                          padding: EdgeInsets.symmetric(vertical: h(10)),
                          textStyle: TextStyle(
                            fontSize: fs(13),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'kufi',
                          ),
                        ),
                        onPressed: _isSnoozing ? null : _snoozeFiveMinutes,
                        icon: _isSnoozing
                            ? SizedBox(
                                width: 14.w,
                                height: 14.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.snooze),
                        label: const Text('تأخير 5 دقائق'),
                      ),
                    ),
                    SizedBox(height: h(6)),
                    Text(
                      'اللهم بارك في وقتنا',
                      style: TextStyle(
                        color: accentGold,
                        fontSize: fs(14),
                        fontFamily: 'uthmanic2',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
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
