import 'package:flutter/material.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

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

class UnifiedLibraryCard extends StatelessWidget {
  const UnifiedLibraryCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leadingLabel,
    this.badges = const [],
    this.onTap,
    this.trailingIcon = Icons.arrow_forward_ios_rounded,
    this.maxSubtitleLines = 2,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  });

  final String title;
  final String? subtitle;
  final String? leadingLabel;
  final List<UnifiedLibraryMeta> badges;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final int maxSubtitleLines;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final visibleBadges = badges.where((badge) => badge.hasValue).toList();
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final hasLeadingLabel =
        leadingLabel != null && leadingLabel!.trim().isNotEmpty;

    final card = CardWidget(
      margin: margin,
      child: Row(
        children: [
          if (hasLeadingLabel) ...[
            _LeadingNumber(label: leadingLabel!),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    maxLines: maxSubtitleLines,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: context.bodyMedium?.copyWith(
                      color: context.onSurfaceColor.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                ],
                if (visibleBadges.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleBadges
                        .map((badge) => _LibraryBadge(meta: badge))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 16,
              color: context.onSurfaceColor.withValues(alpha: 0.55),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: card,
    );
  }
}

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
    return ListTile(
      dense: true,
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: context.titleSmall,
      ),
      subtitle: subtitle == null || subtitle!.trim().isEmpty
          ? null
          : Text(
              subtitle!,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall,
            ),
      trailing: trailing == null || trailing!.trim().isEmpty
          ? null
          : Text(
              trailing!,
              style: context.bodySmall,
            ),
    );
  }
}

class UnifiedLibraryDetailSheet extends StatelessWidget {
  const UnifiedLibraryDetailSheet({
    required this.title,
    required this.shareText,
    required this.copyText,
    this.subtitle,
    this.shareSubject,
    this.badges = const [],
    this.sections = const [],
    this.emptyText = 'لا توجد بيانات.',
    super.key,
  });

  final String title;
  final String? subtitle;
  final String shareText;
  final String copyText;
  final String? shareSubject;
  final List<UnifiedLibraryMeta> badges;
  final List<UnifiedLibrarySection> sections;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final visibleBadges = badges.where((badge) => badge.hasValue).toList();
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final visibleSections = sections.where((section) => section.hasContent);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              textDirection: TextDirection.rtl,
                              style: context.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (hasSubtitle) ...[
                              const SizedBox(height: 6),
                              Text(
                                subtitle!,
                                textDirection: TextDirection.rtl,
                                style: context.bodyMedium?.copyWith(
                                  color: context.onSurfaceColor.withValues(
                                    alpha: 0.74,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          IconShareWidget(
                            text: shareText,
                            subject: shareSubject,
                          ),
                          CopyIconWidget(text: copyText),
                        ],
                      ),
                    ],
                  ),
                  if (visibleBadges.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: visibleBadges
                          .map((badge) => _LibraryBadge(meta: badge))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            ...visibleSections.map(
              (section) => _DetailSectionCard(
                section: section,
                emptyText: emptyText,
              ),
            ),
            if (sections.isEmpty || visibleSections.isEmpty)
              _DetailSectionCard(
                section: UnifiedLibrarySection(
                  title: 'المحتوى',
                  content: emptyText,
                  selectable: false,
                ),
                emptyText: emptyText,
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _LeadingNumber extends StatelessWidget {
  const _LeadingNumber({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: context.primaryColor.withValues(alpha: 0.14),
      child: Text(
        label,
        style: context.labelLarge?.copyWith(
          color: context.primaryColor,
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
    final color = meta.isPrimary ? context.primaryColor : context.onSurfaceColor;
    final background = meta.isPrimary
        ? context.primaryColor.withValues(alpha: 0.12)
        : context.onSurfaceColor.withValues(alpha: 0.08);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '${meta.label}: ${meta.value}',
          style: context.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  const _DetailSectionCard({
    required this.section,
    required this.emptyText,
  });

  final UnifiedLibrarySection section;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final content = section.content.trim().isEmpty ? emptyText : section.content;

    return CardWidget(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            section.title,
            textDirection: TextDirection.rtl,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          section.selectable
              ? SelectableText(
                  content,
                  textDirection: TextDirection.rtl,
                  style: context.bodyMedium?.copyWith(height: 1.65),
                )
              : Text(
                  content,
                  textDirection: TextDirection.rtl,
                  style: context.bodyMedium?.copyWith(height: 1.65),
                ),
        ],
      ),
    );
  }
}
