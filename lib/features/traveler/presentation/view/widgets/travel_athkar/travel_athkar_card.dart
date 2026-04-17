import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/done_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/info_chip.dart';

class TravelAthkarCard extends StatelessWidget {
  const TravelAthkarCard({
    required this.item,
    required this.current,
    super.key,
  });

  final TravelDhikrModel item;
  final int current;

  String _triggerLabel(String trigger) {
    return travelTriggerLabels[trigger] ?? trigger;
  }

  @override
  Widget build(BuildContext context) {
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

    return CardWidget(
      padding: EdgeInsets.all(12.sp),
      border: Border.all(
        color: done
            ? context.primaryColor.withValues(alpha: 0.45)
            : context.outlineVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconShareWidget(
                text: shareText,
                subject: 'أذكار السفر',
              ),
              CopyIconWidget(text: item.text),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              InfoChip(
                label: 'المناسبة',
                value: _triggerLabel(item.trigger),
                color: context.primaryColor,
              ),
              InfoChip(
                label: 'التكرار',
                value: item.repeatLabel,
                color: context.onSurfaceColor,
              ),
              InfoChip(
                label: 'المصدر',
                value: item.reference.source,
                color: context.onSurfaceColor,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SelectableText(
            item.text,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
          ),
          if (item.virtue.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'الفضل: ${item.virtue}',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.72),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context
                    .read<TravelAthkarBloc>()
                    .add(IncrementCounterEvent(item)),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  item.isDynamicRepeat
                      ? 'عدد التكرار: $current'
                      : '$current / ${item.repeatCount ?? 1}',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context
                    .read<TravelAthkarBloc>()
                    .add(ResetCounterEvent(item.key)),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('تصفير العداد'),
              ),
              if (done)
                DoneBadge(
                  text: 'تم',
                  color: context.primaryColor,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'المرجع: ${item.reference.source} - رقم ${item.reference.hadith}',
            style: TextStyle(
              color: context.onSurfaceColor.withValues(alpha: 0.66),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
