import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/service/tasbih_preferences.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_counter.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbih_bead_chain.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// مسرح التسبيح: الذكر المختار، سبحته، وعدّاده.
///
/// اللمس على المساحة كلها لا على زرّ صغير — هكذا تُمسك السبحة الحقيقية،
/// والعين تبقى على النصّ لا على هدفٍ صغير تلاحقه الإصبع.
class TasbeehStage extends StatelessWidget {
  const TasbeehStage({
    required this.subih,
    required this.count,
    super.key,
  });

  final SubihModel subih;
  final int count;

  int get _target {
    final custom = TasbihPreferences.instance.customTargetFor(subih.id ?? -1);
    return custom ?? tasbeehTargetFor(count);
  }

  void _handleTap(BuildContext context) {
    final id = subih.id;
    if (id == null) return;

    // الاهتزاز قبل ذهاب الحدث إلى قاعدة البيانات: الإحساس فوري ولا ينتظر
    // ذهابًا وإيابًا.
    if (TasbihPreferences.instance.hapticsEnabled.value) {
      final next = count + 1;
      if (next >= _target || tasbeehIsMilestone(next)) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }

    context.read<SabihBloc>().add(PerformSubihTapEvent(subihId: id));
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final target = _target;
    final reached = count >= target;

    return ValueListenableBuilder<double>(
      valueListenable: TasbihPreferences.instance.fontScale,
      builder: (context, fontScale, _) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _handleTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  subih.title,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: FontFamily.scheherazade,
                    color: skin.ink,
                    fontSize: 26.sp * fontScale,
                    height: 1.75,
                  ),
                ),
              ),
              if (subih.content.trim().isNotEmpty &&
                  subih.content.trim() != 'بدون وصف') ...[
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Text(
                    subih.content,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 14.h),
              // السحب الأفقي فوق السبحة يعدّ كاللمس — هكذا تُدار السبحة
              // بالإبهام. أفقيٌّ عمدًا: العمودي يتنازع مع تمرير الصفحة.
              _BeadDragCounter(
                onStep: () => _handleTap(context),
                child: ValueListenableBuilder(
                  valueListenable: TasbihPreferences.instance.material,
                  builder: (context, material, _) => SizedBox(
                    height: 92.h,
                    child: TasbihBeadChain(
                      count: count,
                      material: material,
                      stringColor: skin.inkSoft.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                reached ? 'بلغت $target' : 'الهدف $target',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: reached
                      ? skin.accent
                      : skin.inkSoft.withValues(alpha: 0.72),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _CountReadout(count: count, reached: reached, skin: skin),
              SizedBox(height: 8.h),
              Text(
                'المس أي مكان للتسبيح',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.42),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// الرقم وحده، كبيرًا، بأرقام ثابتة العرض حتى لا يهتزّ عند تغيّر الخانات.
class _CountReadout extends StatelessWidget {
  const _CountReadout({
    required this.count,
    required this.reached,
    required this.skin,
  });

  final int count;
  final bool reached;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'عدد التسبيح',
      value: '$count',
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        style: TextStyle(
          color: reached ? AppColors.gold : skin.ink,
          fontSize: 46.sp,
          fontWeight: FontWeight.w800,
          height: 1.1,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        child: Text('$count', textAlign: TextAlign.center),
      ),
    );
  }
}

/// شريط اختيار الذكر — بديل الشرائح المتقلّبة، يُظهر كل الأذكار دفعةً
/// ويُبقي المختار ظاهرًا.
class TasbeehDhikrStrip extends StatelessWidget {
  const TasbeehDhikrStrip({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<SubihModel> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelected(index);
            },
            borderRadius: BorderRadius.circular(999.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                  color: selected ? AppColors.gold : skin.hairline,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (items[index].isCustom) ...[
                    AppIcon(
                      AppIcons.user,
                      size: 11.sp,
                      color: selected ? AppColors.brandIvory : skin.inkSoft,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    items[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? AppColors.brandIvory
                          : skin.ink.withValues(alpha: 0.82),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// يحوّل السحب الأفقي فوق السبحة إلى تسبيحات.
///
/// كل مسافة الخطوة بكسل من الحركة تساوي خرزة، فالسحب البطيء يعدّ واحدة
/// والسحب السريع يعدّ عدّة — كما تنزلق الخرزات تحت الإبهام فعلًا.
class _BeadDragCounter extends StatefulWidget {
  const _BeadDragCounter({required this.onStep, required this.child});

  final VoidCallback onStep;
  final Widget child;

  @override
  State<_BeadDragCounter> createState() => _BeadDragCounterState();
}

class _BeadDragCounterState extends State<_BeadDragCounter> {
  static const _stepDistance = 32.0;

  double _travelled = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) => _travelled = 0,
      onHorizontalDragUpdate: (details) {
        _travelled += details.delta.dx.abs();
        while (_travelled >= _stepDistance) {
          _travelled -= _stepDistance;
          widget.onStep();
        }
      },
      onHorizontalDragEnd: (_) => _travelled = 0,
      child: widget.child,
    );
  }
}
