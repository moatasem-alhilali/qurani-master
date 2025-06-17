import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class MyDhikrCardWidget extends StatelessWidget {
  const MyDhikrCardWidget({
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          CardWidget(
            width: double.infinity,
            margin: const EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
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
                    subih.content,
                    style: titleSmall(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: FxColors.gray1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                SizedBox(height: 8.h),
              ],
            ),
          ),
          CardWidget(
            margin: const EdgeInsets.only(
              bottom: 8,
              left: 16,
              right: 16,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
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
                // Reset button
                IconButton(
                  onPressed: onReset,
                  icon: Icon(
                    Icons.refresh,
                    color: context.primaryScheme,
                  ),
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
      ),
    );
  }
}
