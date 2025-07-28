import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildPeriodChip(context, PeriodType.today, 'اليوم'),
            _buildPeriodChip(context, PeriodType.week, 'الأسبوع'),
            _buildPeriodChip(context, PeriodType.month, 'الشهر'),
            _buildPeriodChip(context, PeriodType.year, 'السنة'),
            _buildPeriodChip(context, PeriodType.allTime, 'الكل'),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(
    BuildContext context,
    PeriodType period,
    String label,
  ) {
    // logger.d(selectedPeriod == period);
    final isSelected = selectedPeriod == period;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: titleMedium(context).copyWith(
            color: isSelected ? Colors.white : FxColors.gray1,
            fontWeight: isSelected ? FontWeight.bold : null,
            fontSize: 12.sp,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            widget.onPeriodChanged(period);
            setState(() {
              selectedPeriod = period;
            });
          }
        },
        backgroundColor: context.onPrimaryContainer,
        selectedColor: context.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? context.secondaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
