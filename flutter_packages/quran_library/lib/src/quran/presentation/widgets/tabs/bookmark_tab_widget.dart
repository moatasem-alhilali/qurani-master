part of '/quran.dart';

class _BookmarksTab extends StatelessWidget {
  final bool isDark;
  final String languageCode;
  final BookmarksTabStyle? style;
  const _BookmarksTab({
    required this.isDark,
    required this.languageCode,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        (BookmarksTabTheme.of(context)?.style ??
            BookmarksTabStyle.defaults(isDark: isDark, context: context));

    return SingleChildScrollView(
      child: Column(
        children: [
          ...BookmarksCtrl.instance.bookmarks.entries.map((entry) {
            final int colorCode = entry.key;
            final groupColor = Color(colorCode);
            final bookmarks = entry.value;

            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: effectiveStyle.groupHorizontalMargin!,
                  vertical: effectiveStyle.groupVerticalMargin!),
              decoration: BoxDecoration(
                color: groupColor.withValues(alpha: 0.06),
                borderRadius:
                    BorderRadius.circular(effectiveStyle.groupBorderRadius!),
                border: Border.all(
                    color: groupColor.withValues(alpha: 0.25),
                    width: effectiveStyle.groupBorderWidth!),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(
                      horizontal:
                          effectiveStyle.expansionTilePaddingHorizontal!),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        effectiveStyle.groupBorderRadius!),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        effectiveStyle.groupBorderRadius!),
                  ),
                  leading: Icon(Icons.bookmark,
                      color: groupColor,
                      size: effectiveStyle.expansionTileIconSize!),
                  title: Text(
                    colorCode == 0xAAFFD354
                        ? effectiveStyle.yellowGroupText!
                        : colorCode == 0xAAF36077
                            ? effectiveStyle.redGroupText!
                            : effectiveStyle.greenGroupText!,
                    style: QuranLibrary().cairoStyle.copyWith(
                        fontSize: effectiveStyle.titleFontSize!,
                        fontWeight: effectiveStyle.titleFontWeight!,
                        color: effectiveStyle.textColor!),
                  ),
                  subtitle: Text(
                    'عدد: ${bookmarks.length}'.convertNumbersAccordingToLang(
                        languageCode: languageCode),
                    style: QuranLibrary().cairoStyle.copyWith(
                        color: effectiveStyle.subtitleTextColor!,
                        fontSize: effectiveStyle.subtitleFontSize!),
                  ),
                  childrenPadding: EdgeInsets.symmetric(
                      horizontal: effectiveStyle.childrenPaddingHorizontal!,
                      vertical: effectiveStyle.childrenPaddingVertical!),
                  children: bookmarks.map((bookmark) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: effectiveStyle.itemVerticalPadding!,
                          horizontal: effectiveStyle.itemHorizontalPadding!),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              effectiveStyle.itemBorderRadius!),
                          onTap: () {
                            Navigator.pop(context);
                            QuranLibrary().jumpToBookmark(bookmark);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: groupColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(
                                  effectiveStyle.itemBorderRadius!),
                              border: Border.all(
                                  color: groupColor.withValues(alpha: 0.2),
                                  width: effectiveStyle.itemBorderWidth!),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    effectiveStyle.itemContentVerticalPadding!,
                                horizontal: effectiveStyle
                                    .itemContentHorizontalPadding!),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Leading visual
                                Container(
                                  height:
                                      effectiveStyle.leadingContainerHeight!,
                                  width: effectiveStyle.leadingContainerWidth!,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        effectiveStyle
                                            .leadingContainerBorderRadius!),
                                    border: Border.all(
                                        color: groupColor,
                                        width: effectiveStyle
                                            .leadingContainerBorderWidth!),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.bookmark,
                                          color: Color(bookmark.colorCode),
                                          size: effectiveStyle
                                              .leadingBookmarkIconSize!),
                                      Text(
                                        bookmark.ayahNumber
                                            .toString()
                                            .convertNumbersAccordingToLang(
                                                languageCode: languageCode),
                                        style: QuranLibrary()
                                            .cairoStyle
                                            .copyWith(
                                                fontSize: effectiveStyle
                                                    .leadingAyahNumberFontSize!),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        effectiveStyle.leadingToTextSpacing!),
                                // Title and chips
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookmark.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: QuranLibrary()
                                            .cairoStyle
                                            .copyWith(
                                                fontSize: effectiveStyle
                                                    .bookmarkNameFontSize!,
                                                fontWeight:
                                                    effectiveStyle
                                                        .bookmarkNameFontWeight!,
                                                color:
                                                    effectiveStyle.textColor!),
                                      ),
                                      SizedBox(
                                          height: effectiveStyle
                                              .nameToChipsSpacing!),
                                      Wrap(
                                        spacing: effectiveStyle.chipSpacing!,
                                        runSpacing:
                                            effectiveStyle.chipRunSpacing!,
                                        children: [
                                          _chip(
                                            context,
                                            effectiveStyle,
                                            'آية ${bookmark.ayahNumber}'
                                                .convertNumbersAccordingToLang(
                                                    languageCode: languageCode),
                                            groupColor.withValues(alpha: 0.12),
                                            effectiveStyle.textColor!,
                                          ),
                                          if (bookmark.page > 0)
                                            _chip(
                                              context,
                                              effectiveStyle,
                                              'صفحة ${bookmark.page}'
                                                  .convertNumbersAccordingToLang(
                                                      languageCode:
                                                          languageCode),
                                              groupColor.withValues(
                                                  alpha: 0.12),
                                              effectiveStyle.textColor!,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        effectiveStyle.textToChevronSpacing!),
                                Icon(Icons.chevron_left,
                                    color: effectiveStyle.textColor!,
                                    size: effectiveStyle.chevronIconSize!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
          if (BookmarksCtrl.instance.bookmarks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: effectiveStyle.emptyStateIconSize!,
                    color: effectiveStyle.emptyStateIconColor!,
                  ),
                  SizedBox(height: effectiveStyle.emptyStateIconToTextSpacing!),
                  Text(
                    effectiveStyle.emptyStateText!,
                    style: QuranLibrary().cairoStyle.copyWith(
                          color: effectiveStyle.emptyStateTextColor!,
                          fontSize: effectiveStyle.emptyStateTextFontSize!,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    BookmarksTabStyle effectiveStyle,
    String label,
    Color bg,
    Color fg,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: effectiveStyle.chipVerticalPadding!,
          horizontal: effectiveStyle.chipHorizontalPadding!),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(effectiveStyle.chipBorderRadius!),
      ),
      child: Text(
        label,
        style: QuranLibrary()
            .cairoStyle
            .copyWith(fontSize: effectiveStyle.chipFontSize!, color: fg),
      ),
    );
  }
}
