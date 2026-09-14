import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

/// اختيار المدّة: شارات صغيرة، المختارة منها بتعبئة ذهبية.
class AnalyticsPeriodSelector extends StatefulWidget {
  const AnalyticsPeriodSelector({
    required this.onPeriodChanged,
    super.key,
  });

  final void Function(PeriodType) onPeriodChanged;

  @override
  State<AnalyticsPeriodSelector> createState() =>
      _AnalyticsPeriodSelectorState();
}

class _AnalyticsPeriodSelectorState extends State<AnalyticsPeriodSelector> {
  PeriodType? selectedPeriod;

  static const _periods = <(PeriodType, String)>[
    (PeriodType.today, 'اليوم'),
    (PeriodType.week, 'الأسبوع'),
    (PeriodType.month, 'الشهر'),
    (PeriodType.year, 'السنة'),
    (PeriodType.allTime, 'الكل'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        children: [
          for (var i = 0; i < _periods.length; i++) ...[
            if (i != 0) SizedBox(width: 6.w),
            _PeriodChip(
              label: _periods[i].$2,
              selected: selectedPeriod == _periods[i].$1,
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onPeriodChanged(_periods[i].$1);
                setState(() {
                  selectedPeriod = _periods[i].$1;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : skin.raised,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? AppColors.gold : skin.hairline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.brandIvory : skin.ink,
            fontSize: 10.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
