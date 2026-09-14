import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// خانة عدّ في شريط الملخّص: الرقم فوق ووصفه تحته.
///
/// ثلاث حبّات ملوّنة متجاورة كانت تُقرأ ككتلة واحدة؛ الرقم أولًا ثم اسمه
/// يجعل العين تلتقط العدد مباشرة.
class SummaryInfoChip extends StatelessWidget {
  const SummaryInfoChip({
    required this.label,
    required this.value,
    this.emphasised = false,
    super.key,
  });

  final String label;
  final String value;

  /// الخانة المميّزة: لون الحبر المميّز ووزن أثقل — لا لون وحده.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Text(
            value,
            style: TextStyle(
              color: emphasised ? skin.accent : skin.ink,
              fontSize: 12.5.sp,
              fontWeight: emphasised ? FontWeight.w800 : FontWeight.w600,
              height: 1.2,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ),
        Text(
          label,
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
    );
  }
}
