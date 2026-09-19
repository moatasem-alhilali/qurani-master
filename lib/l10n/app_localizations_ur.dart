// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class L10nUr extends L10n {
  L10nUr([String locale = 'ur']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'تیرتے اذکار';

  @override
  String get floatingAdhkarSourceBuiltIn => 'پہلے سے شامل';

  @override
  String get floatingAdhkarSourceCustom => 'ذاتی';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'میرے اذکار';

  @override
  String get floatingAdhkarSourceAppLibrary => 'ایپ لائبریری';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'پہلے سے شامل ذکر';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'بے ترتیب ذکر';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'بے ترتیب اذکار';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'تیرتے بے ترتیب اذکار';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'تیرتے اذکار کی سروس پس منظر میں چل رہی ہے';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'یہ سہولت اس پلیٹ فارم پر دستیاب نہیں۔';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'iPhone پر اذکار کی یاد دہانیاں چلانے کے لیے اطلاعات کی اجازت دیں۔';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'پہلے دوسری ایپس کے اوپر دکھانے کی اجازت دیں۔';

  @override
  String get floatingAdhkarErrorNoSource =>
      'تیرتے اذکار کے لیے کم از کم ایک ذریعہ فعال کریں۔';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'iPhone یاد دہانیوں کے لیے اطلاعات کی اجازت ضروری ہے۔';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'تیرتی ونڈو چلانے کے لیے اجازت ضروری ہے۔';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'پہلے سے شامل ذکر اپ ڈیٹ کرنے کے لیے عنوان اور متن ضروری ہیں۔';

  @override
  String get floatingAdhkarErrorNotificationsDenied =>
      'اطلاعات کی اجازت نہیں دی گئی۔';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'دوسری ایپس کے اوپر دکھانے کی اجازت نہیں دی گئی۔';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'پہلے یہ سہولت فعال کریں، پھر براہِ راست پیش منظر استعمال کریں۔';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'ابھی ذکر دکھانے کے لیے اطلاعات کی اجازت ضروری ہے۔';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'تیرتا ذکر دکھانے کے لیے اجازت ضروری ہے۔';

  @override
  String get floatingAdhkarStatusUnsupported => 'معاونت نہیں';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'اجازت درکار';

  @override
  String get floatingAdhkarStatusMisconfigured => 'ترتیب درکار';

  @override
  String get floatingAdhkarStatusActive => 'چل رہی ہے';

  @override
  String get floatingAdhkarStatusInactive => 'بند ہے';

  @override
  String get floatingAdhkarManageTitle => 'اذکار کا انتظام';

  @override
  String get floatingAdhkarManageSubtitle =>
      'پہلے سے شامل اذکار میں سے چنیں اور اپنے اذکار شامل کریں';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'ذاتی ذکر شامل کریں';

  @override
  String get floatingAdhkarAddCustomTitle => 'ذاتی ذکر شامل کریں';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'فعال کرنے پر یہ تیرتے اذکار میں شامل ہو جائے گا۔';

  @override
  String get floatingAdhkarEditTitle => 'ذکر میں ترمیم';

  @override
  String get floatingAdhkarEditSubtitle =>
      'متن اپ ڈیٹ کریں اور فوراً تبدیلیاں محفوظ کریں۔';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$total میں سے $enabled';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle =>
      'کوئی پہلے سے شامل ذکر دستیاب نہیں';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'ایپ میں پہلے سے شامل اذکار کی لائبریری نہیں ملی۔';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'ابھی کوئی ذاتی ذکر نہیں';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'اپنا ذکر یا دعا شامل کریں تاکہ وہ بے ترتیب تیرتے اذکار میں آئے۔';

  @override
  String get floatingAdhkarAddNewDhikr => 'نیا ذکر شامل کریں';

  @override
  String get floatingAdhkarItemOptions => 'ذکر کے اختیارات';

  @override
  String get floatingAdhkarTabBuiltIn => 'پہلے سے شامل اذکار';

  @override
  String get floatingAdhkarTabCustom => 'ذاتی اذکار';

  @override
  String get floatingAdhkarPreviewHeader => 'ذکر کا پیش منظر';

  @override
  String get floatingAdhkarAdvancedTitle => 'اعلیٰ ترتیبات';

  @override
  String get floatingAdhkarAdvancedSubtitle =>
      'ظاہر ہونے کی رفتار، دورانیہ اور ذرائع';

  @override
  String get floatingAdhkarFrequencyTitle => 'ظاہر ہونے کی رفتار';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'ذکر کتنی دیر رہے';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سیکنڈ',
      one: '$count سیکنڈ',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'اذکار کے ذرائع';

  @override
  String get floatingAdhkarAllowNotifications => 'اطلاعات کی اجازت دیں';

  @override
  String get floatingAdhkarGrantPermission => 'مطلوبہ اجازت دیں';

  @override
  String get floatingAdhkarPermissionHint =>
      'اس کے بغیر ذکر دوسری ایپس کے اوپر نظر نہیں آئے گا';

  @override
  String get floatingAdhkarSendNow => 'ابھی ذکر بھیجیں';

  @override
  String get floatingAdhkarShowNow => 'ابھی ذکر دکھائیں';

  @override
  String get floatingAdhkarPreviewReadyHint =>
      'دیکھیں ذکر آپ کو کیسا نظر آئے گا';

  @override
  String get floatingAdhkarPreviewDisabledHint =>
      'پہلے سروس فعال کریں اور اجازت دیں';

  @override
  String get floatingAdhkarIosReminders => 'iPhone یاد دہانیاں';

  @override
  String get floatingAdhkarFloatingService => 'تیرتی سروس';

  @override
  String get floatingAdhkarUnsupportedPlatform => 'اس پلیٹ فارم پر معاونت نہیں';

  @override
  String get floatingAdhkarStatBuiltIn => 'پہلے سے شامل';

  @override
  String get floatingAdhkarStatCustom => 'ذاتی';

  @override
  String get floatingAdhkarSettingsTitleIos => 'اذکار یاد دہانی کی ترتیبات';

  @override
  String get floatingAdhkarSettingsTitle => 'تیرتے اذکار کی ترتیبات';

  @override
  String get floatingAdhkarReminderTiming => 'یاد دہانی کا وقت';

  @override
  String get floatingAdhkarAppearanceTiming => 'ظاہر ہونے کا وقت';

  @override
  String get floatingAdhkarReminderFrequency => 'یاد دہانی کتنی بار';

  @override
  String get floatingAdhkarAppearanceFrequency => 'کتنی بار ظاہر ہو';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle =>
      'ایپ کا بنیادی اندرونی ذریعہ';

  @override
  String get floatingAdhkarCustomSourceSubtitle =>
      'آپ کے خود شامل کیے ہوئے اذکار';

  @override
  String get floatingAdhkarMixSources => 'ذرائع ملا دیں';

  @override
  String get floatingAdhkarMixSourcesOn => 'ایک مشترکہ فہرست سے انتخاب ہوتا ہے';

  @override
  String get floatingAdhkarMixSourcesOff =>
      'پہلے سے شامل اور ذاتی اذکار باری باری آتے ہیں';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'محفوظ کرنے سے پہلے کم از کم ایک ذریعہ فعال کریں۔';

  @override
  String get floatingAdhkarMasterSwitch => 'سہولت مکمل طور پر چلائیں';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'iPhone پر اذکار کی اطلاعات شیڈول ہوتی ہیں';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'پس منظر کی سروس اذکار دکھانا شروع کرتی ہے';

  @override
  String get floatingAdhkarSaveSettings => 'ترتیبات محفوظ کریں';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ہر $count منٹ',
      one: 'ہر منٹ',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'پہلے سے شامل اور ذاتی ملا کر';

  @override
  String get floatingAdhkarSourcesAlternating =>
      'پہلے سے شامل اور ذاتی باری باری';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'صرف پہلے سے شامل اذکار';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'صرف صارف کے اذکار';

  @override
  String get floatingAdhkarSourcesNone => 'کوئی ذریعہ فعال نہیں';

  @override
  String get sabihTitle => 'تسبیح';

  @override
  String get sabihBeadWalnut => 'اخروٹ';

  @override
  String get sabihBeadOak => 'بلوط';

  @override
  String get sabihBeadEmerald => 'زمرد';

  @override
  String get sabihBeadOnyx => 'سیاہ عقیق';

  @override
  String get sabihBeadAmber => 'کہربا';

  @override
  String get sabihBeadMahogany => 'مہوگنی';

  @override
  String get sabihBeadSage => 'زیتونی';

  @override
  String get sabihBeadGarnet => 'سرخ عقیق';

  @override
  String get sabihErrorRefreshList => 'اذکار کی فہرست تازہ نہیں ہو سکی۔';

  @override
  String get sabihErrorLoad => 'اذکار لوڈ نہیں ہو سکے۔';

  @override
  String get sabihErrorRecord => 'ذکر محفوظ نہیں ہو سکا۔';

  @override
  String get sabihErrorResetToday => 'آج کا کاؤنٹر صفر نہیں ہو سکا۔';

  @override
  String get sabihAnalyticsTitle => 'اعداد و شمار';

  @override
  String get sabihTabOverview => 'جائزہ';

  @override
  String get sabihTabDetails => 'اذکار کی تفصیل';

  @override
  String get sabihDhikrSettingsTooltip => 'ذکر کی ترتیبات';

  @override
  String get sabihAddCustomDhikr => 'ذاتی ذکر شامل کریں';

  @override
  String get sabihEmptyMessage => 'کوئی ذکر نہیں ملا';

  @override
  String get sabihAddFirst => 'اپنا پہلا ذکر شامل کریں';

  @override
  String get sabihSaveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get sabihAddDhikr => 'ذکر شامل کریں';

  @override
  String get sabihSaveFailed => 'ذکر محفوظ نہیں ہو سکا۔';

  @override
  String get sabihUpdatedSuccess => 'ذکر کامیابی سے اپ ڈیٹ ہو گیا۔';

  @override
  String get sabihAddedSuccess => 'ذکر کامیابی سے شامل ہو گیا۔';

  @override
  String get sabihEditDhikr => 'ذکر میں ترمیم';

  @override
  String get sabihFieldText => 'ذکر کا متن';

  @override
  String sabihExampleHint(String example) {
    return 'مثال: $example';
  }

  @override
  String get sabihTextRequired => 'براہِ کرم ذکر کا متن درج کریں';

  @override
  String get sabihTextTooShort => 'ذکر کا متن بہت مختصر ہے';

  @override
  String get sabihFieldVirtue => 'فضیلت یا مختصر تفصیل (اختیاری)';

  @override
  String get sabihPeriodToday => 'آج';

  @override
  String get sabihPeriodWeek => 'ہفتہ';

  @override
  String get sabihPeriodMonth => 'مہینہ';

  @override
  String get sabihPeriodYear => 'سال';

  @override
  String get sabihPeriodAll => 'سب';

  @override
  String get sabihThisWeek => 'اس ہفتے';

  @override
  String get sabihThisMonth => 'اس مہینے';

  @override
  String get sabihAllTime => 'اب تک';

  @override
  String get sabihMostUsed => 'سب سے زیادہ پڑھے گئے اذکار';

  @override
  String get sabihTotalCount => 'اذکار کی کل تعداد';

  @override
  String get sabihNoDataYet => 'ابھی کوئی ڈیٹا نہیں';

  @override
  String get sabihResetTodayCounter => 'آج کا کاؤنٹر ری سیٹ کریں';

  @override
  String get sabihEditThisDhikr => 'اس ذکر میں ترمیم کریں';

  @override
  String get sabihDeleteThisDhikr => 'یہ ذکر حذف کریں';

  @override
  String get sabihCustomBadge => 'ذاتی';

  @override
  String get sabihNoCustomDhikr => 'کوئی ذاتی ذکر نہیں';

  @override
  String get sabihSummaryTitle => 'ذکر کا خلاصہ';

  @override
  String get sabihTodayNotStarted => 'آج ابھی ذکر شروع نہیں کیا';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آج $count بار ذکر کیا',
      one: 'آج ایک بار ذکر کیا',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'تسبیح';

  @override
  String sabihTargetReached(int target) {
    return '$target مکمل';
  }

  @override
  String sabihTargetOf(int target) {
    return '$target میں سے';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'ہدف $target';
  }

  @override
  String get sabihTapAnywhere => 'تسبیح کے لیے کہیں بھی چھوئیں';

  @override
  String get sabihCountSemantics => 'تسبیح کی تعداد';

  @override
  String get sabihInvalidNumber => 'صفر سے بڑا درست عدد درج کریں';

  @override
  String get sabihSettingsTitle => 'تسبیح کی ترتیبات';

  @override
  String get sabihTargetSection => 'ذکر کا ہدف';

  @override
  String get sabihTargetAutoHint =>
      'اسے ویسے ہی چھوڑ دیں تو خودبخود بڑھتا جائے گا: 33، پھر 99، پھر ہر سو۔';

  @override
  String get sabihFontSize => 'فونٹ کا سائز';

  @override
  String get sabihFontSizeGlyph => 'ا';

  @override
  String sabihPercent(int value) {
    return '$value٪';
  }

  @override
  String get sabihVibration => 'وائبریشن';

  @override
  String get sabihVibrationTitle => 'ہر تسبیح پر ہلکی وائبریشن';

  @override
  String get sabihVibrationSubtitle => 'اور ہدف پورا ہونے پر واضح وائبریشن';

  @override
  String get sabihBeadDesign => 'تسبیح کا ڈیزائن';

  @override
  String get sabihResetTodayCounterAction => 'آج کا کاؤنٹر ری سیٹ کریں';

  @override
  String get anotherScreenGroupDaily => 'آپ کا روزانہ ورد';

  @override
  String get anotherScreenGroupKnowledge => 'علم اور تلاوت';

  @override
  String get anotherScreenGroupTools => 'اذکار اور ٹولز';

  @override
  String get anotherScreenDailyWird => 'دن اور رات کا زادِ راہ';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'روزانہ اذکار اور تلاوت کا منظم ورد';

  @override
  String get anotherScreenKhatmaPlans => 'ختمِ قرآن کے منصوبے';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'اپنی سہولت کے مطابق ختم مکمل کرنے کے منظم منصوبے';

  @override
  String get anotherScreenTasbihSubtitle =>
      'آرام دہ اور واضح کاؤنٹر کے ساتھ آسان تسبیح';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'مختصر اذکار جو دوسری ایپس کے اوپر نظر آتے ہیں';

  @override
  String get anotherScreenFajrCompanion => 'فجر کے ساتھی';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'دعوتی یاد دہانیاں اور شیڈول شدہ کالیں';

  @override
  String get anotherScreenSurahEncyclopedia => 'سورتوں کا انسائیکلوپیڈیا';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'سورتیں، ان کے فضائل اور موضوعات';

  @override
  String get anotherScreenNawawi40 => 'اربعین نووی';

  @override
  String get anotherScreenNawawi40Subtitle =>
      'دین کے مختلف ابواب پر جامع احادیث';

  @override
  String get anotherScreenNamesOfAllah => 'اسماءُ الحسنیٰ';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'اللہ کے مبارک ناموں اور ان کے معانی پر غور کریں';

  @override
  String get anotherScreenRadio => 'ریڈیو';

  @override
  String get anotherScreenRadioSubtitle =>
      'قرآنی اور اسلامی ریڈیو کی مسلسل براہِ راست نشریات';

  @override
  String get anotherScreenHisnMuslim => 'حصنُ المسلم';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'مختلف حالات و مواقع کے جامع اور مرتب اذکار';

  @override
  String get anotherScreenMyDuas => 'میری دعائیں';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'اپنی ذاتی دعائیں ایک جگہ محفوظ رکھیں';

  @override
  String get anotherScreenTraveler => 'مسافر';

  @override
  String get anotherScreenTravelerSubtitle =>
      'سفر کے اذکار، سفر میں نماز کے اوقات اور مفید مقامات';

  @override
  String get anotherScreenHomeWidgets => 'ہوم اسکرین ویجٹس';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'اگلی نماز، آج کے اوقات اور آج کی آیت';

  @override
  String get anotherScreenFootnotes => 'حواشی';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'باب $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متون',
      one: '$count متن',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حواشی',
      one: '$count حاشیہ',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'ذکر کا متن';

  @override
  String get anotherScreenHisnSearchHint => 'حصنُ المسلم میں تلاش کریں';

  @override
  String get anotherScreenNoResults => 'کوئی نتیجہ نہیں';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'حصنُ المسلم میں آپ کی تلاش سے ملتا کوئی باب نہیں ملا۔';

  @override
  String get anotherScreenShowAllAdhkar => 'تمام اذکار دکھائیں';

  @override
  String get anotherScreenSurahSearchHint => 'سورت تلاش کریں';

  @override
  String anotherScreenSurahTitle(String name) {
    return 'سورۃ $name';
  }

  @override
  String anotherScreenLabelHeading(String label) {
    return '$label:';
  }

  @override
  String anotherScreenLabelValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get anotherScreenSurahOrder => 'ترتیب';

  @override
  String get anotherScreenSurahNumber => 'سورت نمبر';

  @override
  String get anotherScreenAyahCount => 'آیات کی تعداد';

  @override
  String get anotherScreenSurahNameMeaning => 'سورت کے نام کا مطلب';

  @override
  String get anotherScreenSurahNamingReason => 'وجہِ تسمیہ';

  @override
  String get anotherScreenSurahOtherNamesShort => 'دیگر نام';

  @override
  String get anotherScreenSurahOtherNames => 'سورت کے دیگر نام';

  @override
  String get anotherScreenSurahPurpose => 'مرکزی موضوع';

  @override
  String get anotherScreenSurahRevelationReason => 'شانِ نزول';

  @override
  String get anotherScreenSurahVirtues => 'سورت کے فضائل';

  @override
  String get anotherScreenSurahRelations => 'سورت کی مناسبتیں';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count آیات';
  }

  @override
  String get anotherScreenNoMatchingResults => 'کوئی ملتا جلتا نتیجہ نہیں';

  @override
  String get anotherScreenShowAllSurahs => 'تمام سورتیں دکھائیں';

  @override
  String get quranPlanAnalysisStartFirst =>
      'اپنی پیش رفت کا تجزیہ دیکھنے کے لیے پہلی نشست شروع کریں۔';

  @override
  String get quranPlanAnalysisFinished => 'مبارک ہو! آپ نے منصوبہ مکمل کر لیا۔';

  @override
  String get quranPlanAnalysisOnTrack =>
      'آپ درست راستے پر ہیں، امید ہے مقررہ وقت سے پہلے ختم کر لیں گے!';

  @override
  String get quranPlanAnalysisBehind =>
      'آپ مقررہ وقت سے کچھ پیچھے رہ سکتے ہیں۔ تلاوت کی رفتار بڑھانے کی کوشش کریں۔';

  @override
  String quranPlanReminderTitle(String title) {
    return 'ختمِ قرآن کا منصوبہ: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return 'اپنے منصوبے «$title» کی آج کی نشست نہ بھولیں!';
  }

  @override
  String get quranPlanAddTitle => 'ختم کا نیا منصوبہ شامل کریں';

  @override
  String get quranPlanDetailsHeader => 'منصوبے کی تفصیلات';

  @override
  String get quranPlanTitleLabel => 'منصوبے کا عنوان';

  @override
  String get quranPlanTitleHint => 'منصوبے کا نام';

  @override
  String get quranPlanTitleRequired => 'عنوان درج کریں';

  @override
  String get quranPlanFromJuz => 'پارہ سے';

  @override
  String get quranPlanToJuz => 'پارہ تک';

  @override
  String get quranPlanChooseStart => 'آغاز منتخب کریں';

  @override
  String get quranPlanChooseEnd => 'اختتام منتخب کریں';

  @override
  String get quranPlanEndBeforeStart => 'اختتام آغاز سے پہلے ہے';

  @override
  String get quranPlanDaysLabel => 'دنوں کی تعداد';

  @override
  String get quranPlanDaysHint => 'مثال: 30';

  @override
  String get quranPlanDaysInvalid => 'دنوں کی درست تعداد درج کریں';

  @override
  String get quranPlanSave => 'منصوبہ محفوظ کریں';

  @override
  String get quranPlanChoose => 'منتخب کریں';

  @override
  String quranPlanJuz(int number) {
    return 'پارہ $number';
  }

  @override
  String get quranPlanDailyReminder => 'روزانہ یاد دہانی';

  @override
  String get quranPlanNotSet => 'مقرر نہیں';

  @override
  String get quranPlanListTitle => 'ختم کے منصوبے';

  @override
  String get quranPlanNewTooltip => 'نیا منصوبہ';

  @override
  String get quranPlanSearchHint => 'منصوبہ تلاش کریں';

  @override
  String quranPlanJuzRange(int start, int end) {
    return 'پارہ $start تا $end';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن',
      one: '$count دن',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نشستیں لوڈ ہوئیں',
      one: '$count نشست لوڈ ہوئی',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$total میں سے $done';
  }

  @override
  String get quranPlanDeleteConfirm => 'منصوبہ حذف کر دیا جائے؟';

  @override
  String get quranPlanConfirm => 'تصدیق کریں';

  @override
  String get quranPlanDelete => 'منصوبہ حذف کریں';

  @override
  String get quranPlanStagnationWarning =>
      'توجہ دیں: کئی دن سے تلاوت رکی ہوئی ہے۔ آج ایک مختصر نشست معمول بحال کرنے کے لیے کافی ہے۔';

  @override
  String get quranPlanLoadFailed => 'یہ منصوبہ ابھی لوڈ نہیں ہو سکا۔';

  @override
  String get quranPlanTodaySession => 'آج کی نشست';

  @override
  String get quranPlanAllSessionsDone =>
      'آپ نے اس منصوبے کی تمام نشستیں مکمل کر لیں، اللہ برکت دے۔';

  @override
  String get quranPlanRhythm => 'منصوبے کی رفتار';

  @override
  String get quranPlanPath => 'ختم کا سفر';

  @override
  String get quranPlanNoSessions => 'ابھی کوئی نشست نظر نہیں آ رہی۔';

  @override
  String get quranPlanCompleteConfirm => 'نشست مکمل کر دی جائے؟';

  @override
  String quranPlanSessionNumber(int number) {
    return 'نشست $number';
  }

  @override
  String get quranPlanSessionDone => 'مکمل';

  @override
  String get quranPlanCurrentSession => 'آپ کی موجودہ نشست';

  @override
  String get quranPlanOpenMushafHint => 'نشست کے آغاز پر مصحف کھولیں';

  @override
  String get quranPlanSessionCompleted => 'مکمل نشست';

  @override
  String get quranPlanCompleteSession => 'نشست مکمل کریں';

  @override
  String quranPlanSurahFallback(int number) {
    return 'سورت $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return '$fromSurah آیت $fromAyah سے $toSurah آیت $toAyah تک';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'مکمل ہوئی · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'ختم کی متوقع تاریخ';

  @override
  String get quranPlanAverageInterval => 'نشستوں کے درمیان اوسط وقفہ';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days دن';
  }

  @override
  String get quranPlanMostActiveDay => 'سب سے زیادہ فعال دن';

  @override
  String get quranPlanLeastActiveDay => 'سب سے کم فعال دن';

  @override
  String get quranPlanCompletionProbability => 'منصوبہ مکمل ہونے کا امکان';

  @override
  String quranPlanPercentValue(int percent) {
    return '$percent فیصد';
  }

  @override
  String get quranPlanStagnationDays => 'تلاوت کے بغیر دن';

  @override
  String get cleanupRouteNotFound => 'صفحہ نہیں ملا';

  @override
  String get cleanupNotificationSubtitle => 'نئی اطلاع';

  @override
  String get cleanupNotificationActionView => 'دیکھیں';

  @override
  String get cleanupNotificationActionDismiss => 'نظر انداز کریں';

  @override
  String get cleanupDownloadActionFailed =>
      'ڈاؤن لوڈ کا عمل مکمل نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get cleanupDownloadStatusQueued => 'انتظار میں';

  @override
  String get cleanupDownloadStatusCanceled => 'منسوخ';

  @override
  String get cleanupDownloadStatusUnknown => 'نامعلوم';

  @override
  String get cleanupRadioMediaArtist => 'قرآن کریم ریڈیو';

  @override
  String get cleanupDhikrMeaningSubhanAllah => 'اللہ پاک ہے';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'تمام تعریفیں اللہ کے لیے ہیں';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'اللہ کے سوا کوئی معبود نہیں';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'اللہ سب سے بڑا ہے';

  @override
  String get cleanupDhikrMeaningLaHawla =>
      'اللہ کی مدد کے بغیر نہ کوئی طاقت ہے نہ قوت';

  @override
  String get cleanupDhikrMeaningAstaghfirullah =>
      'میں اللہ سے مغفرت مانگتا ہوں';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'اللہ پاک ہے اپنی حمد کے ساتھ، اللہ پاک ہے عظمت والا';

  @override
  String get appName => 'طمأنينة';

  @override
  String get commonContinue => 'جاری رکھیں';

  @override
  String get commonSave => 'محفوظ کریں';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get commonOk => 'ٹھیک ہے';

  @override
  String get commonClose => 'بند کریں';

  @override
  String get commonDone => 'ہو گیا';

  @override
  String get commonRetry => 'دوبارہ کوشش کریں';

  @override
  String get commonSearch => 'تلاش';

  @override
  String get commonSettings => 'ترتیبات';

  @override
  String get commonLoading => 'لوڈ ہو رہا ہے…';

  @override
  String get commonError => 'کوئی خرابی پیش آئی';

  @override
  String get commonDelete => 'حذف کریں';

  @override
  String get commonEdit => 'ترمیم کریں';

  @override
  String get commonAdd => 'شامل کریں';

  @override
  String get commonShare => 'شیئر کریں';

  @override
  String get commonCopy => 'کاپی کریں';

  @override
  String get commonCopied => 'کاپی ہو گیا';

  @override
  String get commonBack => 'واپس';

  @override
  String get commonYes => 'ہاں';

  @override
  String get commonNo => 'نہیں';

  @override
  String get commonRefresh => 'تازہ کریں';

  @override
  String get commonSeeAll => 'سب دیکھیں';

  @override
  String get commonEnable => 'فعال کریں';

  @override
  String get commonDisable => 'بند کریں';

  @override
  String get commonLater => 'بعد میں';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerSunrise => 'طلوعِ آفتاب';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get prayerJumuah => 'جمعہ';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربیع الاول';

  @override
  String get hijriMonth4 => 'ربیع الثانی';

  @override
  String get hijriMonth5 => 'جمادی الاولیٰ';

  @override
  String get hijriMonth6 => 'جمادی الثانی';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذوالقعدہ';

  @override
  String get hijriMonth12 => 'ذوالحجہ';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year ھ';
  }

  @override
  String get youngMuslimTitle => 'ننھا مسلمان';

  @override
  String get youngMuslimQuizUnanswered => 'جواب نہیں دیا';

  @override
  String get youngMuslimResumeReminderTitle =>
      'ننھا مسلمان میں دیکھنا جاری رکھیں';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return '«$topic» پر واپس آئیں اور سکون سے اپنا سفر جاری رکھیں۔';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'بچوں کے لیے محفوظ';

  @override
  String get youngMuslimAudienceGeneral => 'عام ناظرین';

  @override
  String get youngMuslimStatSeries => 'سلسلہ';

  @override
  String get youngMuslimStatEpisode => 'قسط';

  @override
  String get youngMuslimChooseSeries => 'سلسلہ منتخب کریں';

  @override
  String get youngMuslimEpisodes => 'اقساط';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اقساط',
      one: '$count قسط',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'ابھی کوئی قسط نہیں';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'منتخب سلسلہ بدلیں یا فلٹرز اپ ڈیٹ ہونے کے بعد دوبارہ آئیں۔';

  @override
  String get youngMuslimCategoryLoadError => 'حصہ لوڈ نہیں ہو سکا';

  @override
  String get youngMuslimTryAgainShortly => 'تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get youngMuslimSearchHint => 'کہانی تلاش کریں...';

  @override
  String get youngMuslimAchievements => 'کامیابیاں';

  @override
  String get youngMuslimQuickFilter => 'فوری فلٹر';

  @override
  String get youngMuslimFilterResults => 'فلٹر کے نتائج';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتائج',
      one: '$count نتیجہ',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'کوئی ملتا جلتا نتیجہ نہیں';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'آسان الفاظ آزمائیں یا فلٹرز بدلیں تاکہ مزید اقساط نظر آئیں۔';

  @override
  String get youngMuslimSections => 'حصے';

  @override
  String get youngMuslimContinueWatching => 'دیکھنا جاری رکھیں';

  @override
  String get youngMuslimRecentlyWatched => 'حال ہی میں دیکھا';

  @override
  String get youngMuslimFavorites => 'پسندیدہ';

  @override
  String get youngMuslimWatchLater => 'بعد میں دیکھیں';

  @override
  String get youngMuslimSuggestions => 'مناسب تجاویز';

  @override
  String get youngMuslimGreetingWelcome =>
      'کہانیوں اور سیکھنے کی دنیا میں خوش آمدید';

  @override
  String get youngMuslimGreetingPickNew =>
      'نئی کہانی چنیں اور آج اپنا سفر شروع کریں';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اقساط آپ کی واپسی کا انتظار کر رہی ہیں',
      one: 'ایک قسط آپ کی واپسی کا انتظار کر رہی ہے',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'میرے پوائنٹس اور کامیابیاں';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'لیول $level · $points پوائنٹس';
  }

  @override
  String get youngMuslimNextLevelProgress => 'اگلے لیول کی طرف پیش رفت';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$total میں سے $current';
  }

  @override
  String get youngMuslimStatAchievements => 'کامیابیاں';

  @override
  String get youngMuslimStatEpisodes => 'اقساط';

  @override
  String get youngMuslimStatAnswers => 'جوابات';

  @override
  String get youngMuslimFilterAll => 'سب';

  @override
  String get youngMuslimStatusInProgress => 'دیکھی جا رہی ہے';

  @override
  String get youngMuslimStatusCompleted => 'مکمل';

  @override
  String get youngMuslimStatusWatchLater => 'بعد میں';

  @override
  String get youngMuslimFiltersActiveNote =>
      'فلٹرز ابھی فعال ہیں، آپ اوپر فلٹر بٹن سے انہیں بدل سکتے ہیں۔';

  @override
  String get youngMuslimClearFilters => 'صاف کریں';

  @override
  String get youngMuslimContentLoadError => 'مواد لوڈ نہیں ہو سکا';

  @override
  String get youngMuslimPullToRetry => 'دوبارہ کوشش کے لیے صفحہ نیچے کھینچیں۔';

  @override
  String get youngMuslimFilterSheetTitle => 'مواد فلٹر کریں';

  @override
  String get youngMuslimCategoryLabel => 'حصہ';

  @override
  String get youngMuslimFilterLanguage => 'زبان';

  @override
  String get youngMuslimLanguageArabic => 'عربی';

  @override
  String get youngMuslimLanguageFrench => 'فرانسیسی';

  @override
  String get youngMuslimLanguageMixed => 'ملی جلی';

  @override
  String get youngMuslimFilterContentType => 'مواد کی قسم';

  @override
  String get youngMuslimContentTypeStorySeries => 'کہانیوں کے سلسلے';

  @override
  String get youngMuslimApplyFilters => 'فلٹرز لگائیں';

  @override
  String get youngMuslimPlayerTitle => 'بچوں کے لیے محفوظ پلیئر';

  @override
  String get youngMuslimEpisodeQuizTitle => 'دیکھنے کے بعد قسط کا سوال';

  @override
  String get youngMuslimSeriesChallenge => 'سلسلے کا چیلنج';

  @override
  String get youngMuslimPlayerLoadError => 'پلیئر ابھی لوڈ نہیں ہو سکا۔';

  @override
  String get youngMuslimWatchOptions => 'دیکھنے کے اختیارات';

  @override
  String get youngMuslimPlayNextEpisode => 'اگلی قسط چلائیں';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'اسی سلسلے کی قسط $episode';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'سلسلے کی فہرست';

  @override
  String get youngMuslimAutoPlayNext => 'اگلی قسط خودبخود چلائیں';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'قسط ختم ہونے کے بعد صرف اسی سلسلے میں';

  @override
  String get youngMuslimResumeButton => 'دیکھنا جاری رکھیں';

  @override
  String get youngMuslimPlayNow => 'ابھی چلائیں';

  @override
  String youngMuslimPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get youngMuslimProgress => 'پیش رفت';

  @override
  String get youngMuslimWatchCount => 'کتنی بار دیکھی';

  @override
  String get youngMuslimEpisodeDuration => 'قسط کا دورانیہ';

  @override
  String youngMuslimLastWatched(String when) {
    return 'آخری بار دیکھی: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'قسط کی معلومات';

  @override
  String get youngMuslimStory => 'کہانی';

  @override
  String get youngMuslimSeries => 'سلسلہ';

  @override
  String get youngMuslimEpisodeNumber => 'قسط نمبر';

  @override
  String get youngMuslimEpisodeTools => 'قسط کے ٹولز';

  @override
  String get youngMuslimEpisodeQuestions => 'قسط کے سوالات';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'مختصر سوالات جو بچے کو دیکھی ہوئی بات یاد کرائیں';

  @override
  String get youngMuslimAfterWatchQuestion => 'دیکھنے کے بعد سوال';

  @override
  String get youngMuslimNextEpisode => 'اگلی قسط';

  @override
  String get youngMuslimSimilarEpisodes => 'ملتی جلتی اقساط';

  @override
  String get youngMuslimDetailsLoadError => 'قسط کی تفصیلات لوڈ نہیں ہو سکیں';

  @override
  String get youngMuslimQuizIntro =>
      'آسان سوالات جو بچے کو دیکھی ہوئی بات پکی کرنے میں مدد دیتے ہیں۔';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سوالات',
      one: '$count سوال',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return 'کامیابی پر +$points پوائنٹس';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'کامیابی کے لیے $score';
  }

  @override
  String get youngMuslimGrading => 'جوابات جانچے جا رہے ہیں';

  @override
  String get youngMuslimSubmitAnswers => 'جوابات بھیجیں';

  @override
  String get youngMuslimAnswerHint => 'اپنا جواب یہاں صاف صاف لکھیں...';

  @override
  String get youngMuslimQuizPassed => 'شاباش، چیمپئن!';

  @override
  String get youngMuslimQuizAlmost => 'آپ مکمل جواب کے بہت قریب ہیں';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return '$total میں سے $correct جواب درست';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points پوائنٹس';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'لیول $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points پوائنٹس',
      one: '$points پوائنٹ',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'نئی کامیابیاں';

  @override
  String get youngMuslimReviewAnswers => 'جوابات دیکھیں';

  @override
  String get youngMuslimFinish => 'ختم کریں';

  @override
  String get youngMuslimYourAnswer => 'آپ کا جواب';

  @override
  String get youngMuslimCorrectAnswer => 'درست جواب';

  @override
  String get youngMuslimStatSeriesPlural => 'سلسلے';

  @override
  String get youngMuslimStatPerfectScores => 'پورے نمبر';

  @override
  String get youngMuslimUnlockedAchievements => 'حاصل شدہ کامیابیاں';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کامیابیاں',
      one: '$count کامیابی',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'ابھی کوئی کامیابی نہیں';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'سفر شروع کرنے کے لیے پہلی قسط مکمل کریں یا پہلے سوال کا جواب دیں۔';

  @override
  String get youngMuslimUpcomingAchievements => 'آنے والی کامیابیاں';

  @override
  String get youngMuslimAchievementUnlocked => 'یہ کامیابی حاصل ہو گئی۔';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'حاصل ہوئی $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'موجودہ پیش رفت';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get youngMuslimNotWatchedYet => 'ابھی نہیں دیکھی';

  @override
  String get youngMuslimJustNow => 'ابھی';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ پہلے',
      one: '$count منٹ پہلے',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گھنٹے پہلے',
      one: '$count گھنٹہ پہلے',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن پہلے',
      one: '$count دن پہلے',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'دیکھ لی';

  @override
  String youngMuslimProgressPercent(int percent) {
    return '$percent٪ دیکھی';
  }

  @override
  String get youngMuslimReadyToWatch => 'دیکھنے کے لیے تیار';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سلسلے',
      one: '$count سلسلہ',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سلسلے · بچوں کے لیے',
      one: '$count سلسلہ · بچوں کے لیے',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'قسط $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft => 'جہاں چھوڑا تھا وہیں سے جاری رکھیں';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return '$duration باقی';
  }

  @override
  String get youngMuslimAlmostDone => 'بس ختم ہونے والی ہے';

  @override
  String get categoriesRequestFailed => 'عمل مکمل نہیں ہو سکا';

  @override
  String get categoriesLibraryTitle => 'لائبریری';

  @override
  String get categoriesQuranSciencesHeader => 'قرآنِ کریم اور اس کے علوم';

  @override
  String get categoriesTypesHeader => 'اقسام';

  @override
  String get categoriesSectionsHeader => 'حصے';

  @override
  String get categoriesFamousRecitations => 'مشہور تلاوتیں';

  @override
  String get categoriesKidsTeaching => 'بچوں کی تعلیم';

  @override
  String get categoriesRecitationsByNarration =>
      'مختلف روایات و قراءات میں تلاوتیں';

  @override
  String get categoriesRecitationsByNarrationShort => 'روایات میں تلاوتیں';

  @override
  String get categoriesHaramainMushafs => 'حرمین کے مصاحف';

  @override
  String get categoriesTypeVideos => 'ویڈیوز';

  @override
  String get categoriesTypeBooks => 'کتابیں';

  @override
  String get categoriesTypeStories => 'کہانیاں';

  @override
  String get categoriesTypeAudios => 'آڈیوز';

  @override
  String get categoriesTypeFatwas => 'فتاویٰ';

  @override
  String get categoriesTypeQuran => 'قرآن';

  @override
  String get categoriesTypePresentations => 'پریزنٹیشنز';

  @override
  String get categoriesTypeNews => 'خبریں';

  @override
  String get categoriesTypeArticles => 'مضامین';

  @override
  String get categoriesTypeApps => 'ایپس';

  @override
  String get categoriesTypeSermons => 'خطبات';

  @override
  String get categoriesTopicQuran => 'قرآن';

  @override
  String get categoriesTopicSunnah => 'سنت';

  @override
  String get categoriesTopicSeerah => 'سیرتِ نبوی';

  @override
  String get categoriesTopicAqeedah => 'عقیدہ';

  @override
  String get categoriesTopicFiqh => 'فقہ';

  @override
  String get categoriesTopicHistory => 'تاریخ';

  @override
  String get categoriesTopicArabic => 'عربی زبان';

  @override
  String get categoriesTopicIslamicStudies => 'اسلامیات';

  @override
  String get categoriesTopicLessons => 'علمی دروس';

  @override
  String get categoriesTopicMajorSins => 'کبیرہ گناہ اور محرمات';

  @override
  String get categoriesNoSearchResults => 'اس تلاش کا کوئی نتیجہ نہیں۔';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آئٹمز',
      one: '$count آئٹم',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'آڈیو';

  @override
  String get categoriesItemBook => 'کتاب';

  @override
  String get categoriesItemArticle => 'مضمون';

  @override
  String get categoriesItemVideo => 'ویڈیو';

  @override
  String get categoriesFallbackTitle => 'زمرہ';

  @override
  String get categoriesNoAttachments => 'اس مواد کے ساتھ کوئی منسلکہ نہیں۔';

  @override
  String get categoriesAttachments => 'منسلکات';

  @override
  String get categoriesActionWatch => 'دیکھیں';

  @override
  String get categoriesActionRead => 'پڑھیں';

  @override
  String get categoriesActionOpen => 'کھولیں';

  @override
  String categoriesOrder(String order) {
    return 'ترتیب $order';
  }

  @override
  String get categoriesDownload => 'ڈاؤن لوڈ';

  @override
  String get categoriesAttachmentFallback => 'منسلکہ';

  @override
  String get categoriesNoChapters => 'اس حصے میں کوئی باب نہیں۔';

  @override
  String get categoriesClearSearch => 'تلاش صاف کریں';

  @override
  String get categoriesAudioLoadError => 'آڈیو مواد لوڈ نہیں ہو سکا۔';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'کلپ $number';
  }

  @override
  String get categoriesAudioClipFallback => 'آڈیو کلپ';

  @override
  String get booksTitle => 'کتابیں';

  @override
  String get booksLoadError => 'کتابیں ابھی لوڈ نہیں ہو سکیں۔';

  @override
  String get booksEmpty => 'دکھانے کے لیے کوئی کتاب نہیں۔';

  @override
  String get booksFilesHeader => 'کتاب کی فائلیں';

  @override
  String get booksNoFilesTitle => 'کوئی فائل نہیں';

  @override
  String get booksNoFilesBody =>
      'اس کتاب کے ساتھ ڈاؤن لوڈ کے لیے کوئی فائل نہیں۔';

  @override
  String get booksDescriptionHeader => 'تفصیل';

  @override
  String get booksReferenceHeader => 'حوالہ';

  @override
  String booksFileNumber(int number) {
    return 'فائل $number';
  }

  @override
  String get booksReadTitle => 'کتاب پڑھیں';

  @override
  String get booksViewerFailed => 'کتاب ایپ کے اندر نہیں کھل سکی';

  @override
  String get booksOpenOutsideHint => 'آپ اسے ایپ سے باہر کھول سکتے ہیں';

  @override
  String get booksOpenOutside => 'ایپ سے باہر کھولیں';

  @override
  String get hadith40Title => 'اربعین نووی';

  @override
  String hadith40Number(int number) {
    return 'حدیث $number';
  }

  @override
  String get hadith40SearchHint => 'حدیث تلاش کریں';

  @override
  String get hadith40NoResults => 'اس تلاش کا کوئی نتیجہ نہیں';

  @override
  String get hadith40ShowAll => 'تمام احادیث دکھائیں';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'اربعین نووی · حدیث $number';
  }

  @override
  String get hadith40Explanation => 'حدیث کی شرح';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nحدیث کی شرح:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'اسماءُ الحسنیٰ';

  @override
  String allahNamesNameOrder(int number) {
    return 'اسماءُ الحسنیٰ میں سے نام نمبر $number';
  }

  @override
  String get allahNamesMeaning => 'معنی';

  @override
  String get allahNamesSearchHint => 'اسماءُ الحسنیٰ میں تلاش کریں';

  @override
  String get allahNamesNoResultsTitle => 'کوئی نتیجہ نہیں';

  @override
  String get allahNamesNoResultsMessage =>
      'آپ کی تلاش سے ملتا کوئی نام نہیں ملا۔';

  @override
  String get allahNamesShowAll => 'تمام نام دکھائیں';

  @override
  String get readQuranListen => 'سنیں';

  @override
  String get readQuranAyah => 'آیت';

  @override
  String get readQuranTafsir => 'آیت کی تفسیر';

  @override
  String get quranAudioPlayPause => 'چلائیں یا روکیں';

  @override
  String audiosTrackNumber(int number) {
    return 'کلپ $number';
  }

  @override
  String get audiosTracksHeader => 'کلپس';

  @override
  String get audiosSearchSeriesHint => 'سلسلہ تلاش کریں';

  @override
  String get audiosSeriesSubtitle => 'آڈیو سلسلہ';

  @override
  String get audiosNoSeries => 'دکھانے کے لیے کوئی سلسلہ نہیں';

  @override
  String get audiosNoResults => 'آپ کی تلاش کا کوئی نتیجہ نہیں';

  @override
  String get audiosPrevious => 'پچھلا';

  @override
  String get audiosNext => 'اگلا';

  @override
  String get audiosPause => 'عارضی طور پر روکیں';

  @override
  String get audiosPlay => 'چلائیں';

  @override
  String get coreUpdateDownloaded =>
      'اپ ڈیٹ ڈاؤن لوڈ ہو گئی، اب آپ اسے انسٹال کر سکتے ہیں۔';

  @override
  String get coreUpdateInstallNow => 'ابھی انسٹال کریں';

  @override
  String get coreUpdateAvailableTitle => 'نئی اپ ڈیٹ دستیاب ہے';

  @override
  String coreUpdateAvailableMessage(String version) {
    return 'ورژن $version اب App Store پر دستیاب ہے۔';
  }

  @override
  String get coreUpdateWhatsNew => 'اس ورژن میں نیا کیا ہے:';

  @override
  String get coreUpdateNow => 'ابھی اپ ڈیٹ کریں';

  @override
  String get coreExitDialogTitle => 'توجہ';

  @override
  String get coreExitDialogMessage =>
      'کیا آپ واقعی ایپ سے باہر نکلنا چاہتے ہیں؟';

  @override
  String get coreExitConfirmMessage => 'کیا آپ واقعی باہر نکلنا چاہتے ہیں؟';

  @override
  String get coreExitStay => 'رکیں';

  @override
  String get coreExitAction => 'باہر نکلیں';

  @override
  String get coreDeleteDhikrTitle => 'ذکر حذف کریں؟';

  @override
  String get coreDeleteDhikrMessage =>
      'کیا آپ واقعی یہ ذکر حذف کرنا چاہتے ہیں؟';

  @override
  String get coreFieldRequired => 'یہ خانہ ضروری ہے';

  @override
  String get coreNoData => 'کوئی ڈیٹا نہیں۔';

  @override
  String get coreNoDataToShow => 'دکھانے کے لیے کوئی ڈیٹا نہیں';

  @override
  String get coreContent => 'مواد';

  @override
  String get coreGenericError => 'کچھ غلط ہو گیا، براہِ کرم دوبارہ کوشش کریں';

  @override
  String get coreLoadDataError => 'ڈیٹا لوڈ کرتے وقت خرابی پیش آئی';

  @override
  String coreErrorStatus(String code) {
    return 'اسٹیٹس: $code';
  }

  @override
  String get coreCloseSearch => 'تلاش بند کریں';

  @override
  String get coreClear => 'صاف کریں';

  @override
  String get coreSheetDefaultTitle => 'نیا شامل کریں';

  @override
  String get coreSheetDefaultSubtitle => 'مواد اپنی مرضی کے مطابق بنائیں';

  @override
  String get coreCopiedSuccessfully => 'کامیابی سے کاپی ہو گیا';

  @override
  String get coreDownloadStarted => 'ڈاؤن لوڈ شروع ہو گیا';

  @override
  String get coreDownloadCompleted => 'ڈاؤن لوڈ ہو گیا';

  @override
  String get coreSaveReadingPositionPrompt =>
      'کیا آپ اپنی تلاوت کی جگہ محفوظ کرنا چاہتے ہیں؟';

  @override
  String get coreLocationServiceDisabled =>
      'لوکیشن سروس بند ہے۔ نماز کے اوقات معلوم کرنے کے لیے اسے آن کریں۔';

  @override
  String get coreLocationPermissionDenied =>
      'لوکیشن تک رسائی کی اجازت نہیں دی گئی۔';

  @override
  String get coreLocationPermissionDeniedForever =>
      'لوکیشن کی اجازت مستقل طور پر مسترد ہے۔ اسے ایپ کی ترتیبات سے فعال کریں۔';

  @override
  String get coreNotNow => 'ابھی نہیں';

  @override
  String get coreAllow => 'اجازت دیں';

  @override
  String get coreOpenSettings => 'ترتیبات کھولیں';

  @override
  String get coreNotificationPermissionTitle => 'اطلاعات کی اجازت';

  @override
  String get coreNotificationPermissionRationale =>
      'نماز کے اوقات اور اذکار کی یاد دہانی کے لیے ایپ کو اطلاعات کی اجازت درکار ہے۔\nاس سے آپ دن بھر اسلامی تعلیمات سے جڑے رہیں گے۔';

  @override
  String get coreNotificationSettingsTitle => 'اطلاعات کی ترتیبات';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'اطلاعات کی اجازت مستقل طور پر مسترد کر دی گئی ہے۔\nبراہِ کرم ترتیبات میں جا کر خود اطلاعات فعال کریں۔';

  @override
  String get corePermissionStatusGranted => 'تمام اجازتیں دی جا چکی ہیں';

  @override
  String get corePermissionStatusDenied => 'اطلاعات کی اجازتیں مسترد ہیں';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'اجازتیں مستقل طور پر مسترد ہیں';

  @override
  String get corePermissionStatusPartial => 'صرف کچھ اجازتیں دی گئی ہیں';

  @override
  String get corePermissionStatusUnknown => 'اجازتوں کی حالت معلوم نہیں';

  @override
  String get corePermissionResultGranted => 'تمام اجازتیں کامیابی سے مل گئیں';

  @override
  String get corePermissionResultDenied => 'اجازت کی درخواست مسترد ہو گئی';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'اجازتیں مستقل طور پر مسترد ہیں - براہِ کرم ترتیبات میں جائیں';

  @override
  String get corePermissionResultPartial =>
      'کچھ اجازتیں ملی ہیں - مزید اجازتوں کی ضرورت ہو سکتی ہے';

  @override
  String get corePermissionResultError => 'اجازت مانگتے وقت خرابی پیش آئی';

  @override
  String get coreNotificationActionOpenApp => 'ایپ کھولیں';

  @override
  String get coreNotificationActionDismiss => 'چھپائیں';

  @override
  String get coreNotificationActionMarkRead => 'پڑھ لیا';

  @override
  String get coreNotificationActionRemindLater => 'بعد میں یاد دلائیں';

  @override
  String get coreNotificationGroupName => 'اسلامی اطلاعات';

  @override
  String get coreNotificationGroupDescription =>
      'اسلامی ایپ کی اطلاعات کا گروپ';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'اسلامی اطلاعات کے لیے $channel چینل';
  }

  @override
  String get coreNotificationAppLabel => 'طمأنينة ایپ';

  @override
  String get coreNotificationMore => 'مزید...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اطلاعات',
      one: '$count اطلاع',
      zero: 'کوئی اطلاع نہیں',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نئی اطلاعات',
      one: '$count نئی اطلاع',
      zero: 'کوئی نئی اطلاع نہیں',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return 'اب $prayer کی اذان کا وقت ہو گیا ہے';
  }

  @override
  String coreAthanDescription(String prayer) {
    return '$prayer کی اذان';
  }

  @override
  String get coreChannelAthan => 'طمأنينة - اذان';

  @override
  String get coreChannelMohammed => 'طمأنينة - درود شریف';

  @override
  String get coreChannelMorning => 'طمأنينة - صبح کے اذکار';

  @override
  String get coreChannelNight => 'طمأنينة - شام کے اذکار';

  @override
  String get coreChannelSleep => 'طمأنينة - سونے کے اذکار';

  @override
  String get coreChannelGetUp => 'طمأنينة - بیدار ہونے کے اذکار';

  @override
  String get coreChannelMiddleNight => 'طمأنينة - قیام اللیل';

  @override
  String get coreChannelRandomThikr => 'طمأنينة - بے ترتیب اذکار';

  @override
  String get coreChannelAstgferAllh => 'طمأنينة - استغفار';

  @override
  String get coreChannelHasbnaAllh => 'طمأنينة - حسبنا اللہ';

  @override
  String get coreChannelLaHawla => 'طمأنينة - لا حول ولا قوۃ الا باللہ';

  @override
  String get coreChannelSubhanAllh => 'طمأنينة - سبحان اللہ';

  @override
  String get coreChannelDefaultChannel => 'طمأنينة - عمومی اطلاعات';

  @override
  String get coreChannelSmartOutreach => 'طمأنينة - فجر کے ساتھی';

  @override
  String get coreFcmChannelHighImportance => 'طمأنينة - اہم اطلاعات';

  @override
  String get coreFcmChannelChat => 'طمأنينة - پیغامات';

  @override
  String get coreFcmChannelUpdates => 'طمأنينة - اپ ڈیٹس';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'طمأنينة ایپ کی اہم اطلاعات کا چینل';

  @override
  String get coreFcmChannelDefaultDescription =>
      'طمأنينة ایپ کی عمومی اطلاعات کا چینل';

  @override
  String get coreFcmChannelChatDescription =>
      'طمأنينة ایپ کے پیغامات اور الرٹس کا چینل';

  @override
  String get coreFcmChannelUpdatesDescription =>
      'طمأنينة ایپ کی اپ ڈیٹس کا چینل';

  @override
  String get languageTitle => 'اپنی زبان منتخب کریں';

  @override
  String get languageSubtitle => 'آپ اسے بعد میں ترتیبات سے بدل سکتے ہیں۔';

  @override
  String get languageSettingTitle => 'زبان';

  @override
  String get languageSettingSubtitle => 'ایپ کی زبان';

  @override
  String get languageReligiousTextNote =>
      'قرآنِ کریم، اذکار اور دعائیں اپنے عربی متن میں ہی رہیں گی۔';

  @override
  String get onboardingNotificationsTitle => 'کوئی نماز نہ چھوٹے';

  @override
  String get onboardingNotificationsBody =>
      'اطلاعات کی اجازت دیں تاکہ اذان وقت پر پہنچے اور ایپ آپ کو اذکار اور روزانہ ورد یاد دلائے۔';

  @override
  String get onboardingNotificationsPointAthan => 'ہر نماز کے وقت پر اذان';

  @override
  String get onboardingNotificationsPointAdhkar => 'صبح و شام کے اذکار وقت پر';

  @override
  String get onboardingNotificationsPointWird =>
      'آپ کے روزانہ ورد کی نرم یاد دہانی';

  @override
  String get onboardingNotificationsAllow => 'اطلاعات کی اجازت دیں';

  @override
  String get onboardingLocationTitle => 'آپ کے شہر کے درست اوقات';

  @override
  String get onboardingLocationBody =>
      'ہم آپ کے مقام سے نماز کے اوقات اور قبلہ کی سمت درست طور پر معلوم کرتے ہیں۔';

  @override
  String get onboardingLocationPointTimes => 'آپ کی جگہ کے عین مطابق اوقات';

  @override
  String get onboardingLocationPointTravel => 'سفر میں خود بخود اپ ڈیٹ';

  @override
  String get onboardingLocationPointQibla =>
      'جہاں آپ کھڑے ہیں وہاں سے قبلہ کی سمت';

  @override
  String get onboardingLocationAllow => 'مقام کی اجازت دیں';

  @override
  String get onboardingLocationManualHint =>
      'مقام شیئر نہیں کرنا چاہتے؟ بعد میں اوقاتِ نماز کے صفحے سے اپنا شہر خود منتخب کریں۔';

  @override
  String get onboardingChangeLater =>
      'آپ اسے بعد میں اپنے فون کی سیٹنگز سے بدل سکتے ہیں۔';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get homeNoticeNotificationsTitle => 'اطلاعات بند ہیں';

  @override
  String get homeNoticeNotificationsBody =>
      'جب تک آپ انہیں فعال نہیں کرتے، اذان اور اذکار کی یاد دہانی نہیں آئے گی۔';

  @override
  String get homeNoticeNotificationsAction => 'فعال کریں';

  @override
  String get homeNoticeExactAlarmsTitle => 'اذان میں تاخیر ہو سکتی ہے';

  @override
  String get homeNoticeExactAlarmsBody =>
      'ایپ کو الارم سیٹ کرنے کی اجازت دیں تاکہ اذان عین وقت پر آئے۔';

  @override
  String get homeNoticeExactAlarmsAction => 'اجازت دیں';

  @override
  String get outreachTitle => 'فجر کے ساتھی';

  @override
  String get outreachTagline =>
      'پرسکون کال فہرستیں جو آپ کے پیاروں کے دن کا آغاز خیر سے کرائیں';

  @override
  String get outreachActionCallOnly => 'صرف کال';

  @override
  String get outreachErrorScheduleNotFound => 'یہ فہرست موجود نہیں۔';

  @override
  String get outreachContactsPermissionDenied =>
      'نمبر خودبخود چننے کے لیے رابطوں تک رسائی کی اجازت دیں۔';

  @override
  String get outreachContactNoPhone => 'منتخب رابطے میں کوئی فون نمبر نہیں۔';

  @override
  String get outreachContactPickError => 'رابطہ منتخب کرتے وقت خرابی پیش آئی۔';

  @override
  String get outreachUnnamed => 'بے نام';

  @override
  String get outreachPermissionPhone => 'کال';

  @override
  String get outreachPermissionContacts => 'رابطے';

  @override
  String get outreachPermissionNotifications => 'اطلاعات';

  @override
  String get outreachListSeparator => '، ';

  @override
  String get outreachValidationTitleRequired => 'فہرست کا نام لکھیں۔';

  @override
  String get outreachValidationAddNumber => 'کم از کم ایک نمبر شامل کریں۔';

  @override
  String get outreachValidationEmptyPhone => 'ہر خانے میں فون نمبر ہونا چاہیے۔';

  @override
  String get outreachValidationIncompleteNumber => 'ایک نمبر نامکمل ہے۔';

  @override
  String get outreachValidationDuplicateNumber =>
      'اسی فہرست میں ایک نمبر دہرایا گیا ہے۔';

  @override
  String get outreachValidationPickDay => 'کم از کم ایک دن منتخب کریں۔';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'نمبروں کے بغیر فہرست نہیں چلائی جا سکتی۔';

  @override
  String get outreachCallLogsTitle => 'کال لاگ';

  @override
  String get outreachClearLog => 'لاگ صاف کریں';

  @override
  String get outreachStatTotal => 'کل';

  @override
  String get outreachStatAnswered => 'جواب دیا';

  @override
  String get outreachStatNotAnswered => 'جواب نہیں دیا';

  @override
  String get outreachStatFailed => 'ناکام';

  @override
  String get outreachResultsHeader => 'نتائج';

  @override
  String get outreachNoResultsTitle => 'ابھی کوئی نتیجہ نہیں';

  @override
  String get outreachNoResultsMessage =>
      'پہلی بار چلنے کے بعد ہر کال کا نتیجہ یہاں نظر آئے گا۔';

  @override
  String outreachSecondsShort(int seconds) {
    return '$seconds سیکنڈ';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds سیکنڈ';
  }

  @override
  String get outreachCallStatusAnswered => 'جواب دیا گیا';

  @override
  String get outreachCallStatusNotAnswered => 'جواب نہیں ملا';

  @override
  String get outreachCallStatusFailed => 'کال ناکام';

  @override
  String get outreachExecutionTitle => 'کالیں شروع کریں';

  @override
  String get outreachCallsStartedFromAlert => 'الرٹ سے کالیں شروع ہو گئیں۔';

  @override
  String get outreachCallsStartedNow => 'کالیں ابھی شروع ہو گئیں۔';

  @override
  String get outreachCallsStartFailed =>
      'کالیں ابھی شروع نہیں ہو سکیں۔ دوبارہ کوشش کریں۔';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'فہرست ختم ہونے کے بعد دیکھیں کس نے جواب دیا اور کس نے نہیں';

  @override
  String get outreachPreparingCalls => 'کالیں تیار کی جا رہی ہیں...';

  @override
  String get outreachDontCloseHint => 'عمل شروع ہونے تک صفحہ بند نہ کریں۔';

  @override
  String get outreachCanCloseHint =>
      'اب آپ صفحہ بند کر سکتے ہیں اور نتیجہ لاگ میں دیکھ سکتے ہیں۔';

  @override
  String get outreachAddList => 'فہرست شامل کریں';

  @override
  String get outreachStatLists => 'فہرستیں';

  @override
  String get outreachStatEnabled => 'فعال';

  @override
  String get outreachStatNumbers => 'نمبر';

  @override
  String get outreachListsHeader => 'کال فہرستیں';

  @override
  String get outreachToolsHeader => 'ٹولز';

  @override
  String get outreachCallLogsSubtitle =>
      'ہر کال کا نتیجہ: کس نے جواب دیا اور کس نے نہیں';

  @override
  String get outreachSettingsTitle => 'کال کی ترتیبات';

  @override
  String get outreachSettingsSubtitle =>
      'طے شدہ دورانیے اور نئی فہرستوں کا طرزِ عمل';

  @override
  String get outreachNoListsTitle => 'ابھی کوئی فہرست نہیں';

  @override
  String get outreachNoListsMessage =>
      'ایک فہرست شامل کریں، اس کا وقت اور وہ نمبر مقرر کریں جنہیں کال کرنا چاہتے ہیں۔';

  @override
  String get outreachStartsNow => 'ابھی شروع';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ میں',
      one: '$count منٹ میں',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گھنٹوں میں',
      one: '$count گھنٹے میں',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ میں';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دنوں میں',
      one: '$count دن میں',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'پہلے یہ اجازتیں فعال کریں: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'مطلوبہ اجازتیں مکمل نہیں۔ فہرستیں وقت پر چلانے کے لیے فعال کریں: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'اجازتیں دیں';

  @override
  String get outreachOpenSettings => 'ترتیبات کھولیں';

  @override
  String get outreachSettingsSaved => 'ترتیبات محفوظ ہو گئیں۔';

  @override
  String get outreachSettingsIntro => 'یہ اقدار ہر نئی فہرست پر لاگو ہوں گی۔';

  @override
  String get outreachDefaultDurationsHeader => 'طے شدہ دورانیے';

  @override
  String get outreachRingTimeout => 'جواب کا انتظار';

  @override
  String get outreachHangupDelay => 'جواب کے بعد انتظار';

  @override
  String get outreachDelayBetweenEach => 'ہر نمبر کے درمیان وقفہ';

  @override
  String get outreachBehaviorHeader => 'فہرستوں کا طرزِ عمل';

  @override
  String get outreachStopAfterFirstAnswerList =>
      'پہلے جواب کے بعد فہرست روک دیں';

  @override
  String get outreachRetryIfNoAnswer => 'جواب نہ ملنے پر دوبارہ کال کریں';

  @override
  String get outreachRestartAfterFinish => 'ختم ہونے کے بعد دوبارہ شروع کریں';

  @override
  String get outreachSaveSettings => 'ترتیبات محفوظ کریں';

  @override
  String get outreachBackgroundHeader => 'پس منظر میں چلنا';

  @override
  String get outreachBatteryTitle => 'ایپ کو بیٹری کی بچت سے مستثنیٰ کریں';

  @override
  String get outreachBatterySubtitle =>
      'اگر پس منظر میں فہرستیں رک جائیں تو بیٹری کی ترتیبات سے ایپ کو چلنے کی اجازت دیں۔';

  @override
  String get outreachEditList => 'فہرست میں ترمیم';

  @override
  String get outreachNewList => 'نئی فہرست';

  @override
  String get outreachCallTimeHeader => 'کال کا وقت';

  @override
  String get outreachManualTime => 'وقت خود منتخب کریں';

  @override
  String get outreachManualTimeSubtitle => 'گھنٹہ اور منٹ خود مقرر کریں';

  @override
  String get outreachUseFajrTime => 'فجر کا وقت استعمال کریں';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'فجر کا وقت استعمال کریں · $time';
  }

  @override
  String get outreachPrayerTimesNotReady => 'نماز کے اوقات ابھی تیار نہیں';

  @override
  String get outreachFajrAutoFill =>
      'وقت آج کے اوقاتِ نماز سے خودبخود بھر دیا جائے گا';

  @override
  String get outreachFajrUnavailable =>
      'فجر کا وقت ابھی دستیاب نہیں۔ تھوڑی دیر بعد کوشش کریں۔';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'فجر کا وقت استعمال ہوا: $time';
  }

  @override
  String get outreachContactFetchFailed => 'ابھی رابطہ حاصل نہیں ہو سکا۔';

  @override
  String get outreachExactAlarmHint =>
      'فجر کے ساتھی کو بالکل وقت پر چلانے کے لیے ڈیوائس کی ترتیبات سے درست الارم کی اجازت فعال کریں۔';

  @override
  String get outreachListNameHeader => 'فہرست کا نام';

  @override
  String get outreachStartTime => 'شروع ہونے کا وقت';

  @override
  String get outreachStartTimeHint =>
      'وقت خود منتخب کریں یا فجر کا وقت استعمال کریں';

  @override
  String outreachFajrTimeToday(String time) {
    return 'آج فجر کا وقت $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'رابطے · $count';
  }

  @override
  String get outreachPickFromContacts => 'رابطوں سے منتخب کریں';

  @override
  String get outreachPickFromContactsSubtitle =>
      'اس فہرست میں نیا نمبر شامل کریں';

  @override
  String get outreachAdvancedSettings => 'اعلیٰ ترتیبات';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'دن، انتظار کے دورانیے اور دہرانے کا طریقہ';

  @override
  String get outreachSaving => 'محفوظ ہو رہا ہے...';

  @override
  String get outreachSaveList => 'فہرست محفوظ کریں';

  @override
  String get outreachNoNumbersYet => 'ابھی کوئی نمبر شامل نہیں کیا گیا۔';

  @override
  String get outreachEnableList => 'یہ فہرست چلائیں';

  @override
  String get outreachDailyRepeat => 'روزانہ دہرائیں';

  @override
  String get outreachEveryDay => 'ہر روز';

  @override
  String get outreachSelectedWeekdays => 'ہفتے کے منتخب دن';

  @override
  String get outreachDelayBetweenNumbers => 'نمبروں کے درمیان وقفہ';

  @override
  String get outreachStopAfterFirstAnswer => 'پہلے جواب کے بعد روکیں';

  @override
  String get outreachRetryOnNoAnswer => 'جواب نہ ملنے پر دوبارہ';

  @override
  String get outreachRepeatWholeCycle => 'پورا چکر دہرائیں';

  @override
  String get outreachListNameHint => 'مثال: فجر کی یاد دہانی';

  @override
  String get outreachTitleFieldRequired => 'فہرست کا نام لکھیں';

  @override
  String get outreachPickNumber => 'نمبر منتخب کریں';

  @override
  String get outreachMultipleNumbers => 'اس نام کے ایک سے زیادہ نمبر ہیں۔';

  @override
  String get outreachNoDays => 'کوئی دن مقرر نہیں';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نمبر',
      one: '$count نمبر',
      zero: 'کوئی نمبر نہیں',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'انتظار $seconds سیکنڈ';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'جواب کے بعد $seconds سیکنڈ';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'نمبروں کے درمیان $seconds سیکنڈ';
  }

  @override
  String get outreachNearest => 'سب سے قریب';

  @override
  String get outreachStartNow => 'ابھی شروع کریں';

  @override
  String get outreachStatusActive => 'فعال';

  @override
  String get outreachStatusStopped => 'بند';

  @override
  String outreachStatusSemantics(String status) {
    return 'حالت: $status';
  }

  @override
  String get outreachWeekday1 => 'پیر';

  @override
  String get outreachWeekday2 => 'منگل';

  @override
  String get outreachWeekday3 => 'بدھ';

  @override
  String get outreachWeekday4 => 'جمعرات';

  @override
  String get outreachWeekday5 => 'جمعہ';

  @override
  String get outreachWeekday6 => 'ہفتہ';

  @override
  String get outreachWeekday7 => 'اتوار';

  @override
  String get travelerServicesTitle => 'مسافر کی سہولیات';

  @override
  String get travelerNearbyMosques => 'قریبی مساجد';

  @override
  String get travelerNearbyHalalRestaurants => 'قریبی حلال ریسٹورنٹس';

  @override
  String get travelerHalalRestaurants => 'حلال ریسٹورنٹس';

  @override
  String get travelerHintAroundYou => 'آپ کے آس پاس';

  @override
  String get travelerHintWithCounter => 'کاؤنٹر کے ساتھ';

  @override
  String get travelerHintByCountry => 'آپ کے ملک کے مطابق';

  @override
  String get travelerFlightPrayer => 'پرواز کے دوران نماز';

  @override
  String get travelerHintByFlightNumber => 'فلائٹ نمبر سے';

  @override
  String get travelerSetLocationForMakkah =>
      'مکہ کا فاصلہ دیکھنے کے لیے اوقات میں اپنا مقام مقرر کریں۔';

  @override
  String get travelerInMakkah => 'آپ مکہ مکرمہ میں ہیں — اللہ قبول فرمائے۔';

  @override
  String get travelerYourLocation => 'آپ کا مقام';

  @override
  String get travelerMakkah => 'مکہ مکرمہ';

  @override
  String get travelerQibla => 'قبلہ';

  @override
  String travelerDistanceMeters(String value) {
    return '$value میٹر';
  }

  @override
  String travelerDistanceKm(String value) {
    return '$value کلومیٹر';
  }

  @override
  String get travelerListSeparator => '، ';

  @override
  String get travelerDirectionN => 'شمال';

  @override
  String get travelerDirectionNE => 'شمال مشرق';

  @override
  String get travelerDirectionE => 'مشرق';

  @override
  String get travelerDirectionSE => 'جنوب مشرق';

  @override
  String get travelerDirectionS => 'جنوب';

  @override
  String get travelerDirectionSW => 'جنوب مغرب';

  @override
  String get travelerDirectionW => 'مغرب';

  @override
  String get travelerDirectionNW => 'شمال مغرب';

  @override
  String get travelerPrayerUnknown => 'نامعلوم';

  @override
  String get travelerPrayerShortFajr => 'فجر';

  @override
  String get travelerPrayerShortSunrise => 'طلوع';

  @override
  String get travelerPrayerShortDhuhr => 'ظہر';

  @override
  String get travelerPrayerShortAsr => 'عصر';

  @override
  String get travelerPrayerShortMaghrib => 'مغرب';

  @override
  String get travelerPrayerShortIsha => 'عشاء';

  @override
  String get travelerNoMosquesFound => 'موجودہ دائرے میں کوئی مسجد نہیں ملی۔';

  @override
  String get travelerNoRestaurantsFound =>
      'اس دائرے میں کوئی حلال ریسٹورنٹ نہیں ملا۔';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ پیدل',
      one: '$count منٹ پیدل',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'قریبی مسجد';

  @override
  String get travelerDefaultRestaurantName => 'حلال ریسٹورنٹ';

  @override
  String get travelerNoDetailedAddress => 'تفصیلی پتہ دستیاب نہیں';

  @override
  String get travelerRepeatBySituation => 'حالات کے مطابق';

  @override
  String get travelerRepeatOnce => 'ایک بار';

  @override
  String travelerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار',
      one: '$count بار',
    );
    return '$_temp0';
  }

  @override
  String get travelerStageStart => 'سفر کے آغاز پر';

  @override
  String get travelerStageOnTheWay => 'راستے میں';

  @override
  String get travelerStageStop => 'پڑاؤ کے وقت';

  @override
  String get travelerStageReturn => 'واپسی پر';

  @override
  String get travelerStageFarewell => 'مسافر کو رخصت کرنا';

  @override
  String get travelerStageFarewellReply => 'مسافر کے لیے دعا';

  @override
  String get travelerAthkarTitle => 'سفر کے اذکار';

  @override
  String get travelerAthkarLoadFailed => 'سفر کے اذکار لوڈ نہیں ہو سکے۔';

  @override
  String get travelerFarewellTitle => 'مسافر کو رخصت کرنے والے کے لیے';

  @override
  String get travelerFarewellCaption =>
      'یہ آپ کے راستے کے نہیں — بلکہ پیچھے رہ جانے والوں کے لیے ہیں';

  @override
  String get travelerRoadComplete => 'آپ نے راستے کے اذکار مکمل کر لیے';

  @override
  String get travelerRoadStations => 'راستے کے پڑاؤ';

  @override
  String get travelerRoadCompleteCaption => 'سلامتی آپ کے ساتھ رہے۔';

  @override
  String get travelerRoadCaption =>
      'ہر ذکر سفر کے اپنے موقع کا ہے — وہ پڑاؤ کھولیں جہاں آپ ہیں۔';

  @override
  String travelerShareVirtue(String virtue) {
    return 'فضیلت: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'ماخذ: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'کاؤنٹر صفر کریں';

  @override
  String get travelerCounterDone => 'مکمل';

  @override
  String get travelerCounterCount => 'گنیں';

  @override
  String get travelerCountDhikr => 'ذکر گنیں';

  @override
  String get travelerFlightPrayerTitle => 'پرواز کے دوران نماز کے اوقات';

  @override
  String get travelerShowTimes => 'اوقات دکھائیں';

  @override
  String get travelerShowMap => 'نقشہ دکھائیں';

  @override
  String get travelerShowList => 'فہرست دکھائیں';

  @override
  String get travelerSearchByFlightNumber => 'فلائٹ نمبر سے تلاش کریں';

  @override
  String get travelerRunSearchNow => 'ابھی تلاش کریں';

  @override
  String get travelerFlightAttemptsExhausted =>
      'کوششیں ختم ہو گئیں۔ دوبارہ کوشش کے لیے صفحہ پھر سے کھولیں۔';

  @override
  String get travelerFlightNumberInvalid =>
      'فلائٹ نمبر درست نہیں۔ مثال: EK202 یا MS985';

  @override
  String get travelerFlightFetchFailed =>
      'ابھی پرواز کا ڈیٹا حاصل نہیں ہو سکا۔';

  @override
  String get travelerSourceMock => 'مقامی نقل (API کے بغیر)';

  @override
  String get travelerCityRiyadh => 'ریاض';

  @override
  String get travelerCityJeddah => 'جدہ';

  @override
  String get travelerCityDubai => 'دبئی';

  @override
  String get travelerCityDoha => 'دوحہ';

  @override
  String get travelerCityIstanbul => 'استنبول';

  @override
  String get travelerCityCairo => 'قاہرہ';

  @override
  String get travelerCityKualaLumpur => 'کوالالمپور';

  @override
  String get travelerCityLondon => 'لندن';

  @override
  String get travelerCityParis => 'پیرس';

  @override
  String get travelerCityNewYork => 'نیویارک';

  @override
  String get travelerAttemptsRemaining => 'باقی کوششیں';

  @override
  String get travelerLiveTrack => 'براہِ راست روٹ';

  @override
  String get travelerTakeoff => 'روانگی';

  @override
  String get travelerLanding => 'لینڈنگ';

  @override
  String get travelerFlightEnded =>
      'پرواز ختم ہو گئی — جہاز میں کوئی نماز کا وقت باقی نہیں۔';

  @override
  String get travelerNoPrayerDuringFlight =>
      'اس پرواز کے دوران کوئی نماز کا وقت نہیں آیا۔';

  @override
  String get travelerAllFlightPrayersPassed =>
      'اس پرواز کے تمام اوقات گزر چکے ہیں۔';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ میں';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ میں',
      one: '$count منٹ میں',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return 'جہاز میں $prayer — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'جہاز میں پہلی نماز: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return 'جہاز کے مقام کے وقت کے مطابق $time ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane =>
      'جہاز کے نیچے کے مقامی وقت کے مطابق';

  @override
  String get travelerTapStopHint =>
      'کسی بھی پڑاؤ پر ٹیپ کریں تاکہ نقشے پر اس کا مقام دیکھیں';

  @override
  String get travelerUpcoming => 'آنے والی';

  @override
  String get travelerNext => 'اگلی';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · GMT $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader => 'فلائٹ نمبر سے تلاش کریں';

  @override
  String get travelerRun => 'چلائیں';

  @override
  String get travelerFlightSearchHint =>
      'فلائٹ نمبر لکھیں تاکہ ہم پورے راستے میں نماز کے اوقات کا حساب لگائیں۔';

  @override
  String get travelerFlightDetails => 'پرواز کی تفصیلات';

  @override
  String get travelerFlightNumber => 'فلائٹ نمبر';

  @override
  String get travelerFrom => 'سے';

  @override
  String get travelerTo => 'تک';

  @override
  String get travelerDataSource => 'ڈیٹا کا ماخذ';

  @override
  String get travelerFlightTimeline => 'پرواز کی ٹائم لائن';

  @override
  String get travelerNoTimesDuringFlight =>
      'اس پرواز کے دوران کوئی وقت نظر نہیں آیا۔';

  @override
  String get travelerFlightNumberExample => 'مثال: EK202';

  @override
  String get travelerShowFullRoute => 'پورا راستہ دکھائیں';

  @override
  String get travelerZoomIn => 'بڑا کریں';

  @override
  String get travelerZoomOut => 'چھوٹا کریں';

  @override
  String get travelerLocationFailed =>
      'آپ کا موجودہ مقام معلوم نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get travelerLocationServiceDisabled =>
      'لوکیشن سروس بند ہے۔ قریبی نتائج دیکھنے کے لیے اسے آن کریں۔';

  @override
  String get travelerLocationPermissionRequired =>
      'اس سہولت کے لیے لوکیشن کی اجازت ضروری ہے۔';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'لوکیشن کی اجازت مستقل طور پر مسترد ہے۔ ایپ کی ترتیبات کھولیں۔';

  @override
  String get travelerPlacesFetchFailed =>
      'ابھی قریبی نتائج حاصل نہیں ہو سکے۔ دوبارہ کوشش کریں۔';

  @override
  String get travelerExpandRadius => 'دائرہ بڑھائیں';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'سب $radius کے اندر ہیں — تیر ہر ایک کی سمت دکھاتا ہے۔';
  }

  @override
  String get travelerRadius => 'دائرہ';

  @override
  String get travelerNearestPlaces => 'قریب ترین مقامات';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آپ کے قریب $count نتائج ملے',
      one: 'آپ کے قریب $count نتیجہ ملا',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'غیر متوقع خرابی پیش آئی';

  @override
  String get travelerHalalRestricted =>
      'اسلامی ممالک میں حلال ریسٹورنٹس کی تلاش نہیں دکھائی جاتی،\nکیونکہ وہاں کے ریسٹورنٹس پہلے ہی حلال ہوتے ہیں۔';

  @override
  String get travelerOpenMapsFailed => 'نقشے کی ایپ نہیں کھل سکی۔';

  @override
  String get travelerNearestMosque => 'آپ کی قریب ترین مسجد';

  @override
  String get travelerNearestRestaurant => 'قریب ترین حلال ریسٹورنٹ';

  @override
  String get travelerTakeMeThere => 'مجھے وہاں لے چلیں';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آپ $prayer پا لیں گے — $count منٹ باقی',
      one: 'آپ $prayer پا لیں گے — $count منٹ باقی',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'پیدل شاید $prayer نہ پا سکیں — $count منٹ باقی',
      one: 'پیدل شاید $prayer نہ پا سکیں — $count منٹ باقی',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'گوگل میپس میں کھولیں';

  @override
  String get travelerTapMarkerHint => 'تفصیلات دیکھنے کے لیے نشان پر ٹیپ کریں';

  @override
  String get travelerOpenPhoneFailed => 'کال کی ایپ نہیں کھل سکی۔';

  @override
  String get travelerOpenLinkFailed => 'لنک نہیں کھل سکا۔';

  @override
  String get travelerDirections => 'راستہ';

  @override
  String get travelerGoogleMaps => 'گوگل میپس';

  @override
  String get travelerCall => 'کال کریں';

  @override
  String get travelerUpdating => 'اپ ڈیٹ ہو رہا ہے…';

  @override
  String travelerResultsCount(int count) {
    return 'نتائج کی تعداد $count';
  }

  @override
  String get travelerMyCurrentLocation => 'میرا موجودہ مقام';

  @override
  String get travelerMaps => 'نقشے';

  @override
  String get travelerMyLocation => 'میرا مقام';

  @override
  String get qiblahTitle => 'قبلہ';

  @override
  String get qiblahRefreshTooltip => 'سمت دوبارہ معلوم کریں';

  @override
  String get qiblahErrorNoSensor =>
      'آپ کا آلہ سمت معلوم کرنے والے سینسر کو سپورٹ نہیں کرتا';

  @override
  String get qiblahErrorPermissionRequired =>
      'قبلے کی سمت معلوم کرنے کے لیے لوکیشن کی اجازت دیں';

  @override
  String qiblahErrorGeneric(String error) {
    return 'قبلے کی سمت معلوم کرنے میں خرابی: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'لوکیشن سروس بند ہے۔ براہِ کرم ترتیبات سے اسے آن کریں';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'لوکیشن کی اجازت مستقل طور پر مسترد ہے۔ براہِ کرم ایپ کی ترتیبات سے فعال کریں';

  @override
  String get qiblahErrorLocationFailed => 'موجودہ مقام حاصل نہیں ہو سکا';

  @override
  String get qiblahUnknownLocation => 'نامعلوم مقام';

  @override
  String qiblahErrorDirection(String error) {
    return 'سمت معلوم کرنے میں خرابی: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'سمت کی نگرانی شروع نہیں ہو سکی';

  @override
  String get qiblahLocating => 'مقام معلوم کیا جا رہا ہے...';

  @override
  String get qiblahAligned => 'آپ کا رخ قبلے کی طرف ہے';

  @override
  String qiblahTurnLeft(int degrees) {
    return 'بائیں طرف $degrees° گھومیں';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return 'دائیں طرف $degrees° گھومیں';
  }

  @override
  String get qiblahLoadingTitle => 'قبلے کی سمت معلوم کی جا رہی ہے';

  @override
  String get qiblahLoadingSubtitle =>
      'یقینی بنائیں کہ لوکیشن آن ہے اور اجازتیں دی گئی ہیں';

  @override
  String get qiblahHintAligned => 'فون ساکن رکھیں، تیر قبلے کے نشان پر ہے';

  @override
  String get qiblahHintMove =>
      'فون آہستہ آہستہ گھمائیں یہاں تک کہ تیر نشان تک پہنچ جائے';

  @override
  String get qiblahReadingsHeader => 'قطب نما کی ریڈنگ';

  @override
  String get qiblahCurrentHeading => 'آپ کا موجودہ رخ';

  @override
  String get qiblahAngle => 'قبلے کا زاویہ';

  @override
  String get qiblahCurrentLocation => 'آپ کا موجودہ مقام';

  @override
  String get qiblahDistanceToMecca => 'مکہ تک فاصلہ';

  @override
  String qiblahDistanceKm(int km) {
    return '$km کلومیٹر';
  }

  @override
  String get qiblahInstructionsHeader => 'استعمال کی ہدایات';

  @override
  String get qiblahInstructions =>
      '• فون کو اپنے سامنے سیدھا رکھیں۔\n• آہستہ آہستہ گھومیں یہاں تک کہ سنہری تیر اوپر والے نشان سے مل جائے۔\n• سیدھ میں آنے پر حلقہ روشن ہو جائے گا اور ہلکی وائبریشن ہو گی۔\n• دھاتی چیزیں فون سے دور رکھیں۔\n• اگر سوئی بے ترتیب ہو تو فون کو 8 کی شکل میں گھمائیں۔';

  @override
  String get qiblahCompassNorth => 'شمال';

  @override
  String get qiblahCompassEast => 'مشرق';

  @override
  String get qiblahCompassSouth => 'جنوب';

  @override
  String get qiblahCompassWest => 'مغرب';

  @override
  String get homeSectionYourDay => 'آپ کا دن';

  @override
  String get homeSectionAyah => 'قرآن کی ایک آیت';

  @override
  String get homeSectionFeatures => 'خصوصیات';

  @override
  String get homeSectionKids => 'بچوں کا حصہ';

  @override
  String get homeYoungMuslimTitle => 'ننھا مسلمان';

  @override
  String get homeYoungMuslimSubtitle => 'بچوں کے لیے کہانیاں، آداب اور اذکار';

  @override
  String homeUpdateAvailable(String version) {
    return 'نئی اپ ڈیٹ دستیاب ہے · ورژن $version';
  }

  @override
  String get homeUpdateAction => 'اپ ڈیٹ';

  @override
  String get homeContinueReading => 'تلاوت جاری رکھیں';

  @override
  String get homeStartReading => 'تلاوت شروع کریں';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · صفحہ $page';
  }

  @override
  String get homeStartReadingPosition => 'سورۃ الفاتحہ سے · صفحہ 1';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · آیت $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'آیت $number';
  }

  @override
  String get homeAnotherAyah => 'ایک اور آیت';

  @override
  String get homeReadInMushaf => 'مصحف میں پڑھیں';

  @override
  String get homeTrackerComplete =>
      'آپ نے آج کی نمازیں مکمل کر لیں، اللہ قبول فرمائے';

  @override
  String get homeTrackerPrompt => 'آج جو نمازیں ادا کیں ان پر نشان لگائیں';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$total میں سے $count';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'مسلسل $days دن',
      one: 'دن',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'ہوم';

  @override
  String get homeNavSections => 'حصے';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '  $prayer : $time  \n باقی وقت : $remaining ';
  }

  @override
  String get prayerTimeHighLatAuto => 'خودکار';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'حساب کے طریقے کی طے شدہ قدر استعمال ہوتی ہے۔';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'نصف شب';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'فجر نصف شب سے پہلے نہیں اور عشاء نصف شب کے بعد نہیں ہوتی۔';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'رات کا ساتواں حصہ';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'فجر کے لیے رات کا آخری ساتواں حصہ اور عشاء کے لیے پہلا ساتواں حصہ لیا جاتا ہے۔';

  @override
  String get prayerTimeHighLatTwilightAngle => 'شفق کا زاویہ';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'رات کو فجر اور عشاء کے منتخب زاویوں کے مطابق تقسیم کیا جاتا ہے۔';

  @override
  String get prayerTimeIshaModeAngle => 'عشاء زاویے سے';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'عشاء افق سے نیچے سورج کے زاویے سے معلوم کی جاتی ہے۔';

  @override
  String get prayerTimeIshaModeInterval => 'عشاء وقفے سے';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'عشاء مغرب کے بعد مقررہ منٹوں سے معلوم کی جاتی ہے۔';

  @override
  String get prayerTimeMethodUmmAlQura => 'ام القریٰ - مکہ مکرمہ';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'رابطہ عالمِ اسلامی';

  @override
  String get prayerTimeMethodEgyptian => 'مصری جنرل سروے اتھارٹی';

  @override
  String get prayerTimeMethodKarachi => 'جامعہ علومِ اسلامیہ - کراچی';

  @override
  String get prayerTimeMethodDubai => 'دبئی';

  @override
  String get prayerTimeMethodQatar => 'قطر';

  @override
  String get prayerTimeMethodKuwait => 'کویت';

  @override
  String get prayerTimeMethodSingapore => 'سنگاپور';

  @override
  String get prayerTimeMethodTurkey => 'دیانت - ترکی';

  @override
  String get prayerTimeMethodTehran => 'تہران یونیورسٹی جیو فزکس';

  @override
  String get prayerTimeMethodMoonSighting => 'رویتِ ہلال کمیٹی';

  @override
  String get prayerTimeMethodNorthAmerica =>
      'اسلامک سوسائٹی آف نارتھ امریکا (ISNA)';

  @override
  String get prayerTimeMethodCustom => 'ذاتی ترتیب';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'فجر 18.5° اور عشاء مغرب کے 90 منٹ بعد۔';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'فجر 18° اور عشاء 17°۔';

  @override
  String get prayerTimeMethodEgyptianDesc => 'فجر 19.5° اور عشاء 17.5°۔';

  @override
  String get prayerTimeMethodKarachiDesc => 'فجر 18° اور عشاء 18°۔';

  @override
  String get prayerTimeMethodDubaiDesc => 'فجر اور عشاء 18.2°۔';

  @override
  String get prayerTimeMethodQatarDesc =>
      'فجر 18° اور عشاء مغرب کے 90 منٹ بعد۔';

  @override
  String get prayerTimeMethodKuwaitDesc => 'فجر 18° اور عشاء 17.5°۔';

  @override
  String get prayerTimeMethodSingaporeDesc => 'فجر 20° اور عشاء 18°۔';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'فجر 18° اور عشاء 17°، دیانت کی تبدیلیوں کے ساتھ۔';

  @override
  String get prayerTimeMethodTehranDesc => 'فجر 17.7°، عشاء 14° اور مغرب 4.5°۔';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'فجر 18° اور عشاء 18°، موسمی تبدیلیوں کے ساتھ۔';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'فجر 15° اور عشاء 15°۔';

  @override
  String get prayerTimeMethodCustomDesc =>
      'فجر، عشاء اور مغرب کے زاویے خود مقرر کریں۔';

  @override
  String get prayerTimeMadhabShafi => 'شافعی، مالکی اور حنبلی';

  @override
  String get prayerTimeMadhabHanafi => 'حنفی';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'عصر اس وقت جب کسی چیز کا سایہ اس کے برابر ہو جائے؛ مالکی اور حنبلی بھی یہی مانتے ہیں۔';

  @override
  String get prayerTimeMadhabHanafiDesc =>
      'عصر اس وقت جب کسی چیز کا سایہ اس سے دوگنا ہو جائے۔';

  @override
  String get prayerTimeCalcIntro =>
      'وہ کیلنڈر منتخب کریں جو آپ کے علاقے میں رائج ہے، اور اگر محلے کی مسجد سے ملانا ہو تو اوقات خود درست کریں۔';

  @override
  String get prayerTimeCalcMethod => 'حساب کا طریقہ';

  @override
  String get prayerTimeCalcAsrMadhab => 'عصر کے حساب کا مسلک';

  @override
  String get prayerTimeMadhabShafiShort => 'شافعی';

  @override
  String get prayerTimeCalcHighLatitude => 'بلند عرضِ بلد';

  @override
  String get prayerTimeCalcRamadanIsha => 'رمضان میں عشاء مؤخر کریں';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'ام القریٰ کیلنڈر کی طرح پورے مہینے عشاء میں 30 منٹ کا اضافہ کرتا ہے۔';

  @override
  String get prayerTimeCalcRestoreDefaults => 'ام القریٰ کی ترتیبات بحال کریں';

  @override
  String get prayerTimeCalcCustomAngles => 'ذاتی حساب کے زاویے';

  @override
  String get prayerTimeCalcFajrAngle => 'فجر کا زاویہ';

  @override
  String get prayerTimeCalcIshaMode => 'عشاء کا حساب';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'یا تو شفق کے زاویے سے، یا مغرب کے بعد مقررہ وقفے سے۔';

  @override
  String get prayerTimeCalcIshaAngle => 'عشاء کا زاویہ';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'مغرب کے بعد عشاء';

  @override
  String get prayerTimeCalcMaghribAngleToggle => 'غروب کے بجائے مغرب کا زاویہ';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'ان کے لیے جو مغرب کے لیے غروب کے لمحے کے بجائے شفق کا زاویہ مانتے ہیں۔';

  @override
  String get prayerTimeCalcMaghribAngle => 'مغرب کا زاویہ';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value منٹ';
  }

  @override
  String get prayerTimeMinutesZero => '0 منٹ';

  @override
  String get prayerTimeCalcManualAdjust => 'ہر وقت کی دستی تبدیلی';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'اوقات کو محلے کی مسجد سے منٹ بہ منٹ ملائیں';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اوقات دستی طور پر تبدیل',
      one: '$count وقت دستی طور پر تبدیل',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'نماز';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return '$prayer کی اذان';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return '$prayer کی اذان • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'آؤ نماز کی طرف — اپنے دن کا آغاز فجر کے نور سے کریں۔';

  @override
  String get prayerTimeAthanBodyDhuhr => 'اسے دل کا آرام بنائیں۔';

  @override
  String get prayerTimeAthanBodyAsr => 'اللہ کے حضور اپنی حاضری تازہ کریں۔';

  @override
  String get prayerTimeAthanBodyMaghrib =>
      'اپنے دن کا اختتام اطاعت اور سکون سے کریں۔';

  @override
  String get prayerTimeAthanBodyIsha => 'دن کی آخری نماز نہ چھوڑیں۔';

  @override
  String get prayerTimeAthanBodyDefault => 'اللہ آپ کی عبادت قبول فرمائے۔';

  @override
  String get prayerTimeAthanExpandedHint =>
      'نماز کا الرٹ اور تفصیلات کھولنے کے لیے ٹیپ کریں۔';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return 'اب $prayer کی اذان کا وقت ہو گیا ہے';
  }

  @override
  String get prayerTimeAlertNow => 'نماز کا وقت ہو گیا ہے';

  @override
  String get prayerTimeAlertMessage =>
      'خشوع سے نماز ادا کریں، یہ دل کا نور اور روح کا سکون ہے۔';

  @override
  String get prayerTimeAlertReady => 'میں نماز کے لیے تیار ہوں';

  @override
  String get prayerTimeAlertOpenTimes => 'نماز کے اوقات کا صفحہ کھولیں';

  @override
  String get prayerTimeTitle => 'نماز کے اوقات';

  @override
  String get prayerTimeSettingsTitle => 'نماز کے اوقات کی ترتیبات';

  @override
  String get prayerTimeSheetAthanTime => 'اذان کا وقت';

  @override
  String get prayerTimeSheetUntilDhuhr => 'ظہر تک';

  @override
  String get prayerTimeSheetWindow => 'وقت کا دورانیہ';

  @override
  String get prayerTimeSheetShift => 'آج سے فرق';

  @override
  String get prayerTimeWeekdaySat => 'ہفتہ';

  @override
  String get prayerTimeWeekdaySun => 'اتوار';

  @override
  String get prayerTimeWeekdayMon => 'پیر';

  @override
  String get prayerTimeWeekdayTue => 'منگل';

  @override
  String get prayerTimeWeekdayWed => 'بدھ';

  @override
  String get prayerTimeWeekdayThu => 'جمعرات';

  @override
  String get prayerTimeWeekdayFri => 'جمعہ';

  @override
  String get prayerTimeLessThanMinute => 'ایک منٹ سے کم';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours گھنٹے';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String get prayerTimeShiftSameDay => 'آج ہی';

  @override
  String get prayerTimeShiftNone => 'کوئی فرق نہیں';

  @override
  String prayerTimeShiftLater(int minutes) {
    return '$minutes منٹ دیر سے';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return '$minutes منٹ پہلے';
  }

  @override
  String get prayerTimeAm => 'AM';

  @override
  String get prayerTimePm => 'PM';

  @override
  String get prayerTimeLocationSourceManual => 'دستی انتخاب';

  @override
  String get prayerTimeLocationSourceDevice => 'ڈیوائس کا مقام';

  @override
  String get prayerTimeLocationPickHint =>
      'شہر منتخب کریں یا ڈیوائس کا مقام استعمال کریں';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'ابھی کوئی مقام مقرر نہیں';

  @override
  String get prayerTimeMyLocation => 'میرا موجودہ مقام';

  @override
  String get prayerTimeGrantPermission => 'اجازت دیں';

  @override
  String get prayerTimeEmptyWeekTitle =>
      'ہفتے کا جدول دیکھنے کے لیے اپنا مقام مقرر کریں';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'اپنا شہر تلاش کریں یا ڈیوائس کا مقام استعمال کریں';

  @override
  String get prayerTimeSetLocation => 'مقام مقرر کریں';

  @override
  String get prayerTimeWeekNeedsCity =>
      'پورے ہفتے کے اوقات دیکھنے کے لیے اپنا شہر مقرر کریں';

  @override
  String get prayerTimeWeekHint =>
      'باقی دنوں کے لیے جدول افقی طور پر کھسکائیں · تفصیل کے لیے کسی بھی وقت کو چھوئیں';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'قیام اللیل · $day';
  }

  @override
  String get prayerTimeMidnight => 'نصف شب';

  @override
  String get prayerTimeMidnightHint => 'مغرب اور فجر کا درمیانی وقت';

  @override
  String get prayerTimeLastThird => 'رات کا آخری تہائی حصہ';

  @override
  String get prayerTimeLastThirdHint => 'قیام اور دعا کا بہترین وقت';

  @override
  String get prayerTimeLocationHeader => 'مقام';

  @override
  String get prayerTimeLocationUpdateFailed =>
      'موجودہ مقام اپ ڈیٹ نہیں ہو سکا۔';

  @override
  String get prayerTimeToday => 'آج';

  @override
  String get prayerTimeTomorrow => 'کل';

  @override
  String get prayerTimeTablePrayerColumn => 'نماز';

  @override
  String get prayerTimeSettingsCalcHeader => 'اوقات کے حساب کا طریقہ';

  @override
  String get prayerTimeSettingsSilentHeader => 'نماز کے وقت سائلنٹ';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'یہ سہولت چلانے کے لیے پہلے «ڈسٹرب نہ کریں» کی اجازت دیں۔';

  @override
  String get prayerTimeSettingsSaved =>
      'نماز کے اوقات کی ترتیبات محفوظ ہو گئیں۔';

  @override
  String get prayerTimeSilentHint =>
      'نماز کے وقت فون سائلنٹ ہو جاتا ہے اور پھر خودبخود آواز واپس آ جاتی ہے۔';

  @override
  String get prayerTimeSilentEnable => 'خودکار سائلنٹ فعال کریں';

  @override
  String get prayerTimeSilentPermissionNote =>
      'اس سہولت کے لیے سسٹم کی «ڈسٹرب نہ کریں» اجازت درکار ہے۔';

  @override
  String get prayerTimeSilentDuration => 'نماز کے بعد سائلنٹ کا دورانیہ';

  @override
  String get prayerTimeMinutesSuffix => 'منٹ';

  @override
  String get prayerTimeSaving => 'محفوظ ہو رہا ہے';

  @override
  String get prayerTimeSaveSettings => 'ترتیبات محفوظ کریں';

  @override
  String get prayerTimeSavedLocation => 'محفوظ شدہ مقام';

  @override
  String get prayerTimePickerMapPointLabel => 'نقشے پر منتخب مقام';

  @override
  String get prayerTimePickerResolving =>
      'منتخب مقام کا نام معلوم کیا جا رہا ہے...';

  @override
  String get prayerTimePickerTapMap =>
      'علاقہ مقرر کرنے کے لیے نقشے پر ٹیپ کریں';

  @override
  String get prayerTimePickerTitle => 'علاقہ منتخب کریں';

  @override
  String get prayerTimePickerSubtitle =>
      'تلاش کریں یا نقشے پر کوئی مقام منتخب کریں';

  @override
  String get prayerTimePickerUsingDevice =>
      'ڈیوائس کا مقام استعمال ہو رہا ہے...';

  @override
  String get prayerTimePickerUseDevice => 'ڈیوائس کا موجودہ مقام استعمال کریں';

  @override
  String get prayerTimePickerMapTab => 'نقشہ';

  @override
  String get prayerTimePickerSearchHint => 'شہر یا ملک کا نام';

  @override
  String get prayerTimePickerNoResults => 'کوئی ملتا جلتا نتیجہ نہیں ملا';

  @override
  String get prayerTimePickerStartTyping => 'شہر کا نام لکھنا شروع کریں';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'علاقہ منتخب کرنے کے لیے نقشے پر ٹیپ کریں';

  @override
  String get prayerTimePickerApplying => 'لاگو ہو رہا ہے';

  @override
  String get prayerTimePickerApply => 'لاگو کریں';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'موجودہ: $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'اگلی: $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'لوکیشن آن کریں';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'علاقہ مقرر کیے بغیر نماز کے اوقات نہیں دکھائے جا سکتے';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'شہر خود منتخب کریں یا ڈیوائس کا موجودہ مقام استعمال کریں';

  @override
  String get prayerTimeTimelineChooseArea => 'علاقہ منتخب کریں';

  @override
  String get prayerTimeNow => 'ابھی';

  @override
  String get prayerTimeNextBadge => 'اگلی';

  @override
  String get prayerTimeRowNext => 'اگلی نماز';

  @override
  String get prayerTimeRowCompleted => 'وقت گزر گیا';

  @override
  String get prayerTimeRowLocalTime => 'مقامی وقت';

  @override
  String get prayerTimeLoadingTimes => 'اوقات لوڈ ہو رہے ہیں';

  @override
  String get prayerTimeLocatingShort => 'مقام معلوم کیا جا رہا ہے';

  @override
  String get prayerTimeNoticeUnavailable =>
      'نماز کے درست اوقات دیکھنے کے لیے لوکیشن آن کریں یا اجازت دیں۔';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'موجودہ اوقات آخری محفوظ مقام کے مطابق ہیں۔ خودکار اپ ڈیٹ کے لیے لوکیشن آن کریں۔';

  @override
  String get prayerTimeNoticeServiceOff =>
      'لوکیشن سروس بند ہے۔ اپنے موجودہ مقام کے مطابق نماز کے اوقات دیکھنے کے لیے اسے آن کریں۔';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'موجودہ اوقات آخری محفوظ مقام کے مطابق ہیں۔ ابھی اپ ڈیٹ کرنے کے لیے لوکیشن کی اجازت دیں۔';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'لوکیشن کی اجازت نہیں دی گئی۔ موجودہ مقام کے مطابق اوقات دیکھنے کے لیے اجازت دیں۔';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'موجودہ اوقات آخری محفوظ مقام کے مطابق ہیں۔ لوکیشن کی اجازت دوبارہ فعال کرنے کے لیے ترتیبات کھولیں۔';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'لوکیشن کی اجازت مستقل طور پر مسترد ہے۔ درست اوقات کے لیے ترتیبات کھول کر اسے فعال کریں۔';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'ابھی مقام اپ ڈیٹ نہیں ہو سکا، اس لیے آخری محفوظ مقام استعمال ہو رہا ہے۔';

  @override
  String get prayerTimeNoticeError =>
      'ابھی مقام معلوم نہیں ہو سکا۔ اوقات دیکھنے کے لیے لوکیشن آن کریں یا اجازت دیں۔';

  @override
  String get prayerTimeOpenSettings => 'ترتیبات کھولیں';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return '$prayer کا وقت ہو گیا';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return '$prayer ایک منٹ سے کم میں';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes منٹ میں',
      one: '$minutes منٹ میں',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours گھنٹوں میں',
      one: '$hours گھنٹے میں',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer $hours گھنٹے $minutes منٹ میں';
  }

  @override
  String get prayerTimeRemainingNow => 'وقت ہو گیا';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return '$minutes منٹ باقی';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return '$hours گھنٹے باقی';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ باقی';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'موجودہ مقام';

  @override
  String get prayerTimeYouAreInTime => 'اب وقت ہے';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · ام القریٰ کیلنڈر';
  }

  @override
  String get prayerTimeAllTimes => 'تمام اوقات';

  @override
  String get prayerTimeMuteAthan => 'اس نماز کی اذان خاموش کریں';

  @override
  String get prayerTimeUnmuteAthan => 'اس نماز کی اذان چلائیں';

  @override
  String get prayerTimeQuickMushaf => 'مصحف';

  @override
  String get prayerTimeQuickPrayerTimes => 'نماز کے اوقات';

  @override
  String get prayerTimeQuickAdhkar => 'اذکار لائبریری';

  @override
  String get prayerTimeErrorLoad => 'ابھی نماز کے اوقات لوڈ نہیں ہو سکے';

  @override
  String get prayerTimeErrorUpdateArea => 'منتخب علاقہ اپ ڈیٹ نہیں ہو سکا';

  @override
  String get prayerTimeErrorApplySettings =>
      'نئی ترتیبات کے ساتھ اوقات اپ ڈیٹ نہیں ہو سکے';

  @override
  String get prayerTimeErrorServiceOff =>
      'لوکیشن سروس بند ہے۔ اسے آن کریں یا شہر خود منتخب کریں۔';

  @override
  String get prayerTimeErrorPermission =>
      'لوکیشن کی اجازت دیں یا شہر خود منتخب کریں۔';

  @override
  String get prayerTimeErrorDeniedForever =>
      'لوکیشن کی اجازت مستقل طور پر مسترد ہے۔ ترتیبات کھولیں یا شہر منتخب کریں۔';

  @override
  String get prayerTimeErrorDeviceLocation =>
      'ابھی ڈیوائس کا مقام معلوم نہیں ہو سکا';

  @override
  String get homeWidgetsPinFailed =>
      'شامل کرنے کی ونڈو نہیں کھل سکی۔ ہوم اسکرین سے خود شامل کریں۔';

  @override
  String get homeWidgetsSyncSuccess => 'ویجٹس اپ ڈیٹ ہو گئے';

  @override
  String get homeWidgetsSyncFailed =>
      'اپ ڈیٹ نہیں ہو سکا۔ یقینی بنائیں کہ آپ کا مقام مقرر ہے۔';

  @override
  String get homeWidgetsAddTooltip => 'ہوم اسکرین پر شامل کریں';

  @override
  String get homeWidgetsTitle => 'ہوم اسکرین ویجٹس';

  @override
  String get homeWidgetsHowToHeader => 'شامل کرنے کا طریقہ';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'ویجٹ کے ساتھ والا شامل کریں بٹن دبائیں، یا ہوم اسکرین کی خالی جگہ پر دیر تک دبائیں، پھر «ویجٹس» منتخب کر کے «$appName» تلاش کریں۔';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'ہوم اسکرین کی خالی جگہ پر دیر تک دبائیں، پھر اسکرین کے اوپر «+» بٹن دبائیں اور «$appName» تلاش کریں۔ اگلی نماز کا ویجٹ لاک اسکرین کے لیے بھی دستیاب ہے۔';
  }

  @override
  String get homeWidgetsListHeader => 'ویجٹس';

  @override
  String get homeWidgetsNextPrayerTitle => 'اگلی نماز';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'نماز کا نام اور وقت، براہِ راست الٹی گنتی کے ساتھ';

  @override
  String get homeWidgetsNextPrayerSubtitleIos =>
      'چھوٹا سائز · اور لاک اسکرین کے تین انداز';

  @override
  String get homeWidgetsTodayTimesTitle => 'آج کے اوقات';

  @override
  String get homeWidgetsTodayTimesSubtitle =>
      'چھ اوقات، ہجری تاریخ اور شہر کے ساتھ';

  @override
  String get homeWidgetsDailyAyahTitle => 'آج کی آیت';

  @override
  String get homeWidgetsDailyAyahSubtitle => 'ایک مختصر آیت جو روز بدلتی ہے';

  @override
  String get homeWidgetsSyncHeader => 'ہم آہنگی';

  @override
  String get homeWidgetsSyncNow => 'ویجٹس ابھی اپ ڈیٹ کریں';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days دنوں',
      one: '$days دن',
    );
    return 'آپ کے موجودہ مقام اور ترتیبات کے مطابق $_temp0 کے اوقات کا حساب لگاتا ہے';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days دن',
      one: '$days دن',
    );
    return 'ویجٹس ایپ کھولے بغیر $_temp0 تک کام کرتے ہیں اور پس منظر میں خودبخود تازہ ہوتے ہیں۔ مقام یا حساب کا طریقہ بدلنے پر یہ خود اپ ڈیٹ ہو جاتے ہیں۔';
  }

  @override
  String get settingsDeveloperName => 'معتصم الہلالی';

  @override
  String get settingsUpdateStarting => 'ایپ کی اپ ڈیٹ شروع ہو رہی ہے...';

  @override
  String get settingsUpdateUpToDate =>
      'آپ ایپ کا تازہ ترین ورژن استعمال کر رہے ہیں۔';

  @override
  String get settingsUpdateCheckFailed =>
      'اپ ڈیٹس چیک نہیں ہو سکیں، بعد میں کوشش کریں۔';

  @override
  String get settingsGroupPreferences => 'ترجیحات';

  @override
  String get settingsDarkModeTitle => 'ڈارک موڈ';

  @override
  String get settingsStatusOn => 'آن';

  @override
  String get settingsStatusOff => 'آف';

  @override
  String get settingsNotificationsTitle => 'اطلاعات کی ترتیبات';

  @override
  String get settingsNotificationsSubtitle =>
      'ایپ کی ہر اطلاع کو اپنی مرضی سے کنٹرول کریں';

  @override
  String get settingsDownloadsTitle => 'ڈاؤن لوڈ کی ترتیبات';

  @override
  String get settingsDownloadsSubtitle =>
      'ڈاؤن لوڈ شدہ فائلوں اور جگہ کا انتظام';

  @override
  String get settingsGroupApp => 'ایپ';

  @override
  String get settingsCheckUpdatesTitle => 'اپ ڈیٹس چیک کریں';

  @override
  String get settingsCheckUpdatesSubtitle =>
      'یقینی بنائیں کہ آپ تازہ ترین ورژن استعمال کر رہے ہیں';

  @override
  String get settingsAboutUsTitle => 'ہمارے بارے میں';

  @override
  String get settingsAboutUsSubtitle =>
      'طمأنينة ایپ اور اس کے مقصد کے بارے میں جانیں';

  @override
  String get settingsRateAppTitle => 'ایپ کو ریٹ کریں';

  @override
  String get settingsRateAppSubtitle =>
      'اسٹور پر ریٹنگ دے کر خیر پھیلانے میں حصہ لیں';

  @override
  String get settingsGroupPrivacy => 'رازداری اور تحفظ';

  @override
  String get settingsPrivacyPolicyTitle => 'رازداری کی پالیسی';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'ایپ آپ کے ڈیٹا اور اجازتوں کو کیسے استعمال کرتی ہے';

  @override
  String get settingsDataSafetyTitle => 'ڈیٹا کا تحفظ';

  @override
  String get settingsDataSafetySubtitle =>
      'ڈیٹا، اجازتوں اور ان کے استعمال کا خلاصہ';

  @override
  String get settingsGroupDeveloper => 'ڈیولپر';

  @override
  String get settingsAboutDeveloperTitle => 'ڈیولپر کے بارے میں';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'ڈیولپر کی معلومات اور رابطے کے لنکس';

  @override
  String get settingsDeveloperContactSubtitle =>
      'ویب سائٹ یا واٹس ایپ کے ذریعے براہِ راست رابطہ';

  @override
  String get settingsPersonalWebsite => 'ذاتی ویب سائٹ';

  @override
  String get settingsGroupFollowNews => 'تازہ خبروں سے باخبر رہیں';

  @override
  String get settingsSocialTelegram => 'ٹیلیگرام';

  @override
  String get settingsSocialWhatsapp => 'واٹس ایپ';

  @override
  String get settingsSocialFacebook => 'فیس بک';

  @override
  String get settingsSocialInstagram => 'انسٹاگرام';

  @override
  String get settingsSocialTwitter => 'ٹویٹر';

  @override
  String get settingsPrivacyIntro =>
      'ایپ آپ کے ڈیٹا کو کیسے استعمال کرتی ہے، اس بارے میں واضح اور مختصر معلومات۔';

  @override
  String get settingsPrivacyMattersTitle => 'آپ کی رازداری ہمارے لیے اہم ہے';

  @override
  String get settingsPrivacyMattersBody =>
      'طمأنينة میں ہماری کوشش ہے کہ ایپ کا استعمال واضح اور محفوظ ہو۔ ہم صرف وہی ڈیٹا استعمال کرتے ہیں جو ایپ کی سہولیات چلانے اور بہتر بنانے کے لیے ضروری ہو، اور صارفین کا ڈیٹا نہ بیچتے ہیں نہ اشتہاری مقاصد کے لیے شیئر کرتے ہیں۔';

  @override
  String get settingsPrivacyDataUsedTitle =>
      'وہ ڈیٹا جو ایپ استعمال کر سکتی ہے';

  @override
  String get settingsPrivacyDataUsedBody =>
      'ایپ نماز کے اوقات اور قبلے کے حساب کے لیے مقام، اذان اور اذکار کی یاد دہانی کے لیے اطلاعات، ڈاؤن لوڈ شدہ مواد اور مقامی ترتیبات محفوظ کرنے کے لیے اسٹوریج، اور صرف صارف کی فعال کردہ سہولیات جیسے فجر کے ساتھی میں رابطے استعمال کر سکتی ہے۔';

  @override
  String get settingsPrivacyControlTitle => 'اپنے ڈیٹا پر اختیار';

  @override
  String get settingsPrivacyControlBody =>
      'آپ ایپ کے اندر اطلاعات کی ترتیبات سے اطلاعات بند یا تبدیل کر سکتے ہیں، اور کسی بھی وقت اپنی ڈیوائس کی ترتیبات سے سسٹم کی اجازتوں کا انتظام کر سکتے ہیں۔';

  @override
  String get settingsPrivacyThirdPartyTitle => 'بیرونی سروسز';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'ایپ ترتیبات کی تازہ کاری اور عمومی اطلاعات بھیجنے کے لیے Firebase Remote Config اور Firebase Messaging جیسی سروسز استعمال کر سکتی ہے۔ یہ سروسز صرف ایپ چلانے اور تجربہ بہتر بنانے کے لیے استعمال ہوتی ہیں۔';

  @override
  String get settingsDataSafetyIntro =>
      'ایپ کے استعمال کردہ ڈیٹا اور اس کے محفوظ اور شیئر ہونے کے طریقے کا خلاصہ۔';

  @override
  String get settingsDataSafetySensitiveTitle => 'حساس ڈیٹا';

  @override
  String get settingsDataSafetySensitiveBody =>
      'ایپ حساس ڈیٹا صرف اسی وقت مانگتی ہے جب صارف کسی واضح سہولت کا انتخاب کرے۔ کچھ ڈیٹا جیسے یاد دہانی کے اوقات، ترجیحات اور تلاوت کے منصوبے ڈیوائس پر ہی محفوظ ہوتے ہیں۔';

  @override
  String get settingsDataSafetyLocationTitle => 'مقام';

  @override
  String get settingsDataSafetyLocationBody =>
      'مقام نماز کے اوقات، قبلے کی سمت اور مقام پر مبنی سہولیات کے لیے استعمال ہوتا ہے۔ صارف سسٹم کی ترتیبات سے لوکیشن کی اجازت بند کر سکتا ہے۔';

  @override
  String get settingsDataSafetyNotificationsTitle => 'اطلاعات';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'ایپ اذان، اذکار، یاد دہانیوں اور کچھ عمومی پیغامات کے لیے اطلاعات استعمال کرتی ہے۔ ہر قسم کی اطلاع کو اطلاعات کی ترتیبات کے صفحے سے کنٹرول کیا جا سکتا ہے۔';

  @override
  String get settingsDataSafetyStorageTitle => 'اسٹوریج اور ڈاؤن لوڈ';

  @override
  String get settingsDataSafetyStorageBody =>
      'ایپ ان فائلوں اور مواد کو محفوظ کرنے کے لیے اسٹوریج استعمال کر سکتی ہے جنہیں صارف ڈاؤن لوڈ کرنا چاہے، جیسے آڈیوز یا ایپ میں دستیاب مواد۔';

  @override
  String get settingsDataSafetySharingTitle => 'شیئرنگ';

  @override
  String get settingsDataSafetySharingBody =>
      'آپ کا ذاتی ڈیٹا فروخت یا مارکیٹنگ کے لیے بیرونی فریقوں کے ساتھ شیئر نہیں کیا جاتا۔ اگر کوئی شیئرنگ ہوتی ہے تو وہ ضروری آپریشنل سروسز یا صارف کے اپنے عمل کے تحت ہوتی ہے۔';

  @override
  String get settingsAboutAppBody =>
      'ایک قرآنی اور عبادتی ایپ جو نماز، ذکر، تلاوتِ قرآن اور روزانہ ورد پر سکون کے ساتھ اور آسان انداز میں قائم رہنے میں آپ کی مدد کرتی ہے۔';

  @override
  String get settingsAboutMissionTitle => 'ہمارا مقصد';

  @override
  String get settingsAboutMissionBody =>
      'یہ ایپ ایک ہلکا پھلکا ساتھی ہو جو بغیر پریشان کیے اطاعت میں مدد دے، اور مصحف، اذکار، نماز کے اوقات، یاد دہانیوں اور خاندان کے لیے مددگار سہولیات جیسے اہم روزمرہ ٹولز کو ایک جگہ جمع کرے۔';

  @override
  String get settingsAboutOfferTitle => 'ہم کیا پیش کرتے ہیں';

  @override
  String get settingsAboutOfferBody =>
      'مصحف، اذکار، نماز کے اوقات، قبلہ، روزانہ ورد، ویجٹس، فجر کے ساتھی، ننھا مسلمان، مسافر کی سہولیات، اور صارف کی ضرورت کے مطابق قابلِ ترتیب یاد دہانیاں۔';

  @override
  String get settingsDeveloperHeroBody =>
      '7 سال سے زائد تجربہ رکھنے والے Full Stack اور Mobile سافٹ ویئر انجینئر، Flutter، Laravel اور Next.js کے ماہر، جو ویب اور موبائل کے لیے پروڈکشن ایپس بناتے ہیں۔';

  @override
  String get settingsDeveloperBioTitle => 'مختصر تعارف';

  @override
  String get settingsDeveloperBioBody =>
      'معتصم الہلالی حقیقی صارفین کی خدمت کرنے والی ایپس اور ڈیجیٹل پلیٹ فارمز بناتے ہیں، اور موبائل ایپس، بیک اینڈ سسٹمز، یوزر انٹرفیس، اور Fintech و SaaS پلیٹ فارمز میں خاص دلچسپی رکھتے ہیں۔';

  @override
  String get settingsDeveloperFieldsTitle => 'کام کے شعبے';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter، Laravel، Next.js، React، API Development، موبائل ایپس، ویب ایپس، Fintech حل، اور SaaS پلیٹ فارمز۔';

  @override
  String get settingsDeveloperContactTitle => 'رابطے کے ذرائع';

  @override
  String get settingsContactWebsite => 'ویب سائٹ';

  @override
  String get settingsContactEmail => 'ای میل';

  @override
  String get settingsAppLinksTitle => 'ایپ کے لنکس';

  @override
  String get notifSettingsLabelAppNotifications => 'ایپ کی اطلاعات';

  @override
  String get notifSettingsLabelAllAthan => 'تمام اذانوں کی اطلاعات';

  @override
  String notifSettingsAthanOf(String prayer) {
    return '$prayer کی اذان';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'قیام اللیل';

  @override
  String get notifSettingsLabelThikrMorning => 'صبح کے اذکار';

  @override
  String get notifSettingsLabelThikrEvening => 'شام کے اذکار';

  @override
  String get notifSettingsLabelThikrWakeUp => 'بیدار ہونے کے اذکار';

  @override
  String get notifSettingsLabelThikrSleep => 'سونے کے اذکار';

  @override
  String get notifSettingsLabelSalawat => 'محمد ﷺ پر درود';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'بے ترتیب آڈیو اذکار';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'تیرتے اذکار اور متبادل یاد دہانیاں';

  @override
  String get notifSettingsLabelDailyQuranWird => 'روزانہ قرآنی ورد';

  @override
  String get notifSettingsLabelReadSurahMulk => 'سورۃ الملک کی تلاوت';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'کسی مخصوص سورت کی تلاوت';

  @override
  String get notifSettingsLabelReadSurahKahf => 'سورۃ الکہف کی تلاوت';

  @override
  String get notifSettingsLabelFasting => 'روزے کی یاد دہانی';

  @override
  String get notifSettingsLabelFastingMonday => 'پیر کا روزہ';

  @override
  String get notifSettingsLabelFastingThursday => 'جمعرات کا روزہ';

  @override
  String get notifSettingsLabelBestDua =>
      'اللہ سبحانہ و تعالیٰ کو محبوب بہترین دعا جس کا بڑا اثر ہے';

  @override
  String get notifSettingsLabelWirdMorning => 'صبح کا ورد';

  @override
  String get notifSettingsLabelWirdEvening => 'شام کا ورد';

  @override
  String get notifSettingsLabelWirdNight => 'سونے سے پہلے کا ورد';

  @override
  String get notifSettingsLabelWirdSummary => 'روزانہ ورد کا خلاصہ';

  @override
  String get notifSettingsLabelYoungMuslim => 'ننھا مسلمان کی یاد دہانی';

  @override
  String get notifSettingsLabelQuranPlan => 'قرآن کے منصوبوں کی یاد دہانی';

  @override
  String get notifSettingsLabelGeneral => 'ایپ کی عمومی اطلاعات';

  @override
  String get notifSettingsTitleRandomThikr => 'بے ترتیب ذکر';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'تیرتے اذکار';

  @override
  String get notifSettingsTitlePrayerAthan => 'نماز کی اذان';

  @override
  String get notifSettingsBodyThikrMorning => 'صبح کے اذکار نہ بھولیں!';

  @override
  String get notifSettingsBodyThikrEvening => 'شام کے اذکار نہ بھولیں!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'قیام اللیل کا وقت ہو گیا، رات کے آخری تہائی حصے سے فائدہ اٹھائیں۔';

  @override
  String get notifSettingsBodySalawat =>
      'نبی ﷺ پر درود بھیجیں، آپ کا دن خوشگوار گزرے گا۔';

  @override
  String get notifSettingsBodyRememberAllah =>
      'اللہ کو یاد کریں، وہ آپ کو یاد رکھے گا!';

  @override
  String get notifSettingsBodyReadQuran =>
      'اپنے روزانہ قرآنی ورد کے لیے وقت نکالیں۔';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'آج رات سورۃ الملک پڑھنا نہ بھولیں۔';

  @override
  String get notifSettingsBodyThikrSleep => 'سونے سے پہلے سونے کے اذکار پڑھیں۔';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'بیدار ہو کر اپنے دن کا آغاز اللہ کے ذکر سے کریں۔';

  @override
  String get notifSettingsBodyReadSurah =>
      'آج اپنی منتخب سورت پڑھنا نہ بھولیں۔';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'جمعہ کے دن سورۃ الکہف پڑھنا نہ بھولیں۔';

  @override
  String get notifSettingsBodyFasting => 'نفلی روزے کی یاد دہانی۔';

  @override
  String get notifSettingsBodyFastingMonday => 'پیر کے روزے کی یاد دہانی۔';

  @override
  String get notifSettingsBodyFastingThursday => 'جمعرات کے روزے کی یاد دہانی۔';

  @override
  String get notifSettingsBodyAthanTime => 'اذان کا وقت ہو گیا ہے۔';

  @override
  String get notifSettingsBodyWirdMorning =>
      'اپنے دن کا آغاز عبادت کے زادِ راہ سے کریں۔';

  @override
  String get notifSettingsBodyWirdEvening =>
      'شام کے زادِ راہ سے اللہ سے اپنا تعلق تازہ کریں۔';

  @override
  String get notifSettingsBodyWirdNight =>
      'اپنے دن کا اختتام ذکر اور دعا سے کریں۔';

  @override
  String get notifSettingsBodyWirdSummary => 'آج کی اپنی عبادات کا جائزہ لیں۔';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'ننھا مسلمان کے مواد پر واپس آنے کی یاد دہانی۔';

  @override
  String get notifSettingsBodyQuranPlan =>
      'اپنے قرآنی منصوبے کی آج کی نشست نہ بھولیں۔';

  @override
  String get notifSettingsBodyGeneral =>
      'طمأنينة ایپ کی عمومی اطلاعات اور الرٹس۔';

  @override
  String get notifSettingsAllPrayers => 'تمام نمازیں';

  @override
  String get notifSettingsSalawatShort => 'درود شریف';

  @override
  String get notifSettingsQuranWirdShort => 'قرآنی ورد';

  @override
  String get notifSettingsGroupGeneral => 'عمومی';

  @override
  String get notifSettingsGroupAthan => 'اذان';

  @override
  String get notifSettingsGroupDailyWird => 'روزانہ ورد';

  @override
  String get notifSettingsGroupAdhkar => 'اذکار';

  @override
  String get notifSettingsGroupQuran => 'قرآن';

  @override
  String get notifSettingsGroupAppSections => 'ایپ کے حصے';

  @override
  String get notifSettingsGroupNightAndWaking => 'رات اور بیداری';

  @override
  String get notifSettingsGroupFasting => 'روزہ';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'بار بار آنے والے اذکار';

  @override
  String get notifSettingsGroupSystem => 'سسٹم';

  @override
  String get notifSettingsMasterTitle => 'ایپ کی تمام اطلاعات';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'اطلاعات فعال ہیں، آپ نیچے ہر قسم کو ترتیب دے سکتے ہیں';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'یہ سوئچ آن کرنے تک تمام اطلاعات بند ہیں';

  @override
  String get notifSettingsSystemTitle => 'سسٹم کی اطلاعات';

  @override
  String get notifSettingsSystemSubtitle =>
      'اپنی ڈیوائس پر شیڈول شدہ اور فعال اطلاعات دیکھیں';

  @override
  String get notifSettingsStatusStopped => 'بند';

  @override
  String get notifSettingsStatusEnabled => 'فعال';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'روزانہ · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'ہر گھنٹے، منٹ $minute پر';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ہر $count منٹ',
      one: 'ہر منٹ',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => '، ';

  @override
  String get notifSettingsNoDaysSelected => 'کوئی دن منتخب نہیں';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'ہفتہ وار ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذاتی شیڈول · $count اوقات',
      one: 'ذاتی شیڈول · $count وقت',
      zero: 'ذاتی شیڈول · کوئی وقت نہیں',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'یاد دہانی کے اوقات';

  @override
  String get notifSettingsEditScheduleTitle => 'شیڈول میں ترمیم';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'دہرانے کی قسم اور یاد دہانی کا وقت بدلیں';

  @override
  String get notifSettingsExtraSchedulesTitle => 'اضافی اوقات کا انتظام';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'اس اطلاع کے لیے ایک سے زیادہ وقت شامل کریں';

  @override
  String get notifScheduleBodyAllAthan =>
      'تمام اذانوں کی یاد دہانی ان کے مقررہ اوقات پر دہرائی جائے گی۔';

  @override
  String get notifScheduleBodyAthanFajr =>
      'فجر کی اذان کا وقت ہو گیا، نماز کے لیے جلدی کریں۔';

  @override
  String get notifScheduleBodyAthanDhuhr => 'ظہر کی اذان کا وقت ہو گیا ہے۔';

  @override
  String get notifScheduleBodyAthanAsr => 'عصر کی اذان کا وقت ہو گیا ہے۔';

  @override
  String get notifScheduleBodyAthanMaghrib => 'مغرب کی اذان کا وقت ہو گیا ہے۔';

  @override
  String get notifScheduleBodyAthanIsha => 'عشاء کی اذان کا وقت ہو گیا ہے۔';

  @override
  String get notifScheduleBodyMiddleNight =>
      'قیام اللیل کا وقت ہو گیا! اٹھیں اور رحمٰن سے مناجات کریں۔';

  @override
  String get notifScheduleBodyThikrMorning => 'صبح کے اذکار نہ بھولیں!';

  @override
  String get notifScheduleBodyThikrEvening => 'شام کے اذکار نہ بھولیں!';

  @override
  String get notifScheduleBodySalawat =>
      'نبی کریم ﷺ پر درود بھیجیں، آپ کے لیے دس نیکیاں لکھی جائیں گی۔';

  @override
  String get notifScheduleBodyReadQuran => 'آج اپنا قرآنی ورد نہ بھولیں۔';

  @override
  String get notifScheduleBodyReadSurahMulk => 'سونے سے پہلے سورۃ الملک پڑھیں۔';

  @override
  String get notifScheduleBodyThikrSleep => 'سونے سے پہلے سونے کے اذکار پڑھیں۔';

  @override
  String get notifScheduleBodyThikrWakeUp =>
      'اپنے دن کا آغاز بیداری کے اذکار سے کریں۔';

  @override
  String get notifScheduleBodyReadSurah =>
      'آج کے لیے مقرر سورت پڑھنا نہ بھولیں۔';

  @override
  String get notifScheduleBodyReadSurahKahf => 'جمعہ کے دن سورۃ الکہف پڑھیں۔';

  @override
  String get notifScheduleBodyFasting =>
      'نفلی روزوں کا بڑا اجر ہے، یہ موقع ہاتھ سے نہ جانے دیں۔';

  @override
  String get notifScheduleTitleRandomThikr =>
      'بے ترتیب اذکار کی ذاتی یاد دہانی';

  @override
  String get notifScheduleValidateTime => 'پہلے یاد دہانی کا وقت مقرر کریں';

  @override
  String get notifScheduleValidateMinute => 'ہر گھنٹے کا منٹ مقرر کریں';

  @override
  String get notifScheduleValidateWeekday =>
      'ہفتے کا کم از کم ایک دن منتخب کریں';

  @override
  String get notifScheduleValidateInterval =>
      'منٹوں کی تعداد درج کریں (صفر سے زیادہ)';

  @override
  String get notifScheduleValidateDate => 'کم از کم ایک تاریخ شامل کریں';

  @override
  String get notifScheduleDetails => 'تفصیلات';

  @override
  String get notifScheduleMinuteOfHourTitle => 'ہر گھنٹے کا منٹ';

  @override
  String get notifScheduleMinuteOfHourSubtitle => '0 سے 59 کے درمیان عدد';

  @override
  String get notifScheduleMinuteUnit => 'منٹ';

  @override
  String get notifScheduleRepeatTitle => 'دہرائیں';

  @override
  String get notifScheduleRepeatSubtitle =>
      'ہر یاد دہانی اور اگلی کے درمیان وقفہ';

  @override
  String get notifScheduleCustomTime => 'ذاتی وقت';

  @override
  String get notifScheduleDeleteTime => 'وقت حذف کریں';

  @override
  String get notifScheduleNoTimesYet => 'آپ نے ابھی کوئی وقت شامل نہیں کیا';

  @override
  String get notifScheduleAddTime => 'وقت شامل کریں';

  @override
  String get notifScheduleSaveSchedule => 'شیڈول محفوظ کریں';

  @override
  String get notifScheduleAddNewTitle => 'نیا وقت شامل کریں';

  @override
  String get notifScheduleEditTitle => 'وقت میں ترمیم';

  @override
  String get notifScheduleOptionalLabel => 'اختیاری تفصیل';

  @override
  String get notifScheduleAddConfirm => 'وقت شامل کریں';

  @override
  String get notifScheduleSaveEdit => 'ترمیم محفوظ کریں';

  @override
  String get notifScheduleTypeDaily => 'روزانہ';

  @override
  String get notifScheduleTypeHourly => 'ہر گھنٹے';

  @override
  String get notifScheduleTypeEveryNMinutes => 'ہر چند منٹ';

  @override
  String get notifScheduleTypeWeekly => 'ہفتہ وار';

  @override
  String get notifScheduleTypeCustomDates => 'ذاتی تاریخیں';

  @override
  String get notifScheduleTypeDailyDesc =>
      'ہر روز ایک ہی وقت پر دہرایا جاتا ہے';

  @override
  String get notifScheduleTypeHourlyDesc =>
      'ہر گھنٹے ایک مقررہ منٹ پر دہرایا جاتا ہے';

  @override
  String get notifScheduleTypeEveryNMinutesDesc =>
      'آپ کے مقرر کردہ وقفے پر دہرایا جاتا ہے';

  @override
  String get notifScheduleTypeWeeklyDesc =>
      'ہفتے کے مقررہ دنوں میں دہرایا جاتا ہے';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'آپ کی منتخب تاریخوں اور اوقات پر ظاہر ہوتا ہے';

  @override
  String get notifScheduleTypeTitle => 'شیڈول کی قسم';

  @override
  String get notifScheduleTimeTitle => 'یاد دہانی کا وقت';

  @override
  String get notifScheduleTimeSubtitle =>
      'گھنٹہ اور منٹ منتخب کرنے کے لیے دبائیں';

  @override
  String get notifScheduleLabelHint => 'اس وقت کی مختصر تفصیل لکھیں';

  @override
  String notifScheduleRowDaily(String time) {
    return 'ہر روز · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'کوئی دن نہیں';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذاتی اوقات',
      one: '$count ذاتی وقت',
      zero: 'کوئی ذاتی وقت نہیں',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'پیر';

  @override
  String get notifScheduleDayShort2 => 'منگل';

  @override
  String get notifScheduleDayShort3 => 'بدھ';

  @override
  String get notifScheduleDayShort4 => 'جمعرات';

  @override
  String get notifScheduleDayShort5 => 'جمعہ';

  @override
  String get notifScheduleDayShort6 => 'ہفتہ';

  @override
  String get notifScheduleDayShort7 => 'اتوار';

  @override
  String get notifScheduleAllDays => 'تمام دن';

  @override
  String get notifScheduleWorkDays => 'کام کے دن';

  @override
  String get notifScheduleWeekend => 'چھٹی کے دن';

  @override
  String get notifScheduleClear => 'صاف کریں';

  @override
  String get notifScheduleStatTotal => 'کل';

  @override
  String get notifScheduleStatEnabled => 'فعال';

  @override
  String get notifScheduleStatStopped => 'بند';

  @override
  String get notifScheduleUnexpectedError => 'غیر متوقع خرابی پیش آئی';

  @override
  String get notifScheduleSaved => 'محفوظ ہو گیا';

  @override
  String get notifScheduleScreenTitle => 'اطلاع کے اوقات';

  @override
  String get notifScheduleListTitle => 'اوقات';

  @override
  String get notifScheduleEmpty =>
      'ابھی کوئی وقت نہیں — «وقت شامل کریں» بٹن سے وقت شامل کریں۔';

  @override
  String get notifScheduleDeleteTitle => 'وقت حذف کریں';

  @override
  String get notifScheduleDeleteMessage =>
      'کیا آپ واقعی یہ وقت حذف کرنا چاہتے ہیں؟\nاس سے منسلک تمام اطلاعات منسوخ ہو جائیں گی۔';

  @override
  String get notifScheduleSaving => 'محفوظ ہو رہا ہے...';

  @override
  String get notifScheduleLoading => 'اوقات لوڈ ہو رہے ہیں...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'اوقات لوڈ نہیں ہو سکے: $error';
  }

  @override
  String get notifScheduleAdded => 'وقت کامیابی سے شامل ہو گیا';

  @override
  String notifScheduleAddFailed(String error) {
    return 'وقت شامل نہیں ہو سکا: $error';
  }

  @override
  String get notifScheduleUpdated => 'وقت کامیابی سے اپ ڈیٹ ہو گیا';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'وقت اپ ڈیٹ نہیں ہو سکا: $error';
  }

  @override
  String get notifScheduleDeleted => 'وقت کامیابی سے حذف ہو گیا';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'وقت حذف نہیں ہو سکا: $error';
  }

  @override
  String get notifScheduleActivated => 'وقت فعال ہو گیا';

  @override
  String get notifScheduleDeactivated => 'وقت غیر فعال ہو گیا';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'وقت کی حالت تبدیل نہیں ہو سکی: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'شیڈول شدہ';

  @override
  String get notifSettingsNoScheduled => 'ابھی کوئی شیڈول شدہ اطلاع نہیں';

  @override
  String get notifSettingsShownNowGroup => 'ابھی ظاہر';

  @override
  String get notifSettingsNoShown => 'اطلاعات کی بار میں کوئی اطلاع نہیں';

  @override
  String get notifSettingsUntitled => 'بغیر عنوان کی اطلاع';

  @override
  String get notifSettingsDismiss => 'اطلاع چھپائیں';

  @override
  String get notifSettingsCancelNotification => 'اطلاع منسوخ کریں';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return 'اب $prayer کی اذان کا وقت ہو گیا ہے';
  }

  @override
  String get downloadTitle => 'ڈاؤن لوڈز';

  @override
  String get downloadEmptyAll =>
      'ابھی کوئی ڈاؤن لوڈ نہیں، شروع کرنے کے لیے ڈاؤن لوڈ شامل کریں۔';

  @override
  String get downloadEmptyActive => 'کوئی فعال ڈاؤن لوڈ نہیں';

  @override
  String get downloadEmptyCompleted => 'کوئی مکمل ڈاؤن لوڈ نہیں';

  @override
  String get downloadEmptyPaused => 'کوئی رکا ہوا ڈاؤن لوڈ نہیں';

  @override
  String get downloadEmptyFailed => 'کوئی ناکام ڈاؤن لوڈ نہیں';

  @override
  String get downloadCancelAll => 'سب منسوخ کریں';

  @override
  String get downloadCancelAllConfirm =>
      'کیا آپ واقعی تمام فعال ڈاؤن لوڈز منسوخ کرنا چاہتے ہیں؟';

  @override
  String get downloadAdd => 'ڈاؤن لوڈ شامل کریں';

  @override
  String get downloadFilterAll => 'سب';

  @override
  String get downloadStatusActive => 'فعال';

  @override
  String get downloadStatusCompleted => 'مکمل';

  @override
  String get downloadStatusPaused => 'رکا ہوا';

  @override
  String get downloadStatusFailed => 'ناکام';

  @override
  String get downloadStarted => 'ڈاؤن لوڈ شروع ہو گیا';

  @override
  String get downloadAddNewTitle => 'نیا ڈاؤن لوڈ شامل کریں';

  @override
  String get downloadUrlLabel => 'فائل کا لنک';

  @override
  String get downloadUrlRequired => 'براہِ کرم ڈاؤن لوڈ لنک درج کریں';

  @override
  String get downloadUrlInvalid => 'براہِ کرم درست لنک درج کریں';

  @override
  String get downloadFileNameLabel => 'فائل کا نام';

  @override
  String get downloadOptional => 'اختیاری';

  @override
  String get downloadPublicStorageTitle => 'عوامی اسٹوریج';

  @override
  String get downloadPublicStorageSubtitle => 'ڈاؤن لوڈز فولڈر میں محفوظ کریں';

  @override
  String get downloadAllowCellularTitle => 'موبائل ڈیٹا کی اجازت دیں';

  @override
  String get downloadAllowCellularSubtitle => 'موبائل ڈیٹا کے ذریعے ڈاؤن لوڈ';

  @override
  String get downloadStart => 'ڈاؤن لوڈ شروع کریں';

  @override
  String get downloadPause => 'عارضی طور پر روکیں';

  @override
  String get downloadResume => 'جاری رکھیں';

  @override
  String get downloadOpenFile => 'فائل کھولیں';

  @override
  String get downloadRemoveFromList => 'فہرست سے ہٹائیں';

  @override
  String get downloadDeleteFile => 'فائل حذف کریں';

  @override
  String get downloadTotal => 'کل';

  @override
  String get downloadInProgressNow => 'ابھی ڈاؤن لوڈ ہو رہا ہے';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اور $count مزید',
      one: 'اور $count مزید',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'اگلی نماز';

  @override
  String get widgetLabelDailyAyah => 'آج کی آیت';

  @override
  String get widgetLabelOpenApp => 'طمأنينة کھولیں';

  @override
  String get widgetLabelSetLocation => 'ایپ میں اپنا مقام مقرر کریں';

  @override
  String get widgetLabelRefreshNeeded => 'اوقات تازہ کرنے کے لیے';

  @override
  String widgetLabelNextIn(String prayer) {
    return '$prayer تک';
  }

  @override
  String get dailyWirdTitle => 'دن اور رات کا زادِ راہ';

  @override
  String get dailyWirdSettingsTooltip => 'زادِ راہ کی ترتیبات';

  @override
  String get dailyWirdUnexpectedError => 'غیر متوقع خرابی پیش آئی۔';

  @override
  String get dailyWirdRemindersHeader => 'یاد دہانیاں';

  @override
  String get dailyWirdReminderSleepLabel => 'سونے کے اذکار';

  @override
  String get dailyWirdProgramHeader => 'پروگرام';

  @override
  String get dailyWirdSaveSetup => 'ترتیب محفوظ کریں';

  @override
  String get dailyWirdSetupFailed => 'عبادت کا زادِ راہ ترتیب نہیں دیا جا سکا۔';

  @override
  String get dailyWirdItemNotFound => 'زادِ راہ کا یہ عمل نہیں ملا۔';

  @override
  String get dailyWirdTodayTasksHeader => 'آج کے اعمال';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'پابندی: $count دن',
      one: 'پابندی: $count دن',
      zero: 'پابندی: 0 دن',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'ہفتے کی پابندی $percent%';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'اپنا عبادتی زادِ راہ منتخب کریں';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'تیار پروگرام سے شروع کریں، پھر اپنی سہولت کے مطابق بدلیں';

  @override
  String get dailyWirdItemOptions => 'عمل کے اختیارات';

  @override
  String get dailyWirdEditTargetCount => 'مطلوبہ تعداد بدلیں';

  @override
  String get dailyWirdStartOver => 'نئے سرے سے شروع کریں';

  @override
  String get dailyWirdMoveUp => 'ترتیب میں اوپر کریں';

  @override
  String get dailyWirdMoveDown => 'ترتیب میں نیچے کریں';

  @override
  String get dailyWirdHideItem => 'زادِ راہ سے چھپائیں';

  @override
  String get dailyWirdCountHint => 'مثال: 50 بار';

  @override
  String get dailyWirdTimeMorning => 'صبح';

  @override
  String get dailyWirdTimeEvening => 'شام';

  @override
  String get dailyWirdTimeNight => 'رات';

  @override
  String get dailyWirdTimeAny => 'کسی بھی وقت';

  @override
  String get dailyWirdTimeMorningLong => 'صبح کا وقت';

  @override
  String get dailyWirdTimeEveningLong => 'شام کا وقت';

  @override
  String get dailyWirdTimeNightLong => 'سونے سے پہلے';

  @override
  String get dailyWirdTimeAnyLong => 'کسی بھی وقت';

  @override
  String get dailyWirdTypeDhikrSet => 'اذکار';

  @override
  String get dailyWirdTypeCountedDhikr => 'گنتی والا ذکر';

  @override
  String get dailyWirdTypeQuran => 'قرآنی ورد';

  @override
  String get dailyWirdTypeDua => 'دعا';

  @override
  String get dailyWirdTypeSurah => 'سورت';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$total میں سے $done';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return 'آپ نے $total$unit میں سے $done مکمل کیے';
  }

  @override
  String get dailyWirdItemDone => 'مکمل';

  @override
  String get dailyWirdMarkComplete => 'مکمل کریں';

  @override
  String get dailyWirdCountOnce => 'ایک بار گنیں';

  @override
  String get dailyWirdCompleteThis => 'یہ عمل مکمل کریں';

  @override
  String get dailyWirdUncomplete => 'تکمیل منسوخ کریں';

  @override
  String get dailyWirdReminderMorningTitle => 'صبح کا زادِ راہ';

  @override
  String get dailyWirdReminderMorningBody =>
      'اپنے دن کا آغاز اللہ کے ذکر، اس کی کتاب کی تلاوت اور دعا سے کریں۔';

  @override
  String get dailyWirdReminderEveningTitle => 'شام کا زادِ راہ';

  @override
  String get dailyWirdReminderEveningBody =>
      'اللہ سے اپنا تعلق تازہ کریں اور شام کا زادِ راہ جتنا ہو سکے مکمل کریں۔';

  @override
  String get dailyWirdReminderNightTitle => 'سونے سے پہلے کا زادِ راہ';

  @override
  String get dailyWirdReminderNightBody =>
      'اپنے دن کا اختتام ذکر، دعا اور باقی ماندہ عبادات سے کریں۔';

  @override
  String get dailyWirdReminderSummaryTitle => 'دن کے آخر کا محاسبہ';

  @override
  String get dailyWirdReminderSummaryBody =>
      'آج کی اپنی عبادات کا جائزہ لیں اور دیکھیں کتنا مکمل کیا۔';

  @override
  String get wirdMorningAdhkar => 'صبح کے اذکار';

  @override
  String get wirdEveningAdhkar => 'شام کے اذکار';

  @override
  String get wirdMorningTitle => 'صبح کا ورد';

  @override
  String get wirdEveningTitle => 'شام کا ورد';

  @override
  String get wirdSearchHint => 'ذکر تلاش کریں';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'ذکر $current از $total';
  }

  @override
  String get wirdPrevious => 'پچھلا';

  @override
  String get wirdNext => 'اگلا';

  @override
  String get wirdShowSingle => 'ایک ایک ذکر دکھائیں';

  @override
  String get wirdShowList => 'اذکار فہرست میں دکھائیں';

  @override
  String get wirdTypeMorningOnly => 'صرف صبح';

  @override
  String get wirdTypeEveningOnly => 'صرف شام';

  @override
  String get wirdTypeBoth => 'صبح و شام';

  @override
  String get wirdNoAudio => 'کوئی آڈیو فائل نہیں';

  @override
  String get wirdPause => 'عارضی طور پر روکیں';

  @override
  String get wirdReplay => 'دوبارہ چلائیں';

  @override
  String get wirdPlayAudio => 'آڈیو چلائیں';

  @override
  String wirdRemaining(int remaining, int total) {
    return '$total میں سے $remaining باقی';
  }

  @override
  String get wirdCompleted => 'مکمل ہو گیا';

  @override
  String get wirdResetCount => 'گنتی دوبارہ شروع کریں';

  @override
  String get wirdCopyDhikr => 'ذکر کاپی کریں';

  @override
  String get wirdSource => 'ماخذ';

  @override
  String get wirdShowDetails => 'تفصیلات دکھائیں';

  @override
  String get wirdHideDetails => 'تفصیلات چھپائیں';

  @override
  String get wirdVirtue => 'فضیلت';

  @override
  String get wirdHadithText => 'حدیث کا متن';

  @override
  String get wirdWordExplanations => 'منتخب الفاظ کی وضاحت';

  @override
  String get wirdReadOnce => 'ایک بار پڑھ لیا';

  @override
  String get wirdPlayAll => 'پورا ورد چلائیں';

  @override
  String get wirdPreparingAudio => 'آڈیو تیار ہو رہی ہے';

  @override
  String get wirdReplayAll => 'ورد دوبارہ چلائیں';

  @override
  String get wirdPlayAllFinished => 'تمام اذکار چل چکے ہیں۔';

  @override
  String get wirdNowPlaying => 'ابھی پڑھا جا رہا ہے';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'تکرار $current از $total';
  }

  @override
  String get thikrLibraryTitle => 'اذکار لائبریری';

  @override
  String get thikrGroupDaily => 'روزانہ کے اذکار';

  @override
  String get thikrMorningSubtitle => 'فجر کے بعد سے دن چڑھنے تک کا ورد';

  @override
  String get thikrEveningSubtitle => 'عصر کے بعد سے رات تک کا ورد';

  @override
  String get thikrSleepTitle => 'سونے اور خواب کے اذکار';

  @override
  String get thikrSleepSubtitle =>
      'سونے سے پہلے اور نیند میں گھبراہٹ کے وقت کیا پڑھیں';

  @override
  String get thikrPrayerJumuahTitle => 'نماز اور جمعہ کے اذکار';

  @override
  String get thikrPrayerJumuahSubtitle =>
      'اذان، نماز کے بعد اور جمعہ کے دن کے اذکار';

  @override
  String get thikrGroupDuas => 'مسنون دعائیں';

  @override
  String get thikrQuranicDuasTitle => 'قرآنی دعائیں';

  @override
  String get thikrQuranicDuasSubtitle =>
      'انبیاء کی دعائیں جیسے اللہ کی کتاب میں آئی ہیں';

  @override
  String get thikrComprehensiveDuasTitle => 'جامع دعائیں';

  @override
  String get thikrComprehensiveDuasSubtitle =>
      'دنیا و آخرت کی بھلائی جمع کرنے والی دعائیں';

  @override
  String get thikrHajjTitle => 'حج اور عمرہ کی دعائیں';

  @override
  String get thikrHajjSubtitle => 'احرام، طواف، سعی اور مشاعر کی دعائیں';

  @override
  String get thikrFuneralTitle => 'میت اور جنازے کی دعائیں';

  @override
  String get thikrFuneralSubtitle =>
      'نمازِ جنازہ اور قبر پر پڑھی جانے والی دعائیں';

  @override
  String get thikrGroupTools => 'آپ کے ٹولز';

  @override
  String get thikrTasbeehTitle => 'تسبیح';

  @override
  String get thikrTasbeehSubtitle =>
      'کاؤنٹر جو آپ کی تسبیح گنتا ہے اور دن کا حاصل محفوظ رکھتا ہے';

  @override
  String get thikrMyDuasSubtitle => 'آپ کی خود شامل کی ہوئی دعائیں ایک جگہ';

  @override
  String get thikrSliderSubtitle => 'اس وقت کا ورد، ابھی کھولیں';

  @override
  String get afterPrayerTitle => 'نماز کے بعد کے اذکار';

  @override
  String get afterPrayerSubtitle => 'نماز کے بعد کے اذکار';

  @override
  String get afterPrayerSearchHint => 'اذکار تلاش کریں';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'نماز کے بعد کا ذکر $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'تکرار کی تعداد: $count';
  }

  @override
  String afterPrayerVirtueLine(String virtue) {
    return 'فضیلت: $virtue';
  }

  @override
  String get afterPrayerRepeatLabel => 'تکرار';

  @override
  String get afterPrayerVirtueLabel => 'فضیلت';

  @override
  String get afterPrayerMentioned => 'مذکور';

  @override
  String get afterPrayerNotMentioned => 'مذکور نہیں';

  @override
  String get afterPrayerTextSection => 'ذکر کا متن';

  @override
  String get afterPrayerVirtueSection => 'ذکر کی فضیلت';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار',
      one: 'ایک بار',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'کوئی ملتا جلتا نتیجہ نہیں';

  @override
  String get afterPrayerShowAll => 'تمام اذکار دکھائیں';

  @override
  String get myDuasTitle => 'میری دعائیں';

  @override
  String get myDuasActionFailed => 'یہ عمل مکمل نہیں ہو سکا۔';

  @override
  String get myDuasEmptyCustomTitle => 'کوئی شامل کی گئی دعا نہیں';

  @override
  String get myDuasEmptyCustomMessage =>
      'اس حصے میں صرف وہ دعائیں دکھائی جاتی ہیں جو آپ نے شامل کی ہیں۔';

  @override
  String get myDuasEmptyTitle => 'ابھی کوئی دعا نہیں';

  @override
  String get myDuasEmptyMessage =>
      'اپنی پہلی دعا شامل کریں، وہ فوراً یہاں نظر آئے گی۔';

  @override
  String get myDuasAddNew => 'نئی دعا شامل کریں';

  @override
  String get myDuasAdd => 'دعا شامل کریں';

  @override
  String get myDuasAddSubtitle =>
      'دعا لکھیں تاکہ وہ آپ کی ذاتی دعاؤں میں شامل ہو جائے۔';

  @override
  String get myDuasEditTitle => 'دعا میں ترمیم';

  @override
  String get myDuasEditSubtitle =>
      'آپ متن یا تفصیل بدل کر فوراً تبدیلیاں محفوظ کر سکتے ہیں۔';

  @override
  String get myDuasCountLabel => 'دعاؤں کی تعداد';

  @override
  String get myDuasTodayLabel => 'آج کی تکرار';

  @override
  String get myDuasOptions => 'دعا کے اختیارات';

  @override
  String get myDuasResetToday => 'آج کا کاؤنٹر صفر کریں';

  @override
  String get ruqyahTitle => 'شرعی رقیہ';

  @override
  String get ruqyahSearchHint => 'رقیہ تلاش کریں';

  @override
  String get ruqyahDefaultReference => 'قرآنِ کریم';

  @override
  String get ruqyahUnspecified => 'غیر متعین';

  @override
  String ruqyahRepeatLine(String count) {
    return 'تکرار: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'حوالہ: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'تفصیل: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'رقیہ $number';
  }

  @override
  String get ruqyahTextSection => 'رقیہ کا متن';

  @override
  String get ruqyahDescriptionSection => 'تفصیل';

  @override
  String get ruqyahNoResultsTitle => 'کوئی نتیجہ نہیں';

  @override
  String get ruqyahNoResultsMessage => 'آپ کی تلاش سے ملتا کوئی رقیہ نہیں ملا۔';

  @override
  String get ruqyahShowAll => 'تمام رقیہ دکھائیں';

  @override
  String get radioTitle => 'ریڈیو';

  @override
  String get radioKindReciters => 'قراء';

  @override
  String get radioKindPrograms => 'پروگرام اور تلاوتیں';

  @override
  String get radioLoadFailed => 'ریڈیو اسٹیشنز ابھی لوڈ نہیں ہو سکے۔';

  @override
  String get radioPlayFailed => 'ریڈیو ابھی نہیں چل سکا۔';

  @override
  String get radioToggleFailed => 'چلانے کی حالت تبدیل نہیں ہو سکی۔';

  @override
  String get radioStopFailed => 'ریڈیو بند نہیں ہو سکا۔';

  @override
  String get radioNoMatch => 'اس نام کا کوئی اسٹیشن نہیں۔';

  @override
  String get radioSearchHint => 'قاری یا پروگرام تلاش کریں';

  @override
  String get radioFavouritesHint =>
      'کسی بھی اسٹیشن کو پسندیدہ میں شامل کرنے کے لیے اس پر دیر تک دبائیں۔';

  @override
  String get radioAddFavourite => 'پسندیدہ میں شامل کریں';

  @override
  String get radioRemoveFavourite => 'پسندیدہ سے ہٹائیں';

  @override
  String radioAddedToFavourites(String station) {
    return '$station پسندیدہ میں شامل ہو گیا';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return '$station پسندیدہ سے ہٹا دیا گیا';
  }

  @override
  String get radioSleepTimer => 'سلیپ ٹائمر';

  @override
  String get radioSleepTimerDescription =>
      'منتخب وقت کے بعد نشریات خودبخود بند ہو جائیں گی۔';

  @override
  String radioStopsIn(String time) {
    return '$time بعد بند ہو گا';
  }

  @override
  String get radioCancelTimer => 'ٹائمر منسوخ کریں';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منٹ',
      one: '$count منٹ',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'نشریات بند کریں';

  @override
  String get radioTuning => 'اسٹیشن سے رابطہ ہو رہا ہے…';

  @override
  String get radioLive => 'براہِ راست';

  @override
  String get radioPaused => 'عارضی طور پر رکا ہوا';

  @override
  String get radioTapToPlay => 'چلانے کے لیے دبائیں';

  @override
  String get radioPause => 'عارضی طور پر روکیں';

  @override
  String get radioPlay => 'چلائیں';
}
