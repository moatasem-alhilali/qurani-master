import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';

/// أيقونة العمل حسب نوعه.
HugeIconData dailyWirdItemIcon(DailyWirdItem item) {
  switch (item.type) {
    case 'dhikr_set':
      return AppIcons.moon;
    case 'counted_dhikr':
      return AppIcons.tasbih;
    case 'quran':
      return AppIcons.quran;
    case 'dua':
      return AppIcons.heart;
    case 'surah':
      return AppIcons.bookOpen;
    default:
      return AppIcons.check;
  }
}

String dailyWirdTimeLabel(String value) {
  switch (value) {
    case 'morning':
      return 'صباح';
    case 'evening':
      return 'مساء';
    case 'night':
      return 'ليل';
    default:
      return 'أي وقت';
  }
}

String dailyWirdTypeLabel(DailyWirdItem item) {
  switch (item.type) {
    case 'dhikr_set':
      return 'أذكار';
    case 'counted_dhikr':
      return 'ذكر بعدد';
    case 'quran':
      return 'ورد قرآن';
    case 'dua':
      return 'دعاء';
    case 'surah':
      return 'سورة';
    default:
      return item.type;
  }
}

/// مربّع أيقونة صغير — بديل البطاقة حول كل عنصر.
class DailyWirdIconChip extends StatelessWidget {
  const DailyWirdIconChip({required this.icon, super.key});

  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}

/// خطّ التقدّم: شعرة تمتلئ ذهبًا بسلاسة، لا بطاقة ولا شريط سميك.
class DailyWirdProgressLine extends StatelessWidget {
  const DailyWirdProgressLine({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
      builder: (context, animated, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: animated,
            minHeight: 3.h,
            backgroundColor: skin.hairline,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        );
      },
    );
  }
}

/// انتظار هادئ بخطّ رفيع بدل دائرة تدور.
class DailyWirdThinLoader extends StatelessWidget {
  const DailyWirdThinLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: LinearProgressIndicator(
          minHeight: 3.h,
          backgroundColor: skin.hairline,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      ),
    );
  }
}

/// زرّ رئيسي بتعبئة ذهبية — يُستعمل مرّة واحدة في الورقة.
class DailyWirdPrimaryButton extends StatelessWidget {
  const DailyWirdPrimaryButton({
    required this.label,
    required this.onTap,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final HugeIconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, color: AppColors.brandIvory, size: 14.sp),
              SizedBox(width: 7.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: AppColors.brandIvory,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// زرّ احتساب العمل: الذهب يرتفع بقدر ما أُنجز، وعلامة الصحّ تُرسم عند
/// الإتمام ولا تظهر جاهزة، ومع كل ضغطة اهتزازة — وأوضح منها عند الإتمام.
class DailyWirdActionButton extends StatefulWidget {
  const DailyWirdActionButton({required this.item, super.key});

  final DailyWirdItem item;

  @override
  State<DailyWirdActionButton> createState() => _DailyWirdActionButtonState();
}

class _DailyWirdActionButtonState extends State<DailyWirdActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );

  late double _from = widget.item.progress;
  late double _to = _from;

  late final Animation<double> _pop = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.07), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.07, end: 1), weight: 65),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  double get _fill {
    if (!_controller.isAnimating && _controller.value == 0) return _from;
    final t = Curves.easeOutCubic.transform(_controller.value);
    return _from + (_to - _from) * t;
  }

  @override
  void didUpdateWidget(covariant DailyWirdActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.progress == oldWidget.item.progress) return;
    _from = _fill;
    _to = widget.item.progress;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    final item = widget.item;
    final bloc = context.read<DailyWirdBloc>();

    if (item.hasCounter) {
      final willComplete = item.countCompleted + 1 >= (item.countRequired ?? 1);
      if (willComplete) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
      bloc.add(DailyWirdIncrementItemEvent(item.id));
      return;
    }

    if (item.isCompleted) {
      HapticFeedback.selectionClick();
    } else {
      HapticFeedback.mediumImpact();
    }
    bloc.add(DailyWirdToggleItemEvent(item.id));
  }

  String get _label {
    final item = widget.item;
    if (item.hasCounter) {
      if (item.isCompleted) return 'أُنجز';
      return '${item.countCompleted} من ${item.countRequired ?? 0}';
    }
    return item.isCompleted ? 'تم' : 'إتمام';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);
    final done = widget.item.isCompleted;
    final disabled = widget.item.hasCounter && done;

    return Semantics(
      button: true,
      selected: done,
      child: InkWell(
        onTap: disabled ? null : _handleTap,
        borderRadius: radius,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _fill.clamp(0.0, 1.0);
            final textColor =
                Color.lerp(skin.ink, AppColors.brandIvory, t) ?? skin.ink;

            return Transform.scale(
              scale: _controller.isAnimating ? _pop.value : 1.0,
              child: Container(
                height: 28.h,
                decoration: BoxDecoration(
                  color: skin.raised,
                  borderRadius: radius,
                  border: Border.all(
                    color: Color.lerp(
                          AppColors.gold.withValues(alpha: 0.42),
                          AppColors.gold,
                          t,
                        ) ??
                        AppColors.gold,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
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
                            if (done)
                              SizedBox(
                                width: 11.w,
                                height: 10.sp,
                                child: CustomPaint(
                                  painter: DailyWirdCheckPainter(
                                    progress:
                                        ((t - 0.35) / 0.65).clamp(0.0, 1.0),
                                    color: AppColors.brandIvory,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                _label,
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
class DailyWirdCheckPainter extends CustomPainter {
  const DailyWirdCheckPainter({required this.progress, required this.color});

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
  bool shouldRepaint(covariant DailyWirdCheckPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// ورقة تعديل العدد المقصود — بلغة الشاشة نفسها.
Future<int?> showDailyWirdCountSheet(
  BuildContext context, {
  required int currentValue,
}) {
  final skin = AppSkin.of(context);
  final controller = TextEditingController(text: '$currentValue');

  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (sheetContext) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 34.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'تعديل العدد المقصود',
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                cursorColor: skin.accent,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: skin.raised,
                  hintText: 'مثال: ٥٠ مرة',
                  hintStyle: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.5),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 10.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: skin.hairline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: skin.raisedBorder),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              DailyWirdPrimaryButton(
                label: 'حفظ',
                icon: AppIcons.save,
                onTap: () {
                  final parsed = int.tryParse(controller.text.trim());
                  if (parsed == null || parsed <= 0) {
                    return;
                  }
                  Navigator.of(sheetContext).pop(parsed);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
