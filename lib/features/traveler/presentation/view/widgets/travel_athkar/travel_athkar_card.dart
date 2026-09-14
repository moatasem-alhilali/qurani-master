import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/done_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/info_chip.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// ذكر واحد: عنوان، وسوم، نصّ الذكر، ثم عدّاده.
///
/// كان بطاقة بحدّ حول كل ذكر في القائمة، فصارت الصفحة صندوقًا في صندوق.
/// الآن يجلس الذكر على الأرضية ويفصله عن تاليه خطّ شعرة واحد.
class TravelAthkarCard extends StatelessWidget {
  const TravelAthkarCard({
    required this.item,
    required this.current,
    this.showDivider = false,
    super.key,
  });

  final TravelDhikrModel item;
  final int current;

  /// في وضع القائمة يفصل خطّ شعرة بين ذكر وآخر؛ في وضع الصفحات لا فاصل.
  final bool showDivider;

  String _triggerLabel(String trigger) =>
      travelTriggerLabels[trigger] ?? trigger;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final target = item.repeatCount;
    final done = target != null && !item.isDynamicRepeat && current >= target;

    final shareText = [
      item.title,
      '',
      item.text,
      if (item.virtue.trim().isNotEmpty) ...[
        '',
        'الفضل: ${item.virtue}',
      ],
      '',
      'المصدر: ${item.reference.source} (${item.reference.hadith})',
    ].join('\n');

    return Container(
      decoration: showDivider
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            )
          : null,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              IconShareWidget(text: shareText, subject: 'أذكار السفر'),
              CopyIconWidget(text: item.text),
            ],
          ),
          SizedBox(height: 7.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              InfoChip(label: 'المناسبة', value: _triggerLabel(item.trigger)),
              InfoChip(label: 'التكرار', value: item.repeatLabel),
              InfoChip(label: 'المصدر', value: item.reference.source),
            ],
          ),
          SizedBox(height: 10.h),
          SelectableText(
            item.text,
            textDirection: ui.TextDirection.rtl,
            style: TextStyle(
              color: skin.ink,
              fontFamily: FontFamily.scheherazade,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.9,
            ),
          ),
          if (item.virtue.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'الفضل: ${item.virtue}',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _DhikrCounterButton(
                  item: item,
                  current: current,
                  done: done,
                ),
              ),
              SizedBox(width: 8.w),
              TravelerPillButton(
                label: 'تصفير',
                icon: AppIcons.refresh,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context
                      .read<TravelAthkarBloc>()
                      .add(ResetCounterEvent(item.key));
                },
              ),
              if (done) ...[
                SizedBox(width: 8.w),
                const DoneBadge(text: 'تمّ'),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'المرجع: ${item.reference.source} · رقم ${item.reference.hadith}',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.7),
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

/// عدّاد الذكر: التعبئة تتحرّك مع كل ضغطة بدل أن تُبدَّل دفعة واحدة.
class _DhikrCounterButton extends StatelessWidget {
  const _DhikrCounterButton({
    required this.item,
    required this.current,
    required this.done,
  });

  final TravelDhikrModel item;
  final int current;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final target = item.repeatCount ?? 1;
    final fill = item.isDynamicRepeat
        ? 0.0
        : (target == 0 ? 0.0 : (current / target).clamp(0.0, 1.0));

    final label =
        item.isDynamicRepeat ? 'كرّرت $current مرة' : '$current من $target';

    return InkWell(
      onTap: done
          ? null
          : () {
              // الاكتمال يُحسّ أقوى من مجرّد خطوة: نبضة أثقل عند آخر عدّة.
              if (!item.isDynamicRepeat && current + 1 >= target) {
                HapticFeedback.mediumImpact();
              } else {
                HapticFeedback.selectionClick();
              }
              context.read<TravelAthkarBloc>().add(IncrementCounterEvent(item));
            },
      borderRadius: BorderRadius.circular(999.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: SizedBox(
          height: 30.h,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: skin.iconChip)),
              Positioned.fill(
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: fill,
                  // تعبئة شفّافة لا مصمتة: الحبر نفسه يمرّ فوق الجزء
                  // الممتلئ والفارغ، فيبقى مقروءًا في الوضعين.
                  child: ColoredBox(
                    color: AppColors.gold.withValues(alpha: 0.42),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(
                      done ? AppIcons.checkSmall : AppIcons.add,
                      color: skin.ink,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      label,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        fontFeatures: const [ui.FontFeature.tabularFigures()],
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
  }
}
