import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// محطّة واحدة على طريق السفر.
///
/// الصفحة لا تعرض قائمة أذكار — تعرض **الرحلة**: كل ذكر مربوط بلحظته من
/// الطريق (`trigger` في البيانات، وكان مهدورًا في شارة صغيرة). فمن يريد ذكر
/// الركوب يجده عند «بداية السفر» لا في بطاقة رقم ثلاثة.
///
/// محطّة واحدة مفتوحة في الوقت نفسه، والمفتوحة تلقائيًّا هي أوّل ما لم يُتمّ
/// — فيفتح المستخدم الصفحة وهو في موضعه من الطريق بلا بحث.
class TravelRoadStation extends StatelessWidget {
  const TravelRoadStation({
    required this.item,
    required this.count,
    required this.isExpanded,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
    super.key,
  });

  final TravelDhikrModel item;
  final int count;
  final bool isExpanded;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  int get _target => item.repeatCount ?? 1;

  bool get _isDone => item.isDynamicRepeat ? count > 0 : count >= _target;

  String _stageLabel(L10n l10n) =>
      travelTriggerLabel(l10n, item.trigger) ?? item.trigger;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // الطريق يُرسم **خلف** المحتوى لا في عمود بجانبه.
    //
    // النسخة الأولى وضعت الرسّام في `Row` داخل `IntrinsicHeight` ليأخذ
    // الخطُّ ارتفاع الصفّ. لكن `IntrinsicHeight` يسأل أطفاله عن أطول ارتفاع
    // ممكن، و`AnimatedCrossFade` يجيب بارتفاع الجسم **المفتوح** حتى وهو
    // مطويّ — فكانت كل محطّة مغلقة تحجز فراغ المفتوحة تحتها.
    //
    // `CustomPaint` بطفلٍ يأخذ قياسه من الطفل، فيتبع الخطُّ الارتفاعَ الفعلي
    // بلا حساب مسبق.
    return CustomPaint(
      painter: _RoadPainter(
        isDone: _isDone,
        isActive: isExpanded,
        isFirst: isFirst,
        isLast: isLast,
        isRtl: Directionality.of(context) == TextDirection.rtl,
        line: skin.hairline,
        accent: skin.accent,
        ground: skin.ground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 34.w,
          bottom: isLast ? 6.h : 14.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _stageLabel(context.l10n),
                            style: TextStyle(
                              color: _isDone || isExpanded
                                  ? skin.accent
                                  : skin.ink,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.7),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: AppIcon(
                        AppIcons.down,
                        color: skin.inkSoft.withValues(alpha: 0.6),
                        size: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 240),
              sizeCurve: Curves.easeOutCubic,
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _StationBody(
                item: item,
                count: count,
                target: _target,
                isDone: _isDone,
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

/// جسم المحطّة المفتوحة: النصّ، ثم الفضل، ثم العدّاد والمصدر.
class _StationBody extends StatelessWidget {
  const _StationBody({
    required this.item,
    required this.count,
    required this.target,
    required this.isDone,
  });

  final TravelDhikrModel item;
  final int count;
  final int target;
  final bool isDone;

  String _shareText(L10n l10n) {
    final buffer = StringBuffer()
      ..writeln(item.title)
      ..writeln()
      ..writeln(item.text);

    if (item.virtue.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(l10n.travelerShareVirtue(item.virtue));
    }
    buffer
      ..writeln()
      ..writeln(
        l10n.travelerShareSource(item.reference.source, item.reference.hadith),
      );

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(top: 8.h, end: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // نصّ الذكر عربيّ في كل اللغات، فيبقى اتجاهه من اليمين.
          Directionality(
            textDirection: TextDirection.rtl,
            child: SelectableText(
              item.text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: skin.ink,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.95,
              ),
            ),
          ),
          if (item.virtue.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              item.virtue,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 1.7,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              _CounterButton(
                  item: item, count: count, target: target, isDone: isDone),
              SizedBox(width: 8.w),
              if (count > 0)
                _GhostAction(
                  icon: AppIcons.refresh,
                  tooltip: context.l10n.travelerResetCounter,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context
                        .read<TravelAthkarBloc>()
                        .add(ResetCounterEvent(item.key));
                  },
                ),
              const Spacer(),
              IconShareWidget(
                text: _shareText(context.l10n),
                subject: context.l10n.travelerAthkarTitle,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${item.reference.source} · ${item.reference.hadith}',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.55),
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// زرّ العدّ: يمتلئ ذهبًا مع كل تسبيحة حتى يكتمل.
class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.item,
    required this.count,
    required this.target,
    required this.isDone,
  });

  final TravelDhikrModel item;
  final int count;
  final int target;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final onGold = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;
    final l10n = context.l10n;
    final label = item.isDynamicRepeat
        ? (isDone ? l10n.travelerCounterDone : l10n.travelerCounterCount)
        : '$count / $target';

    return Semantics(
      button: true,
      label: l10n.travelerCountDhikr,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.read<TravelAthkarBloc>().add(IncrementCounterEvent(item));
        },
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDone ? AppColors.gold : skin.iconChip,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                isDone ? AppIcons.check : AppIcons.tasbih,
                color: isDone ? onGold : skin.accent,
                size: 14.sp,
              ),
              SizedBox(width: 6.w),
              // الاتّجاه مثبّت: «٣ / ٥» تنقلب في العربية فتُقرأ ٥ من ٣.
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDone ? onGold : skin.ink,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostAction extends StatelessWidget {
  const _GhostAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final HugeIconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(7.w),
          child: AppIcon(
            icon,
            color: skin.inkSoft.withValues(alpha: 0.6),
            size: 15.sp,
          ),
        ),
      ),
    );
  }
}

/// الطريق نفسه: خطّ رأسي وعقدة.
///
/// الخطّ فوق العقدة يأخذ لون ما **قبلها** والخطّ تحتها لون حالتها، فيبدو
/// الطريق ممتلئًا ذهبًا إلى حيث وصلت لا مقطّعًا عند كل محطّة.
class _RoadPainter extends CustomPainter {
  const _RoadPainter({
    required this.isDone,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.isRtl,
    required this.line,
    required this.accent,
    required this.ground,
  });

  final bool isDone;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  /// الطريق يجري على جهة البداية: يمينًا في العربية ويسارًا في غيرها.
  final bool isRtl;

  final Color line;
  final Color accent;
  final Color ground;

  /// نصف عرض العمود المتروك للطريق في حشوة المحتوى.
  static const double _rail = 17;

  @override
  void paint(Canvas canvas, Size size) {
    final x = isRtl ? size.width - _rail : _rail;
    const nodeY = 16.0;
    final radius = isActive || isDone ? 7.0 : 5.5;

    final stroke = Paint()
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    if (!isFirst) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, nodeY - radius - 2),
        stroke..color = isDone ? accent.withValues(alpha: 0.6) : line,
      );
    }
    if (!isLast) {
      canvas.drawLine(
        Offset(x, nodeY + radius + 2),
        Offset(x, size.height),
        stroke..color = isDone ? accent.withValues(alpha: 0.6) : line,
      );
    }

    final center = Offset(x, nodeY);
    if (isDone) {
      canvas.drawCircle(center, radius, Paint()..color = accent);
      // علامة صحّ مرسومة — أصغر من أن تُقرأ أيقونةً في هذا الحجم.
      final tick = Path()
        ..moveTo(center.dx - 3, center.dy)
        ..lineTo(center.dx - 0.8, center.dy + 2.4)
        ..lineTo(center.dx + 3.2, center.dy - 2.4);
      canvas.drawPath(
        tick,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.7
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = ground,
      );
      return;
    }

    canvas
      ..drawCircle(center, radius, Paint()..color = ground)
      ..drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 2.2 : 1.6
          ..color = isActive ? accent : line,
      );
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) =>
      oldDelegate.isDone != isDone ||
      oldDelegate.isActive != isActive ||
      oldDelegate.isFirst != isFirst ||
      oldDelegate.isLast != isLast ||
      oldDelegate.isRtl != isRtl ||
      oldDelegate.line != line ||
      oldDelegate.accent != accent ||
      oldDelegate.ground != ground;
}
