import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryInfoChip extends StatelessWidget {
  const SummaryInfoChip({super.key, required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Text(
          '$label: $value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 10.2.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
