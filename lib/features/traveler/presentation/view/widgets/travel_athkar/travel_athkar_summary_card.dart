import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/summary_info_chip.dart';

class TravelAthkarSummaryCard extends StatelessWidget {
  const TravelAthkarSummaryCard({required this.state, super.key});

  final TravelAthkarState state;

  @override
  Widget build(BuildContext context) {
    final fixedItemsCount = state.allItems
        .where((item) => item.repeatCount != null && !item.isDynamicRepeat)
        .length;
    final fixedItems = state.allItems
        .where((item) => item.repeatCount != null && !item.isDynamicRepeat)
        .toList();

    int completedItemsCount = 0;
    for (var item in fixedItems) {
      final current = state.repeatCounts[item.key] ?? 0;
      if (current >= (item.repeatCount ?? 0)) completedItemsCount++;
    }

    final fixedCount = fixedItemsCount;
    final completed = completedItemsCount;
    final dynamicCount =
        state.allItems.where((item) => item.isDynamicRepeat).length;
    final progress = fixedCount == 0 ? 0.0 : completed / fixedCount;
    final progressText = '$completed / $fixedCount';

    return CardWidget(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      border: Border.all(
        color: context.outlineVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16.sp,
                color: context.primaryColor,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'مساعد أذكار السفر',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 13.2.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  child: Text(
                    progressText,
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.5.h,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: SummaryInfoChip(
                  label: 'إجمالي',
                  value: '${state.allItems.length}',
                  color: context.primaryColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: SummaryInfoChip(
                  label: 'ديناميكي',
                  value: '$dynamicCount',
                  color: context.onSurfaceColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: SummaryInfoChip(
                  label: 'المكتمل',
                  value: '$completed',
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
