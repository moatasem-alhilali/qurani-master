import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// سطر تعريفي في تفاصيل الرحلة: الوصف يمينًا وقيمته يسارًا.
///
/// كانت أربع حبّات ملوّنة متراصّة في `Wrap`، فتقرأ العين ألوانًا لا معلومة.
/// الصفوف النحيلة المفصولة بشعرة تجعل «من» و«إلى» و«المصدر» جدولًا يُقرأ.
class FlightDetailRow extends StatelessWidget {
  const FlightDetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.emphasised = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isLast;

  /// القيمة المميّزة تأخذ لون الحبر المميّز ووزنًا أثقل.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: emphasised ? skin.accent : skin.ink,
                fontSize: 12.5.sp,
                fontWeight: emphasised ? FontWeight.w800 : FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
