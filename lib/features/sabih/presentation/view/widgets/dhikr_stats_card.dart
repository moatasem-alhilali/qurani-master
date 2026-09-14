import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

/// صفّ إحصاء ذكر واحد: عنوان ووصف ورقم، بلا بطاقة ولا دائرة ملوّنة.
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
    final skin = AppSkin.of(context);
    final hasCount = count > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        subih.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (subih.isCustom) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: skin.iconChip,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          'مخصص',
                          style: TextStyle(
                            color: skin.accent,
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subih.content.trim().isNotEmpty)
                  Text(
                    subih.content,
                    maxLines: 2,
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
          SizedBox(width: 10.w),
          Text(
            '$count',
            style: TextStyle(
              color: hasCount
                  ? skin.accent
                  : skin.inkSoft.withValues(alpha: 0.45),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
