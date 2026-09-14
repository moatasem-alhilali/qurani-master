import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/summary_info_chip.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// شريط تقدّم أذكار السفر: سطر واحد وخطّ تعبئة وثلاثة أعداد.
///
/// كان بطاقة فوق بطاقات، فيتنافس مع الذكر نفسه على الانتباه. الآن يجلس
/// على الأرضية ويفصله خطّ شعرة، والتعبئة الذهبية وحدها هي التي تلفت.
class TravelAthkarSummaryCard extends StatelessWidget {
  const TravelAthkarSummaryCard({required this.state, super.key});

  final TravelAthkarState state;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final fixedItems = state.allItems
        .where((item) => item.repeatCount != null && !item.isDynamicRepeat)
        .toList();

    var completed = 0;
    for (final item in fixedItems) {
      final current = state.repeatCounts[item.key] ?? 0;
      if (current >= (item.repeatCount ?? 0)) completed++;
    }

    final fixedCount = fixedItems.length;
    final dynamicCount =
        state.allItems.where((item) => item.isDynamicRepeat).length;
    final progress = fixedCount == 0 ? 0.0 : completed / fixedCount;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 11.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const TravelerIconChip(icon: AppIcons.dailyWird),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'وردك في الطريق',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      // الكسر «٣ / ٩» ينقلب في الاتجاه العربي فيُقرأ مقلوبًا،
                      // فصيغ بالعربية بدل الشرطة المائلة.
                      'أتممت $completed من $fixedCount ذكرًا مؤقّتًا',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 3.h,
                backgroundColor: skin.hairline,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              ),
            ),
          ),
          SizedBox(height: 9.h),
          Row(
            children: [
              Expanded(
                child: SummaryInfoChip(
                  label: 'إجمالي الأذكار',
                  value: '${state.allItems.length}',
                ),
              ),
              _CountDivider(color: skin.hairline),
              Expanded(
                child: SummaryInfoChip(
                  label: 'بحسب الموقف',
                  value: '$dynamicCount',
                ),
              ),
              _CountDivider(color: skin.hairline),
              Expanded(
                child: SummaryInfoChip(
                  label: 'المكتمل',
                  value: '$completed',
                  emphasised: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// فاصل رأسي بسُمك شعرة بين خانات العدّ.
class _CountDivider extends StatelessWidget {
  const _CountDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 22.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: color,
    );
  }
}
