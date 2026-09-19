import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

/// يختار رقمًا واحدًا حين يكون للاسم أكثر من رقم.
///
/// الورقة تجلس على أرضية الشاشة نفسها، وأرقامها صفوف نحيلة يفصلها خطّ شعرة.
Future<String?> showSmartOutreachPhonePicker(
  BuildContext context,
  List<String> phoneNumbers,
) {
  final unique = phoneNumbers
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList();

  if (unique.isEmpty) {
    return Future.value();
  }

  if (unique.length == 1) {
    return Future.value(unique.first);
  }

  final skin = AppSkin.of(context);

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: skin.ground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
              child: Container(
                width: 34.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            HomeSectionHeader(title: context.l10n.outreachPickNumber),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
              child: Text(
                context.l10n.outreachMultipleNumbers,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
            for (final entry in unique.asMap().entries)
              _PhoneOptionRow(
                phone: entry.value,
                isLast: entry.key == unique.length - 1,
                onTap: () {
                  unawaited(HapticFeedback.selectionClick());
                  Navigator.of(sheetContext).pop(entry.value);
                },
              ),
            SizedBox(height: 12.h),
          ],
        ),
      );
    },
  );
}

/// صفّ رقم واحد: الرقم بترتيب لاتيني حتى لا ينقلب في الاتجاه العربي.
class _PhoneOptionRow extends StatelessWidget {
  const _PhoneOptionRow({
    required this.phone,
    required this.isLast,
    required this.onTap,
  });

  final String phone;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            const OutreachIconChip(icon: AppIcons.phone),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                phone,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                textAlign: outreachStartAlign(context),
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            AppIcon(
              outreachForwardChevron(context),
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
