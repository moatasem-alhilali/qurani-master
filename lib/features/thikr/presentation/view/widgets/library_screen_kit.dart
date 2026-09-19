import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// أدوات الشاشات المكتبية: حصن المسلم، الرقية الشرعية، أسماء الله الحسنى.
///
/// كلّها قوائم طويلة، وكانت كل فقرة فيها تجلس داخل بطاقة بظلّ وحدّ، فصارت
/// الصفحة شريطًا من الصناديق لا يبرز فيها شيء. هنا المحتوى يجلس على
/// `skin.ground` مباشرة، ويفصل بين الصفوف خطّ بسُمك شعرة.

/// يجعل الشاشة كلّها أرضية واحدة: الترويسة والمحتوى وما تحته.
///
/// `AppScaffoldWidget` يأخذ خلفيته من الثيم العام (رمادي بارد)، فتظهر
/// حاشية باردة فوق المحتوى الورقي وتحته. هنا نغيّر لون السكافولد للشاشة
/// وحدها إلى `skin.ground` بدل تعديل الويدجت المشترك.
class GroundScaffoldTheme extends StatelessWidget {
  const GroundScaffoldTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: child,
    );
  }
}

/// يمدّ أرضية الصفحة خلف القائمة كلّها، لا خلف كل صفّ على حدة.
///
/// النوع المُعاد `SliverPadding` عمدًا: `whenSliver` يلفّ كل ما ليس sliver
/// معروفًا داخل `SliverToBoxAdapter`، فيكسر أي غلاف مخصّص.
SliverPadding librarySliverGround(
  BuildContext context, {
  required Widget sliver,
}) {
  final skin = AppSkin.of(context);

  return SliverPadding(
    padding: EdgeInsets.zero,
    sliver: DecoratedSliver(
      decoration: BoxDecoration(color: skin.ground),
      sliver: sliver,
    ),
  );
}

/// صفّ قائمة: رقم الترتيب، عنوان، وصف مختصر، ثم سهم.
class LibraryRow extends StatelessWidget {
  const LibraryRow({
    required this.order,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingLabel,
    this.titleFontFamily,
    this.titleSize,
    this.isLast = false,
    super.key,
  });

  final int order;
  final String title;
  final String? subtitle;

  /// قيمة صغيرة تُقرأ من طرف الصفّ، مثل عدد التكرار.
  final String? trailingLabel;
  final String? titleFontFamily;
  final double? titleSize;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final description = subtitle?.trim() ?? '';
    final badge = trailingLabel?.trim() ?? '';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: skin.hairline),
                ),
              ),
        child: Row(
          children: [
            LibraryOrderChip(order: order),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: titleFontFamily,
                      color: skin.ink,
                      fontSize: titleSize ?? 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: titleFontFamily == null ? 1.2 : 1.45,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (badge.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Text(
                badge,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ],
            SizedBox(width: 6.w),
            AppIcon(
              Directionality.of(context) == TextDirection.rtl
                  ? AppIcons.chevronLeft
                  : AppIcons.chevronRight,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// مربّع رقم الترتيب — بديل البطاقة، لا حدّ ولا ظلّ.
class LibraryOrderChip extends StatelessWidget {
  const LibraryOrderChip({required this.order, super.key});

  final int order;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        '$order',
        style: TextStyle(
          color: skin.accent,
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// حالة «لا نتائج» — سطران وزرّ نصّي، بلا بطاقة.
class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon = AppIcons.searchOff,
    super.key,
  });

  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final note = message?.trim() ?? '';
    final hasAction = actionLabel != null && onAction != null;

    return ColoredBox(
      color: skin.ground,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                icon,
                color: skin.accent.withValues(alpha: 0.6),
                size: 22.sp,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (note.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  note,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
              if (hasAction) ...[
                SizedBox(height: 10.h),
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(999.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        color: skin.accent,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// قسم داخل ورقة التفاصيل: عنوان صغير ثم نصّ بخطّ المصحف.
class LibraryDetailSection {
  const LibraryDetailSection({
    required this.title,
    required this.content,
    this.scripture = true,
  });

  final String title;
  final String content;

  /// النصوص المتلوّة بخطّ `scheherazade`، والشروح بخطّ الواجهة.
  final bool scripture;

  bool get hasContent => content.trim().isNotEmpty;
}

/// يفتح ورقة تفاصيل على أرضية الشاشة نفسها.
///
/// `context.showBottomSheet` يتجاهل لون الخلفية الممرَّر ويأخذ لون
/// السكافولد، فنفتح الورقة هنا مباشرة حتى تبقى على `skin.ground`.
Future<void> showLibraryDetailSheet(
  BuildContext context, {
  required String title,
  required String shareText,
  required List<LibraryDetailSection> sections,
  String? subtitle,
  String? shareSubject,
  List<String> facts = const [],
  double titleSize = 15,
  String? titleFontFamily,
}) {
  final skin = AppSkin.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: skin.ground,
    isScrollControlled: true,
    elevation: 0,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
    ),
    builder: (sheetContext) {
      return LibraryDetailSheet(
        title: title,
        subtitle: subtitle,
        shareText: shareText,
        shareSubject: shareSubject,
        facts: facts,
        sections: sections,
        titleSize: titleSize,
        titleFontFamily: titleFontFamily,
      );
    },
  );
}

/// محتوى ورقة التفاصيل: مقبض، عنوان، مشاركة ونسخ، ثم الأقسام.
class LibraryDetailSheet extends StatelessWidget {
  const LibraryDetailSheet({
    required this.title,
    required this.shareText,
    required this.sections,
    this.subtitle,
    this.shareSubject,
    this.facts = const [],
    this.titleSize = 15,
    this.titleFontFamily,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String shareText;
  final String? shareSubject;
  final List<String> facts;
  final List<LibraryDetailSection> sections;
  final double titleSize;
  final String? titleFontFamily;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final visible = sections.where((section) => section.hasContent).toList();
    final note = subtitle?.trim() ?? '';
    final visibleFacts = facts.where((fact) => fact.trim().isNotEmpty).toList();

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.w, 2.h, 16.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: titleFontFamily,
                            color: skin.ink,
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                        if (note.isNotEmpty)
                          Text(
                            note,
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconShareWidget(text: shareText, subject: shareSubject),
                  CopyIconWidget(text: shareText),
                ],
              ),
            ),
            if (visibleFacts.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Text(
                  visibleFacts.join('  ·  '),
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            skin.divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  return _SheetSection(
                    section: visible[index],
                    isLast: index == visible.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({required this.section, required this.isLast});

  final LibraryDetailSection section;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              section.title,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Divider(height: 1, thickness: 1, color: skin.hairline),
            ),
          ],
        ),
        SizedBox(height: 7.h),
        SelectableText(
          section.content.trim(),
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: section.scripture ? FontFamily.scheherazade : null,
            color: skin.ink,
            fontSize: section.scripture ? 16.sp : 11.sp,
            height: section.scripture ? 1.9 : 1.6,
            fontWeight: section.scripture ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
        if (!isLast) SizedBox(height: 16.h),
      ],
    );
  }
}
