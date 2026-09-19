// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'الأذكار العائمة';

  @override
  String get floatingAdhkarSourceBuiltIn => 'افتراضي';

  @override
  String get floatingAdhkarSourceCustom => 'مخصص';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'أذكاري الخاصة';

  @override
  String get floatingAdhkarSourceAppLibrary => 'مكتبة التطبيق';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'ذكر افتراضي';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'ذكر عشوائي';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'الأذكار العشوائية';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'الأذكار العشوائية العائمة';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'خدمة الأذكار العائمة تعمل في الخلفية';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'هذه الميزة غير متاحة على هذه المنصة.';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'يجب السماح بالإشعارات لتشغيل تذكيرات الأذكار على iPhone.';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'يجب منح صلاحية الظهور فوق التطبيقات الأخرى أولًا.';

  @override
  String get floatingAdhkarErrorNoSource =>
      'فعّل مصدرًا واحدًا على الأقل للأذكار العائمة.';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'صلاحية الإشعارات مطلوبة لتشغيل تذكيرات iPhone.';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'الصلاحية مطلوبة لتشغيل النافذة العائمة.';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'العنوان والنص مطلوبان لتحديث الذكر الافتراضي.';

  @override
  String get floatingAdhkarErrorNotificationsDenied =>
      'لم يتم منح صلاحية الإشعارات.';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'لم يتم منح صلاحية الظهور فوق التطبيقات الأخرى.';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'فعّل الميزة أولًا ثم استخدم المعاينة المباشرة.';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'صلاحية الإشعارات مطلوبة لعرض ذكر الآن.';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'الصلاحية مطلوبة لعرض الذكر العائم.';

  @override
  String get floatingAdhkarStatusUnsupported => 'غير مدعومة';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'تحتاج صلاحية';

  @override
  String get floatingAdhkarStatusMisconfigured => 'تحتاج تهيئة';

  @override
  String get floatingAdhkarStatusActive => 'تعمل الآن';

  @override
  String get floatingAdhkarStatusInactive => 'متوقفة';

  @override
  String get floatingAdhkarManageTitle => 'إدارة الأذكار';

  @override
  String get floatingAdhkarManageSubtitle =>
      'اختر ما يظهر من الافتراضي وأضف أذكارك';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'إضافة ذكر خاص';

  @override
  String get floatingAdhkarAddCustomTitle => 'إضافة ذكر مخصص';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'سيصبح متاحًا ضمن الأذكار العائمة عند تفعيله.';

  @override
  String get floatingAdhkarEditTitle => 'تعديل الذكر';

  @override
  String get floatingAdhkarEditSubtitle =>
      'حدّث النص ثم احفظ التغييرات مباشرة.';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$enabled من $total';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle => 'لا توجد أذكار افتراضية متاحة';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'لم يتم العثور على مكتبة الأذكار الافتراضية داخل التطبيق.';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'لا توجد أذكار خاصة بعد';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'أضف ذكرك أو دعاءك ليدخل ضمن الدوران العشوائي العائم.';

  @override
  String get floatingAdhkarAddNewDhikr => 'إضافة ذكر جديد';

  @override
  String get floatingAdhkarItemOptions => 'خيارات الذكر';

  @override
  String get floatingAdhkarTabBuiltIn => 'الأذكار الافتراضية';

  @override
  String get floatingAdhkarTabCustom => 'الأذكار الخاصة';

  @override
  String get floatingAdhkarPreviewHeader => 'معاينة الذكر';

  @override
  String get floatingAdhkarAdvancedTitle => 'إعدادات متقدمة';

  @override
  String get floatingAdhkarAdvancedSubtitle =>
      'معدل الظهور ومدّة البقاء والمصادر';

  @override
  String get floatingAdhkarFrequencyTitle => 'معدل الظهور';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'مدة بقاء الذكر';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانية',
      few: '$count ثوانٍ',
      two: 'ثانيتان',
      one: 'ثانية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'مصادر الأذكار';

  @override
  String get floatingAdhkarAllowNotifications => 'السماح بالإشعارات';

  @override
  String get floatingAdhkarGrantPermission => 'منح الصلاحية المطلوبة';

  @override
  String get floatingAdhkarPermissionHint =>
      'بدونها لن يظهر الذكر فوق التطبيقات';

  @override
  String get floatingAdhkarSendNow => 'إرسال ذكر الآن';

  @override
  String get floatingAdhkarShowNow => 'عرض ذكر الآن';

  @override
  String get floatingAdhkarPreviewReadyHint => 'جرّب شكل الذكر كما سيظهر لك';

  @override
  String get floatingAdhkarPreviewDisabledHint =>
      'فعّل الخدمة وامنح الصلاحية أولًا';

  @override
  String get floatingAdhkarIosReminders => 'تذكيرات iPhone';

  @override
  String get floatingAdhkarFloatingService => 'الخدمة العائمة';

  @override
  String get floatingAdhkarUnsupportedPlatform => 'غير مدعوم على هذه المنصة';

  @override
  String get floatingAdhkarStatBuiltIn => 'الافتراضية';

  @override
  String get floatingAdhkarStatCustom => 'الخاصة';

  @override
  String get floatingAdhkarSettingsTitleIos => 'إعدادات تذكيرات الأذكار';

  @override
  String get floatingAdhkarSettingsTitle => 'إعدادات الأذكار العائمة';

  @override
  String get floatingAdhkarReminderTiming => 'توقيت التذكير';

  @override
  String get floatingAdhkarAppearanceTiming => 'توقيت الظهور';

  @override
  String get floatingAdhkarReminderFrequency => 'معدل تكرار التنبيه';

  @override
  String get floatingAdhkarAppearanceFrequency => 'معدل تكرار الظهور';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle =>
      'المصدر الداخلي الأساسي للتطبيق';

  @override
  String get floatingAdhkarCustomSourceSubtitle => 'الأذكار التي أضفتها بنفسك';

  @override
  String get floatingAdhkarMixSources => 'الخلط بين المصادر';

  @override
  String get floatingAdhkarMixSourcesOn => 'يتم الاختيار من قائمة موحدة';

  @override
  String get floatingAdhkarMixSourcesOff => 'يتم التناوب بين الافتراضي والمخصص';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'فعّل مصدرًا واحدًا على الأقل قبل الحفظ.';

  @override
  String get floatingAdhkarMasterSwitch => 'تشغيل الميزة بالكامل';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'تُجدول تنبيهات أذكار على iPhone';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'تبدأ الخدمة الخلفية في إظهار الأذكار';

  @override
  String get floatingAdhkarSaveSettings => 'حفظ الإعدادات';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'كل $count دقيقة',
      few: 'كل $count دقائق',
      two: 'كل دقيقتين',
      one: 'كل دقيقة',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'دمج بين الافتراضي والمخصص';

  @override
  String get floatingAdhkarSourcesAlternating => 'تناوب بين الافتراضي والمخصص';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'الأذكار الافتراضية فقط';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'أذكار المستخدم فقط';

  @override
  String get floatingAdhkarSourcesNone => 'لا يوجد مصدر مفعّل';

  @override
  String get sabihTitle => 'المسبحة';

  @override
  String get sabihBeadWalnut => 'جوز';

  @override
  String get sabihBeadOak => 'بلّوط';

  @override
  String get sabihBeadEmerald => 'زمرّد';

  @override
  String get sabihBeadOnyx => 'عقيق أسود';

  @override
  String get sabihBeadAmber => 'كهرمان';

  @override
  String get sabihBeadMahogany => 'ماهوجني';

  @override
  String get sabihBeadSage => 'زيتوني';

  @override
  String get sabihBeadGarnet => 'عقيق أحمر';

  @override
  String get sabihErrorRefreshList => 'تعذر تحديث قائمة الأذكار.';

  @override
  String get sabihErrorLoad => 'تعذر تحميل الأذكار.';

  @override
  String get sabihErrorRecord => 'تعذر تسجيل الذكر.';

  @override
  String get sabihErrorResetToday => 'تعذر تصفير عداد اليوم.';

  @override
  String get sabihAnalyticsTitle => 'الإحصائيات';

  @override
  String get sabihTabOverview => 'نظرة عامة';

  @override
  String get sabihTabDetails => 'تفصيل الأذكار';

  @override
  String get sabihDhikrSettingsTooltip => 'إعدادات الذكر';

  @override
  String get sabihAddCustomDhikr => 'إضافة ذكر مخصص';

  @override
  String get sabihEmptyMessage => 'لم يتم العثور على عناصر ذكر';

  @override
  String get sabihAddFirst => 'أضف ذكرك الأول';

  @override
  String get sabihSaveChanges => 'حفظ التعديلات';

  @override
  String get sabihAddDhikr => 'إضافة الذكر';

  @override
  String get sabihSaveFailed => 'تعذر حفظ الذكر.';

  @override
  String get sabihUpdatedSuccess => 'تم تحديث الذكر بنجاح.';

  @override
  String get sabihAddedSuccess => 'تمت إضافة الذكر بنجاح.';

  @override
  String get sabihEditDhikr => 'تعديل الذكر';

  @override
  String get sabihFieldText => 'نص الذكر';

  @override
  String sabihExampleHint(String example) {
    return 'مثال: $example';
  }

  @override
  String get sabihTextRequired => 'يرجى إدخال نص الذكر';

  @override
  String get sabihTextTooShort => 'نص الذكر قصير جدًا';

  @override
  String get sabihFieldVirtue => 'الفضل أو وصف مختصر (اختياري)';

  @override
  String get sabihPeriodToday => 'اليوم';

  @override
  String get sabihPeriodWeek => 'الأسبوع';

  @override
  String get sabihPeriodMonth => 'الشهر';

  @override
  String get sabihPeriodYear => 'السنة';

  @override
  String get sabihPeriodAll => 'الكل';

  @override
  String get sabihThisWeek => 'هذا الأسبوع';

  @override
  String get sabihThisMonth => 'هذا الشهر';

  @override
  String get sabihAllTime => 'كل الوقت';

  @override
  String get sabihMostUsed => 'الأذكار الأكثر استخدامًا';

  @override
  String get sabihTotalCount => 'إجمالي عدد الأذكار';

  @override
  String get sabihNoDataYet => 'لا توجد بيانات بعد';

  @override
  String get sabihResetTodayCounter => 'إعادة تعيين عدّاد اليوم';

  @override
  String get sabihEditThisDhikr => 'تعديل هذا الذكر';

  @override
  String get sabihDeleteThisDhikr => 'حذف هذا الذكر';

  @override
  String get sabihCustomBadge => 'مخصص';

  @override
  String get sabihNoCustomDhikr => 'لا يوجد ذكر مخصص';

  @override
  String get sabihSummaryTitle => 'ملخّص الذكر';

  @override
  String get sabihTodayNotStarted => 'لم تبدأ ذكر اليوم بعد';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذكرت اليوم $count مرّة',
      few: 'ذكرت اليوم $count مرّات',
      two: 'ذكرت اليوم مرّتين',
      one: 'ذكرت اليوم مرّة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'تسبيح';

  @override
  String sabihTargetReached(int target) {
    return 'بلغت $target';
  }

  @override
  String sabihTargetOf(int target) {
    return 'من $target';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'الهدف $target';
  }

  @override
  String get sabihTapAnywhere => 'المس أي مكان للتسبيح';

  @override
  String get sabihCountSemantics => 'عدد التسبيح';

  @override
  String get sabihInvalidNumber => 'أدخل رقمًا صحيحًا أكبر من صفر';

  @override
  String get sabihSettingsTitle => 'إعدادات المسبحة';

  @override
  String get sabihTargetSection => 'هدف الذكر';

  @override
  String get sabihTargetAutoHint =>
      'اتركه كما هو وسيتدرّج تلقائيًا: ٣٣ ثم ٩٩ ثم كل مئة.';

  @override
  String get sabihFontSize => 'حجم الخط';

  @override
  String get sabihFontSizeGlyph => 'أ';

  @override
  String sabihPercent(int value) {
    return '$value٪';
  }

  @override
  String get sabihVibration => 'الاهتزاز';

  @override
  String get sabihVibrationTitle => 'اهتزاز خفيف مع كل تسبيحة';

  @override
  String get sabihVibrationSubtitle => 'واهتزازة أوضح عند بلوغ الهدف';

  @override
  String get sabihBeadDesign => 'تصميم السبحة';

  @override
  String get sabihResetTodayCounterAction => 'إعادة ضبط عدّاد اليوم';

  @override
  String get anotherScreenGroupDaily => 'وردك اليومي';

  @override
  String get anotherScreenGroupKnowledge => 'علم وتلاوة';

  @override
  String get anotherScreenGroupTools => 'أذكار وأدوات';

  @override
  String get anotherScreenDailyWird => 'زاد اليوم والليلة';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'ورد تعبدي منظم لأذكارك وتلاوتك اليومية';

  @override
  String get anotherScreenKhatmaPlans => 'خطط الختمة';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'خطط مرتبة لإتمام الختمة بما يناسبك';

  @override
  String get anotherScreenTasbihSubtitle => 'تسبيح سهل بعداد مريح وواضح';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'أذكار قصيرة تظهر فوق التطبيقات الأخرى';

  @override
  String get anotherScreenFajrCompanion => 'صحبة الفجر';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'تذكيرات دعوية واتصالات مجدولة';

  @override
  String get anotherScreenSurahEncyclopedia => 'موسوعة السور';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'استعراض السور وفضائلها وموضوعاتها';

  @override
  String get anotherScreenNawawi40 => 'الأربعون النووية';

  @override
  String get anotherScreenNawawi40Subtitle => 'أحاديث جامعة في أبواب الدين';

  @override
  String get anotherScreenNamesOfAllah => 'أسماء الله الحسنى';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'تأمل الأسماء ومعانيها المباركة';

  @override
  String get anotherScreenRadio => 'الإذاعة';

  @override
  String get anotherScreenRadioSubtitle =>
      'إذاعات قرآنية وإسلامية ببث مباشر متواصل';

  @override
  String get anotherScreenHisnMuslim => 'حصن المسلم';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'أذكار جامعة مرتبة للأحوال والمناسبات';

  @override
  String get anotherScreenMyDuas => 'أدعيتي الخاصة';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'احتفظ بأدعيتك الشخصية في مكان واحد';

  @override
  String get anotherScreenTraveler => 'المسافر';

  @override
  String get anotherScreenTravelerSubtitle =>
      'أذكار السفر ومواقيت الرحلات وأماكن نافعة';

  @override
  String get anotherScreenHomeWidgets => 'ودجات الشاشة الرئيسية';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'الصلاة القادمة ومواقيت اليوم وآية اليوم';

  @override
  String get anotherScreenFootnotes => 'الحواشي';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'الباب $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نصًّا',
      few: '$count نصوص',
      two: 'نصّان',
      one: 'نص واحد',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حاشية',
      few: '$count حواشٍ',
      two: 'حاشيتان',
      one: 'حاشية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'نص الذكر';

  @override
  String get anotherScreenHisnSearchHint => 'بحث عن حصن المسلم';

  @override
  String get anotherScreenNoResults => 'لا توجد نتائج';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'لم نجد بابًا يطابق بحثك في حصن المسلم.';

  @override
  String get anotherScreenShowAllAdhkar => 'عرض جميع الأذكار';

  @override
  String get anotherScreenSurahSearchHint => 'بحث عن سورة';

  @override
  String anotherScreenSurahTitle(String name) {
    return 'سورة $name';
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
  String get anotherScreenSurahOrder => 'الترتيب';

  @override
  String get anotherScreenSurahNumber => 'رقم السورة';

  @override
  String get anotherScreenAyahCount => 'عدد الآيات';

  @override
  String get anotherScreenSurahNameMeaning => 'معنى اسم السورة';

  @override
  String get anotherScreenSurahNamingReason => 'سبب التسمية';

  @override
  String get anotherScreenSurahOtherNamesShort => 'أسماء أخرى';

  @override
  String get anotherScreenSurahOtherNames => 'أسماء أخرى للسورة';

  @override
  String get anotherScreenSurahPurpose => 'المقصد العام';

  @override
  String get anotherScreenSurahRevelationReason => 'سبب النزول';

  @override
  String get anotherScreenSurahVirtues => 'فضائل السورة';

  @override
  String get anotherScreenSurahRelations => 'مناسبات السورة';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count آية';
  }

  @override
  String get anotherScreenNoMatchingResults => 'لا توجد نتائج مطابقة';

  @override
  String get anotherScreenShowAllSurahs => 'عرض جميع السور';

  @override
  String get quranPlanAnalysisStartFirst => 'ابدأ أول جلسة لتحليل تقدمك.';

  @override
  String get quranPlanAnalysisFinished => 'مبارك! لقد أنهيت الخطة.';

  @override
  String get quranPlanAnalysisOnTrack =>
      'أنت على المسار الصحيح، ومتوقع أن تختم قبل الوقت المحدد!';

  @override
  String get quranPlanAnalysisBehind =>
      'قد تتأخر قليلاً عن الموعد. حاول تسريع وتيرة القراءة.';

  @override
  String quranPlanReminderTitle(String title) {
    return 'خطة ختم القرآن: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return 'لا تنس جلسة اليوم في خطتك \"$title\"!';
  }

  @override
  String get quranPlanAddTitle => 'إضافة خطة ختم جديدة';

  @override
  String get quranPlanDetailsHeader => 'تفاصيل الخطة';

  @override
  String get quranPlanTitleLabel => 'عنوان الخطة';

  @override
  String get quranPlanTitleHint => 'اسم الخطة';

  @override
  String get quranPlanTitleRequired => 'أدخل عنوانًا';

  @override
  String get quranPlanFromJuz => 'من الجزء';

  @override
  String get quranPlanToJuz => 'إلى الجزء';

  @override
  String get quranPlanChooseStart => 'اختر البداية';

  @override
  String get quranPlanChooseEnd => 'اختر النهاية';

  @override
  String get quranPlanEndBeforeStart => 'النهاية قبل البداية';

  @override
  String get quranPlanDaysLabel => 'عدد الأيام';

  @override
  String get quranPlanDaysHint => 'مثال: 30';

  @override
  String get quranPlanDaysInvalid => 'أدخل عدد الأيام بشكل صحيح';

  @override
  String get quranPlanSave => 'حفظ الخطة';

  @override
  String get quranPlanChoose => 'اختر';

  @override
  String quranPlanJuz(int number) {
    return 'الجزء $number';
  }

  @override
  String get quranPlanDailyReminder => 'تذكير يومي';

  @override
  String get quranPlanNotSet => 'غير محدّد';

  @override
  String get quranPlanListTitle => 'خطط الختم';

  @override
  String get quranPlanNewTooltip => 'خطة جديدة';

  @override
  String get quranPlanSearchHint => 'بحث عن خطة';

  @override
  String quranPlanJuzRange(int start, int end) {
    return 'الجزء $start إلى $end';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جلسة محمّلة',
      few: '$count جلسات محمّلة',
      two: 'جلستان محمّلتان',
      one: 'جلسة واحدة محمّلة',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$done من $total';
  }

  @override
  String get quranPlanDeleteConfirm => 'سيتم حذف الخطة ؟';

  @override
  String get quranPlanConfirm => 'تأكيد';

  @override
  String get quranPlanDelete => 'حذف الخطة';

  @override
  String get quranPlanStagnationWarning =>
      'انتبه: لديك عدة أيام ركود. جلسة قصيرة اليوم تكفي لإعادة الإيقاع.';

  @override
  String get quranPlanLoadFailed => 'تعذّر تحميل هذه الخطة حاليًا.';

  @override
  String get quranPlanTodaySession => 'جلسة اليوم';

  @override
  String get quranPlanAllSessionsDone =>
      'أتممت جلسات هذه الخطة، بارك الله فيك.';

  @override
  String get quranPlanRhythm => 'إيقاع الخطة';

  @override
  String get quranPlanPath => 'مسار الختمة';

  @override
  String get quranPlanNoSessions => 'لا توجد جلسات ظاهرة بعد.';

  @override
  String get quranPlanCompleteConfirm => 'سيتم إنهاء الجلسة ؟';

  @override
  String quranPlanSessionNumber(int number) {
    return 'جلسة $number';
  }

  @override
  String get quranPlanSessionDone => 'مُنجزة';

  @override
  String get quranPlanCurrentSession => 'جلستك الحالية';

  @override
  String get quranPlanOpenMushafHint => 'افتح المصحف عند بداية الجلسة';

  @override
  String get quranPlanSessionCompleted => 'جلسة مُنجزة';

  @override
  String get quranPlanCompleteSession => 'إنهاء الجلسة';

  @override
  String quranPlanSurahFallback(int number) {
    return 'سورة $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return 'من $fromSurah الآية $fromAyah إلى $toSurah الآية $toAyah';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'تم الإنجاز · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'توقّع يوم الختم';

  @override
  String get quranPlanAverageInterval => 'متوسّط الفاصل بين الجلسات';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days يوم';
  }

  @override
  String get quranPlanMostActiveDay => 'اليوم الأكثر نشاطًا';

  @override
  String get quranPlanLeastActiveDay => 'اليوم الأقلّ نشاطًا';

  @override
  String get quranPlanCompletionProbability => 'احتمال إتمام الخطة';

  @override
  String quranPlanPercentValue(int percent) {
    return '$percent بالمئة';
  }

  @override
  String get quranPlanStagnationDays => 'أيام الركود';

  @override
  String get cleanupRouteNotFound => 'الصفحة غير موجودة';

  @override
  String get cleanupNotificationSubtitle => 'إشعار جديد';

  @override
  String get cleanupNotificationActionView => 'عرض';

  @override
  String get cleanupNotificationActionDismiss => 'تجاهل';

  @override
  String get cleanupDownloadActionFailed =>
      'تعذّر إتمام عملية التنزيل. حاول مرة أخرى.';

  @override
  String get cleanupDownloadStatusQueued => 'في الانتظار';

  @override
  String get cleanupDownloadStatusCanceled => 'أُلغي';

  @override
  String get cleanupDownloadStatusUnknown => 'غير معروف';

  @override
  String get cleanupRadioMediaArtist => 'إذاعة القرآن الكريم';

  @override
  String get cleanupDhikrMeaningSubhanAllah => 'تنزيه الله عن كل نقص';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'الثناء على الله بكل كمال';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'لا معبود بحقّ إلا الله';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'الله أعظم من كل شيء';

  @override
  String get cleanupDhikrMeaningLaHawla => 'لا تحوّل ولا قدرة إلا بعون الله';

  @override
  String get cleanupDhikrMeaningAstaghfirullah => 'أطلب من الله المغفرة';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'تنزيه الله مع حمده وتعظيمه';

  @override
  String get appName => 'طمأنينة';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonOk => 'حسنًا';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonDone => 'تم';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonSettings => 'الإعدادات';

  @override
  String get commonLoading => 'جارٍ التحميل…';

  @override
  String get commonError => 'حدث خطأ';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonCopy => 'نسخ';

  @override
  String get commonCopied => 'تم النسخ';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonYes => 'نعم';

  @override
  String get commonNo => 'لا';

  @override
  String get commonRefresh => 'تحديث';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonEnable => 'تفعيل';

  @override
  String get commonDisable => 'إيقاف';

  @override
  String get commonLater => 'لاحقًا';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get prayerJumuah => 'الجمعة';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربيع الأول';

  @override
  String get hijriMonth4 => 'ربيع الآخر';

  @override
  String get hijriMonth5 => 'جمادى الأولى';

  @override
  String get hijriMonth6 => 'جمادى الآخرة';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذو القعدة';

  @override
  String get hijriMonth12 => 'ذو الحجة';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year هـ';
  }

  @override
  String get youngMuslimTitle => 'المسلم الصغير';

  @override
  String get youngMuslimQuizUnanswered => 'لم تتم الإجابة';

  @override
  String get youngMuslimResumeReminderTitle => 'كمل المشاهدة في المسلم الصغير';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return 'ارجع إلى \"$topic\" وأكمل رحلتك بهدوء.';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'واجهة آمنة للأطفال';

  @override
  String get youngMuslimAudienceGeneral => 'مشاهدة عامة';

  @override
  String get youngMuslimStatSeries => 'سلسلة';

  @override
  String get youngMuslimStatEpisode => 'حلقة';

  @override
  String get youngMuslimChooseSeries => 'اختر السلسلة';

  @override
  String get youngMuslimEpisodes => 'الحلقات';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حلقة',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'لا توجد حلقات الآن';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'غيّر السلسلة المختارة أو عد لاحقًا بعد تحديث الفلاتر.';

  @override
  String get youngMuslimCategoryLoadError => 'تعذّر تحميل القسم';

  @override
  String get youngMuslimTryAgainShortly => 'حاول مرة أخرى بعد قليل.';

  @override
  String get youngMuslimSearchHint => 'ابحث عن قصة...';

  @override
  String get youngMuslimAchievements => 'الإنجازات';

  @override
  String get youngMuslimQuickFilter => 'تصفية سريعة';

  @override
  String get youngMuslimFilterResults => 'نتائج الفلترة';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'لا توجد نتائج مطابقة';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'جرّب كلمات أبسط أو غيّر الفلاتر لتظهر حلقات أكثر.';

  @override
  String get youngMuslimSections => 'الأقسام';

  @override
  String get youngMuslimContinueWatching => 'أكمل المشاهدة';

  @override
  String get youngMuslimRecentlyWatched => 'شاهدت مؤخرًا';

  @override
  String get youngMuslimFavorites => 'المفضلة';

  @override
  String get youngMuslimWatchLater => 'سأشاهد لاحقًا';

  @override
  String get youngMuslimSuggestions => 'اقتراحات مناسبة';

  @override
  String get youngMuslimGreetingWelcome => 'مرحبًا بك في عالم القصص والتعلّم';

  @override
  String get youngMuslimGreetingPickNew => 'اختر قصة جديدة وابدأ رحلتك اليوم';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لديك $count حلقة بانتظارك لتعود إليها',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'نقاطي وإنجازاتي';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'المستوى $level · $points نقطة';
  }

  @override
  String get youngMuslimNextLevelProgress => 'التقدّم للمستوى التالي';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$current من $total';
  }

  @override
  String get youngMuslimStatAchievements => 'إنجازات';

  @override
  String get youngMuslimStatEpisodes => 'حلقات';

  @override
  String get youngMuslimStatAnswers => 'إجابات';

  @override
  String get youngMuslimFilterAll => 'الكل';

  @override
  String get youngMuslimStatusInProgress => 'قيد المشاهدة';

  @override
  String get youngMuslimStatusCompleted => 'مكتمل';

  @override
  String get youngMuslimStatusWatchLater => 'لاحقًا';

  @override
  String get youngMuslimFiltersActiveNote =>
      'الفلاتر مفعّلة الآن، ويمكنك تعديلها من زرّ التصفية أعلى الصفحة.';

  @override
  String get youngMuslimClearFilters => 'مسح';

  @override
  String get youngMuslimContentLoadError => 'تعذّر تحميل المحتوى';

  @override
  String get youngMuslimPullToRetry => 'اسحب الصفحة للأسفل لإعادة المحاولة.';

  @override
  String get youngMuslimFilterSheetTitle => 'تصفية المحتوى';

  @override
  String get youngMuslimCategoryLabel => 'القسم';

  @override
  String get youngMuslimFilterLanguage => 'اللغة';

  @override
  String get youngMuslimLanguageArabic => 'العربية';

  @override
  String get youngMuslimLanguageFrench => 'الفرنسية';

  @override
  String get youngMuslimLanguageMixed => 'مختلط';

  @override
  String get youngMuslimFilterContentType => 'نوع المحتوى';

  @override
  String get youngMuslimContentTypeStorySeries => 'سلاسل قصصية';

  @override
  String get youngMuslimApplyFilters => 'تطبيق الفلاتر';

  @override
  String get youngMuslimPlayerTitle => 'تشغيل آمن للأطفال';

  @override
  String get youngMuslimEpisodeQuizTitle => 'سؤال الحلقة بعد المشاهدة';

  @override
  String get youngMuslimSeriesChallenge => 'تحدي السلسلة';

  @override
  String get youngMuslimPlayerLoadError => 'تعذّر تحميل المشغّل الآن.';

  @override
  String get youngMuslimWatchOptions => 'خيارات المشاهدة';

  @override
  String get youngMuslimPlayNextEpisode => 'تشغيل الحلقة التالية';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'الحلقة $episode من نفس السلسلة';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'قائمة السلسلة';

  @override
  String get youngMuslimAutoPlayNext => 'تشغيل الحلقة التالية تلقائيًا';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'ضمن السلسلة نفسها فقط بعد نهاية الحلقة';

  @override
  String get youngMuslimResumeButton => 'متابعة المشاهدة';

  @override
  String get youngMuslimPlayNow => 'تشغيل الآن';

  @override
  String youngMuslimPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get youngMuslimProgress => 'التقدّم';

  @override
  String get youngMuslimWatchCount => 'مرات المشاهدة';

  @override
  String get youngMuslimEpisodeDuration => 'مدّة الحلقة';

  @override
  String youngMuslimLastWatched(String when) {
    return 'آخر مشاهدة: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'معلومات الحلقة';

  @override
  String get youngMuslimStory => 'القصة';

  @override
  String get youngMuslimSeries => 'السلسلة';

  @override
  String get youngMuslimEpisodeNumber => 'رقم الحلقة';

  @override
  String get youngMuslimEpisodeTools => 'أدوات الحلقة';

  @override
  String get youngMuslimEpisodeQuestions => 'أسئلة الحلقة';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'أسئلة قصيرة تثبّت ما شاهده الطفل';

  @override
  String get youngMuslimAfterWatchQuestion => 'سؤال بعد المشاهدة';

  @override
  String get youngMuslimNextEpisode => 'الحلقة التالية';

  @override
  String get youngMuslimSimilarEpisodes => 'حلقات مشابهة';

  @override
  String get youngMuslimDetailsLoadError => 'تعذّر تحميل تفاصيل الحلقة';

  @override
  String get youngMuslimQuizIntro =>
      'أسئلة بسيطة تساعد الطفل على تثبيت ما شاهده.';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسئلة',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return '+$points نقطة عند النجاح';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'النجاح من $score';
  }

  @override
  String get youngMuslimGrading => 'جارٍ تصحيح الإجابات';

  @override
  String get youngMuslimSubmitAnswers => 'إرسال الإجابات';

  @override
  String get youngMuslimAnswerHint => 'اكتب إجابتك هنا بوضوح...';

  @override
  String get youngMuslimQuizPassed => 'أحسنت يا بطل';

  @override
  String get youngMuslimQuizAlmost => 'أنت قريب من الإجابة الكاملة';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return 'أجبت $correct من $total إجابة صحيحة';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points نقطة';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'المستوى $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points نقطة',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'إنجازات جديدة';

  @override
  String get youngMuslimReviewAnswers => 'مراجعة الإجابات';

  @override
  String get youngMuslimFinish => 'إنهاء';

  @override
  String get youngMuslimYourAnswer => 'إجابتك';

  @override
  String get youngMuslimCorrectAnswer => 'الإجابة الصحيحة';

  @override
  String get youngMuslimStatSeriesPlural => 'سلاسل';

  @override
  String get youngMuslimStatPerfectScores => 'نتائج كاملة';

  @override
  String get youngMuslimUnlockedAchievements => 'الإنجازات المفتوحة';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إنجاز',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'لا توجد إنجازات بعد';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'أكمل أول حلقة أو أجب عن أول سؤال لتبدأ الرحلة.';

  @override
  String get youngMuslimUpcomingAchievements => 'إنجازات قادمة';

  @override
  String get youngMuslimAchievementUnlocked => 'تم فتح هذا الإنجاز.';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'فُتح $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'التقدّم الحالي';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '$minutesد';
  }

  @override
  String get youngMuslimNotWatchedYet => 'لم يُشاهد بعد';

  @override
  String get youngMuslimJustNow => 'الآن';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count ساعة',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يوم',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'تمت المشاهدة';

  @override
  String youngMuslimProgressPercent(int percent) {
    return 'تقدّم $percent٪';
  }

  @override
  String get youngMuslimReadyToWatch => 'جاهزة للمشاهدة';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سلسلة',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سلسلة · للأطفال',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'حلقة $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft => 'تابع من حيث توقفت';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return 'يتبقّى $duration';
  }

  @override
  String get youngMuslimAlmostDone => 'اقتربت النهاية';

  @override
  String get categoriesRequestFailed => 'غير قادر على معالجة العملية';

  @override
  String get categoriesLibraryTitle => 'المكتبة';

  @override
  String get categoriesQuranSciencesHeader => 'القرآن الكريم وعلومه';

  @override
  String get categoriesTypesHeader => 'تصنيفات';

  @override
  String get categoriesSectionsHeader => 'الأقسام';

  @override
  String get categoriesFamousRecitations => 'تلاوات مشهورة';

  @override
  String get categoriesKidsTeaching => 'تعليم أطفال';

  @override
  String get categoriesRecitationsByNarration => 'تلاوات بروايات وقراءات';

  @override
  String get categoriesRecitationsByNarrationShort => 'تلاوات بروايات';

  @override
  String get categoriesHaramainMushafs => 'مصاحف الحرمين';

  @override
  String get categoriesTypeVideos => 'فيديوهات';

  @override
  String get categoriesTypeBooks => 'كتب';

  @override
  String get categoriesTypeStories => 'قصص';

  @override
  String get categoriesTypeAudios => 'أصوات';

  @override
  String get categoriesTypeFatwas => 'فتاوى';

  @override
  String get categoriesTypeQuran => 'قرآن';

  @override
  String get categoriesTypePresentations => 'عروض تقديمية';

  @override
  String get categoriesTypeNews => 'أخبار';

  @override
  String get categoriesTypeArticles => 'مقالات';

  @override
  String get categoriesTypeApps => 'تطبيقات';

  @override
  String get categoriesTypeSermons => 'خطب';

  @override
  String get categoriesTopicQuran => 'القرآن';

  @override
  String get categoriesTopicSunnah => 'السنة';

  @override
  String get categoriesTopicSeerah => 'السيرة النبوية';

  @override
  String get categoriesTopicAqeedah => 'العقيدة';

  @override
  String get categoriesTopicFiqh => 'فقه';

  @override
  String get categoriesTopicHistory => 'التاريخ';

  @override
  String get categoriesTopicArabic => 'اللغة العربية';

  @override
  String get categoriesTopicIslamicStudies => 'دراسات إسلامية';

  @override
  String get categoriesTopicLessons => 'الدروس العلمية';

  @override
  String get categoriesTopicMajorSins => 'الكبائر والمحرمات';

  @override
  String get categoriesNoSearchResults => 'لا توجد نتائج لهذا البحث.';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصرًا',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'مادة صوتية';

  @override
  String get categoriesItemBook => 'كتاب';

  @override
  String get categoriesItemArticle => 'مقال';

  @override
  String get categoriesItemVideo => 'مرئي';

  @override
  String get categoriesFallbackTitle => 'التصنيف';

  @override
  String get categoriesNoAttachments => 'لا توجد مرفقات لهذه المادة.';

  @override
  String get categoriesAttachments => 'المرفقات';

  @override
  String get categoriesActionWatch => 'مشاهدة';

  @override
  String get categoriesActionRead => 'قراءة';

  @override
  String get categoriesActionOpen => 'فتح';

  @override
  String categoriesOrder(String order) {
    return 'الترتيب $order';
  }

  @override
  String get categoriesDownload => 'تحميل';

  @override
  String get categoriesAttachmentFallback => 'مرفق';

  @override
  String get categoriesNoChapters => 'لا توجد أبواب في هذا القسم.';

  @override
  String get categoriesClearSearch => 'مسح البحث';

  @override
  String get categoriesAudioLoadError => 'تعذر تحميل المواد الصوتية.';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'مقطع $number';
  }

  @override
  String get categoriesAudioClipFallback => 'مقطع صوتي';

  @override
  String get booksTitle => 'كتب';

  @override
  String get booksLoadError => 'تعذّر تحميل الكتب حاليًا.';

  @override
  String get booksEmpty => 'لا توجد كتب للعرض.';

  @override
  String get booksFilesHeader => 'ملفّات الكتاب';

  @override
  String get booksNoFilesTitle => 'لا توجد ملفّات';

  @override
  String get booksNoFilesBody => 'لم تُرفق بهذا الكتاب ملفّات للتنزيل.';

  @override
  String get booksDescriptionHeader => 'الوصف';

  @override
  String get booksReferenceHeader => 'المرجع';

  @override
  String booksFileNumber(int number) {
    return 'الملفّ $number';
  }

  @override
  String get booksReadTitle => 'قراءة الكتاب';

  @override
  String get booksViewerFailed => 'تعذّر عرض الكتاب داخل التطبيق';

  @override
  String get booksOpenOutsideHint => 'يمكنك فتحه خارج التطبيق';

  @override
  String get booksOpenOutside => 'فتح خارج التطبيق';

  @override
  String get hadith40Title => 'الأربعون النووية';

  @override
  String hadith40Number(int number) {
    return 'الحديث $number';
  }

  @override
  String get hadith40SearchHint => 'بحث عن حديث';

  @override
  String get hadith40NoResults => 'لا توجد نتائج لهذا البحث';

  @override
  String get hadith40ShowAll => 'عرض الأحاديث كلها';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'الأربعون النووية · الحديث $number';
  }

  @override
  String get hadith40Explanation => 'شرح الحديث';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nشرح الحديث:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'أسماء الله الحسنى';

  @override
  String allahNamesNameOrder(int number) {
    return 'الاسم $number من أسماء الله الحسنى';
  }

  @override
  String get allahNamesMeaning => 'المعنى';

  @override
  String get allahNamesSearchHint => 'بحث عن أسماء الله الحسنى';

  @override
  String get allahNamesNoResultsTitle => 'لا توجد نتائج';

  @override
  String get allahNamesNoResultsMessage => 'لم نجد اسمًا يطابق بحثك.';

  @override
  String get allahNamesShowAll => 'عرض الأسماء كلها';

  @override
  String get readQuranListen => 'السماع';

  @override
  String get readQuranAyah => 'الآية';

  @override
  String get readQuranTafsir => 'تفسير الآية';

  @override
  String get quranAudioPlayPause => 'تشغيل أو إيقاف';

  @override
  String audiosTrackNumber(int number) {
    return 'المقطع $number';
  }

  @override
  String get audiosTracksHeader => 'المقاطع';

  @override
  String get audiosSearchSeriesHint => 'ابحث عن سلسلة';

  @override
  String get audiosSeriesSubtitle => 'سلسلة صوتية';

  @override
  String get audiosNoSeries => 'لا توجد سلاسل للعرض';

  @override
  String get audiosNoResults => 'لا نتائج لبحثك';

  @override
  String get audiosPrevious => 'السابق';

  @override
  String get audiosNext => 'التالي';

  @override
  String get audiosPause => 'إيقاف مؤقّت';

  @override
  String get audiosPlay => 'تشغيل';

  @override
  String get coreUpdateDownloaded => 'تم تحميل التحديث، يمكنك تثبيته الآن.';

  @override
  String get coreUpdateInstallNow => 'تثبيت الآن';

  @override
  String get coreUpdateAvailableTitle => 'يتوفر تحديث جديد';

  @override
  String coreUpdateAvailableMessage(String version) {
    return 'الإصدار $version متاح الآن على App Store.';
  }

  @override
  String get coreUpdateWhatsNew => 'الجديد في هذا الإصدار:';

  @override
  String get coreUpdateNow => 'تحديث الآن';

  @override
  String get coreExitDialogTitle => 'تنبيه';

  @override
  String get coreExitDialogMessage => 'هل أنت متأكد من الخروج من التطبيق';

  @override
  String get coreExitConfirmMessage => 'هل أنت متأكد من الخروج';

  @override
  String get coreExitStay => 'تراجع';

  @override
  String get coreExitAction => 'الخروج';

  @override
  String get coreDeleteDhikrTitle => 'حذف الذكر؟';

  @override
  String get coreDeleteDhikrMessage => 'هل أنت متأكد من حذف الذكر؟';

  @override
  String get coreFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get coreNoData => 'لا توجد بيانات.';

  @override
  String get coreNoDataToShow => 'لا يوجد بيانات للعرض';

  @override
  String get coreContent => 'المحتوى';

  @override
  String get coreGenericError => 'هناك خطأ ما يرجى المحاولة مرة أخرى';

  @override
  String get coreLoadDataError => 'حدث خطأ أثناء تحميل البيانات';

  @override
  String coreErrorStatus(String code) {
    return 'الحالة: $code';
  }

  @override
  String get coreCloseSearch => 'إغلاق البحث';

  @override
  String get coreClear => 'مسح';

  @override
  String get coreSheetDefaultTitle => 'إضافة جديد';

  @override
  String get coreSheetDefaultSubtitle => 'قم بتخصيص المحتوى';

  @override
  String get coreCopiedSuccessfully => 'تم النسخ بنجاح';

  @override
  String get coreDownloadStarted => 'التنزيل بدأ';

  @override
  String get coreDownloadCompleted => 'تم التنزيل';

  @override
  String get coreSaveReadingPositionPrompt => 'هل تريد حفظ مكان قراءتك؟';

  @override
  String get coreLocationServiceDisabled =>
      'خدمة الموقع غير مفعّلة. فعّلها لتحديد مواقيت الصلاة.';

  @override
  String get coreLocationPermissionDenied =>
      'لم يتم منح صلاحية الوصول إلى الموقع.';

  @override
  String get coreLocationPermissionDeniedForever =>
      'صلاحية الموقع مرفوضة نهائيًا. فعّلها من إعدادات التطبيق.';

  @override
  String get coreNotNow => 'ليس الآن';

  @override
  String get coreAllow => 'السماح';

  @override
  String get coreOpenSettings => 'فتح الإعدادات';

  @override
  String get coreNotificationPermissionTitle => 'إذن الإشعارات';

  @override
  String get coreNotificationPermissionRationale =>
      'يحتاج التطبيق إلى إذن الإشعارات لتذكيرك بأوقات الصلاة والأذكار.\nهذا يساعدك على البقاء على اتصال مع تعاليم الإسلام طوال اليوم.';

  @override
  String get coreNotificationSettingsTitle => 'إعدادات الإشعارات';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'تم رفض إذن الإشعارات بشكل دائم.\nيرجى الذهاب إلى الإعدادات وتفعيل الإشعارات يدوياً.';

  @override
  String get corePermissionStatusGranted => 'تم منح جميع الأذونات';

  @override
  String get corePermissionStatusDenied => 'تم رفض أذونات الإشعارات';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'تم رفض الأذونات بشكل دائم';

  @override
  String get corePermissionStatusPartial => 'تم منح بعض الأذونات فقط';

  @override
  String get corePermissionStatusUnknown => 'حالة الأذونات غير معروفة';

  @override
  String get corePermissionResultGranted => 'تم منح جميع الأذونات بنجاح';

  @override
  String get corePermissionResultDenied => 'تم رفض طلب الأذونات';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'تم رفض الأذونات بشكل دائم - يرجى الذهاب إلى الإعدادات';

  @override
  String get corePermissionResultPartial =>
      'تم منح بعض الأذونات - قد تحتاج لأذونات إضافية';

  @override
  String get corePermissionResultError => 'حدث خطأ أثناء طلب الأذونات';

  @override
  String get coreNotificationActionOpenApp => 'فتح التطبيق';

  @override
  String get coreNotificationActionDismiss => 'إخفاء';

  @override
  String get coreNotificationActionMarkRead => 'تم القراءة';

  @override
  String get coreNotificationActionRemindLater => 'تذكير لاحقاً';

  @override
  String get coreNotificationGroupName => 'الإشعارات الإسلامية';

  @override
  String get coreNotificationGroupDescription =>
      'مجموعة الإشعارات الخاصة بالتطبيق الإسلامي';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'قناة $channel للإشعارات الإسلامية';
  }

  @override
  String get coreNotificationAppLabel => 'تطبيق طمأنينة';

  @override
  String get coreNotificationMore => 'المزيد...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إشعار',
      many: '$count إشعارًا',
      few: '$count إشعارات',
      two: 'إشعاران',
      one: 'إشعار واحد',
      zero: 'لا إشعارات',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إشعار جديد',
      many: '$count إشعارًا جديدًا',
      few: '$count إشعارات جديدة',
      two: 'إشعاران جديدان',
      one: 'إشعار جديد واحد',
      zero: 'لا إشعارات جديدة',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return 'حان الآن أذان $prayer';
  }

  @override
  String coreAthanDescription(String prayer) {
    return 'أذان $prayer';
  }

  @override
  String get coreChannelAthan => 'طمأنينة - الأذان';

  @override
  String get coreChannelMohammed => 'طمأنينة - الصلاة على النبي';

  @override
  String get coreChannelMorning => 'طمأنينة - أذكار الصباح';

  @override
  String get coreChannelNight => 'طمأنينة - أذكار المساء';

  @override
  String get coreChannelSleep => 'طمأنينة - أذكار النوم';

  @override
  String get coreChannelGetUp => 'طمأنينة - أذكار الاستيقاظ';

  @override
  String get coreChannelMiddleNight => 'طمأنينة - قيام الليل';

  @override
  String get coreChannelRandomThikr => 'طمأنينة - أذكار عشوائية';

  @override
  String get coreChannelAstgferAllh => 'طمأنينة - الاستغفار';

  @override
  String get coreChannelHasbnaAllh => 'طمأنينة - حسبنا الله';

  @override
  String get coreChannelLaHawla => 'طمأنينة - لا حول ولا قوة إلا بالله';

  @override
  String get coreChannelSubhanAllh => 'طمأنينة - سبحان الله';

  @override
  String get coreChannelDefaultChannel => 'طمأنينة - الإشعارات العامة';

  @override
  String get coreChannelSmartOutreach => 'طمأنينة - صحبة الفجر';

  @override
  String get coreFcmChannelHighImportance => 'طمأنينة - إشعارات مهمة';

  @override
  String get coreFcmChannelChat => 'طمأنينة - الرسائل';

  @override
  String get coreFcmChannelUpdates => 'طمأنينة - التحديثات';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'قناة الإشعارات المهمة في تطبيق طمأنينة';

  @override
  String get coreFcmChannelDefaultDescription =>
      'قناة الإشعارات العامة في تطبيق طمأنينة';

  @override
  String get coreFcmChannelChatDescription =>
      'قناة رسائل وتنبيهات تطبيق طمأنينة';

  @override
  String get coreFcmChannelUpdatesDescription => 'قناة تحديثات تطبيق طمأنينة';

  @override
  String get languageTitle => 'اختر لغتك';

  @override
  String get languageSubtitle => 'يمكنك تغييرها لاحقًا من الإعدادات.';

  @override
  String get languageSettingTitle => 'اللغة';

  @override
  String get languageSettingSubtitle => 'لغة واجهة التطبيق';

  @override
  String get languageReligiousTextNote =>
      'القرآن الكريم والأذكار والأدعية تبقى بنصّها العربي.';

  @override
  String get onboardingNotificationsTitle => 'لا تفوتك صلاة';

  @override
  String get onboardingNotificationsBody =>
      'اسمح بالإشعارات ليصلك الأذان في وقته، ويذكّرك التطبيق بأذكارك وورد يومك.';

  @override
  String get onboardingNotificationsPointAthan => 'الأذان عند دخول كل وقت';

  @override
  String get onboardingNotificationsPointAdhkar =>
      'أذكار الصباح والمساء في موعدها';

  @override
  String get onboardingNotificationsPointWird => 'تذكير لطيف بوردك اليومي';

  @override
  String get onboardingNotificationsAllow => 'السماح بالإشعارات';

  @override
  String get onboardingLocationTitle => 'مواقيت دقيقة لمدينتك';

  @override
  String get onboardingLocationBody =>
      'نستخدم موقعك لحساب مواقيت الصلاة واتجاه القبلة بدقة حيث أنت.';

  @override
  String get onboardingLocationPointTimes => 'مواقيت محسوبة لمكانك بالضبط';

  @override
  String get onboardingLocationPointTravel => 'تتحدّث تلقائيًا حين تسافر';

  @override
  String get onboardingLocationPointQibla => 'اتجاه القبلة من حيث تقف';

  @override
  String get onboardingLocationAllow => 'السماح بالموقع';

  @override
  String get onboardingLocationManualHint =>
      'تفضّل ألّا تشارك موقعك؟ اختر مدينتك يدويًا لاحقًا من صفحة المواقيت.';

  @override
  String get onboardingChangeLater =>
      'يمكنك تغيير ذلك لاحقًا من إعدادات جهازك.';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get homeNoticeNotificationsTitle => 'الإشعارات متوقفة';

  @override
  String get homeNoticeNotificationsBody =>
      'لن يصلك الأذان ولا تذكير الأذكار حتى تفعّلها.';

  @override
  String get homeNoticeNotificationsAction => 'تفعيل';

  @override
  String get homeNoticeExactAlarmsTitle => 'قد يتأخر الأذان';

  @override
  String get homeNoticeExactAlarmsBody =>
      'اسمح للتطبيق بضبط المنبّهات ليصل الأذان في وقته تمامًا.';

  @override
  String get homeNoticeExactAlarmsAction => 'السماح';

  @override
  String get outreachTitle => 'صحبة الفجر';

  @override
  String get outreachTagline => 'قوائم اتصال هادئة تبدأ يوم من تحبّ بالخير';

  @override
  String get outreachActionCallOnly => 'اتصال فقط';

  @override
  String get outreachErrorScheduleNotFound => 'هذه القائمة غير موجودة.';

  @override
  String get outreachContactsPermissionDenied =>
      'يجب السماح بالوصول لجهات الاتصال لاختيار رقم تلقائياً.';

  @override
  String get outreachContactNoPhone =>
      'جهة الاتصال المختارة لا تحتوي على رقم هاتف.';

  @override
  String get outreachContactPickError => 'حدث خطأ أثناء اختيار جهة الاتصال.';

  @override
  String get outreachUnnamed => 'بدون اسم';

  @override
  String get outreachPermissionPhone => 'الاتصال';

  @override
  String get outreachPermissionContacts => 'جهات الاتصال';

  @override
  String get outreachPermissionNotifications => 'الإشعارات';

  @override
  String get outreachListSeparator => '، ';

  @override
  String get outreachValidationTitleRequired => 'اكتب اسمًا للقائمة.';

  @override
  String get outreachValidationAddNumber => 'أضف رقمًا واحدًا على الأقل.';

  @override
  String get outreachValidationEmptyPhone =>
      'كل خانة يجب أن تحتوي على رقم هاتف.';

  @override
  String get outreachValidationIncompleteNumber => 'يوجد رقم غير مكتمل.';

  @override
  String get outreachValidationDuplicateNumber =>
      'يوجد رقم مكرر في نفس القائمة.';

  @override
  String get outreachValidationPickDay => 'اختر يومًا واحدًا على الأقل.';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'لا يمكن تشغيل قائمة بدون أرقام.';

  @override
  String get outreachCallLogsTitle => 'سجل المكالمات';

  @override
  String get outreachClearLog => 'مسح السجل';

  @override
  String get outreachStatTotal => 'الإجمالي';

  @override
  String get outreachStatAnswered => 'ردّوا';

  @override
  String get outreachStatNotAnswered => 'لم يردّوا';

  @override
  String get outreachStatFailed => 'فشل';

  @override
  String get outreachResultsHeader => 'النتائج';

  @override
  String get outreachNoResultsTitle => 'لا توجد نتائج بعد';

  @override
  String get outreachNoResultsMessage =>
      'ستظهر هنا نتيجة كل مكالمة بعد أول تشغيل.';

  @override
  String outreachSecondsShort(int seconds) {
    return '$secondsث';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds ث';
  }

  @override
  String get outreachCallStatusAnswered => 'تم الرد';

  @override
  String get outreachCallStatusNotAnswered => 'لم يتم الرد';

  @override
  String get outreachCallStatusFailed => 'فشل الاتصال';

  @override
  String get outreachExecutionTitle => 'بدء المكالمات';

  @override
  String get outreachCallsStartedFromAlert => 'بدأت المكالمات من التنبيه.';

  @override
  String get outreachCallsStartedNow => 'بدأت المكالمات الآن.';

  @override
  String get outreachCallsStartFailed =>
      'تعذر بدء المكالمات الآن. حاول مرة أخرى.';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'راجع من ردّ ومن لم يردّ بعد انتهاء القائمة';

  @override
  String get outreachPreparingCalls => 'جارِ تجهيز المكالمات...';

  @override
  String get outreachDontCloseHint => 'لا تغلق الصفحة حتى تبدأ العملية.';

  @override
  String get outreachCanCloseHint =>
      'يمكنك إغلاق الصفحة الآن ومراجعة النتيجة من السجل.';

  @override
  String get outreachAddList => 'إضافة قائمة';

  @override
  String get outreachStatLists => 'القوائم';

  @override
  String get outreachStatEnabled => 'المفعّلة';

  @override
  String get outreachStatNumbers => 'الأرقام';

  @override
  String get outreachListsHeader => 'قوائم الاتصال';

  @override
  String get outreachToolsHeader => 'أدوات';

  @override
  String get outreachCallLogsSubtitle => 'نتيجة كل اتصال: من ردّ ومن لم يردّ';

  @override
  String get outreachSettingsTitle => 'إعدادات الاتصال';

  @override
  String get outreachSettingsSubtitle =>
      'المدد الافتراضية وسلوك القوائم الجديدة';

  @override
  String get outreachNoListsTitle => 'لا توجد قوائم بعد';

  @override
  String get outreachNoListsMessage =>
      'أضف قائمة وحدّد وقتها والأرقام التي تودّ الاتصال بها.';

  @override
  String get outreachStartsNow => 'تبدأ الآن';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count ساعة',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return 'بعد $hours ساعة و$minutes دقيقة';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count أيام',
      one: 'بعد يوم',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'لازم تفعيل هذه الصلاحيات أولًا: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'الصلاحيات المطلوبة غير مكتملة. لتعمل القوائم في وقتها فعّل: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'منح الصلاحيات';

  @override
  String get outreachOpenSettings => 'فتح الإعدادات';

  @override
  String get outreachSettingsSaved => 'تم حفظ الإعدادات.';

  @override
  String get outreachSettingsIntro => 'تُطبَّق هذه القيم على كل قائمة جديدة.';

  @override
  String get outreachDefaultDurationsHeader => 'المدد الافتراضية';

  @override
  String get outreachRingTimeout => 'مدة انتظار الرد';

  @override
  String get outreachHangupDelay => 'الانتظار بعد الرد';

  @override
  String get outreachDelayBetweenEach => 'الفاصل بين كل رقم';

  @override
  String get outreachBehaviorHeader => 'سلوك القوائم';

  @override
  String get outreachStopAfterFirstAnswerList => 'إيقاف القائمة بعد أول رد';

  @override
  String get outreachRetryIfNoAnswer => 'إعادة الاتصال إذا لم يتم الرد';

  @override
  String get outreachRestartAfterFinish => 'إعادة البدء بعد الانتهاء';

  @override
  String get outreachSaveSettings => 'حفظ الإعدادات';

  @override
  String get outreachBackgroundHeader => 'التشغيل في الخلفية';

  @override
  String get outreachBatteryTitle => 'استثناء التطبيق من توفير البطارية';

  @override
  String get outreachBatterySubtitle =>
      'إذا توقفت القوائم وهي في الخلفية، اسمح للتطبيق بالعمل من إعدادات البطارية.';

  @override
  String get outreachEditList => 'تعديل القائمة';

  @override
  String get outreachNewList => 'قائمة جديدة';

  @override
  String get outreachCallTimeHeader => 'وقت الاتصال';

  @override
  String get outreachManualTime => 'اختيار وقت يدوي';

  @override
  String get outreachManualTimeSubtitle => 'حدّد الساعة والدقيقة بنفسك';

  @override
  String get outreachUseFajrTime => 'استخدام وقت الفجر';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'استخدام وقت الفجر · $time';
  }

  @override
  String get outreachPrayerTimesNotReady => 'مواقيت الصلاة غير جاهزة الآن';

  @override
  String get outreachFajrAutoFill => 'يُعبَّأ الوقت تلقائيًا من مواقيت اليوم';

  @override
  String get outreachFajrUnavailable =>
      'وقت الفجر غير متاح الآن. جرّب بعد قليل.';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'تم استخدام وقت الفجر: $time';
  }

  @override
  String get outreachContactFetchFailed => 'ما قدرنا نجيب جهة الاتصال الآن.';

  @override
  String get outreachExactAlarmHint =>
      'لضمان صحبة الفجر في وقتها بدقة، فعّل إذن التنبيهات الدقيقة من إعدادات الجهاز.';

  @override
  String get outreachListNameHeader => 'اسم القائمة';

  @override
  String get outreachStartTime => 'موعد البدء';

  @override
  String get outreachStartTimeHint => 'اختر وقتًا يدويًا أو استعمل وقت الفجر';

  @override
  String outreachFajrTimeToday(String time) {
    return 'وقت الفجر اليوم $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'جهات الاتصال · $count';
  }

  @override
  String get outreachPickFromContacts => 'اختيار من جهات الاتصال';

  @override
  String get outreachPickFromContactsSubtitle =>
      'أضف رقمًا جديدًا إلى هذه القائمة';

  @override
  String get outreachAdvancedSettings => 'إعدادات متقدمة';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'الأيام، مدد الانتظار، وسلوك التكرار';

  @override
  String get outreachSaving => 'جارِ الحفظ...';

  @override
  String get outreachSaveList => 'حفظ القائمة';

  @override
  String get outreachNoNumbersYet => 'لم تُضف أرقام بعد.';

  @override
  String get outreachEnableList => 'تشغيل هذه القائمة';

  @override
  String get outreachDailyRepeat => 'تكرار يومي';

  @override
  String get outreachEveryDay => 'كل يوم';

  @override
  String get outreachSelectedWeekdays => 'أيام مختارة من الأسبوع';

  @override
  String get outreachDelayBetweenNumbers => 'الفاصل بين الأرقام';

  @override
  String get outreachStopAfterFirstAnswer => 'إيقاف بعد أول رد';

  @override
  String get outreachRetryOnNoAnswer => 'إعادة عند عدم الرد';

  @override
  String get outreachRepeatWholeCycle => 'تكرار الحلقة بالكامل';

  @override
  String get outreachListNameHint => 'مثال: تذكير الفجر';

  @override
  String get outreachTitleFieldRequired => 'اكتب اسمًا للقائمة';

  @override
  String get outreachPickNumber => 'اختر الرقم';

  @override
  String get outreachMultipleNumbers => 'هذا الاسم فيه أكثر من رقم.';

  @override
  String get outreachNoDays => 'بلا أيام محددة';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رقمًا',
      many: '$count رقمًا',
      few: '$count أرقام',
      two: 'رقمان',
      one: 'رقم واحد',
      zero: 'بلا أرقام',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'انتظار $secondsث';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'بعد الرد $secondsث';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'بين الأرقام $secondsث';
  }

  @override
  String get outreachNearest => 'الأقرب';

  @override
  String get outreachStartNow => 'ابدأ الآن';

  @override
  String get outreachStatusActive => 'نشط';

  @override
  String get outreachStatusStopped => 'متوقّف';

  @override
  String outreachStatusSemantics(String status) {
    return 'الحالة: $status';
  }

  @override
  String get outreachWeekday1 => 'الإثنين';

  @override
  String get outreachWeekday2 => 'الثلاثاء';

  @override
  String get outreachWeekday3 => 'الأربعاء';

  @override
  String get outreachWeekday4 => 'الخميس';

  @override
  String get outreachWeekday5 => 'الجمعة';

  @override
  String get outreachWeekday6 => 'السبت';

  @override
  String get outreachWeekday7 => 'الأحد';

  @override
  String get travelerServicesTitle => 'خدمات المسافر';

  @override
  String get travelerNearbyMosques => 'المساجد القريبة';

  @override
  String get travelerNearbyHalalRestaurants => 'مطاعم حلال قريبة';

  @override
  String get travelerHalalRestaurants => 'مطاعم حلال';

  @override
  String get travelerHintAroundYou => 'حولك الآن';

  @override
  String get travelerHintWithCounter => 'بعدّاد';

  @override
  String get travelerHintByCountry => 'حسب بلدك';

  @override
  String get travelerFlightPrayer => 'الصلاة أثناء الطيران';

  @override
  String get travelerHintByFlightNumber => 'برقم الرحلة';

  @override
  String get travelerSetLocationForMakkah =>
      'حدّد موقعك في المواقيت لتظهر المسافة إلى مكّة.';

  @override
  String get travelerInMakkah => 'أنت في مكّة المكرّمة — تقبّل الله.';

  @override
  String get travelerYourLocation => 'موضعك';

  @override
  String get travelerMakkah => 'مكّة المكرّمة';

  @override
  String get travelerQibla => 'القبلة';

  @override
  String travelerDistanceMeters(String value) {
    return '$value م';
  }

  @override
  String travelerDistanceKm(String value) {
    return '$value كم';
  }

  @override
  String get travelerListSeparator => '، ';

  @override
  String get travelerDirectionN => 'شمالًا';

  @override
  String get travelerDirectionNE => 'شمال شرق';

  @override
  String get travelerDirectionE => 'شرقًا';

  @override
  String get travelerDirectionSE => 'جنوب شرق';

  @override
  String get travelerDirectionS => 'جنوبًا';

  @override
  String get travelerDirectionSW => 'جنوب غرب';

  @override
  String get travelerDirectionW => 'غربًا';

  @override
  String get travelerDirectionNW => 'شمال غرب';

  @override
  String get travelerPrayerUnknown => 'غير محدد';

  @override
  String get travelerPrayerShortFajr => 'فجر';

  @override
  String get travelerPrayerShortSunrise => 'شروق';

  @override
  String get travelerPrayerShortDhuhr => 'ظهر';

  @override
  String get travelerPrayerShortAsr => 'عصر';

  @override
  String get travelerPrayerShortMaghrib => 'مغرب';

  @override
  String get travelerPrayerShortIsha => 'عشاء';

  @override
  String get travelerNoMosquesFound => 'لم نعثر على مساجد في النطاق الحالي.';

  @override
  String get travelerNoRestaurantsFound =>
      'لم نعثر على مطاعم حلال في هذا النطاق.';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقيقة مشيًا',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'مسجد قريب';

  @override
  String get travelerDefaultRestaurantName => 'مطعم حلال';

  @override
  String get travelerNoDetailedAddress => 'بدون عنوان تفصيلي';

  @override
  String get travelerRepeatBySituation => 'بحسب الموقف';

  @override
  String get travelerRepeatOnce => 'مرة';

  @override
  String travelerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
    );
    return '$_temp0';
  }

  @override
  String get travelerStageStart => 'عند بداية السفر';

  @override
  String get travelerStageOnTheWay => 'أثناء الطريق';

  @override
  String get travelerStageStop => 'عند التوقف';

  @override
  String get travelerStageReturn => 'عند الرجوع';

  @override
  String get travelerStageFarewell => 'توديع المسافر';

  @override
  String get travelerStageFarewellReply => 'دعاء للمسافر';

  @override
  String get travelerAthkarTitle => 'أذكار السفر';

  @override
  String get travelerAthkarLoadFailed => 'تعذر تحميل أذكار السفر.';

  @override
  String get travelerFarewellTitle => 'لمن يودّع مسافرًا';

  @override
  String get travelerFarewellCaption => 'ليست من طريقك — بل ممّن بقي خلفك';

  @override
  String get travelerRoadComplete => 'أتممت أذكار طريقك';

  @override
  String get travelerRoadStations => 'محطّات الطريق';

  @override
  String get travelerRoadCompleteCaption => 'صحبتك السلامة.';

  @override
  String get travelerRoadCaption =>
      'كل ذكر في موضعه من الرحلة — افتح المحطّة التي أنت فيها.';

  @override
  String travelerShareVirtue(String virtue) {
    return 'الفضل: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'المصدر: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'تصفير العدّاد';

  @override
  String get travelerCounterDone => 'تمّ';

  @override
  String get travelerCounterCount => 'عدّ';

  @override
  String get travelerCountDhikr => 'عدّ الذكر';

  @override
  String get travelerFlightPrayerTitle => 'مواقيت الصلاة أثناء الطيران';

  @override
  String get travelerShowTimes => 'عرض المواقيت';

  @override
  String get travelerShowMap => 'عرض الخريطة';

  @override
  String get travelerShowList => 'عرض القائمة';

  @override
  String get travelerSearchByFlightNumber => 'بحث برقم الرحلة';

  @override
  String get travelerRunSearchNow => 'تشغيل البحث الآن';

  @override
  String get travelerFlightAttemptsExhausted =>
      'انتهت المحاولات. أعد فتح الصفحة للمحاولة مجددًا.';

  @override
  String get travelerFlightNumberInvalid =>
      'رقم الرحلة غير صحيح. مثال: EK202 أو MS985';

  @override
  String get travelerFlightFetchFailed => 'تعذر جلب بيانات الرحلة حاليًا.';

  @override
  String get travelerSourceMock => 'محاكاة محلية (بدون API)';

  @override
  String get travelerCityRiyadh => 'الرياض';

  @override
  String get travelerCityJeddah => 'جدة';

  @override
  String get travelerCityDubai => 'دبي';

  @override
  String get travelerCityDoha => 'الدوحة';

  @override
  String get travelerCityIstanbul => 'إسطنبول';

  @override
  String get travelerCityCairo => 'القاهرة';

  @override
  String get travelerCityKualaLumpur => 'كوالالمبور';

  @override
  String get travelerCityLondon => 'لندن';

  @override
  String get travelerCityParis => 'باريس';

  @override
  String get travelerCityNewYork => 'نيويورك';

  @override
  String get travelerAttemptsRemaining => 'محاولات متبقّية';

  @override
  String get travelerLiveTrack => 'مسار مباشر';

  @override
  String get travelerTakeoff => 'الإقلاع';

  @override
  String get travelerLanding => 'الهبوط';

  @override
  String get travelerFlightEnded => 'انتهت الرحلة — لم تبقَ مواقيت على متنها.';

  @override
  String get travelerNoPrayerDuringFlight =>
      'لم تقع أي صلاة ضمن مدّة هذه الرحلة.';

  @override
  String get travelerAllFlightPrayersPassed => 'مضت كل مواقيت هذه الرحلة.';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return 'بعد $hours س و$minutes د';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بعد $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return '$prayer على متن الرحلة — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'أوّل صلاة على متن الرحلة: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return '$time بتوقيت موضع الطائرة ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane => 'بالتوقيت المحلي فوق موضع الطائرة';

  @override
  String get travelerTapStopHint => 'اضغط على أي محطّة لترى موضعها على الخريطة';

  @override
  String get travelerUpcoming => 'قادم';

  @override
  String get travelerNext => 'التالية';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · جرينتش $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader => 'ابحث برقم الرحلة';

  @override
  String get travelerRun => 'تشغيل';

  @override
  String get travelerFlightSearchHint =>
      'اكتب رقم الرحلة لنحسب مواقيت الصلاة على طول المسار.';

  @override
  String get travelerFlightDetails => 'تفاصيل الرحلة';

  @override
  String get travelerFlightNumber => 'رقم الرحلة';

  @override
  String get travelerFrom => 'من';

  @override
  String get travelerTo => 'إلى';

  @override
  String get travelerDataSource => 'مصدر البيانات';

  @override
  String get travelerFlightTimeline => 'خطّ زمن الرحلة';

  @override
  String get travelerNoTimesDuringFlight =>
      'لم تظهر مواقيت ضمن مدة هذه الرحلة.';

  @override
  String get travelerFlightNumberExample => 'مثال: EK202';

  @override
  String get travelerShowFullRoute => 'عرض المسار كاملًا';

  @override
  String get travelerZoomIn => 'تكبير';

  @override
  String get travelerZoomOut => 'تصغير';

  @override
  String get travelerLocationFailed =>
      'تعذر تحديد موقعك الحالي. حاول مرة أخرى.';

  @override
  String get travelerLocationServiceDisabled =>
      'خدمة الموقع غير مفعلة. فعّلها لإظهار النتائج القريبة.';

  @override
  String get travelerLocationPermissionRequired =>
      'يجب منح صلاحية الموقع حتى تعمل هذه الميزة.';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'تم رفض صلاحية الموقع نهائيًا. افتح إعدادات التطبيق.';

  @override
  String get travelerPlacesFetchFailed =>
      'تعذر جلب النتائج القريبة الآن. حاول مجددًا.';

  @override
  String get travelerExpandRadius => 'وسّع النطاق';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'كلّها ضمن $radius — والسهم يشير إلى جهة كلٍّ منها.';
  }

  @override
  String get travelerRadius => 'النطاق';

  @override
  String get travelerNearestPlaces => 'أقرب الأماكن';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'وجدنا $count نتيجة قربك',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get travelerHalalRestricted =>
      'لا يظهر بحث المطاعم الحلال في الدول الإسلامية،\nلأن مطاعمها حلال أصلًا.';

  @override
  String get travelerOpenMapsFailed => 'تعذّر فتح تطبيق الخرائط.';

  @override
  String get travelerNearestMosque => 'أقرب مسجد إليك';

  @override
  String get travelerNearestRestaurant => 'أقرب مطعم حلال';

  @override
  String get travelerTakeMeThere => 'خذني إليه';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تلحق $prayer — تبقّى $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قد لا تلحق $prayer مشيًا — تبقّى $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'فتح في خرائط جوجل';

  @override
  String get travelerTapMarkerHint => 'اضغط على العلامة لعرض التفاصيل';

  @override
  String get travelerOpenPhoneFailed => 'تعذر فتح تطبيق الاتصال.';

  @override
  String get travelerOpenLinkFailed => 'تعذر فتح الرابط.';

  @override
  String get travelerDirections => 'الاتجاه';

  @override
  String get travelerGoogleMaps => 'خرائط جوجل';

  @override
  String get travelerCall => 'اتصال';

  @override
  String get travelerUpdating => 'جارٍ التحديث…';

  @override
  String travelerResultsCount(int count) {
    return 'عدد النتائج $count';
  }

  @override
  String get travelerMyCurrentLocation => 'موقعي الحالي';

  @override
  String get travelerMaps => 'الخرائط';

  @override
  String get travelerMyLocation => 'موقعي';

  @override
  String get qiblahTitle => 'القبلة';

  @override
  String get qiblahRefreshTooltip => 'تحديث الاتجاه';

  @override
  String get qiblahErrorNoSensor => 'جهازك لا يدعم استشعار الاتجاه';

  @override
  String get qiblahErrorPermissionRequired =>
      'يجب السماح بالوصول للموقع لتحديد اتجاه القبلة';

  @override
  String qiblahErrorGeneric(String error) {
    return 'حدث خطأ في تحديد اتجاه القبلة: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'تم رفض أذونات الموقع نهائياً. يرجى تفعيلها من إعدادات التطبيق';

  @override
  String get qiblahErrorLocationFailed => 'فشل في الحصول على الموقع الحالي';

  @override
  String get qiblahUnknownLocation => 'موقع غير معروف';

  @override
  String qiblahErrorDirection(String error) {
    return 'خطأ في تحديد الاتجاه: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'فشل في بدء تتبع الاتجاه';

  @override
  String get qiblahLocating => 'جاري تحديد الموقع...';

  @override
  String get qiblahAligned => 'أنت متوجّه إلى القبلة';

  @override
  String qiblahTurnLeft(int degrees) {
    return 'استدر يسارًا $degrees°';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return 'استدر يمينًا $degrees°';
  }

  @override
  String get qiblahLoadingTitle => 'جارِ تحديد اتجاه القبلة';

  @override
  String get qiblahLoadingSubtitle => 'تأكد من تفعيل الموقع والسماح بالأذونات';

  @override
  String get qiblahHintAligned => 'ثبّت الجهاز، السهم على علامة القبلة';

  @override
  String get qiblahHintMove => 'حرّك الجهاز ببطء حتى يصل السهم إلى العلامة';

  @override
  String get qiblahReadingsHeader => 'قراءة البوصلة';

  @override
  String get qiblahCurrentHeading => 'اتجاهك الحالي';

  @override
  String get qiblahAngle => 'زاوية القبلة';

  @override
  String get qiblahCurrentLocation => 'موقعك الحالي';

  @override
  String get qiblahDistanceToMecca => 'المسافة إلى مكة';

  @override
  String qiblahDistanceKm(int km) {
    return '$km كم';
  }

  @override
  String get qiblahInstructionsHeader => 'تعليمات الاستخدام';

  @override
  String get qiblahInstructions =>
      '• امسك الهاتف مستويًا أمامك.\n• تحرّك ببطء حتى يلتقي السهم الذهبي بالعلامة العلوية.\n• عند المحاذاة تضيء الحلقة وتشعر باهتزازة خفيفة.\n• أبعد الأجسام المعدنية عن الهاتف.\n• إذا اضطرب المؤشر، حرّك الهاتف على شكل رقم ٨.';

  @override
  String get qiblahCompassNorth => 'شمال';

  @override
  String get qiblahCompassEast => 'شرق';

  @override
  String get qiblahCompassSouth => 'جنوب';

  @override
  String get qiblahCompassWest => 'غرب';

  @override
  String get homeSectionYourDay => 'يومك';

  @override
  String get homeSectionAyah => 'آية من القرآن';

  @override
  String get homeSectionFeatures => 'المميزات';

  @override
  String get homeSectionKids => 'قسم الأطفال';

  @override
  String get homeYoungMuslimTitle => 'المسلم الصغير';

  @override
  String get homeYoungMuslimSubtitle => 'قصص وآداب وأذكار للطفل';

  @override
  String homeUpdateAvailable(String version) {
    return 'يوجد تحديث جديد · الإصدار $version';
  }

  @override
  String get homeUpdateAction => 'تحديث';

  @override
  String get homeContinueReading => 'تكملة القراءة';

  @override
  String get homeStartReading => 'ابدأ القراءة';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · صفحة $page';
  }

  @override
  String get homeStartReadingPosition => 'من سورة الفاتحة · صفحة ١';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · الآية $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'الآية $number';
  }

  @override
  String get homeAnotherAyah => 'آية أخرى';

  @override
  String get homeReadInMushaf => 'اقرأها في المصحف';

  @override
  String get homeTrackerComplete => 'أتممت صلوات اليوم، تقبّل الله';

  @override
  String get homeTrackerPrompt => 'علّم ما أدّيته اليوم';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$count من $total';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم متتالٍ',
      many: '$days يومًا متتاليًا',
      few: '$days أيام متتالية',
      two: 'يومان متتاليان',
      one: 'يوم',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'الرئيسية';

  @override
  String get homeNavSections => 'الاقسام';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '  $prayer : $time  \n الوقت المتبقي : $remaining ';
  }

  @override
  String get prayerTimeHighLatAuto => 'تلقائي';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'يترك المعالجة للقيمة الافتراضية لطريقة الحساب.';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'منتصف الليل';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'لا يسبق الفجر منتصف الليل ولا يتأخر العشاء عنه.';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'سُبع الليل';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'يعتمد على سُبع الليل الأخير للفجر والأول للعشاء.';

  @override
  String get prayerTimeHighLatTwilightAngle => 'زاوية الشفق';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'يقسّم الليل حسب زاويتي الفجر والعشاء المختارتين.';

  @override
  String get prayerTimeIshaModeAngle => 'العشاء بزاوية';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'يُحسب العشاء بزاوية الشمس تحت الأفق.';

  @override
  String get prayerTimeIshaModeInterval => 'العشاء بفاصل زمني';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'يُحسب العشاء بعدد دقائق ثابت بعد المغرب.';

  @override
  String get prayerTimeMethodUmmAlQura => 'أم القرى - مكة المكرمة';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'رابطة العالم الإسلامي';

  @override
  String get prayerTimeMethodEgyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get prayerTimeMethodKarachi => 'جامعة العلوم الإسلامية - كراتشي';

  @override
  String get prayerTimeMethodDubai => 'دبي';

  @override
  String get prayerTimeMethodQatar => 'قطر';

  @override
  String get prayerTimeMethodKuwait => 'الكويت';

  @override
  String get prayerTimeMethodSingapore => 'سنغافورة';

  @override
  String get prayerTimeMethodTurkey => 'ديانت - تركيا';

  @override
  String get prayerTimeMethodTehran => 'جامعة طهران للجيوفيزياء';

  @override
  String get prayerTimeMethodMoonSighting => 'لجنة رؤية الهلال';

  @override
  String get prayerTimeMethodNorthAmerica =>
      'الجمعية الإسلامية لأمريكا الشمالية';

  @override
  String get prayerTimeMethodCustom => 'إعداد مخصص';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'الفجر 18.5° والعشاء بعد المغرب بـ 90 دقيقة.';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'الفجر 18° والعشاء 17°.';

  @override
  String get prayerTimeMethodEgyptianDesc => 'الفجر 19.5° والعشاء 17.5°.';

  @override
  String get prayerTimeMethodKarachiDesc => 'الفجر 18° والعشاء 18°.';

  @override
  String get prayerTimeMethodDubaiDesc => 'الفجر والعشاء 18.2°.';

  @override
  String get prayerTimeMethodQatarDesc =>
      'الفجر 18° والعشاء بعد المغرب بـ 90 دقيقة.';

  @override
  String get prayerTimeMethodKuwaitDesc => 'الفجر 18° والعشاء 17.5°.';

  @override
  String get prayerTimeMethodSingaporeDesc => 'الفجر 20° والعشاء 18°.';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'الفجر 18° والعشاء 17° مع تعديلات ديانت.';

  @override
  String get prayerTimeMethodTehranDesc =>
      'الفجر 17.7° والعشاء 14° والمغرب 4.5°.';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'الفجر 18° والعشاء 18° مع تعديلات موسمية.';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'الفجر 15° والعشاء 15°.';

  @override
  String get prayerTimeMethodCustomDesc =>
      'حدّد زوايا الفجر والعشاء والمغرب بنفسك.';

  @override
  String get prayerTimeMadhabShafi => 'الشافعي والمالكي والحنبلي';

  @override
  String get prayerTimeMadhabHanafi => 'الحنفي';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'العصر عندما يصير ظل الشيء مثله، وعليه المالكي والحنبلي أيضًا.';

  @override
  String get prayerTimeMadhabHanafiDesc => 'العصر عندما يصير ظل الشيء مثليه.';

  @override
  String get prayerTimeCalcIntro =>
      'اختر التقويم الذي تعتمده جهتك المحلية، وعدّل المواقيت يدويًا إن احتجت مطابقتها مع مسجد الحي.';

  @override
  String get prayerTimeCalcMethod => 'طريقة الحساب';

  @override
  String get prayerTimeCalcAsrMadhab => 'مذهب حساب العصر';

  @override
  String get prayerTimeMadhabShafiShort => 'الشافعي';

  @override
  String get prayerTimeCalcHighLatitude => 'خطوط العرض العالية';

  @override
  String get prayerTimeCalcRamadanIsha => 'تأخير العشاء في رمضان';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'يضيف ٣٠ دقيقة على العشاء طوال الشهر كما في تقويم أم القرى.';

  @override
  String get prayerTimeCalcRestoreDefaults => 'استعادة إعدادات أم القرى';

  @override
  String get prayerTimeCalcCustomAngles => 'زوايا الحساب المخصصة';

  @override
  String get prayerTimeCalcFajrAngle => 'زاوية الفجر';

  @override
  String get prayerTimeCalcIshaMode => 'حساب العشاء';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'إمّا بزاوية الشفق، وإمّا بفاصل ثابت بعد المغرب.';

  @override
  String get prayerTimeCalcIshaAngle => 'زاوية العشاء';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'العشاء بعد المغرب';

  @override
  String get prayerTimeCalcMaghribAngleToggle => 'زاوية المغرب بدل الغروب';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'لِمن يعتمد زاوية شفق للمغرب بدل لحظة الغروب.';

  @override
  String get prayerTimeCalcMaghribAngle => 'زاوية المغرب';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value د';
  }

  @override
  String get prayerTimeMinutesZero => '٠ د';

  @override
  String get prayerTimeCalcManualAdjust => 'تعديل يدوي لكل وقت';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'طابق المواقيت مع مسجد الحي دقيقة بدقيقة';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count من المواقيت معدّلة يدويًا',
      few: '$count مواقيت معدّلة يدويًا',
      two: 'وقتان معدّلان يدويًا',
      one: 'وقت واحد معدّل يدويًا',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'الصلاة';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return 'أذان $prayer';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return 'أذان $prayer • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'حيّ على الصلاة — ابدأ يومك بنور الفجر.';

  @override
  String get prayerTimeAthanBodyDhuhr => 'اجعلها استراحة قلب.';

  @override
  String get prayerTimeAthanBodyAsr => 'جدّد حضورك مع الله.';

  @override
  String get prayerTimeAthanBodyMaghrib => 'اختم يومك بطاعة وسكينة.';

  @override
  String get prayerTimeAthanBodyIsha => 'لا تفوّت ختام الصلوات.';

  @override
  String get prayerTimeAthanBodyDefault => 'تقبّل الله طاعتك.';

  @override
  String get prayerTimeAthanExpandedHint => 'اضغط لفتح تنبيه الصلاة والتفاصيل.';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return 'حان الآن أذان $prayer';
  }

  @override
  String get prayerTimeAlertNow => 'حان الآن وقت الصلاة';

  @override
  String get prayerTimeAlertMessage =>
      'أقم صلاتك بخشوع، فهي نور القلب وسكينة الروح.';

  @override
  String get prayerTimeAlertReady => 'تم الاستعداد للصلاة';

  @override
  String get prayerTimeAlertOpenTimes => 'فتح صفحة أوقات الصلاة';

  @override
  String get prayerTimeTitle => 'أوقات الصلاة';

  @override
  String get prayerTimeSettingsTitle => 'إعدادات أوقات الصلاة';

  @override
  String get prayerTimeSheetAthanTime => 'وقت الأذان';

  @override
  String get prayerTimeSheetUntilDhuhr => 'حتى الظهر';

  @override
  String get prayerTimeSheetWindow => 'مدّة النافذة';

  @override
  String get prayerTimeSheetShift => 'الفارق عن اليوم';

  @override
  String get prayerTimeWeekdaySat => 'سبت';

  @override
  String get prayerTimeWeekdaySun => 'أحد';

  @override
  String get prayerTimeWeekdayMon => 'إثن';

  @override
  String get prayerTimeWeekdayTue => 'ثلا';

  @override
  String get prayerTimeWeekdayWed => 'أرب';

  @override
  String get prayerTimeWeekdayThu => 'خمي';

  @override
  String get prayerTimeWeekdayFri => 'جمع';

  @override
  String get prayerTimeLessThanMinute => 'أقل من دقيقة';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours س';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String get prayerTimeShiftSameDay => 'اليوم نفسه';

  @override
  String get prayerTimeShiftNone => 'بلا فارق';

  @override
  String prayerTimeShiftLater(int minutes) {
    return 'متأخّر $minutes د';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return 'مبكّر $minutes د';
  }

  @override
  String get prayerTimeAm => 'ص';

  @override
  String get prayerTimePm => 'م';

  @override
  String get prayerTimeLocationSourceManual => 'اختيار يدوي';

  @override
  String get prayerTimeLocationSourceDevice => 'موقع الجهاز';

  @override
  String get prayerTimeLocationPickHint => 'اختر مدينة أو استخدم موقع الجهاز';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'لم يتم تحديد موقع بعد';

  @override
  String get prayerTimeMyLocation => 'موقعي الحالي';

  @override
  String get prayerTimeGrantPermission => 'منح الصلاحية';

  @override
  String get prayerTimeEmptyWeekTitle => 'حدّد موقعك ليظهر جدول الأسبوع';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'ابحث عن مدينتك أو استخدم موقع الجهاز';

  @override
  String get prayerTimeSetLocation => 'تحديد الموقع';

  @override
  String get prayerTimeWeekNeedsCity =>
      'حدّد مدينتك لعرض مواقيت الأسبوع كاملًا';

  @override
  String get prayerTimeWeekHint =>
      'اسحب الجدول أفقيًا لبقية الأيام · المس أي وقت لتفاصيله';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'قيام الليل · $day';
  }

  @override
  String get prayerTimeMidnight => 'منتصف الليل';

  @override
  String get prayerTimeMidnightHint => 'منتصف ما بين المغرب والفجر';

  @override
  String get prayerTimeLastThird => 'الثلث الأخير';

  @override
  String get prayerTimeLastThirdHint => 'أفضل أوقات القيام والدعاء';

  @override
  String get prayerTimeLocationHeader => 'الموقع';

  @override
  String get prayerTimeLocationUpdateFailed => 'تعذر تحديث الموقع الحالي.';

  @override
  String get prayerTimeToday => 'اليوم';

  @override
  String get prayerTimeTomorrow => 'غدًا';

  @override
  String get prayerTimeTablePrayerColumn => 'الصلاة';

  @override
  String get prayerTimeSettingsCalcHeader => 'طريقة حساب المواقيت';

  @override
  String get prayerTimeSettingsSilentHeader => 'الصامت وقت الصلاة';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'امنح صلاحية عدم الإزعاج أولًا حتى تعمل الميزة.';

  @override
  String get prayerTimeSettingsSaved => 'تم حفظ إعدادات أوقات الصلاة.';

  @override
  String get prayerTimeSilentHint =>
      'يحوّل الجهاز إلى صامت مع وقت الصلاة ثم يعيد الصوت تلقائيًا.';

  @override
  String get prayerTimeSilentEnable => 'تفعيل الصامت تلقائيًا';

  @override
  String get prayerTimeSilentPermissionNote =>
      'تحتاج الميزة صلاحية «عدم الإزعاج» من النظام.';

  @override
  String get prayerTimeSilentDuration => 'مدة الصامت بعد الصلاة';

  @override
  String get prayerTimeMinutesSuffix => 'د';

  @override
  String get prayerTimeSaving => 'جارِ الحفظ';

  @override
  String get prayerTimeSaveSettings => 'حفظ الإعدادات';

  @override
  String get prayerTimeSavedLocation => 'الموقع المحفوظ';

  @override
  String get prayerTimePickerMapPointLabel => 'موقع محدد على الخريطة';

  @override
  String get prayerTimePickerResolving => 'جارِ قراءة اسم الموقع المحدد...';

  @override
  String get prayerTimePickerTapMap => 'اضغط على الخريطة لتحديد المنطقة';

  @override
  String get prayerTimePickerTitle => 'اختيار المنطقة';

  @override
  String get prayerTimePickerSubtitle => 'ابحث أو حدّد نقطة من الخريطة';

  @override
  String get prayerTimePickerUsingDevice => 'جارِ استخدام موقع الجهاز...';

  @override
  String get prayerTimePickerUseDevice => 'استخدام موقع الجهاز الحالي';

  @override
  String get prayerTimePickerMapTab => 'الخريطة';

  @override
  String get prayerTimePickerSearchHint => 'اسم المدينة أو الدولة';

  @override
  String get prayerTimePickerNoResults => 'لم نعثر على نتائج مطابقة';

  @override
  String get prayerTimePickerStartTyping => 'ابدأ بكتابة اسم المدينة';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'اضغط على الخريطة لاختيار المنطقة';

  @override
  String get prayerTimePickerApplying => 'جارِ الاعتماد';

  @override
  String get prayerTimePickerApply => 'اعتماد';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'الحالية $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'القادمة $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'تفعيل الموقع';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'لا يمكن عرض مواقيت الصلاة قبل تحديد المنطقة';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'اختر مدينة يدويًا أو استخدم موقع الجهاز الحالي';

  @override
  String get prayerTimeTimelineChooseArea => 'اختيار منطقة';

  @override
  String get prayerTimeNow => 'الآن';

  @override
  String get prayerTimeNextBadge => 'التالية';

  @override
  String get prayerTimeRowNext => 'الصلاة القادمة';

  @override
  String get prayerTimeRowCompleted => 'انتهى وقتها';

  @override
  String get prayerTimeRowLocalTime => 'الوقت المحلي';

  @override
  String get prayerTimeLoadingTimes => 'جاري تحميل المواقيت';

  @override
  String get prayerTimeLocatingShort => 'جاري تحديد الموقع';

  @override
  String get prayerTimeNoticeUnavailable =>
      'فعّل الموقع أو امنح الصلاحية لعرض مواقيت الصلاة بدقة.';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'الأوقات الحالية تستخدم آخر موقع محفوظ. فعّل الموقع لتحديثها تلقائيًا.';

  @override
  String get prayerTimeNoticeServiceOff =>
      'خدمة الموقع غير مفعلة. فعّلها لعرض مواقيت الصلاة حسب موقعك الحالي.';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'الأوقات الحالية تستخدم آخر موقع محفوظ. اسمح بالوصول للموقع لتحديثها الآن.';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'صلاحية الموقع غير ممنوحة. اسمح بها لعرض المواقيت حسب موقعك الحالي.';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'الأوقات الحالية تستخدم آخر موقع محفوظ. افتح الإعدادات لإعادة تفعيل صلاحية الموقع.';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات وفعّلها لعرض المواقيت بدقة.';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'تعذر تحديث الموقع الآن، لذلك يتم استخدام آخر موقع محفوظ للمستخدم.';

  @override
  String get prayerTimeNoticeError =>
      'تعذر تحديد الموقع حاليًا. فعّل الموقع أو اسمح بالصلاحية لإظهار المواقيت.';

  @override
  String get prayerTimeOpenSettings => 'فتح الإعدادات';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return 'حان الآن وقت $prayer';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return '$prayer بعد أقل من دقيقة';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقيقة',
      few: '$minutes دقائق',
      two: 'دقيقتين',
      one: 'دقيقة واحدة',
    );
    return '$prayer بعد $_temp0';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ساعة',
      few: '$hours ساعات',
      two: 'ساعتين',
      one: 'ساعة',
    );
    return '$prayer بعد $_temp0';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer بعد $hours س $minutes د';
  }

  @override
  String get prayerTimeRemainingNow => 'حان الوقت';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return 'بقي $minutes د';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return 'بقي $hours س';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return 'بقي $hours س $minutes د';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'الموقع الحالي';

  @override
  String get prayerTimeYouAreInTime => 'أنت الآن في وقت';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · توقيت أم القرى';
  }

  @override
  String get prayerTimeAllTimes => 'كل المواقيت';

  @override
  String get prayerTimeMuteAthan => 'كتم أذان هذه الصلاة';

  @override
  String get prayerTimeUnmuteAthan => 'تشغيل أذان هذه الصلاة';

  @override
  String get prayerTimeQuickMushaf => 'المصحف';

  @override
  String get prayerTimeQuickPrayerTimes => 'مواقيت الصلاة';

  @override
  String get prayerTimeQuickAdhkar => 'مكتبة الأذكار';

  @override
  String get prayerTimeErrorLoad => 'تعذر تحميل مواقيت الصلاة حاليًا';

  @override
  String get prayerTimeErrorUpdateArea => 'تعذر تحديث المنطقة المختارة';

  @override
  String get prayerTimeErrorApplySettings =>
      'تعذر تحديث المواقيت بالإعدادات الجديدة';

  @override
  String get prayerTimeErrorServiceOff =>
      'خدمة الموقع غير مفعلة. فعّلها أو اختر مدينة يدويًا.';

  @override
  String get prayerTimeErrorPermission =>
      'يلزم منح صلاحية الموقع أو اختيار مدينة يدويًا.';

  @override
  String get prayerTimeErrorDeniedForever =>
      'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات أو اختر مدينة.';

  @override
  String get prayerTimeErrorDeviceLocation => 'تعذر تحديد موقع الجهاز حاليًا';

  @override
  String get homeWidgetsPinFailed =>
      'تعذّر فتح نافذة الإضافة. أضفها يدويًا من الشاشة الرئيسية.';

  @override
  String get homeWidgetsSyncSuccess => 'تم تحديث الودجات';

  @override
  String get homeWidgetsSyncFailed => 'تعذّر التحديث. تأكّد من تحديد موقعك.';

  @override
  String get homeWidgetsAddTooltip => 'إضافة إلى الشاشة الرئيسية';

  @override
  String get homeWidgetsTitle => 'ودجات الشاشة الرئيسية';

  @override
  String get homeWidgetsHowToHeader => 'طريقة الإضافة';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'اضغط زر الإضافة بجانب الودجت، أو اضغط مطوّلًا على مساحة فارغة في الشاشة الرئيسية ثم «التطبيقات المصغّرة» وابحث عن «$appName».';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'اضغط مطوّلًا على مساحة فارغة في الشاشة الرئيسية، ثم زر «+» أعلى الشاشة، وابحث عن «$appName». ودجت الصلاة القادمة متاحة أيضًا لشاشة القفل.';
  }

  @override
  String get homeWidgetsListHeader => 'الودجات';

  @override
  String get homeWidgetsNextPrayerTitle => 'الصلاة القادمة';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'اسم الصلاة ووقتها مع عدّ تنازلي حيّ';

  @override
  String get homeWidgetsNextPrayerSubtitleIos =>
      'صغيرة · وشاشة القفل بثلاثة أشكال';

  @override
  String get homeWidgetsTodayTimesTitle => 'مواقيت اليوم';

  @override
  String get homeWidgetsTodayTimesSubtitle =>
      'الصلوات الستّ مع التاريخ الهجري والمدينة';

  @override
  String get homeWidgetsDailyAyahTitle => 'آية اليوم';

  @override
  String get homeWidgetsDailyAyahSubtitle => 'آية قصيرة تتجدّد كل يوم';

  @override
  String get homeWidgetsSyncHeader => 'المزامنة';

  @override
  String get homeWidgetsSyncNow => 'تحديث الودجات الآن';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومين',
      one: 'يومًا واحدًا',
    );
    return 'يحسب مواقيت $_temp0 بموقعك وإعداداتك الحالية';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومين',
      one: 'يومًا واحدًا',
    );
    return 'الودجات تعمل $_temp0 دون فتح التطبيق، وتتجدّد تلقائيًا في الخلفية. تتحدّث وحدها عند تغيير موقعك أو طريقة الحساب.';
  }

  @override
  String get settingsDeveloperName => 'معتصم الهلالي';

  @override
  String get settingsUpdateStarting => 'جارٍ بدء تحديث التطبيق...';

  @override
  String get settingsUpdateUpToDate => 'أنت تستخدم أحدث إصدار من التطبيق.';

  @override
  String get settingsUpdateCheckFailed =>
      'تعذّر التحقق من التحديثات، حاول لاحقاً.';

  @override
  String get settingsGroupPreferences => 'التفضيلات';

  @override
  String get settingsDarkModeTitle => 'النمط الداكن';

  @override
  String get settingsStatusOn => 'مفعل';

  @override
  String get settingsStatusOff => 'معطل';

  @override
  String get settingsNotificationsTitle => 'إعدادات الإشعارات';

  @override
  String get settingsNotificationsSubtitle => 'تحكّم بكل تنبيه يصلك من التطبيق';

  @override
  String get settingsDownloadsTitle => 'إعدادات التنزيل';

  @override
  String get settingsDownloadsSubtitle => 'إدارة الملفات المحمّلة والمساحة';

  @override
  String get settingsGroupApp => 'التطبيق';

  @override
  String get settingsCheckUpdatesTitle => 'التحقق من التحديثات';

  @override
  String get settingsCheckUpdatesSubtitle => 'تأكد من أنك تستخدم أحدث إصدار';

  @override
  String get settingsAboutUsTitle => 'من نحن';

  @override
  String get settingsAboutUsSubtitle => 'تعرف على تطبيق طمأنينة ورسالته';

  @override
  String get settingsRateAppTitle => 'قيّم التطبيق';

  @override
  String get settingsRateAppSubtitle => 'ساهم في نشر الخير بتقييمك على المتجر';

  @override
  String get settingsGroupPrivacy => 'الخصوصية والأمان';

  @override
  String get settingsPrivacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'كيف يتعامل التطبيق مع بياناتك وصلاحياتك';

  @override
  String get settingsDataSafetyTitle => 'أمان البيانات';

  @override
  String get settingsDataSafetySubtitle =>
      'ملخص البيانات والصلاحيات وطريقة استخدامها';

  @override
  String get settingsGroupDeveloper => 'المطوّر';

  @override
  String get settingsAboutDeveloperTitle => 'حول المطور';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'معلومات وروابط التواصل الخاصة بالمطور';

  @override
  String get settingsDeveloperContactSubtitle =>
      'تواصل مباشر عبر الموقع أو واتس اب';

  @override
  String get settingsPersonalWebsite => 'الموقع الشخصي';

  @override
  String get settingsGroupFollowNews => 'تابع آخر الأخبار';

  @override
  String get settingsSocialTelegram => 'تليجرام';

  @override
  String get settingsSocialWhatsapp => 'واتس اب';

  @override
  String get settingsSocialFacebook => 'فيسبوك';

  @override
  String get settingsSocialInstagram => 'انستجرام';

  @override
  String get settingsSocialTwitter => 'تويتر';

  @override
  String get settingsPrivacyIntro =>
      'معلومات واضحة ومختصرة حول طريقة تعامل التطبيق مع بياناتك.';

  @override
  String get settingsPrivacyMattersTitle => 'خصوصيتك تهمنا';

  @override
  String get settingsPrivacyMattersBody =>
      'نحرص في طمأنينة على أن تكون تجربة استخدام التطبيق واضحة وآمنة. نستخدم البيانات الضرورية فقط لتشغيل مزايا التطبيق وتحسينها، ولا نبيع بيانات المستخدمين أو نشاركها لأغراض إعلانية.';

  @override
  String get settingsPrivacyDataUsedTitle =>
      'البيانات التي قد يستخدمها التطبيق';

  @override
  String get settingsPrivacyDataUsedBody =>
      'قد يستخدم التطبيق الموقع لحساب أوقات الصلاة والقبلة، والإشعارات لتنبيهات الأذان والأذكار، وبيانات التخزين لحفظ المحتوى المحمل والإعدادات المحلية، وجهات الاتصال فقط في الميزات التي يفعّلها المستخدم مثل صحبة الفجر.';

  @override
  String get settingsPrivacyControlTitle => 'التحكم ببياناتك';

  @override
  String get settingsPrivacyControlBody =>
      'يمكنك تعطيل الإشعارات أو تعديلها من إعدادات الإشعارات داخل التطبيق، ويمكنك إدارة صلاحيات النظام من إعدادات جهازك في أي وقت.';

  @override
  String get settingsPrivacyThirdPartyTitle => 'الخدمات الخارجية';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'قد يستخدم التطبيق خدمات مثل Firebase Remote Config وFirebase Messaging لتحديث الإعدادات وإرسال التنبيهات العامة. يتم استخدام هذه الخدمات لتشغيل التطبيق وتحسين التجربة فقط.';

  @override
  String get settingsDataSafetyIntro =>
      'ملخص للبيانات التي يستخدمها التطبيق وكيف تُحفظ وتُشارك.';

  @override
  String get settingsDataSafetySensitiveTitle => 'البيانات الحساسة';

  @override
  String get settingsDataSafetySensitiveBody =>
      'لا يطلب التطبيق بيانات حساسة إلا عند الحاجة لميزة واضحة يختارها المستخدم. بعض البيانات مثل أوقات التنبيه، التفضيلات، وخطط القراءة تُحفظ محليًا على الجهاز.';

  @override
  String get settingsDataSafetyLocationTitle => 'الموقع';

  @override
  String get settingsDataSafetyLocationBody =>
      'يُستخدم الموقع لحساب مواقيت الصلاة، اتجاه القبلة، والخدمات المعتمدة على المكان. يمكن للمستخدم إيقاف صلاحية الموقع من إعدادات النظام.';

  @override
  String get settingsDataSafetyNotificationsTitle => 'الإشعارات';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'يستخدم التطبيق الإشعارات للأذان، الأذكار، التذكيرات، وبعض رسائل التطبيق العامة. يمكن التحكم بكل نوع إشعار من صفحة إعدادات الإشعارات.';

  @override
  String get settingsDataSafetyStorageTitle => 'التخزين والتحميل';

  @override
  String get settingsDataSafetyStorageBody =>
      'قد يستخدم التطبيق التخزين لحفظ الملفات والمحتوى الذي يختار المستخدم تحميله، مثل الصوتيات أو المواد المتاحة داخل التطبيق.';

  @override
  String get settingsDataSafetySharingTitle => 'المشاركة';

  @override
  String get settingsDataSafetySharingBody =>
      'لا تتم مشاركة بياناتك الشخصية مع أطراف خارجية للبيع أو التسويق. أي مشاركة تتم تكون ضمن خدمات تشغيل ضرورية أو إجراء يبدأه المستخدم.';

  @override
  String get settingsAboutAppBody =>
      'تطبيق قرآني وعبادي يساعدك على الصلاة، الذكر، تلاوة القرآن، والاستمرار على ورد يومي بهدوء وبأسلوب قريب من المستخدم.';

  @override
  String get settingsAboutMissionTitle => 'رسالتنا';

  @override
  String get settingsAboutMissionBody =>
      'أن يكون التطبيق رفيقًا خفيفًا يعين المستخدم على الطاعة دون إزعاج، ويجمع الأدوات اليومية المهمة مثل المصحف، الأذكار، مواقيت الصلاة، التنبيهات، والميزات المساعدة للأسرة.';

  @override
  String get settingsAboutOfferTitle => 'ما نقدمه';

  @override
  String get settingsAboutOfferBody =>
      'مصحف، أذكار، مواقيت صلاة، قبلة، ورد يومي، تطبيقات مصغرة، صحبة الفجر، المسلم الصغير، خدمات للمسافر، وتنبيهات قابلة للتخصيص حسب حاجة المستخدم.';

  @override
  String get settingsDeveloperHeroBody =>
      'مهندس برمجيات Full Stack وMobile بخبرة تتجاوز 7 سنوات، متخصص في Flutter وLaravel وNext.js وبناء تطبيقات إنتاجية للويب والجوال.';

  @override
  String get settingsDeveloperBioTitle => 'نبذة مختصرة';

  @override
  String get settingsDeveloperBioBody =>
      'يعمل معتصم الهلالي على بناء تطبيقات ومنصات رقمية تخدم مستخدمين حقيقيين، مع اهتمام خاص بتطبيقات الجوال، الأنظمة الخلفية، واجهات الاستخدام، ومنصات Fintech وSaaS.';

  @override
  String get settingsDeveloperFieldsTitle => 'مجالات العمل';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter، Laravel، Next.js، React، API Development، تطبيقات الجوال، تطبيقات الويب، حلول Fintech، ومنصات SaaS.';

  @override
  String get settingsDeveloperContactTitle => 'طرق التواصل';

  @override
  String get settingsContactWebsite => 'الموقع';

  @override
  String get settingsContactEmail => 'البريد';

  @override
  String get settingsAppLinksTitle => 'روابط التطبيق';

  @override
  String get notifSettingsLabelAppNotifications => 'اشعارات التطبيق';

  @override
  String get notifSettingsLabelAllAthan => 'إشعارات جميع الأذان';

  @override
  String notifSettingsAthanOf(String prayer) {
    return 'أذان $prayer';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'قيام الليل';

  @override
  String get notifSettingsLabelThikrMorning => 'أذكار الصباح';

  @override
  String get notifSettingsLabelThikrEvening => 'أذكار المساء';

  @override
  String get notifSettingsLabelThikrWakeUp => 'أذكار الاستيقاظ';

  @override
  String get notifSettingsLabelThikrSleep => 'أذكار النوم';

  @override
  String get notifSettingsLabelSalawat => 'الصلاة على محمد ﷺ';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'الأذكار الصوتية العشوائية';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'الأذكار العائمة والتنبيهات البديلة';

  @override
  String get notifSettingsLabelDailyQuranWird => 'الورد القرآني اليومي';

  @override
  String get notifSettingsLabelReadSurahMulk => 'قراءة سورة الملك';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'قراءة سورة محددة';

  @override
  String get notifSettingsLabelReadSurahKahf => 'قراءة سورة الكهف';

  @override
  String get notifSettingsLabelFasting => 'تذكير بالصيام';

  @override
  String get notifSettingsLabelFastingMonday => 'صيام الاثنين';

  @override
  String get notifSettingsLabelFastingThursday => 'صيام الخميس';

  @override
  String get notifSettingsLabelBestDua =>
      'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم';

  @override
  String get notifSettingsLabelWirdMorning => 'ورد الصباح';

  @override
  String get notifSettingsLabelWirdEvening => 'ورد المساء';

  @override
  String get notifSettingsLabelWirdNight => 'ورد ما قبل النوم';

  @override
  String get notifSettingsLabelWirdSummary => 'ملخص الورد اليومي';

  @override
  String get notifSettingsLabelYoungMuslim => 'تذكير المسلم الصغير';

  @override
  String get notifSettingsLabelQuranPlan => 'تذكير خطط القرآن';

  @override
  String get notifSettingsLabelGeneral => 'إشعارات التطبيق العامة';

  @override
  String get notifSettingsTitleRandomThikr => 'ذكر عشوائي';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'الأذكار العائمة';

  @override
  String get notifSettingsTitlePrayerAthan => 'أذان الصلاة';

  @override
  String get notifSettingsBodyThikrMorning => 'لا تنس أذكار الصباح!';

  @override
  String get notifSettingsBodyThikrEvening => 'لا تنس أذكار المساء!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'حان وقت قيام الليل، استغل الثلث الأخير من الليل.';

  @override
  String get notifSettingsBodySalawat => 'صلِّ على النبي ﷺ تسعد في يومك.';

  @override
  String get notifSettingsBodyRememberAllah => 'اذكر الله يذكرك!';

  @override
  String get notifSettingsBodyReadQuran => 'خصص وقتًا لوردك القرآني اليومي.';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'لا تنس قراءة سورة الملك الليلة.';

  @override
  String get notifSettingsBodyThikrSleep => 'اذكار النوم قبل أن تغفو.';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'ابدأ يومك بذكر الله بعد الاستيقاظ.';

  @override
  String get notifSettingsBodyReadSurah =>
      'لا تنس قراءة السورة التي اخترتها اليوم.';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'لا تنس قراءة سورة الكهف في يوم الجمعة.';

  @override
  String get notifSettingsBodyFasting => 'تذكير بصيام التطوع.';

  @override
  String get notifSettingsBodyFastingMonday => 'تذكير بصيام يوم الاثنين.';

  @override
  String get notifSettingsBodyFastingThursday => 'تذكير بصيام يوم الخميس.';

  @override
  String get notifSettingsBodyAthanTime => 'حان الآن موعد الأذان.';

  @override
  String get notifSettingsBodyWirdMorning => 'ابدأ نهارك بزادك التعبدي.';

  @override
  String get notifSettingsBodyWirdEvening => 'جدد صلتك بالله في زاد المساء.';

  @override
  String get notifSettingsBodyWirdNight => 'اختم يومك بالذكر والدعاء.';

  @override
  String get notifSettingsBodyWirdSummary => 'راجع زادك التعبدي اليوم.';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'تذكير للعودة إلى محتوى المسلم الصغير.';

  @override
  String get notifSettingsBodyQuranPlan =>
      'لا تنس جلسة اليوم من خطتك القرآنية.';

  @override
  String get notifSettingsBodyGeneral =>
      'إشعارات وتنبيهات عامة من تطبيق طمأنينة.';

  @override
  String get notifSettingsAllPrayers => 'كل الصلوات';

  @override
  String get notifSettingsSalawatShort => 'الصلاة على محمد';

  @override
  String get notifSettingsQuranWirdShort => 'الورد القرآني';

  @override
  String get notifSettingsGroupGeneral => 'عام';

  @override
  String get notifSettingsGroupAthan => 'الأذان';

  @override
  String get notifSettingsGroupDailyWird => 'الورد اليومي';

  @override
  String get notifSettingsGroupAdhkar => 'الأذكار';

  @override
  String get notifSettingsGroupQuran => 'القرآن';

  @override
  String get notifSettingsGroupAppSections => 'أقسام التطبيق';

  @override
  String get notifSettingsGroupNightAndWaking => 'الليل واليقظة';

  @override
  String get notifSettingsGroupFasting => 'الصيام';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'أذكار متكررة';

  @override
  String get notifSettingsGroupSystem => 'النظام';

  @override
  String get notifSettingsMasterTitle => 'كل إشعارات التطبيق';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'الإشعارات مفعّلة، وتستطيع ضبط كل نوع أدناه';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'كل الإشعارات موقوفة حتى تفعّل هذا المفتاح';

  @override
  String get notifSettingsSystemTitle => 'إشعارات النظام';

  @override
  String get notifSettingsSystemSubtitle =>
      'استعرض الإشعارات المجدولة والمفعّلة على جهازك';

  @override
  String get notifSettingsStatusStopped => 'موقوف';

  @override
  String get notifSettingsStatusEnabled => 'مفعّل';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'يومياً · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'كل ساعة عند الدقيقة $minute';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'كل $count دقيقة',
      many: 'كل $count دقيقة',
      few: 'كل $count دقائق',
      two: 'كل دقيقتين',
      one: 'كل دقيقة',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => '، ';

  @override
  String get notifSettingsNoDaysSelected => 'بدون أيام محددة';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'أسبوعياً ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جدولة مخصصة · $count توقيت',
      many: 'جدولة مخصصة · $count توقيتًا',
      few: 'جدولة مخصصة · $count توقيتات',
      two: 'جدولة مخصصة · توقيتان',
      one: 'جدولة مخصصة · توقيت واحد',
      zero: 'جدولة مخصصة · بدون توقيت',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'مواعيد التنبيه';

  @override
  String get notifSettingsEditScheduleTitle => 'تعديل الجدولة';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'غيّر نوع التكرار ووقت التنبيه';

  @override
  String get notifSettingsExtraSchedulesTitle => 'إدارة مواعيد إضافية';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'أضف أكثر من موعد لهذا الإشعار';

  @override
  String get notifScheduleBodyAllAthan =>
      'سيتكرر تنبيه جميع الأذان في أوقاتها المحددة.';

  @override
  String get notifScheduleBodyAthanFajr =>
      'حان الآن وقت أذان الفجر، بادر بالصلاة.';

  @override
  String get notifScheduleBodyAthanDhuhr => 'حان الآن وقت أذان الظهر.';

  @override
  String get notifScheduleBodyAthanAsr => 'حان الآن وقت أذان العصر.';

  @override
  String get notifScheduleBodyAthanMaghrib => 'حان الآن وقت أذان المغرب.';

  @override
  String get notifScheduleBodyAthanIsha => 'حان الآن وقت أذان العشاء.';

  @override
  String get notifScheduleBodyMiddleNight =>
      'حان وقت قيام الليل! قم وناجِ الرحمن.';

  @override
  String get notifScheduleBodyThikrMorning => 'لا تنسَ أذكار الصباح!';

  @override
  String get notifScheduleBodyThikrEvening => 'لا تنسَ أذكار المساء!';

  @override
  String get notifScheduleBodySalawat =>
      'صَلِّ على النبي الكريم ﷺ، تُكتب لك عشرُ حسنات.';

  @override
  String get notifScheduleBodyReadQuran => 'لا تنسَ وردك من القرآن اليوم.';

  @override
  String get notifScheduleBodyReadSurahMulk => 'اقرأ سورة الملك قبل النوم.';

  @override
  String get notifScheduleBodyThikrSleep => 'اقرأ أذكار النوم قبل أن تنام.';

  @override
  String get notifScheduleBodyThikrWakeUp => 'ابدأ يومك بأذكار الاستيقاظ.';

  @override
  String get notifScheduleBodyReadSurah =>
      'لا تنسَ قراءة السورة المحددة لهذا اليوم.';

  @override
  String get notifScheduleBodyReadSurahKahf => 'اقرأ سورة الكهف يوم الجمعة.';

  @override
  String get notifScheduleBodyFasting =>
      'صيام النوافل له أجر عظيم، لا تفوت الفرصة.';

  @override
  String get notifScheduleTitleRandomThikr => 'مخصصة من أذكار عشوائية';

  @override
  String get notifScheduleValidateTime => 'حدد وقت التنبيه أولاً';

  @override
  String get notifScheduleValidateMinute => 'حدد الدقيقة من كل ساعة';

  @override
  String get notifScheduleValidateWeekday =>
      'حدد يوماً واحداً على الأقل من الأسبوع';

  @override
  String get notifScheduleValidateInterval => 'أدخل عدد الدقائق (أكبر من صفر)';

  @override
  String get notifScheduleValidateDate => 'أضف تاريخاً واحداً على الأقل';

  @override
  String get notifScheduleDetails => 'التفاصيل';

  @override
  String get notifScheduleMinuteOfHourTitle => 'الدقيقة من كل ساعة';

  @override
  String get notifScheduleMinuteOfHourSubtitle => 'رقم بين 0 و 59';

  @override
  String get notifScheduleMinuteUnit => 'دقيقة';

  @override
  String get notifScheduleRepeatTitle => 'التكرار';

  @override
  String get notifScheduleRepeatSubtitle => 'المدة بين كل تنبيه والذي يليه';

  @override
  String get notifScheduleCustomTime => 'موعد مخصص';

  @override
  String get notifScheduleDeleteTime => 'حذف الموعد';

  @override
  String get notifScheduleNoTimesYet => 'لم تضف أي موعد بعد';

  @override
  String get notifScheduleAddTime => 'إضافة موعد';

  @override
  String get notifScheduleSaveSchedule => 'حفظ الجدولة';

  @override
  String get notifScheduleAddNewTitle => 'إضافة موعد جديد';

  @override
  String get notifScheduleEditTitle => 'تعديل الموعد';

  @override
  String get notifScheduleOptionalLabel => 'وصف اختياري';

  @override
  String get notifScheduleAddConfirm => 'إضافة الموعد';

  @override
  String get notifScheduleSaveEdit => 'حفظ التعديل';

  @override
  String get notifScheduleTypeDaily => 'يومي';

  @override
  String get notifScheduleTypeHourly => 'كل ساعة';

  @override
  String get notifScheduleTypeEveryNMinutes => 'كل عدة دقائق';

  @override
  String get notifScheduleTypeWeekly => 'أسبوعي';

  @override
  String get notifScheduleTypeCustomDates => 'تواريخ مخصصة';

  @override
  String get notifScheduleTypeDailyDesc => 'يتكرر كل يوم في الوقت نفسه';

  @override
  String get notifScheduleTypeHourlyDesc => 'يتكرر كل ساعة عند دقيقة محددة';

  @override
  String get notifScheduleTypeEveryNMinutesDesc => 'يتكرر كل فترة زمنية تحددها';

  @override
  String get notifScheduleTypeWeeklyDesc => 'يتكرر في أيام محددة من الأسبوع';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'يظهر في تواريخ وأوقات تختارها';

  @override
  String get notifScheduleTypeTitle => 'نوع الجدولة';

  @override
  String get notifScheduleTimeTitle => 'وقت التنبيه';

  @override
  String get notifScheduleTimeSubtitle => 'اضغط لاختيار الساعة والدقيقة';

  @override
  String get notifScheduleLabelHint => 'أضف وصفاً قصيراً لهذا الموعد';

  @override
  String notifScheduleRowDaily(String time) {
    return 'كل يوم · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'بدون أيام';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موعد مخصص',
      many: '$count موعدًا مخصصًا',
      few: '$count مواعيد مخصصة',
      two: 'موعدان مخصصان',
      one: 'موعد مخصص واحد',
      zero: 'لا مواعيد مخصصة',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'اثنين';

  @override
  String get notifScheduleDayShort2 => 'ثلاثاء';

  @override
  String get notifScheduleDayShort3 => 'أربعاء';

  @override
  String get notifScheduleDayShort4 => 'خميس';

  @override
  String get notifScheduleDayShort5 => 'جمعة';

  @override
  String get notifScheduleDayShort6 => 'سبت';

  @override
  String get notifScheduleDayShort7 => 'أحد';

  @override
  String get notifScheduleAllDays => 'كل الأيام';

  @override
  String get notifScheduleWorkDays => 'أيام العمل';

  @override
  String get notifScheduleWeekend => 'العطلة';

  @override
  String get notifScheduleClear => 'مسح';

  @override
  String get notifScheduleStatTotal => 'الإجمالي';

  @override
  String get notifScheduleStatEnabled => 'مفعّل';

  @override
  String get notifScheduleStatStopped => 'موقوف';

  @override
  String get notifScheduleUnexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get notifScheduleSaved => 'تم الحفظ';

  @override
  String get notifScheduleScreenTitle => 'مواعيد الإشعار';

  @override
  String get notifScheduleListTitle => 'المواعيد';

  @override
  String get notifScheduleEmpty =>
      'لا توجد مواعيد بعد — أضف موعداً من زر «إضافة موعد».';

  @override
  String get notifScheduleDeleteTitle => 'حذف موعد';

  @override
  String get notifScheduleDeleteMessage =>
      'هل أنت متأكد من حذف هذا الموعد؟\nسيتم إلغاء جميع الإشعارات المرتبطة به.';

  @override
  String get notifScheduleSaving => 'جارٍ الحفظ...';

  @override
  String get notifScheduleLoading => 'جارٍ تحميل المواعيد...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'فشل في تحميل المواعيد: $error';
  }

  @override
  String get notifScheduleAdded => 'تم إضافة الموعد بنجاح';

  @override
  String notifScheduleAddFailed(String error) {
    return 'فشل في إضافة الموعد: $error';
  }

  @override
  String get notifScheduleUpdated => 'تم تحديث الموعد بنجاح';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'فشل في تحديث الموعد: $error';
  }

  @override
  String get notifScheduleDeleted => 'تم حذف الموعد بنجاح';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'فشل في حذف الموعد: $error';
  }

  @override
  String get notifScheduleActivated => 'تم تفعيل الموعد';

  @override
  String get notifScheduleDeactivated => 'تم إلغاء تفعيل الموعد';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'فشل في تغيير حالة الموعد: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'مجدولة';

  @override
  String get notifSettingsNoScheduled => 'لا توجد إشعارات مجدولة حالياً';

  @override
  String get notifSettingsShownNowGroup => 'ظاهرة الآن';

  @override
  String get notifSettingsNoShown => 'لا توجد إشعارات ظاهرة في شريط الإشعارات';

  @override
  String get notifSettingsUntitled => 'إشعار بلا عنوان';

  @override
  String get notifSettingsDismiss => 'إخفاء الإشعار';

  @override
  String get notifSettingsCancelNotification => 'إلغاء الإشعار';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return 'حان الآن أذان $prayer';
  }

  @override
  String get downloadTitle => 'التنزيلات';

  @override
  String get downloadEmptyAll => 'لا توجد تنزيلات بعد، أضف تنزيلاً للبدء.';

  @override
  String get downloadEmptyActive => 'لا توجد تنزيلات نشطة';

  @override
  String get downloadEmptyCompleted => 'لا توجد تنزيلات مكتملة';

  @override
  String get downloadEmptyPaused => 'لا توجد تنزيلات متوقّفة';

  @override
  String get downloadEmptyFailed => 'لا توجد تنزيلات فاشلة';

  @override
  String get downloadCancelAll => 'إلغاء الكل';

  @override
  String get downloadCancelAllConfirm =>
      'هل أنت متأكد من إلغاء جميع التنزيلات النشطة؟';

  @override
  String get downloadAdd => 'إضافة تنزيل';

  @override
  String get downloadFilterAll => 'الكل';

  @override
  String get downloadStatusActive => 'نشط';

  @override
  String get downloadStatusCompleted => 'مكتمل';

  @override
  String get downloadStatusPaused => 'متوقّف';

  @override
  String get downloadStatusFailed => 'فشل';

  @override
  String get downloadStarted => 'بدأ التحميل';

  @override
  String get downloadAddNewTitle => 'إضافة تنزيل جديد';

  @override
  String get downloadUrlLabel => 'رابط الملفّ';

  @override
  String get downloadUrlRequired => 'الرجاء إدخال رابط التحميل';

  @override
  String get downloadUrlInvalid => 'الرجاء إدخال رابط صحيح';

  @override
  String get downloadFileNameLabel => 'اسم الملفّ';

  @override
  String get downloadOptional => 'اختياري';

  @override
  String get downloadPublicStorageTitle => 'التخزين العام';

  @override
  String get downloadPublicStorageSubtitle => 'حفظ في مجلّد التنزيلات';

  @override
  String get downloadAllowCellularTitle => 'السماح بالبيانات الخلوية';

  @override
  String get downloadAllowCellularSubtitle => 'التحميل عبر بيانات الجوّال';

  @override
  String get downloadStart => 'بدء التحميل';

  @override
  String get downloadPause => 'إيقاف مؤقّت';

  @override
  String get downloadResume => 'متابعة';

  @override
  String get downloadOpenFile => 'فتح الملفّ';

  @override
  String get downloadRemoveFromList => 'حذف من القائمة';

  @override
  String get downloadDeleteFile => 'حذف الملفّ';

  @override
  String get downloadTotal => 'الإجمالي';

  @override
  String get downloadInProgressNow => 'يجري تنزيله الآن';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'و$count غيرها',
      many: 'و$count غيرها',
      few: 'و$count غيرها',
      two: 'وتنزيلان آخران',
      one: 'وتنزيل آخر',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'الصلاة القادمة';

  @override
  String get widgetLabelDailyAyah => 'آية اليوم';

  @override
  String get widgetLabelOpenApp => 'افتح طمأنينة';

  @override
  String get widgetLabelSetLocation => 'حدّد موقعك في التطبيق';

  @override
  String get widgetLabelRefreshNeeded => 'لتحديث المواقيت';

  @override
  String widgetLabelNextIn(String prayer) {
    return '$prayer بعد';
  }

  @override
  String get dailyWirdTitle => 'زاد اليوم والليلة';

  @override
  String get dailyWirdSettingsTooltip => 'إعدادات الزاد';

  @override
  String get dailyWirdUnexpectedError => 'حدث خطأ غير متوقع.';

  @override
  String get dailyWirdRemindersHeader => 'التذكيرات';

  @override
  String get dailyWirdReminderSleepLabel => 'أذكار النوم';

  @override
  String get dailyWirdProgramHeader => 'البرنامج';

  @override
  String get dailyWirdSaveSetup => 'حفظ التهيئة';

  @override
  String get dailyWirdSetupFailed => 'تعذر إعداد الزاد التعبدي.';

  @override
  String get dailyWirdItemNotFound => 'تعذر العثور على عنصر الزاد التعبدي.';

  @override
  String get dailyWirdTodayTasksHeader => 'أعمال اليوم';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المداومة $count يوم',
      many: 'المداومة $count يومًا',
      few: 'المداومة $count أيام',
      two: 'المداومة يومان',
      one: 'المداومة يوم واحد',
      zero: 'المداومة 0 يوم',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'مواظبة الأسبوع $percent%';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'اختر زادك التعبدي';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'ابدأ ببرنامج جاهز ثم خصّصه كما يناسبك';

  @override
  String get dailyWirdItemOptions => 'خيارات العمل';

  @override
  String get dailyWirdEditTargetCount => 'تعديل العدد المقصود';

  @override
  String get dailyWirdStartOver => 'البدء من جديد';

  @override
  String get dailyWirdMoveUp => 'تقديم في الترتيب';

  @override
  String get dailyWirdMoveDown => 'تأخير في الترتيب';

  @override
  String get dailyWirdHideItem => 'إخفاء من الزاد';

  @override
  String get dailyWirdCountHint => 'مثال: ٥٠ مرة';

  @override
  String get dailyWirdTimeMorning => 'صباح';

  @override
  String get dailyWirdTimeEvening => 'مساء';

  @override
  String get dailyWirdTimeNight => 'ليل';

  @override
  String get dailyWirdTimeAny => 'أي وقت';

  @override
  String get dailyWirdTimeMorningLong => 'وقت الصباح';

  @override
  String get dailyWirdTimeEveningLong => 'وقت المساء';

  @override
  String get dailyWirdTimeNightLong => 'قبل النوم';

  @override
  String get dailyWirdTimeAnyLong => 'في أي وقت';

  @override
  String get dailyWirdTypeDhikrSet => 'أذكار';

  @override
  String get dailyWirdTypeCountedDhikr => 'ذكر بعدد';

  @override
  String get dailyWirdTypeQuran => 'ورد قرآن';

  @override
  String get dailyWirdTypeDua => 'دعاء';

  @override
  String get dailyWirdTypeSurah => 'سورة';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$done من $total';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return 'أتممت $done من $total$unit';
  }

  @override
  String get dailyWirdItemDone => 'أُنجز';

  @override
  String get dailyWirdMarkComplete => 'إتمام';

  @override
  String get dailyWirdCountOnce => 'احتساب مرّة';

  @override
  String get dailyWirdCompleteThis => 'إتمام هذا العمل';

  @override
  String get dailyWirdUncomplete => 'إلغاء الإتمام';

  @override
  String get dailyWirdReminderMorningTitle => 'زاد الصباح';

  @override
  String get dailyWirdReminderMorningBody =>
      'ابدأ نهارك بذكر الله وتلاوة كتابه والدعاء.';

  @override
  String get dailyWirdReminderEveningTitle => 'زاد المساء';

  @override
  String get dailyWirdReminderEveningBody =>
      'جدد صلتك بالله، وأتم ما تيسر من زاد المساء.';

  @override
  String get dailyWirdReminderNightTitle => 'زاد ما قبل النوم';

  @override
  String get dailyWirdReminderNightBody =>
      'اختم يومك بالذكر والدعاء وما بقي من زادك التعبدي.';

  @override
  String get dailyWirdReminderSummaryTitle => 'محاسبة آخر اليوم';

  @override
  String get dailyWirdReminderSummaryBody =>
      'راجع زادك التعبدي اليوم، وانظر ما أتممت منه.';

  @override
  String get wirdMorningAdhkar => 'أذكار الصباح';

  @override
  String get wirdEveningAdhkar => 'أذكار المساء';

  @override
  String get wirdMorningTitle => 'الورد الصباحي';

  @override
  String get wirdEveningTitle => 'الورد المسائي';

  @override
  String get wirdSearchHint => 'بحث عن ذكر';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'الذكر $current من $total';
  }

  @override
  String get wirdPrevious => 'السابق';

  @override
  String get wirdNext => 'التالي';

  @override
  String get wirdShowSingle => 'عرض ذكرًا واحدًا';

  @override
  String get wirdShowList => 'عرض الأذكار قائمةً';

  @override
  String get wirdTypeMorningOnly => 'صباح فقط';

  @override
  String get wirdTypeEveningOnly => 'مساء فقط';

  @override
  String get wirdTypeBoth => 'صباح ومساء';

  @override
  String get wirdNoAudio => 'لا يوجد ملف صوتي';

  @override
  String get wirdPause => 'إيقاف مؤقت';

  @override
  String get wirdReplay => 'إعادة التشغيل';

  @override
  String get wirdPlayAudio => 'تشغيل الصوت';

  @override
  String wirdRemaining(int remaining, int total) {
    return 'بقي $remaining من $total';
  }

  @override
  String get wirdCompleted => 'أتممتها';

  @override
  String get wirdResetCount => 'إعادة العدّ';

  @override
  String get wirdCopyDhikr => 'نسخ الذكر';

  @override
  String get wirdSource => 'المصدر';

  @override
  String get wirdShowDetails => 'عرض التفاصيل';

  @override
  String get wirdHideDetails => 'إخفاء التفاصيل';

  @override
  String get wirdVirtue => 'الفضل';

  @override
  String get wirdHadithText => 'نص الحديث';

  @override
  String get wirdWordExplanations => 'شرح مفردات مختارة';

  @override
  String get wirdReadOnce => 'قرأت مرة';

  @override
  String get wirdPlayAll => 'تشغيل الورد كاملًا';

  @override
  String get wirdPreparingAudio => 'تهيئة الصوت';

  @override
  String get wirdReplayAll => 'إعادة تشغيل الورد';

  @override
  String get wirdPlayAllFinished => 'تم الانتهاء من تشغيل جميع الأذكار.';

  @override
  String get wirdNowPlaying => 'يُتلى الآن';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'التكرار $current من $total';
  }

  @override
  String get thikrLibraryTitle => 'مكتبة الأذكار';

  @override
  String get thikrGroupDaily => 'أذكار يومك';

  @override
  String get thikrMorningSubtitle => 'وردك بعد الفجر إلى ارتفاع النهار';

  @override
  String get thikrEveningSubtitle => 'وردك بعد العصر إلى الليل';

  @override
  String get thikrSleepTitle => 'أذكار النوم والأحلام';

  @override
  String get thikrSleepSubtitle => 'ما تقوله قبل النوم وعند الفزع منه';

  @override
  String get thikrPrayerJumuahTitle => 'أذكار الصلاة والجمعة';

  @override
  String get thikrPrayerJumuahSubtitle =>
      'أذكار الأذان ودبر الصلاة ويوم الجمعة';

  @override
  String get thikrGroupDuas => 'أدعية مأثورة';

  @override
  String get thikrQuranicDuasTitle => 'الأدعية القرآنية';

  @override
  String get thikrQuranicDuasSubtitle => 'دعاء الأنبياء كما جاء في كتاب الله';

  @override
  String get thikrComprehensiveDuasTitle => 'أدعية جامعة';

  @override
  String get thikrComprehensiveDuasSubtitle => 'دعوات تجمع خير الدنيا والآخرة';

  @override
  String get thikrHajjTitle => 'أدعية الحج والعمرة';

  @override
  String get thikrHajjSubtitle => 'دعاء الإحرام والطواف والسعي والمشاعر';

  @override
  String get thikrFuneralTitle => 'أدعية للميت والجنازة';

  @override
  String get thikrFuneralSubtitle => 'ما يُقال في الصلاة على الميت وعند القبر';

  @override
  String get thikrGroupTools => 'أدواتك';

  @override
  String get thikrTasbeehTitle => 'التسبيح';

  @override
  String get thikrTasbeehSubtitle => 'عدّاد يحصي تسبيحك ويحفظ حصيلة يومك';

  @override
  String get thikrMyDuasSubtitle => 'أدعيتك التي أضفتها بنفسك في مكان واحد';

  @override
  String get thikrSliderSubtitle => 'وردُ هذا الوقت، افتحه الآن';

  @override
  String get afterPrayerTitle => 'أذكار بعد الصلاة';

  @override
  String get afterPrayerSubtitle => 'أذكار ما بعد الصلاة';

  @override
  String get afterPrayerSearchHint => 'بحث عن أذكار';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'ذكر بعد الصلاة $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'عدد التكرار: $count';
  }

  @override
  String afterPrayerVirtueLine(String virtue) {
    return 'الفضل: $virtue';
  }

  @override
  String get afterPrayerRepeatLabel => 'التكرار';

  @override
  String get afterPrayerVirtueLabel => 'الفضل';

  @override
  String get afterPrayerMentioned => 'مذكور';

  @override
  String get afterPrayerNotMentioned => 'غير مذكور';

  @override
  String get afterPrayerTextSection => 'نص الذكر';

  @override
  String get afterPrayerVirtueSection => 'فضل الذكر';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      many: '$count مرة',
      few: '$count مرات',
      two: 'مرتان',
      one: 'مرة',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'لا توجد نتائج مطابقة';

  @override
  String get afterPrayerShowAll => 'عرض الأذكار كلها';

  @override
  String get myDuasTitle => 'أدعيتي';

  @override
  String get myDuasActionFailed => 'تعذر تنفيذ العملية.';

  @override
  String get myDuasEmptyCustomTitle => 'لا توجد أدعية مضافة';

  @override
  String get myDuasEmptyCustomMessage =>
      'هذا القسم يعرض الأدعية التي أضفتها أنت فقط.';

  @override
  String get myDuasEmptyTitle => 'لا توجد أدعية بعد';

  @override
  String get myDuasEmptyMessage => 'أضف دعاءك الأول وسيظهر هنا مباشرة.';

  @override
  String get myDuasAddNew => 'إضافة دعاء جديد';

  @override
  String get myDuasAdd => 'إضافة دعاء';

  @override
  String get myDuasAddSubtitle => 'اكتب الدعاء ليظهر ضمن أدعيتك الخاصة.';

  @override
  String get myDuasEditTitle => 'تعديل الدعاء';

  @override
  String get myDuasEditSubtitle =>
      'يمكنك تعديل النص أو الوصف وحفظ التغييرات مباشرة.';

  @override
  String get myDuasCountLabel => 'عدد الأدعية';

  @override
  String get myDuasTodayLabel => 'ترديد اليوم';

  @override
  String get myDuasOptions => 'خيارات الدعاء';

  @override
  String get myDuasResetToday => 'تصفير عداد اليوم';

  @override
  String get ruqyahTitle => 'الرقية الشرعية';

  @override
  String get ruqyahSearchHint => 'بحث عن رقية';

  @override
  String get ruqyahDefaultReference => 'القرآن الكريم';

  @override
  String get ruqyahUnspecified => 'غير محدد';

  @override
  String ruqyahRepeatLine(String count) {
    return 'التكرار: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'المرجع: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'الوصف: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'الرقية $number';
  }

  @override
  String get ruqyahTextSection => 'نص الرقية';

  @override
  String get ruqyahDescriptionSection => 'الوصف';

  @override
  String get ruqyahNoResultsTitle => 'لا توجد نتائج';

  @override
  String get ruqyahNoResultsMessage => 'لم نجد رقية تطابق بحثك.';

  @override
  String get ruqyahShowAll => 'عرض الرقى كلها';

  @override
  String get radioTitle => 'الإذاعة';

  @override
  String get radioKindReciters => 'قرّاء';

  @override
  String get radioKindPrograms => 'برامج وتلاوات';

  @override
  String get radioLoadFailed => 'تعذّر تحميل الإذاعات حاليًا.';

  @override
  String get radioPlayFailed => 'تعذّر تشغيل الإذاعة الآن.';

  @override
  String get radioToggleFailed => 'تعذّر تغيير حالة التشغيل.';

  @override
  String get radioStopFailed => 'تعذّر إيقاف الإذاعة.';

  @override
  String get radioNoMatch => 'لا توجد محطة بهذا الاسم.';

  @override
  String get radioSearchHint => 'ابحث عن قارئ أو برنامج';

  @override
  String get radioFavouritesHint =>
      'اضغط مطوّلًا على أي محطة لإضافتها إلى المفضّلة.';

  @override
  String get radioAddFavourite => 'إضافة إلى المفضّلة';

  @override
  String get radioRemoveFavourite => 'إزالة من المفضّلة';

  @override
  String radioAddedToFavourites(String station) {
    return 'أُضيفت $station إلى المفضّلة';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return 'أُزيلت $station من المفضّلة';
  }

  @override
  String get radioSleepTimer => 'مؤقّت النوم';

  @override
  String get radioSleepTimerDescription =>
      'يتوقّف البثّ وحده بعد المدّة المختارة.';

  @override
  String radioStopsIn(String time) {
    return 'يتوقّف بعد $time';
  }

  @override
  String get radioCancelTimer => 'إلغاء المؤقّت';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقيقة',
      many: '$count دقيقة',
      few: '$count دقائق',
      two: 'دقيقتان',
      one: 'دقيقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'إيقاف البثّ';

  @override
  String get radioTuning => 'جارٍ الالتقاط…';

  @override
  String get radioLive => 'بثّ مباشر';

  @override
  String get radioPaused => 'متوقّف مؤقّتًا';

  @override
  String get radioTapToPlay => 'اضغط للتشغيل';

  @override
  String get radioPause => 'إيقاف مؤقّت';

  @override
  String get radioPlay => 'تشغيل';
}
