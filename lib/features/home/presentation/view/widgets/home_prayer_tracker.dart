import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/data/prayer_tracker_store.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// متتبّع الصلوات الخمس لليوم.
///
/// التعليم ليس تبديل لون: الذهب يرتفع داخل الزرّ، وعلامة صحّ ترتسم بجانب
/// الاسم، ويهتزّ الجهاز اهتزازة خفيفة. وعند اكتمال الخمس يمرّ وميض ذهبي
/// على الصفّ كلّه وتتقدّم سلسلة الأيام — هذا ما يجعل الفعل يستحقّ التكرار.
class HomePrayerTracker extends StatefulWidget {
  const HomePrayerTracker({super.key});

  @override
  State<HomePrayerTracker> createState() => _HomePrayerTrackerState();
}

class _HomePrayerTrackerState extends State<HomePrayerTracker>
    with SingleTickerProviderStateMixin {
  DateTime? _day;
  List<bool> _done = List<bool>.filled(kTrackedPrayers.length, false);
  int _streak = 0;

  late final AnimationController _celebrate = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void dispose() {
    _celebrate.dispose();
    super.dispose();
  }

  /// «الآن» بتوقيت الموقع المختار، لا بتوقيت الجهاز.
  ///
  /// مواقيت الصلاة محسوبة بتوقيت المدينة، فمقارنتها بساعة الجهاز تعطي نتيجة
  /// خاطئة متى اختلف التوقيتان — ويظهر وقت دخل فعلاً وكأنه لم يدخل بعد.
  DateTime _locationNow(PrayerTimeState state) {
    final offset = state.selectedLocation?.utcOffsetMinutes;
    if (offset == null) {
      return DateTime.now();
    }
    return DateTime.now().toUtc().add(Duration(minutes: offset));
  }

  /// يضمن أن الحالة المعروضة تخصّ يوم الموقع الحالي، ويعيد التحميل عند
  /// انقلاب التاريخ والتطبيق مفتوح.
  void _syncDay(DateTime now) {
    final day = _day;
    if (day != null &&
        day.year == now.year &&
        day.month == now.month &&
        day.day == now.day) {
      return;
    }
    _day = now;
    _done = PrayerTrackerStore.read(now);
    _streak = PrayerTrackerStore.streak(now);
  }

  Future<void> _toggle(int index, DateTime now) async {
    _syncDay(now);
    final marking = !_done[index];

    setState(() => _done[index] = marking);
    await PrayerTrackerStore.write(_day!, _done);

    final completed = _done.every((done) => done);
    if (!mounted) return;

    setState(() => _streak = PrayerTrackerStore.streak(_day!));

    if (marking && completed) {
      // اكتملت الخمس: اهتزازة أوضح ووميض على الصفّ.
      unawaited(HapticFeedback.mediumImpact());
      _celebrate.forward(from: 0);
    } else if (marking) {
      unawaited(HapticFeedback.selectionClick());
    }
  }

  /// الصلوات التي دخل وقتها فعلاً. عند غياب المواقيت نفتحها كلها بدل أن
  /// نمنع المستخدم من تسجيل صلاته.
  List<bool> _enteredFrom(PrayerTimeState state, DateTime now) {
    if (state.prayerList.isEmpty) {
      return List<bool>.filled(kTrackedPrayers.length, true);
    }
    return kTrackedPrayers.map((prayer) {
      final match =
          state.prayerList.where((info) => info.type == prayer).toList();
      if (match.isEmpty) return true;
      return !match.first.time.isAfter(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
      builder: (context, state) {
        final now = _locationNow(state);
        _syncDay(now);
        final entered = _enteredFrom(state, now);
        final count = _done.where((done) => done).length;
        final skin = AppSkin.of(context);
        final complete = count == kTrackedPrayers.length;

        return Padding(
          padding: AppSkin.gutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      child: Text(
                        complete
                            ? context.l10n.homeTrackerComplete
                            : context.l10n.homeTrackerPrompt,
                        key: ValueKey(complete),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: complete
                              ? skin.accent
                              : skin.inkSoft.withValues(alpha: 0.78),
                          fontSize: 10.sp,
                          fontWeight:
                              complete ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (_streak > 0) ...[
                    _StreakChip(days: _streak, skin: skin),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    context.l10n
                        .homeTrackerProgress(count, kTrackedPrayers.length),
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              _CelebrationSweep(
                controller: _celebrate,
                child: Row(
                  children: [
                    for (var i = 0; i < kTrackedPrayers.length; i++) ...[
                      if (i != 0) SizedBox(width: 6.w),
                      Expanded(
                        child: _TrackerButton(
                          label:
                              context.l10n.prayerName(kTrackedPrayers[i].name),
                          done: _done[i],
                          enabled: entered[i],
                          onTap: () => _toggle(i, now),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// شارة السلسلة: عدد الأيام المتتالية التي أُتمّت فيها الصلوات الخمس.
class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days, required this.skin});

  final int days;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(AppIcons.checkSmall, color: skin.accent, size: 11.sp),
          SizedBox(width: 3.w),
          Text(
            context.l10n.homeTrackerStreak(days),
            style: TextStyle(
              color: skin.accent,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// وميض ذهبي يمرّ مرّة واحدة على الصفّ عند اكتمال الصلوات الخمس.
class _CelebrationSweep extends StatelessWidget {
  const _CelebrationSweep({required this.controller, required this.child});

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, inner) {
        if (!controller.isAnimating) {
          return inner!;
        }
        final t = Curves.easeInOut.transform(controller.value);
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.55),
                Colors.white.withValues(alpha: 0),
              ],
              stops: [
                (t - 0.18).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.18).clamp(0.0, 1.0),
              ],
            ).createShader(bounds, textDirection: Directionality.of(context));
          },
          child: inner,
        );
      },
      child: child,
    );
  }
}

/// زرّ صلاة واحد: الذهب يرتفع من أسفل الزرّ، وعلامة الصحّ ترتسم بجانب
/// الاسم، مع نبضة حجم خفيفة عند اللمس.
class _TrackerButton extends StatefulWidget {
  const _TrackerButton({
    required this.label,
    required this.done,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool done;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_TrackerButton> createState() => _TrackerButtonState();
}

class _TrackerButtonState extends State<_TrackerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
    value: widget.done ? 1 : 0,
  );

  late final Animation<double> _fill = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  /// نبضة الحجم: تكبر قليلًا ثم تعود، فيُحسّ الضغط لا يُرى فقط.
  late final Animation<double> _pop = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.07), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.07, end: 1), weight: 65),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void didUpdateWidget(covariant _TrackerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.done != oldWidget.done) {
      widget.done ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);

    final base = widget.enabled ? skin.raised : skin.iconChip;
    final idleBorder =
        widget.enabled ? AppColors.gold.withValues(alpha: 0.42) : skin.hairline;
    final idleText =
        widget.enabled ? skin.ink : skin.inkSoft.withValues(alpha: 0.42);

    return Semantics(
      button: true,
      selected: widget.done,
      label: widget.label,
      child: InkWell(
        onTap: widget.enabled ? widget.onTap : null,
        borderRadius: radius,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _fill.value;
            final textColor = Color.lerp(idleText, AppColors.brandIvory, t)!;

            return Transform.scale(
              scale: widget.done || _controller.isAnimating ? _pop.value : 1.0,
              child: Container(
                height: 32.h,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: radius,
                  border: Border.all(
                    color: Color.lerp(idleBorder, AppColors.gold, t)!,
                    width: 1 + t * 0.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // الذهب يرتفع من القاع بدل أن يظهر دفعة واحدة.
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: t,
                          child: const ColoredBox(color: AppColors.gold),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (t > 0.02)
                              SizedBox(
                                width: 12.w * t,
                                height: 11.sp,
                                child: CustomPaint(
                                  painter: _CheckPainter(
                                    progress:
                                        ((t - 0.35) / 0.65).clamp(0.0, 1.0),
                                    color: AppColors.brandIvory,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                widget.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// يرسم علامة الصحّ سكتةً بعد سكتة بدل إظهارها جاهزة.
class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.52)
      ..lineTo(size.width * 0.4, size.height * 0.78)
      ..lineTo(size.width * 0.88, size.height * 0.24);

    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
