import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class DhikrStatsCard extends StatelessWidget {
  const DhikrStatsCard({
    required this.subih,
    required this.count,
    super.key,
  });
  final SubihModel subih;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subih.title,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      if (subih.isCustom)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryScheme.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'مخصص',
                            style: context.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subih.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium?.copyWith(
                      color: context.gray1,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildCountDisplay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCountDisplay(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: count > 0 ? context.primaryScheme : context.gray1,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Text(
          count.toString(),
          style: context.bodyMedium?.copyWith(
            color: count > 0 ? Colors.white : context.gray2,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
