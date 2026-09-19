import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// لبنات المكتبات المشتركة (السور، حصن المسلم، الرقية، أسماء الله، أذكار
/// بعد الصلاة) — أُعيد بناؤها على [AppSkin].
///
/// كانت كلها بطاقات بظلال وألوان من اللوحة القديمة (`context.primaryColor`
/// و`context.onSurfaceColor`)، فبقيت جزرًا بالثيم القديم داخل شاشات أُعيد
/// تصميمها. الآن: صفوف نحيلة بفواصل شعرة على أرضية التطبيق.

class UnifiedLibraryMeta {
  const UnifiedLibraryMeta({
    required this.label,
    required this.value,
    this.isPrimary = false,
  });

  final String label;
  final String value;
  final bool isPrimary;

  bool get hasValue => value.trim().isNotEmpty;
}

class UnifiedLibrarySection {
  const UnifiedLibrarySection({
    required this.title,
    required this.content,
    this.selectable = true,
  });

  final String title;
  final String content;
  final bool selectable;

  bool get hasContent => content.trim().isNotEmpty;
}

/// صفّ عنصر في قائمة مكتبة.
class UnifiedLibraryCard extends StatelessWidget {
  const UnifiedLibraryCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leadingLabel,
    this.badges = const [],
    this.onTap,
    this.trailingIcon,
    this.maxSubtitleLines = 2,
    this.margin = EdgeInsets.zero,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final String? leadingLabel;
  final List<UnifiedLibraryMeta> badges;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final int maxSubtitleLines;
  final EdgeInsetsGeometry margin;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final visibleBadges = badges.where((badge) => badge.hasValue).toList();
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final hasLeadingLabel =
        leadingLabel != null && leadingLabel!.trim().isNotEmpty;

    final row = Container(
      margin: margin,
      decoration: showDivider
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLeadingLabel) ...[
            _LeadingNumber(label: leadingLabel!),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                if (hasSubtitle)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      subtitle!,
                      maxLines: maxSubtitleLines,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                if (visibleBadges.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 7.h),
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: visibleBadges
                          .map((badge) => _LibraryBadge(meta: badge))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          if (trailingIcon != null) ...[
            SizedBox(width: 8.w),
            Icon(trailingIcon, size: 15.sp, color: skin.accent),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return row;
    }

    return InkWell(onTap: onTap, child: row);
  }
}

/// صفّ نتيجة بحث — أنحل من صفّ القائمة لأن القائمة المنسدلة أضيق.
class UnifiedLibrarySearchSuggestion extends StatelessWidget {
  const UnifiedLibrarySearchSuggestion({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final hasTrailing = trailing != null && trailing!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                if (hasSubtitle)
                  Text(
                    subtitle!,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
          if (hasTrailing) ...[
            SizedBox(width: 8.w),
            Text(
              trailing!,
              style: TextStyle(
                color: skin.accent,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ورقة التفاصيل: عنوان وأفعال، ثم أقسام يفصلها خطّ شعرة — بلا بطاقات.
class UnifiedLibraryDetailSheet extends StatelessWidget {
  const UnifiedLibraryDetailSheet({
    required this.title,
    required this.shareText,
    required this.copyText,
    this.subtitle,
    this.shareSubject,
    this.badges = const [],
    this.sections = const [],
    this.emptyText,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String shareText;
  final String copyText;
  final String? shareSubject;
  final List<UnifiedLibraryMeta> badges;
  final List<UnifiedLibrarySection> sections;

  /// Falls back to [L10n.coreNoData] when null.
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final emptyText = this.emptyText ?? context.l10n.coreNoData;
    final visibleBadges = badges.where((badge) => badge.hasValue).toList();
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final visibleSections =
        sections.where((section) => section.hasContent).toList();

    return ColoredBox(
      color: skin.ground,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: skin.ink,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      if (hasSubtitle)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            subtitle!,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                IconShareWidget(text: shareText, subject: shareSubject),
                CopyIconWidget(text: copyText),
              ],
            ),
            if (visibleBadges.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 9.h),
                child: Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: visibleBadges
                      .map((badge) => _LibraryBadge(meta: badge))
                      .toList(),
                ),
              ),
            if (visibleSections.isEmpty)
              _DetailSection(
                section: UnifiedLibrarySection(
                  title: context.l10n.coreContent,
                  content: emptyText,
                  selectable: false,
                ),
                emptyText: emptyText,
              )
            else
              ...visibleSections.map(
                (section) => _DetailSection(
                  section: section,
                  emptyText: emptyText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// رقم العنصر — مربّع صغير بلون الأيقونات، لا دائرة كبيرة.
class _LeadingNumber extends StatelessWidget {
  const _LeadingNumber({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: skin.accent,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LibraryBadge extends StatelessWidget {
  const _LibraryBadge({required this.meta});

  final UnifiedLibraryMeta meta;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color = meta.isPrimary ? skin.accent : skin.inkSoft;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: meta.isPrimary
            ? skin.iconChip
            : skin.inkSoft.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Text(
          '${meta.label}: ${meta.value}',
          style: TextStyle(
            color: color,
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.section, required this.emptyText});

  final UnifiedLibrarySection section;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isEmpty = section.content.trim().isEmpty;
    final content = isEmpty ? emptyText : section.content;
    // The Arabic library content stays RTL; the UI fallback follows the locale.
    final contentDirection = isEmpty ? null : TextDirection.rtl;
    final style = TextStyle(
      color: skin.ink.withValues(alpha: 0.9),
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 1.75,
    );

    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          SizedBox(height: 8.h),
          if (section.selectable)
            SelectableText(
              content,
              textDirection: contentDirection,
              style: style,
            )
          else
            Text(content, textDirection: contentDirection, style: style),
        ],
      ),
    );
  }
}
