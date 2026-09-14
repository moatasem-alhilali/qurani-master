import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// سطر تفصيلي داخل الذكر: عنوان صغير ثم نصّه.
class WirdInfoRow extends StatelessWidget {
  const WirdInfoRow({
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    if (content.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.8),
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 3.h),
        SelectableText(
          content,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: skin.inkSoft,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w500,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}
