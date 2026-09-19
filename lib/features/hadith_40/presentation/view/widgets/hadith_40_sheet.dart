import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/services/share_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/l10n/l10n.dart';

/// ورقة الحديث: النصّ هو البطل.
///
/// لا بطاقة ولا إطار حول الحديث — يجلس على أرضية الصفحة بخطّ شهرزاد
/// وارتفاع سطر واسع، وكل ما حوله يهدأ حتى لا ينازعه.
Future<void> showHadith40Sheet(
  BuildContext context, {
  required String title,
  required int order,
  required String hadith,
  required String explanation,
}) async {
  final skin = AppSkin.of(context);
  final shareText = context.l10n.hadith40ShareText(title, hadith, explanation);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.86,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return _Hadith40SheetBody(
            scrollController: scrollController,
            title: title,
            order: order,
            hadith: hadith,
            explanation: explanation,
            shareText: shareText,
          );
        },
      );
    },
  );
}

class _Hadith40SheetBody extends StatelessWidget {
  const _Hadith40SheetBody({
    required this.scrollController,
    required this.title,
    required this.order,
    required this.hadith,
    required this.explanation,
    required this.shareText,
  });

  final ScrollController scrollController;
  final String title;
  final int order;
  final String hadith;
  final String explanation;
  final String shareText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasExplanation = explanation.trim().isNotEmpty;

    return ColoredBox(
      color: skin.ground,
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: 24.h),
        children: [
          SizedBox(height: 10.h),
          Center(
            child: Container(
              width: 34.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: skin.hairline,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        context.l10n.hadith40SheetSubtitle(order),
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
                  ),
                ),
                _SheetAction(
                  icon: AppIcons.copy,
                  tooltip: context.l10n.commonCopy,
                  onTap: () async {
                    await HapticFeedback.selectionClick();
                    await CopyService.copyToClipboard(shareText);
                  },
                ),
                SizedBox(width: 4.w),
                _SheetAction(
                  icon: AppIcons.share,
                  tooltip: context.l10n.commonShare,
                  onTap: () async {
                    await HapticFeedback.selectionClick();
                    await ShareService.shareText(
                      text: shareText,
                      subject: context.l10n.hadith40Title,
                    );
                  },
                ),
              ],
            ),
          ),
          skin.divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: SelectableText(
              hadith.replaceAll('\r', '').trim(),
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: skin.ink,
                fontFamily: FontFamily.scheherazade,
                fontSize: 19.sp,
                fontWeight: FontWeight.w500,
                height: 1.9,
              ),
            ),
          ),
          if (hasExplanation) ...[
            skin.divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              child: Text(
                context.l10n.hadith40Explanation,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: SelectableText(
                explanation.replaceAll('\r', '').trim(),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: skin.inkSoft,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.75,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final HugeIconData icon;
  final String tooltip;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: skin.iconChip,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: AppIcon(icon, color: skin.accent, size: 15.sp),
          ),
        ),
      ),
    );
  }
}
