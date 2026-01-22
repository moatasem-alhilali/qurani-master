part of '../../../../../quran.dart';

/// فئة لتخصيص أنماط واجهة تبويب الفواصل
/// Class for customizing Bookmarks Tab styles
class BookmarksTabStyle {
  /// لون النص الأساسي
  /// Primary text color
  final Color? textColor;

  /// عرض حدود المجموعة
  /// Group border width
  final double? groupBorderWidth;

  /// نصف قطر حدود المجموعة
  /// Group border radius
  final double? groupBorderRadius;

  /// الهامش الأفقي للمجموعة
  /// Group horizontal margin
  final double? groupHorizontalMargin;

  /// الهامش العمودي للمجموعة
  /// Group vertical margin
  final double? groupVerticalMargin;

  /// حجم أيقونة الفاصلة في ExpansionTile
  /// Bookmark icon size in ExpansionTile
  final double? expansionTileIconSize;

  /// حجم خط العنوان
  /// Title font size
  final double? titleFontSize;

  /// وزن خط العنوان
  /// Title font weight
  final FontWeight? titleFontWeight;

  /// لون نص العنوان الفرعي
  /// Subtitle text color
  final Color? subtitleTextColor;

  /// حجم خط العنوان الفرعي
  /// Subtitle font size
  final double? subtitleFontSize;

  /// الحشو الأفقي للعنصر
  /// Item horizontal padding
  final double? itemHorizontalPadding;

  /// الحشو العمودي للعنصر
  /// Item vertical padding
  final double? itemVerticalPadding;

  /// نصف قطر حدود العنصر
  /// Item border radius
  final double? itemBorderRadius;

  /// عرض حدود العنصر
  /// Item border width
  final double? itemBorderWidth;

  /// الحشو العمودي لمحتوى العنصر
  /// Item content vertical padding
  final double? itemContentVerticalPadding;

  /// الحشو الأفقي لمحتوى العنصر
  /// Item content horizontal padding
  final double? itemContentHorizontalPadding;

  /// ارتفاع الحاوية الرائدة
  /// Leading container height
  final double? leadingContainerHeight;

  /// عرض الحاوية الرائدة
  /// Leading container width
  final double? leadingContainerWidth;

  /// نصف قطر حدود الحاوية الرائدة
  /// Leading container border radius
  final double? leadingContainerBorderRadius;

  /// عرض حدود الحاوية الرائدة
  /// Leading container border width
  final double? leadingContainerBorderWidth;

  /// حجم أيقونة الفاصلة في الحاوية الرائدة
  /// Leading bookmark icon size
  final double? leadingBookmarkIconSize;

  /// حجم خط رقم الآية في الحاوية الرائدة
  /// Leading ayah number font size
  final double? leadingAyahNumberFontSize;

  /// المسافة بين الحاوية الرائدة والنص
  /// Space between leading container and text
  final double? leadingToTextSpacing;

  /// حجم خط اسم الفاصلة
  /// Bookmark name font size
  final double? bookmarkNameFontSize;

  /// وزن خط اسم الفاصلة
  /// Bookmark name font weight
  final FontWeight? bookmarkNameFontWeight;

  /// المسافة بين اسم الفاصلة والرقاقات
  /// Space between bookmark name and chips
  final double? nameToChipsSpacing;

  /// حجم خط الرقاقة
  /// Chip font size
  final double? chipFontSize;

  /// نصف قطر حدود الرقاقة
  /// Chip border radius
  final double? chipBorderRadius;

  /// الحشو الأفقي للرقاقة
  /// Chip horizontal padding
  final double? chipHorizontalPadding;

  /// الحشو العمودي للرقاقة
  /// Chip vertical padding
  final double? chipVerticalPadding;

  /// المسافة بين الرقاقات
  /// Spacing between chips
  final double? chipSpacing;

  /// المسافة بين أسطر الرقاقات
  /// Run spacing between chip rows
  final double? chipRunSpacing;

  /// المسافة بين النص والأيقونة
  /// Space between text and chevron icon
  final double? textToChevronSpacing;

  /// حجم أيقونة السهم
  /// Chevron icon size
  final double? chevronIconSize;

  /// حجم أيقونة الحالة الفارغة
  /// Empty state icon size
  final double? emptyStateIconSize;

  /// لون أيقونة الحالة الفارغة
  /// Empty state icon color
  final Color? emptyStateIconColor;

  /// نص الحالة الفارغة
  /// Empty state text
  final String? emptyStateText;

  /// حجم خط نص الحالة الفارغة
  /// Empty state text font size
  final double? emptyStateTextFontSize;

  /// لون نص الحالة الفارغة
  /// Empty state text color
  final Color? emptyStateTextColor;

  /// المسافة بين أيقونة الحالة الفارغة والنص
  /// Space between empty state icon and text
  final double? emptyStateIconToTextSpacing;

  /// نص المجموعة الصفراء
  /// Yellow group text
  final String? yellowGroupText;

  /// نص المجموعة الحمراء
  /// Red group text
  final String? redGroupText;

  /// نص المجموعة الخضراء
  /// Green group text
  final String? greenGroupText;

  /// الحشو الأفقي لـ ExpansionTile
  /// ExpansionTile horizontal padding
  final double? expansionTilePaddingHorizontal;

  /// الحشو الأفقي لمحتوى الأطفال
  /// Children padding horizontal
  final double? childrenPaddingHorizontal;

  /// الحشو العمودي لمحتوى الأطفال
  /// Children padding vertical
  final double? childrenPaddingVertical;

  /// منشئ فئة BookmarksTabStyle
  /// BookmarksTabStyle class constructor
  BookmarksTabStyle({
    this.textColor,
    this.groupBorderWidth,
    this.groupBorderRadius,
    this.groupHorizontalMargin,
    this.groupVerticalMargin,
    this.expansionTileIconSize,
    this.titleFontSize,
    this.titleFontWeight,
    this.subtitleTextColor,
    this.subtitleFontSize,
    this.itemHorizontalPadding,
    this.itemVerticalPadding,
    this.itemBorderRadius,
    this.itemBorderWidth,
    this.itemContentVerticalPadding,
    this.itemContentHorizontalPadding,
    this.leadingContainerHeight,
    this.leadingContainerWidth,
    this.leadingContainerBorderRadius,
    this.leadingContainerBorderWidth,
    this.leadingBookmarkIconSize,
    this.leadingAyahNumberFontSize,
    this.leadingToTextSpacing,
    this.bookmarkNameFontSize,
    this.bookmarkNameFontWeight,
    this.nameToChipsSpacing,
    this.chipFontSize,
    this.chipBorderRadius,
    this.chipHorizontalPadding,
    this.chipVerticalPadding,
    this.chipSpacing,
    this.chipRunSpacing,
    this.textToChevronSpacing,
    this.chevronIconSize,
    this.emptyStateIconSize,
    this.emptyStateIconColor,
    this.emptyStateText,
    this.emptyStateTextFontSize,
    this.emptyStateTextColor,
    this.emptyStateIconToTextSpacing,
    this.yellowGroupText,
    this.redGroupText,
    this.greenGroupText,
    this.expansionTilePaddingHorizontal,
    this.childrenPaddingHorizontal,
    this.childrenPaddingVertical,
  });

  BookmarksTabStyle copyWith({
    Color? textColor,
    double? groupBorderWidth,
    double? groupBorderRadius,
    double? groupHorizontalMargin,
    double? groupVerticalMargin,
    double? expansionTileIconSize,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    Color? subtitleTextColor,
    double? subtitleFontSize,
    double? itemHorizontalPadding,
    double? itemVerticalPadding,
    double? itemBorderRadius,
    double? itemBorderWidth,
    double? itemContentVerticalPadding,
    double? itemContentHorizontalPadding,
    double? leadingContainerHeight,
    double? leadingContainerWidth,
    double? leadingContainerBorderRadius,
    double? leadingContainerBorderWidth,
    double? leadingBookmarkIconSize,
    double? leadingAyahNumberFontSize,
    double? leadingToTextSpacing,
    double? bookmarkNameFontSize,
    FontWeight? bookmarkNameFontWeight,
    double? nameToChipsSpacing,
    double? chipFontSize,
    double? chipBorderRadius,
    double? chipHorizontalPadding,
    double? chipVerticalPadding,
    double? chipSpacing,
    double? chipRunSpacing,
    double? textToChevronSpacing,
    double? chevronIconSize,
    double? emptyStateIconSize,
    Color? emptyStateIconColor,
    String? emptyStateText,
    double? emptyStateTextFontSize,
    Color? emptyStateTextColor,
    double? emptyStateIconToTextSpacing,
    String? yellowGroupText,
    String? redGroupText,
    String? greenGroupText,
    double? expansionTilePaddingHorizontal,
    double? childrenPaddingHorizontal,
    double? childrenPaddingVertical,
  }) {
    return BookmarksTabStyle(
      textColor: textColor ?? this.textColor,
      groupBorderWidth: groupBorderWidth ?? this.groupBorderWidth,
      groupBorderRadius: groupBorderRadius ?? this.groupBorderRadius,
      groupHorizontalMargin:
          groupHorizontalMargin ?? this.groupHorizontalMargin,
      groupVerticalMargin: groupVerticalMargin ?? this.groupVerticalMargin,
      expansionTileIconSize:
          expansionTileIconSize ?? this.expansionTileIconSize,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      subtitleTextColor: subtitleTextColor ?? this.subtitleTextColor,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      itemVerticalPadding: itemVerticalPadding ?? this.itemVerticalPadding,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemBorderWidth: itemBorderWidth ?? this.itemBorderWidth,
      itemContentVerticalPadding:
          itemContentVerticalPadding ?? this.itemContentVerticalPadding,
      itemContentHorizontalPadding:
          itemContentHorizontalPadding ?? this.itemContentHorizontalPadding,
      leadingContainerHeight:
          leadingContainerHeight ?? this.leadingContainerHeight,
      leadingContainerWidth:
          leadingContainerWidth ?? this.leadingContainerWidth,
      leadingContainerBorderRadius:
          leadingContainerBorderRadius ?? this.leadingContainerBorderRadius,
      leadingContainerBorderWidth:
          leadingContainerBorderWidth ?? this.leadingContainerBorderWidth,
      leadingBookmarkIconSize:
          leadingBookmarkIconSize ?? this.leadingBookmarkIconSize,
      leadingAyahNumberFontSize:
          leadingAyahNumberFontSize ?? this.leadingAyahNumberFontSize,
      leadingToTextSpacing: leadingToTextSpacing ?? this.leadingToTextSpacing,
      bookmarkNameFontSize: bookmarkNameFontSize ?? this.bookmarkNameFontSize,
      bookmarkNameFontWeight:
          bookmarkNameFontWeight ?? this.bookmarkNameFontWeight,
      nameToChipsSpacing: nameToChipsSpacing ?? this.nameToChipsSpacing,
      chipFontSize: chipFontSize ?? this.chipFontSize,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipHorizontalPadding:
          chipHorizontalPadding ?? this.chipHorizontalPadding,
      chipVerticalPadding: chipVerticalPadding ?? this.chipVerticalPadding,
      chipSpacing: chipSpacing ?? this.chipSpacing,
      chipRunSpacing: chipRunSpacing ?? this.chipRunSpacing,
      textToChevronSpacing: textToChevronSpacing ?? this.textToChevronSpacing,
      chevronIconSize: chevronIconSize ?? this.chevronIconSize,
      emptyStateIconSize: emptyStateIconSize ?? this.emptyStateIconSize,
      emptyStateIconColor: emptyStateIconColor ?? this.emptyStateIconColor,
      emptyStateText: emptyStateText ?? this.emptyStateText,
      emptyStateTextFontSize:
          emptyStateTextFontSize ?? this.emptyStateTextFontSize,
      emptyStateTextColor: emptyStateTextColor ?? this.emptyStateTextColor,
      emptyStateIconToTextSpacing:
          emptyStateIconToTextSpacing ?? this.emptyStateIconToTextSpacing,
      yellowGroupText: yellowGroupText ?? this.yellowGroupText,
      redGroupText: redGroupText ?? this.redGroupText,
      greenGroupText: greenGroupText ?? this.greenGroupText,
      expansionTilePaddingHorizontal:
          expansionTilePaddingHorizontal ?? this.expansionTilePaddingHorizontal,
      childrenPaddingHorizontal:
          childrenPaddingHorizontal ?? this.childrenPaddingHorizontal,
      childrenPaddingVertical:
          childrenPaddingVertical ?? this.childrenPaddingVertical,
    );
  }

  /// القيم الافتراضية الموحدة حسب الثيم
  /// Unified defaults based on theme
  factory BookmarksTabStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final textColor = AppColors.getTextColor(isDark);

    return BookmarksTabStyle(
      // ألوان عامة
      textColor: textColor,
      subtitleTextColor: textColor.withValues(alpha: 0.7),

      // المجموعات
      groupBorderWidth: 1.0,
      groupBorderRadius: 12.0,
      groupHorizontalMargin: 12.0,
      groupVerticalMargin: 6.0,

      // ExpansionTile
      expansionTileIconSize: 24.0,
      expansionTilePaddingHorizontal: 12.0,
      childrenPaddingHorizontal: 8.0,
      childrenPaddingVertical: 6.0,

      // النصوص
      titleFontSize: 16.0,
      titleFontWeight: FontWeight.w700,
      subtitleFontSize: 12.0,

      // العناصر
      itemHorizontalPadding: 4.0,
      itemVerticalPadding: 4.0,
      itemBorderRadius: 10.0,
      itemBorderWidth: 1.0,
      itemContentVerticalPadding: 8.0,
      itemContentHorizontalPadding: 10.0,

      // الحاوية الرائدة
      leadingContainerHeight: 36.0,
      leadingContainerWidth: 30.0,
      leadingContainerBorderRadius: 6.0,
      leadingContainerBorderWidth: 1.0,
      leadingBookmarkIconSize: 26.0,
      leadingAyahNumberFontSize: 12.0,
      leadingToTextSpacing: 10.0,

      // أسماء الفواصل
      bookmarkNameFontSize: 15.0,
      bookmarkNameFontWeight: FontWeight.w600,
      nameToChipsSpacing: 4.0,

      // الرقاقات (Chips)
      chipFontSize: 12.0,
      chipBorderRadius: 999.0,
      chipHorizontalPadding: 8.0,
      chipVerticalPadding: 2.0,
      chipSpacing: 6.0,
      chipRunSpacing: -6.0,

      // الأيقونات
      chevronIconSize: 24.0,
      textToChevronSpacing: 8.0,

      // الحالة الفارغة
      emptyStateIconSize: 48.0,
      emptyStateIconColor: textColor.withValues(alpha: 0.5),
      emptyStateText: 'لا توجد فواصل محفوظة',
      emptyStateTextFontSize: 14.0,
      emptyStateTextColor: textColor.withValues(alpha: 0.7),
      emptyStateIconToTextSpacing: 16.0,

      // نصوص المجموعات
      yellowGroupText: 'الفواصل الصفراء',
      redGroupText: 'الفواصل الحمراء',
      greenGroupText: 'الفواصل الخضراء',
    );
  }
}
