import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/widgets/animated_tasbih_widget.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class DhikrCardWidget extends StatelessWidget {
  const DhikrCardWidget({
    required this.subih,
    required this.count,
    required this.onTap,
    required this.onReset,
    super.key,
    this.onEdit,
    this.onDelete,
    this.useAnimatedTasbih = false,
  });
  final SubihModel subih;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool useAnimatedTasbih;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header with title and actions
                SizedBox(height: 16.h),

                // Dhikr title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    subih.title,
                    style: titleMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'اقصى التسبيح التي وصلتها هو $count',
                    style: titleSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: FxColors.gray1,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Tasbeeh interaction (button or animated tasbih)
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AnimatedTasbihWidget(
                      // initialCount: count,
                      onCountChanged: (_) => onTap(),
                      primaryColor: context.primaryColor,
                      secondaryColor: context.primaryColor.withOpacity(0.8),
                    ),
                  ),
                ),
                const Spacer(),

                // Reset button
                TextButton.icon(
                  onPressed: onReset,
                  icon: Icon(
                    Icons.refresh,
                    color: context.primaryColor,
                  ),
                  label: Text(
                    'إعادة تعيين الذكر',
                    style: titleMedium(context).copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
        if (subih.isCustom)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.secondaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Edit button for custom dhikr
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onEdit,
                    tooltip: 'تعديل',
                  ),
                // Delete button for custom dhikr
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: 'حذف',
                    color: Colors.red,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
