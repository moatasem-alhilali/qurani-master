// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class L10nFa extends L10n {
  L10nFa([String locale = 'fa']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'اذکار شناور';

  @override
  String get floatingAdhkarSourceBuiltIn => 'پیش‌فرض';

  @override
  String get floatingAdhkarSourceCustom => 'سفارشی';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'اذکار شخصی من';

  @override
  String get floatingAdhkarSourceAppLibrary => 'کتابخانهٔ برنامه';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'ذکر پیش‌فرض';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'ذکر تصادفی';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'اذکار تصادفی';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'اذکار تصادفی شناور';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'سرویس اذکار شناور در پس‌زمینه فعال است';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'این قابلیت در این پلتفرم در دسترس نیست.';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'برای فعال‌کردن یادآورهای ذکر در iPhone باید اعلان‌ها را مجاز کنید.';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'ابتدا باید مجوز «نمایش روی برنامه‌های دیگر» را بدهید.';

  @override
  String get floatingAdhkarErrorNoSource =>
      'دست‌کم یک منبع برای اذکار شناور فعال کنید.';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'برای فعال‌کردن یادآورهای iPhone مجوز اعلان لازم است.';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'برای فعال‌کردن پنجرهٔ شناور، این مجوز لازم است.';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'برای به‌روزرسانی ذکر پیش‌فرض، عنوان و متن لازم است.';

  @override
  String get floatingAdhkarErrorNotificationsDenied => 'مجوز اعلان داده نشد.';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'مجوز نمایش روی برنامه‌های دیگر داده نشد.';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'ابتدا قابلیت را فعال کنید، سپس از پیش‌نمایش زنده استفاده کنید.';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'برای نمایش ذکر در همین لحظه، مجوز اعلان لازم است.';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'برای نمایش ذکر شناور، این مجوز لازم است.';

  @override
  String get floatingAdhkarStatusUnsupported => 'پشتیبانی نمی‌شود';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'نیاز به مجوز';

  @override
  String get floatingAdhkarStatusMisconfigured => 'نیاز به تنظیم';

  @override
  String get floatingAdhkarStatusActive => 'در حال اجرا';

  @override
  String get floatingAdhkarStatusInactive => 'متوقف';

  @override
  String get floatingAdhkarManageTitle => 'مدیریت اذکار';

  @override
  String get floatingAdhkarManageSubtitle =>
      'انتخاب کنید کدام اذکار پیش‌فرض نمایش داده شوند و اذکار خود را اضافه کنید';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'افزودن ذکر شخصی';

  @override
  String get floatingAdhkarAddCustomTitle => 'افزودن ذکر سفارشی';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'پس از فعال‌سازی، در میان اذکار شناور قرار می‌گیرد.';

  @override
  String get floatingAdhkarEditTitle => 'ویرایش ذکر';

  @override
  String get floatingAdhkarEditSubtitle =>
      'متن را به‌روز کنید و تغییرات را فوراً ذخیره کنید.';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$enabled از $total';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle =>
      'هیچ ذکر پیش‌فرضی در دسترس نیست';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'کتابخانهٔ اذکار پیش‌فرض در برنامه پیدا نشد.';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'هنوز ذکر شخصی ندارید';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'ذکر یا دعای خود را اضافه کنید تا در چرخش تصادفی اذکار شناور قرار گیرد.';

  @override
  String get floatingAdhkarAddNewDhikr => 'افزودن ذکر جدید';

  @override
  String get floatingAdhkarItemOptions => 'گزینه‌های ذکر';

  @override
  String get floatingAdhkarTabBuiltIn => 'اذکار پیش‌فرض';

  @override
  String get floatingAdhkarTabCustom => 'اذکار شخصی';

  @override
  String get floatingAdhkarPreviewHeader => 'پیش‌نمایش ذکر';

  @override
  String get floatingAdhkarAdvancedTitle => 'تنظیمات پیشرفته';

  @override
  String get floatingAdhkarAdvancedSubtitle => 'دفعات نمایش، مدت ماندن و منابع';

  @override
  String get floatingAdhkarFrequencyTitle => 'دفعات نمایش';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'مدت ماندن ذکر';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثانیه',
      one: '$count ثانیه',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'منابع اذکار';

  @override
  String get floatingAdhkarAllowNotifications => 'اجازهٔ اعلان‌ها';

  @override
  String get floatingAdhkarGrantPermission => 'دادن مجوز لازم';

  @override
  String get floatingAdhkarPermissionHint =>
      'بدون آن، ذکر روی برنامه‌های دیگر نمایش داده نمی‌شود';

  @override
  String get floatingAdhkarSendNow => 'ارسال ذکر همین حالا';

  @override
  String get floatingAdhkarShowNow => 'نمایش ذکر همین حالا';

  @override
  String get floatingAdhkarPreviewReadyHint =>
      'ظاهر ذکر را همان‌طور که نمایش داده می‌شود امتحان کنید';

  @override
  String get floatingAdhkarPreviewDisabledHint =>
      'ابتدا سرویس را فعال کنید و مجوز را بدهید';

  @override
  String get floatingAdhkarIosReminders => 'یادآورهای iPhone';

  @override
  String get floatingAdhkarFloatingService => 'سرویس شناور';

  @override
  String get floatingAdhkarUnsupportedPlatform =>
      'در این پلتفرم پشتیبانی نمی‌شود';

  @override
  String get floatingAdhkarStatBuiltIn => 'پیش‌فرض';

  @override
  String get floatingAdhkarStatCustom => 'شخصی';

  @override
  String get floatingAdhkarSettingsTitleIos => 'تنظیمات یادآور اذکار';

  @override
  String get floatingAdhkarSettingsTitle => 'تنظیمات اذکار شناور';

  @override
  String get floatingAdhkarReminderTiming => 'زمان‌بندی یادآوری';

  @override
  String get floatingAdhkarAppearanceTiming => 'زمان‌بندی نمایش';

  @override
  String get floatingAdhkarReminderFrequency => 'دفعات تکرار یادآوری';

  @override
  String get floatingAdhkarAppearanceFrequency => 'دفعات تکرار نمایش';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle => 'منبع داخلی اصلی برنامه';

  @override
  String get floatingAdhkarCustomSourceSubtitle =>
      'اذکاری که خودتان اضافه کرده‌اید';

  @override
  String get floatingAdhkarMixSources => 'ترکیب منابع';

  @override
  String get floatingAdhkarMixSourcesOn => 'انتخاب از یک فهرست واحد';

  @override
  String get floatingAdhkarMixSourcesOff => 'نوبتی بین پیش‌فرض و سفارشی';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'پیش از ذخیره، دست‌کم یک منبع را فعال کنید.';

  @override
  String get floatingAdhkarMasterSwitch => 'فعال‌سازی کامل قابلیت';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'یادآورهای ذکر در iPhone زمان‌بندی می‌شوند';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'سرویس پس‌زمینه نمایش اذکار را آغاز می‌کند';

  @override
  String get floatingAdhkarSaveSettings => 'ذخیرهٔ تنظیمات';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count دقیقه',
      one: 'هر $count دقیقه',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'ترکیب پیش‌فرض و سفارشی';

  @override
  String get floatingAdhkarSourcesAlternating => 'نوبتی بین پیش‌فرض و سفارشی';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'فقط اذکار پیش‌فرض';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'فقط اذکار کاربر';

  @override
  String get floatingAdhkarSourcesNone => 'هیچ منبعی فعال نیست';

  @override
  String get sabihTitle => 'تسبیح';

  @override
  String get sabihBeadWalnut => 'گردو';

  @override
  String get sabihBeadOak => 'بلوط';

  @override
  String get sabihBeadEmerald => 'زمرد';

  @override
  String get sabihBeadOnyx => 'عقیق سیاه';

  @override
  String get sabihBeadAmber => 'کهربا';

  @override
  String get sabihBeadMahogany => 'ماهون';

  @override
  String get sabihBeadSage => 'زیتونی';

  @override
  String get sabihBeadGarnet => 'عقیق سرخ';

  @override
  String get sabihErrorRefreshList => 'به‌روزرسانی فهرست اذکار ممکن نشد.';

  @override
  String get sabihErrorLoad => 'بارگیری اذکار ممکن نشد.';

  @override
  String get sabihErrorRecord => 'ثبت ذکر ممکن نشد.';

  @override
  String get sabihErrorResetToday => 'صفرکردن شمارندهٔ امروز ممکن نشد.';

  @override
  String get sabihAnalyticsTitle => 'آمار';

  @override
  String get sabihTabOverview => 'نمای کلی';

  @override
  String get sabihTabDetails => 'جزئیات اذکار';

  @override
  String get sabihDhikrSettingsTooltip => 'تنظیمات ذکر';

  @override
  String get sabihAddCustomDhikr => 'افزودن ذکر سفارشی';

  @override
  String get sabihEmptyMessage => 'هیچ ذکری پیدا نشد';

  @override
  String get sabihAddFirst => 'اولین ذکر خود را اضافه کنید';

  @override
  String get sabihSaveChanges => 'ذخیرهٔ تغییرات';

  @override
  String get sabihAddDhikr => 'افزودن ذکر';

  @override
  String get sabihSaveFailed => 'ذخیرهٔ ذکر ممکن نشد.';

  @override
  String get sabihUpdatedSuccess => 'ذکر با موفقیت به‌روز شد.';

  @override
  String get sabihAddedSuccess => 'ذکر با موفقیت اضافه شد.';

  @override
  String get sabihEditDhikr => 'ویرایش ذکر';

  @override
  String get sabihFieldText => 'متن ذکر';

  @override
  String sabihExampleHint(String example) {
    return 'مثال: $example';
  }

  @override
  String get sabihTextRequired => 'لطفاً متن ذکر را وارد کنید';

  @override
  String get sabihTextTooShort => 'متن ذکر خیلی کوتاه است';

  @override
  String get sabihFieldVirtue => 'فضیلت یا توضیح کوتاه (اختیاری)';

  @override
  String get sabihPeriodToday => 'امروز';

  @override
  String get sabihPeriodWeek => 'هفته';

  @override
  String get sabihPeriodMonth => 'ماه';

  @override
  String get sabihPeriodYear => 'سال';

  @override
  String get sabihPeriodAll => 'همه';

  @override
  String get sabihThisWeek => 'این هفته';

  @override
  String get sabihThisMonth => 'این ماه';

  @override
  String get sabihAllTime => 'همهٔ زمان‌ها';

  @override
  String get sabihMostUsed => 'پرکاربردترین اذکار';

  @override
  String get sabihTotalCount => 'مجموع اذکار';

  @override
  String get sabihNoDataYet => 'هنوز داده‌ای نیست';

  @override
  String get sabihResetTodayCounter => 'بازنشانی شمارندهٔ امروز';

  @override
  String get sabihEditThisDhikr => 'ویرایش این ذکر';

  @override
  String get sabihDeleteThisDhikr => 'حذف این ذکر';

  @override
  String get sabihCustomBadge => 'سفارشی';

  @override
  String get sabihNoCustomDhikr => 'ذکر سفارشی وجود ندارد';

  @override
  String get sabihSummaryTitle => 'خلاصهٔ ذکر';

  @override
  String get sabihTodayNotStarted => 'هنوز ذکر امروز را شروع نکرده‌اید';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'امروز $count بار ذکر گفتید',
      one: 'امروز $count بار ذکر گفتید',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'تسبیح';

  @override
  String sabihTargetReached(int target) {
    return 'به $target رسیدید';
  }

  @override
  String sabihTargetOf(int target) {
    return 'از $target';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'هدف $target';
  }

  @override
  String get sabihTapAnywhere => 'برای تسبیح، هر جای صفحه را لمس کنید';

  @override
  String get sabihCountSemantics => 'تعداد تسبیح';

  @override
  String get sabihInvalidNumber => 'یک عدد صحیح بزرگ‌تر از صفر وارد کنید';

  @override
  String get sabihSettingsTitle => 'تنظیمات تسبیح';

  @override
  String get sabihTargetSection => 'هدف ذکر';

  @override
  String get sabihTargetAutoHint =>
      'اگر تغییرش ندهید، خودکار بالا می‌رود: ۳۳، سپس ۹۹، سپس هر صد.';

  @override
  String get sabihFontSize => 'اندازهٔ قلم';

  @override
  String get sabihFontSizeGlyph => 'آ';

  @override
  String sabihPercent(int value) {
    return '$value٪';
  }

  @override
  String get sabihVibration => 'لرزش';

  @override
  String get sabihVibrationTitle => 'لرزش ملایم با هر تسبیح';

  @override
  String get sabihVibrationSubtitle => 'و لرزش واضح‌تر هنگام رسیدن به هدف';

  @override
  String get sabihBeadDesign => 'طرح تسبیح';

  @override
  String get sabihResetTodayCounterAction => 'بازنشانی شمارندهٔ امروز';

  @override
  String get anotherScreenGroupDaily => 'ورد روزانهٔ شما';

  @override
  String get anotherScreenGroupKnowledge => 'دانش و تلاوت';

  @override
  String get anotherScreenGroupTools => 'اذکار و ابزارها';

  @override
  String get anotherScreenDailyWird => 'توشهٔ شبانه‌روز';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'وردی منظم برای اذکار و تلاوت روزانهٔ شما';

  @override
  String get anotherScreenKhatmaPlans => 'برنامه‌های ختم قرآن';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'برنامه‌هایی مرتب برای ختم قرآن به‌شکلی که برایتان مناسب است';

  @override
  String get anotherScreenTasbihSubtitle =>
      'تسبیح آسان با شمارنده‌ای راحت و واضح';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'اذکار کوتاهی که روی برنامه‌های دیگر نمایش داده می‌شوند';

  @override
  String get anotherScreenFajrCompanion => 'همراه نماز صبح';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'یادآورهای دعوت و تماس‌های زمان‌بندی‌شده';

  @override
  String get anotherScreenSurahEncyclopedia => 'دانشنامهٔ سوره‌ها';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'مرور سوره‌ها، فضایل و موضوعات آن‌ها';

  @override
  String get anotherScreenNawawi40 => 'اربعین نووی';

  @override
  String get anotherScreenNawawi40Subtitle => 'احادیث جامع در ابواب دین';

  @override
  String get anotherScreenNamesOfAllah => 'اسماء الحسنی';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'تأمل در نام‌های خداوند و معانی مبارک آن‌ها';

  @override
  String get anotherScreenRadio => 'رادیو';

  @override
  String get anotherScreenRadioSubtitle =>
      'رادیوهای قرآنی و اسلامی با پخش زندهٔ پیوسته';

  @override
  String get anotherScreenHisnMuslim => 'حصن المسلم';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'اذکار جامع، مرتب‌شده برای حالات و مناسبت‌ها';

  @override
  String get anotherScreenMyDuas => 'دعاهای شخصی من';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'دعاهای شخصی خود را در یک جا نگه دارید';

  @override
  String get anotherScreenTraveler => 'مسافر';

  @override
  String get anotherScreenTravelerSubtitle =>
      'اذکار سفر، اوقات سفر و مکان‌های مفید';

  @override
  String get anotherScreenHomeWidgets => 'ویجت‌های صفحهٔ اصلی';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'نماز بعدی، اوقات امروز و آیهٔ روز';

  @override
  String get anotherScreenFootnotes => 'پانوشت‌ها';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'باب $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متن',
      one: '$count متن',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پانوشت',
      one: '$count پانوشت',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'متن ذکر';

  @override
  String get anotherScreenHisnSearchHint => 'جستجو در حصن المسلم';

  @override
  String get anotherScreenNoResults => 'نتیجه‌ای یافت نشد';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'بابی مطابق جستجوی شما در حصن المسلم پیدا نشد.';

  @override
  String get anotherScreenShowAllAdhkar => 'نمایش همهٔ اذکار';

  @override
  String get anotherScreenSurahSearchHint => 'جستجوی سوره';

  @override
  String anotherScreenSurahTitle(String name) {
    return 'سورهٔ $name';
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
  String get anotherScreenSurahNumber => 'شمارهٔ سوره';

  @override
  String get anotherScreenAyahCount => 'تعداد آیات';

  @override
  String get anotherScreenSurahNameMeaning => 'معنای نام سوره';

  @override
  String get anotherScreenSurahNamingReason => 'علت نام‌گذاری';

  @override
  String get anotherScreenSurahOtherNamesShort => 'نام‌های دیگر';

  @override
  String get anotherScreenSurahOtherNames => 'نام‌های دیگر سوره';

  @override
  String get anotherScreenSurahPurpose => 'هدف کلی';

  @override
  String get anotherScreenSurahRevelationReason => 'شأن نزول';

  @override
  String get anotherScreenSurahVirtues => 'فضایل سوره';

  @override
  String get anotherScreenSurahRelations => 'تناسب سوره';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count آیه';
  }

  @override
  String get anotherScreenNoMatchingResults => 'نتیجهٔ مطابقی یافت نشد';

  @override
  String get anotherScreenShowAllSurahs => 'نمایش همهٔ سوره‌ها';

  @override
  String get quranPlanAnalysisStartFirst =>
      'اولین جلسه را شروع کنید تا پیشرفتتان تحلیل شود.';

  @override
  String get quranPlanAnalysisFinished =>
      'مبارک باشد! برنامه را به پایان رساندید.';

  @override
  String get quranPlanAnalysisOnTrack =>
      'در مسیر درستی هستید و احتمالاً پیش از موعد ختم می‌کنید!';

  @override
  String get quranPlanAnalysisBehind =>
      'ممکن است کمی از برنامه عقب بیفتید. سعی کنید سرعت قرائت را بیشتر کنید.';

  @override
  String quranPlanReminderTitle(String title) {
    return 'برنامهٔ ختم قرآن: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return 'جلسهٔ امروز برنامهٔ «$title» را فراموش نکنید!';
  }

  @override
  String get quranPlanAddTitle => 'افزودن برنامهٔ ختم جدید';

  @override
  String get quranPlanDetailsHeader => 'جزئیات برنامه';

  @override
  String get quranPlanTitleLabel => 'عنوان برنامه';

  @override
  String get quranPlanTitleHint => 'نام برنامه';

  @override
  String get quranPlanTitleRequired => 'یک عنوان وارد کنید';

  @override
  String get quranPlanFromJuz => 'از جزء';

  @override
  String get quranPlanToJuz => 'تا جزء';

  @override
  String get quranPlanChooseStart => 'انتخاب شروع';

  @override
  String get quranPlanChooseEnd => 'انتخاب پایان';

  @override
  String get quranPlanEndBeforeStart => 'پایان پیش از شروع است';

  @override
  String get quranPlanDaysLabel => 'تعداد روزها';

  @override
  String get quranPlanDaysHint => 'مثال: ۳۰';

  @override
  String get quranPlanDaysInvalid => 'تعداد روزها را درست وارد کنید';

  @override
  String get quranPlanSave => 'ذخیرهٔ برنامه';

  @override
  String get quranPlanChoose => 'انتخاب کنید';

  @override
  String quranPlanJuz(int number) {
    return 'جزء $number';
  }

  @override
  String get quranPlanDailyReminder => 'یادآور روزانه';

  @override
  String get quranPlanNotSet => 'تعیین نشده';

  @override
  String get quranPlanListTitle => 'برنامه‌های ختم';

  @override
  String get quranPlanNewTooltip => 'برنامهٔ جدید';

  @override
  String get quranPlanSearchHint => 'جستجوی برنامه';

  @override
  String quranPlanJuzRange(int start, int end) {
    return 'جزء $start تا $end';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز',
      one: '$count روز',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جلسهٔ بارگیری‌شده',
      one: '$count جلسهٔ بارگیری‌شده',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$done از $total';
  }

  @override
  String get quranPlanDeleteConfirm => 'برنامه حذف شود؟';

  @override
  String get quranPlanConfirm => 'تأیید';

  @override
  String get quranPlanDelete => 'حذف برنامه';

  @override
  String get quranPlanStagnationWarning =>
      'توجه: چند روز وقفه داشته‌اید. یک جلسهٔ کوتاه امروز برای بازگشت به روال کافی است.';

  @override
  String get quranPlanLoadFailed => 'در حال حاضر بارگیری این برنامه ممکن نیست.';

  @override
  String get quranPlanTodaySession => 'جلسهٔ امروز';

  @override
  String get quranPlanAllSessionsDone =>
      'جلسات این برنامه را به پایان رساندید؛ بارک الله فیک.';

  @override
  String get quranPlanRhythm => 'روند برنامه';

  @override
  String get quranPlanPath => 'مسیر ختم';

  @override
  String get quranPlanNoSessions => 'هنوز جلسه‌ای نمایش داده نشده است.';

  @override
  String get quranPlanCompleteConfirm => 'جلسه پایان یابد؟';

  @override
  String quranPlanSessionNumber(int number) {
    return 'جلسهٔ $number';
  }

  @override
  String get quranPlanSessionDone => 'انجام شد';

  @override
  String get quranPlanCurrentSession => 'جلسهٔ فعلی شما';

  @override
  String get quranPlanOpenMushafHint => 'در آغاز جلسه، مصحف را باز کنید';

  @override
  String get quranPlanSessionCompleted => 'جلسهٔ انجام‌شده';

  @override
  String get quranPlanCompleteSession => 'پایان جلسه';

  @override
  String quranPlanSurahFallback(int number) {
    return 'سورهٔ $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return 'از $fromSurah آیهٔ $fromAyah تا $toSurah آیهٔ $toAyah';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'انجام شد · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'پیش‌بینی روز ختم';

  @override
  String get quranPlanAverageInterval => 'میانگین فاصلهٔ جلسات';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days روز';
  }

  @override
  String get quranPlanMostActiveDay => 'فعال‌ترین روز';

  @override
  String get quranPlanLeastActiveDay => 'کم‌فعالیت‌ترین روز';

  @override
  String get quranPlanCompletionProbability => 'احتمال اتمام برنامه';

  @override
  String quranPlanPercentValue(int percent) {
    return '$percent درصد';
  }

  @override
  String get quranPlanStagnationDays => 'روزهای وقفه';

  @override
  String get cleanupRouteNotFound => 'صفحه پیدا نشد';

  @override
  String get cleanupNotificationSubtitle => 'اعلان جدید';

  @override
  String get cleanupNotificationActionView => 'مشاهده';

  @override
  String get cleanupNotificationActionDismiss => 'نادیده گرفتن';

  @override
  String get cleanupDownloadActionFailed =>
      'انجام عملیات دانلود ممکن نشد. دوباره تلاش کنید.';

  @override
  String get cleanupDownloadStatusQueued => 'در صف';

  @override
  String get cleanupDownloadStatusCanceled => 'لغو شد';

  @override
  String get cleanupDownloadStatusUnknown => 'نامشخص';

  @override
  String get cleanupRadioMediaArtist => 'رادیو قرآن کریم';

  @override
  String get cleanupDhikrMeaningSubhanAllah => 'خداوند از هر عیبی پاک است';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'ستایش از آنِ خداست';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'معبودی جز الله نیست';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'خدا بزرگ‌تر است';

  @override
  String get cleanupDhikrMeaningLaHawla =>
      'هیچ نیرو و توانی جز به یاری خدا نیست';

  @override
  String get cleanupDhikrMeaningAstaghfirullah => 'از خداوند آمرزش می‌خواهم';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'پاک است خدا و ستایش از آنِ اوست، پاک است خدای بزرگ';

  @override
  String get appName => 'طمأنينة';

  @override
  String get commonContinue => 'ادامه';

  @override
  String get commonSave => 'ذخیره';

  @override
  String get commonCancel => 'لغو';

  @override
  String get commonOk => 'باشه';

  @override
  String get commonClose => 'بستن';

  @override
  String get commonDone => 'تمام';

  @override
  String get commonRetry => 'تلاش دوباره';

  @override
  String get commonSearch => 'جستجو';

  @override
  String get commonSettings => 'تنظیمات';

  @override
  String get commonLoading => 'در حال بارگیری…';

  @override
  String get commonError => 'خطایی رخ داد';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'ویرایش';

  @override
  String get commonAdd => 'افزودن';

  @override
  String get commonShare => 'اشتراک‌گذاری';

  @override
  String get commonCopy => 'کپی';

  @override
  String get commonCopied => 'کپی شد';

  @override
  String get commonBack => 'بازگشت';

  @override
  String get commonYes => 'بله';

  @override
  String get commonNo => 'خیر';

  @override
  String get commonRefresh => 'به‌روزرسانی';

  @override
  String get commonSeeAll => 'مشاهدهٔ همه';

  @override
  String get commonEnable => 'فعال‌سازی';

  @override
  String get commonDisable => 'غیرفعال‌سازی';

  @override
  String get commonLater => 'بعداً';

  @override
  String get prayerFajr => 'صبح';

  @override
  String get prayerSunrise => 'طلوع آفتاب';

  @override
  String get prayerDhuhr => 'ظهر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشا';

  @override
  String get prayerJumuah => 'جمعه';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربیع‌الاول';

  @override
  String get hijriMonth4 => 'ربیع‌الثانی';

  @override
  String get hijriMonth5 => 'جمادی‌الاول';

  @override
  String get hijriMonth6 => 'جمادی‌الثانی';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذی‌القعده';

  @override
  String get hijriMonth12 => 'ذی‌الحجه';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year ه‍.ق';
  }

  @override
  String get youngMuslimTitle => 'مسلمان کوچک';

  @override
  String get youngMuslimQuizUnanswered => 'پاسخ داده نشد';

  @override
  String get youngMuslimResumeReminderTitle =>
      'تماشا را در «مسلمان کوچک» ادامه بده';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return 'به «$topic» برگرد و سفرت را با آرامش ادامه بده.';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'محیط امن برای کودکان';

  @override
  String get youngMuslimAudienceGeneral => 'تماشای عمومی';

  @override
  String get youngMuslimStatSeries => 'مجموعه';

  @override
  String get youngMuslimStatEpisode => 'قسمت';

  @override
  String get youngMuslimChooseSeries => 'انتخاب مجموعه';

  @override
  String get youngMuslimEpisodes => 'قسمت‌ها';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قسمت',
      one: '$count قسمت',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'فعلاً قسمتی نیست';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'مجموعهٔ انتخابی را عوض کن یا بعد از به‌روزرسانی فیلترها دوباره سر بزن.';

  @override
  String get youngMuslimCategoryLoadError => 'بارگیری بخش ممکن نشد';

  @override
  String get youngMuslimTryAgainShortly => 'کمی بعد دوباره امتحان کن.';

  @override
  String get youngMuslimSearchHint => 'جستجوی داستان...';

  @override
  String get youngMuslimAchievements => 'دستاوردها';

  @override
  String get youngMuslimQuickFilter => 'فیلتر سریع';

  @override
  String get youngMuslimFilterResults => 'نتایج فیلتر';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتیجه',
      one: '$count نتیجه',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'نتیجهٔ مطابقی یافت نشد';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'کلمات ساده‌تری امتحان کن یا فیلترها را تغییر بده تا قسمت‌های بیشتری نمایش داده شود.';

  @override
  String get youngMuslimSections => 'بخش‌ها';

  @override
  String get youngMuslimContinueWatching => 'ادامهٔ تماشا';

  @override
  String get youngMuslimRecentlyWatched => 'اخیراً تماشا کردی';

  @override
  String get youngMuslimFavorites => 'علاقه‌مندی‌ها';

  @override
  String get youngMuslimWatchLater => 'بعداً تماشا می‌کنم';

  @override
  String get youngMuslimSuggestions => 'پیشنهادهای مناسب';

  @override
  String get youngMuslimGreetingWelcome => 'به دنیای داستان و یادگیری خوش آمدی';

  @override
  String get youngMuslimGreetingPickNew =>
      'یک داستان تازه انتخاب کن و سفرت را امروز شروع کن';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قسمت منتظر است که به آن برگردی',
      one: '$count قسمت منتظر است که به آن برگردی',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'امتیازها و دستاوردهای من';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'سطح $level · $points امتیاز';
  }

  @override
  String get youngMuslimNextLevelProgress => 'پیشرفت تا سطح بعدی';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$current از $total';
  }

  @override
  String get youngMuslimStatAchievements => 'دستاورد';

  @override
  String get youngMuslimStatEpisodes => 'قسمت';

  @override
  String get youngMuslimStatAnswers => 'پاسخ';

  @override
  String get youngMuslimFilterAll => 'همه';

  @override
  String get youngMuslimStatusInProgress => 'در حال تماشا';

  @override
  String get youngMuslimStatusCompleted => 'کامل‌شده';

  @override
  String get youngMuslimStatusWatchLater => 'بعداً';

  @override
  String get youngMuslimFiltersActiveNote =>
      'فیلترها اکنون فعال‌اند و می‌توانی از دکمهٔ فیلتر بالای صفحه آن‌ها را تغییر دهی.';

  @override
  String get youngMuslimClearFilters => 'پاک کردن';

  @override
  String get youngMuslimContentLoadError => 'بارگیری محتوا ممکن نشد';

  @override
  String get youngMuslimPullToRetry =>
      'برای تلاش دوباره، صفحه را به پایین بکش.';

  @override
  String get youngMuslimFilterSheetTitle => 'فیلتر محتوا';

  @override
  String get youngMuslimCategoryLabel => 'بخش';

  @override
  String get youngMuslimFilterLanguage => 'زبان';

  @override
  String get youngMuslimLanguageArabic => 'عربی';

  @override
  String get youngMuslimLanguageFrench => 'فرانسوی';

  @override
  String get youngMuslimLanguageMixed => 'ترکیبی';

  @override
  String get youngMuslimFilterContentType => 'نوع محتوا';

  @override
  String get youngMuslimContentTypeStorySeries => 'مجموعه‌های داستانی';

  @override
  String get youngMuslimApplyFilters => 'اعمال فیلترها';

  @override
  String get youngMuslimPlayerTitle => 'پخش امن برای کودکان';

  @override
  String get youngMuslimEpisodeQuizTitle => 'پرسش قسمت پس از تماشا';

  @override
  String get youngMuslimSeriesChallenge => 'چالش مجموعه';

  @override
  String get youngMuslimPlayerLoadError =>
      'در حال حاضر بارگیری پخش‌کننده ممکن نیست.';

  @override
  String get youngMuslimWatchOptions => 'گزینه‌های تماشا';

  @override
  String get youngMuslimPlayNextEpisode => 'پخش قسمت بعدی';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'قسمت $episode از همین مجموعه';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'فهرست مجموعه';

  @override
  String get youngMuslimAutoPlayNext => 'پخش خودکار قسمت بعدی';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'فقط در همین مجموعه و پس از پایان قسمت';

  @override
  String get youngMuslimResumeButton => 'ادامهٔ تماشا';

  @override
  String get youngMuslimPlayNow => 'پخش همین حالا';

  @override
  String youngMuslimPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get youngMuslimProgress => 'پیشرفت';

  @override
  String get youngMuslimWatchCount => 'دفعات تماشا';

  @override
  String get youngMuslimEpisodeDuration => 'مدت قسمت';

  @override
  String youngMuslimLastWatched(String when) {
    return 'آخرین تماشا: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'اطلاعات قسمت';

  @override
  String get youngMuslimStory => 'داستان';

  @override
  String get youngMuslimSeries => 'مجموعه';

  @override
  String get youngMuslimEpisodeNumber => 'شمارهٔ قسمت';

  @override
  String get youngMuslimEpisodeTools => 'ابزارهای قسمت';

  @override
  String get youngMuslimEpisodeQuestions => 'پرسش‌های قسمت';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'پرسش‌های کوتاهی که آنچه کودک دیده را در ذهنش تثبیت می‌کند';

  @override
  String get youngMuslimAfterWatchQuestion => 'پرسش پس از تماشا';

  @override
  String get youngMuslimNextEpisode => 'قسمت بعدی';

  @override
  String get youngMuslimSimilarEpisodes => 'قسمت‌های مشابه';

  @override
  String get youngMuslimDetailsLoadError => 'بارگیری جزئیات قسمت ممکن نشد';

  @override
  String get youngMuslimQuizIntro =>
      'پرسش‌های ساده‌ای که به کودک کمک می‌کند آنچه دیده را به خاطر بسپارد.';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پرسش',
      one: '$count پرسش',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return '+$points امتیاز در صورت قبولی';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'حد قبولی: $score';
  }

  @override
  String get youngMuslimGrading => 'در حال تصحیح پاسخ‌ها';

  @override
  String get youngMuslimSubmitAnswers => 'ارسال پاسخ‌ها';

  @override
  String get youngMuslimAnswerHint => 'پاسخت را این‌جا واضح بنویس...';

  @override
  String get youngMuslimQuizPassed => 'آفرین قهرمان!';

  @override
  String get youngMuslimQuizAlmost => 'به پاسخ کامل نزدیکی';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return '$correct پاسخ درست از $total';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points امتیاز';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'سطح $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points امتیاز',
      one: '$points امتیاز',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'دستاوردهای جدید';

  @override
  String get youngMuslimReviewAnswers => 'مرور پاسخ‌ها';

  @override
  String get youngMuslimFinish => 'پایان';

  @override
  String get youngMuslimYourAnswer => 'پاسخ تو';

  @override
  String get youngMuslimCorrectAnswer => 'پاسخ درست';

  @override
  String get youngMuslimStatSeriesPlural => 'مجموعه';

  @override
  String get youngMuslimStatPerfectScores => 'نمرهٔ کامل';

  @override
  String get youngMuslimUnlockedAchievements => 'دستاوردهای بازشده';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دستاورد',
      one: '$count دستاورد',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'هنوز دستاوردی نداری';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'اولین قسمت را کامل کن یا به اولین پرسش پاسخ بده تا سفر آغاز شود.';

  @override
  String get youngMuslimUpcomingAchievements => 'دستاوردهای پیش رو';

  @override
  String get youngMuslimAchievementUnlocked => 'این دستاورد باز شد.';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'باز شد $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'پیشرفت فعلی';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '$minutesد';
  }

  @override
  String get youngMuslimNotWatchedYet => 'هنوز تماشا نشده';

  @override
  String get youngMuslimJustNow => 'همین حالا';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه پیش',
      one: '$count دقیقه پیش',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعت پیش',
      one: '$count ساعت پیش',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز پیش',
      one: '$count روز پیش',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'تماشا شد';

  @override
  String youngMuslimProgressPercent(int percent) {
    return 'پیشرفت $percent٪';
  }

  @override
  String get youngMuslimReadyToWatch => 'آمادهٔ تماشا';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجموعه',
      one: '$count مجموعه',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجموعه · برای کودکان',
      one: '$count مجموعه · برای کودکان',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'قسمت $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft => 'از همان‌جا که ماندی ادامه بده';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return '$duration باقی مانده';
  }

  @override
  String get youngMuslimAlmostDone => 'نزدیک پایان';

  @override
  String get categoriesRequestFailed => 'انجام این عملیات ممکن نیست';

  @override
  String get categoriesLibraryTitle => 'کتابخانه';

  @override
  String get categoriesQuranSciencesHeader => 'قرآن کریم و علوم آن';

  @override
  String get categoriesTypesHeader => 'دسته‌بندی‌ها';

  @override
  String get categoriesSectionsHeader => 'بخش‌ها';

  @override
  String get categoriesFamousRecitations => 'تلاوت‌های مشهور';

  @override
  String get categoriesKidsTeaching => 'آموزش کودکان';

  @override
  String get categoriesRecitationsByNarration =>
      'تلاوت به روایات و قرائات مختلف';

  @override
  String get categoriesRecitationsByNarrationShort => 'تلاوت به روایات';

  @override
  String get categoriesHaramainMushafs => 'مصاحف حرمین';

  @override
  String get categoriesTypeVideos => 'ویدئوها';

  @override
  String get categoriesTypeBooks => 'کتاب‌ها';

  @override
  String get categoriesTypeStories => 'داستان‌ها';

  @override
  String get categoriesTypeAudios => 'صوتی‌ها';

  @override
  String get categoriesTypeFatwas => 'فتواها';

  @override
  String get categoriesTypeQuran => 'قرآن';

  @override
  String get categoriesTypePresentations => 'ارائه‌ها';

  @override
  String get categoriesTypeNews => 'اخبار';

  @override
  String get categoriesTypeArticles => 'مقاله‌ها';

  @override
  String get categoriesTypeApps => 'برنامه‌ها';

  @override
  String get categoriesTypeSermons => 'خطبه‌ها';

  @override
  String get categoriesTopicQuran => 'قرآن';

  @override
  String get categoriesTopicSunnah => 'سنت';

  @override
  String get categoriesTopicSeerah => 'سیرهٔ نبوی';

  @override
  String get categoriesTopicAqeedah => 'عقیده';

  @override
  String get categoriesTopicFiqh => 'فقه';

  @override
  String get categoriesTopicHistory => 'تاریخ';

  @override
  String get categoriesTopicArabic => 'زبان عربی';

  @override
  String get categoriesTopicIslamicStudies => 'مطالعات اسلامی';

  @override
  String get categoriesTopicLessons => 'درس‌های علمی';

  @override
  String get categoriesTopicMajorSins => 'گناهان کبیره و محرمات';

  @override
  String get categoriesNoSearchResults => 'برای این جستجو نتیجه‌ای یافت نشد.';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد',
      one: '$count مورد',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'صوتی';

  @override
  String get categoriesItemBook => 'کتاب';

  @override
  String get categoriesItemArticle => 'مقاله';

  @override
  String get categoriesItemVideo => 'ویدئو';

  @override
  String get categoriesFallbackTitle => 'دسته‌بندی';

  @override
  String get categoriesNoAttachments => 'این مطلب پیوستی ندارد.';

  @override
  String get categoriesAttachments => 'پیوست‌ها';

  @override
  String get categoriesActionWatch => 'تماشا';

  @override
  String get categoriesActionRead => 'خواندن';

  @override
  String get categoriesActionOpen => 'باز کردن';

  @override
  String categoriesOrder(String order) {
    return 'ترتیب $order';
  }

  @override
  String get categoriesDownload => 'دانلود';

  @override
  String get categoriesAttachmentFallback => 'پیوست';

  @override
  String get categoriesNoChapters => 'در این بخش بابی وجود ندارد.';

  @override
  String get categoriesClearSearch => 'پاک کردن جستجو';

  @override
  String get categoriesAudioLoadError => 'بارگیری مطالب صوتی ممکن نشد.';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'قطعهٔ $number';
  }

  @override
  String get categoriesAudioClipFallback => 'قطعهٔ صوتی';

  @override
  String get booksTitle => 'کتاب‌ها';

  @override
  String get booksLoadError => 'در حال حاضر بارگیری کتاب‌ها ممکن نیست.';

  @override
  String get booksEmpty => 'کتابی برای نمایش وجود ندارد.';

  @override
  String get booksFilesHeader => 'فایل‌های کتاب';

  @override
  String get booksNoFilesTitle => 'فایلی وجود ندارد';

  @override
  String get booksNoFilesBody =>
      'برای این کتاب فایلی جهت دانلود پیوست نشده است.';

  @override
  String get booksDescriptionHeader => 'توضیحات';

  @override
  String get booksReferenceHeader => 'منبع';

  @override
  String booksFileNumber(int number) {
    return 'فایل $number';
  }

  @override
  String get booksReadTitle => 'خواندن کتاب';

  @override
  String get booksViewerFailed => 'نمایش کتاب در برنامه ممکن نشد';

  @override
  String get booksOpenOutsideHint => 'می‌توانید آن را بیرون از برنامه باز کنید';

  @override
  String get booksOpenOutside => 'باز کردن بیرون از برنامه';

  @override
  String get hadith40Title => 'اربعین نووی';

  @override
  String hadith40Number(int number) {
    return 'حدیث $number';
  }

  @override
  String get hadith40SearchHint => 'جستجوی حدیث';

  @override
  String get hadith40NoResults => 'برای این جستجو نتیجه‌ای یافت نشد';

  @override
  String get hadith40ShowAll => 'نمایش همهٔ احادیث';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'اربعین نووی · حدیث $number';
  }

  @override
  String get hadith40Explanation => 'شرح حدیث';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nشرح حدیث:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'اسماء الحسنی';

  @override
  String allahNamesNameOrder(int number) {
    return 'نام $number از اسماء الحسنی';
  }

  @override
  String get allahNamesMeaning => 'معنا';

  @override
  String get allahNamesSearchHint => 'جستجو در اسماء الحسنی';

  @override
  String get allahNamesNoResultsTitle => 'نتیجه‌ای یافت نشد';

  @override
  String get allahNamesNoResultsMessage => 'نامی مطابق جستجوی شما پیدا نشد.';

  @override
  String get allahNamesShowAll => 'نمایش همهٔ نام‌ها';

  @override
  String get readQuranListen => 'شنیدن';

  @override
  String get readQuranAyah => 'آیه';

  @override
  String get readQuranTafsir => 'تفسیر آیه';

  @override
  String get quranAudioPlayPause => 'پخش یا توقف';

  @override
  String audiosTrackNumber(int number) {
    return 'قطعهٔ $number';
  }

  @override
  String get audiosTracksHeader => 'قطعه‌ها';

  @override
  String get audiosSearchSeriesHint => 'جستجوی مجموعه';

  @override
  String get audiosSeriesSubtitle => 'مجموعهٔ صوتی';

  @override
  String get audiosNoSeries => 'مجموعه‌ای برای نمایش وجود ندارد';

  @override
  String get audiosNoResults => 'نتیجه‌ای برای جستجوی شما یافت نشد';

  @override
  String get audiosPrevious => 'قبلی';

  @override
  String get audiosNext => 'بعدی';

  @override
  String get audiosPause => 'توقف موقت';

  @override
  String get audiosPlay => 'پخش';

  @override
  String get coreUpdateDownloaded =>
      'به‌روزرسانی دانلود شد؛ اکنون می‌توانید آن را نصب کنید.';

  @override
  String get coreUpdateInstallNow => 'نصب کن';

  @override
  String get coreUpdateAvailableTitle => 'نسخهٔ جدید موجود است';

  @override
  String coreUpdateAvailableMessage(String version) {
    return 'نسخهٔ $version اکنون در App Store موجود است.';
  }

  @override
  String get coreUpdateWhatsNew => 'تازه‌های این نسخه:';

  @override
  String get coreUpdateNow => 'به‌روزرسانی';

  @override
  String get coreExitDialogTitle => 'توجه';

  @override
  String get coreExitDialogMessage =>
      'آیا مطمئنید که می‌خواهید از برنامه خارج شوید؟';

  @override
  String get coreExitConfirmMessage => 'آیا از خروج مطمئنید؟';

  @override
  String get coreExitStay => 'انصراف';

  @override
  String get coreExitAction => 'خروج';

  @override
  String get coreDeleteDhikrTitle => 'ذکر حذف شود؟';

  @override
  String get coreDeleteDhikrMessage => 'آیا از حذف این ذکر مطمئنید؟';

  @override
  String get coreFieldRequired => 'این فیلد الزامی است';

  @override
  String get coreNoData => 'داده‌ای وجود ندارد.';

  @override
  String get coreNoDataToShow => 'داده‌ای برای نمایش وجود ندارد';

  @override
  String get coreContent => 'محتوا';

  @override
  String get coreGenericError => 'مشکلی پیش آمد، لطفاً دوباره تلاش کنید';

  @override
  String get coreLoadDataError => 'هنگام بارگیری داده‌ها خطایی رخ داد';

  @override
  String coreErrorStatus(String code) {
    return 'وضعیت: $code';
  }

  @override
  String get coreCloseSearch => 'بستن جستجو';

  @override
  String get coreClear => 'پاک کردن';

  @override
  String get coreSheetDefaultTitle => 'افزودن مورد جدید';

  @override
  String get coreSheetDefaultSubtitle => 'محتوا را سفارشی کنید';

  @override
  String get coreCopiedSuccessfully => 'با موفقیت کپی شد';

  @override
  String get coreDownloadStarted => 'دانلود آغاز شد';

  @override
  String get coreDownloadCompleted => 'دانلود انجام شد';

  @override
  String get coreSaveReadingPositionPrompt =>
      'می‌خواهید جای قرائت خود را ذخیره کنید؟';

  @override
  String get coreLocationServiceDisabled =>
      'سرویس موقعیت مکانی خاموش است. برای تعیین اوقات نماز آن را روشن کنید.';

  @override
  String get coreLocationPermissionDenied =>
      'مجوز دسترسی به موقعیت مکانی داده نشد.';

  @override
  String get coreLocationPermissionDeniedForever =>
      'مجوز موقعیت مکانی برای همیشه رد شده است. آن را از تنظیمات برنامه فعال کنید.';

  @override
  String get coreNotNow => 'الان نه';

  @override
  String get coreAllow => 'اجازه دادن';

  @override
  String get coreOpenSettings => 'باز کردن تنظیمات';

  @override
  String get coreNotificationPermissionTitle => 'مجوز اعلان‌ها';

  @override
  String get coreNotificationPermissionRationale =>
      'برنامه برای یادآوری اوقات نماز و اذکار به مجوز اعلان نیاز دارد.\nاین کمک می‌کند در طول روز با آموزه‌های اسلام در ارتباط بمانید.';

  @override
  String get coreNotificationSettingsTitle => 'تنظیمات اعلان‌ها';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'مجوز اعلان‌ها برای همیشه رد شده است.\nلطفاً به تنظیمات بروید و اعلان‌ها را دستی فعال کنید.';

  @override
  String get corePermissionStatusGranted => 'همهٔ مجوزها داده شده است';

  @override
  String get corePermissionStatusDenied => 'مجوزهای اعلان رد شده است';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'مجوزها برای همیشه رد شده است';

  @override
  String get corePermissionStatusPartial => 'فقط برخی مجوزها داده شده است';

  @override
  String get corePermissionStatusUnknown => 'وضعیت مجوزها نامشخص است';

  @override
  String get corePermissionResultGranted => 'همهٔ مجوزها با موفقیت داده شد';

  @override
  String get corePermissionResultDenied => 'درخواست مجوزها رد شد';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'مجوزها برای همیشه رد شد - لطفاً به تنظیمات بروید';

  @override
  String get corePermissionResultPartial =>
      'برخی مجوزها داده شد - ممکن است به مجوزهای بیشتری نیاز باشد';

  @override
  String get corePermissionResultError => 'هنگام درخواست مجوزها خطایی رخ داد';

  @override
  String get coreNotificationActionOpenApp => 'باز کردن برنامه';

  @override
  String get coreNotificationActionDismiss => 'پنهان کردن';

  @override
  String get coreNotificationActionMarkRead => 'خوانده شد';

  @override
  String get coreNotificationActionRemindLater => 'بعداً یادآوری کن';

  @override
  String get coreNotificationGroupName => 'اعلان‌های اسلامی';

  @override
  String get coreNotificationGroupDescription =>
      'گروه اعلان‌های برنامهٔ اسلامی';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'کانال $channel برای اعلان‌های اسلامی';
  }

  @override
  String get coreNotificationAppLabel => 'برنامهٔ طمأنينة';

  @override
  String get coreNotificationMore => 'بیشتر...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اعلان',
      one: '$count اعلان',
      zero: 'اعلانی نیست',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اعلان جدید',
      one: '$count اعلان جدید',
      zero: 'اعلان جدیدی نیست',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return 'اکنون وقت اذان $prayer است';
  }

  @override
  String coreAthanDescription(String prayer) {
    return 'اذان $prayer';
  }

  @override
  String get coreChannelAthan => 'طمأنينة - اذان';

  @override
  String get coreChannelMohammed => 'طمأنينة - صلوات بر پیامبر';

  @override
  String get coreChannelMorning => 'طمأنينة - اذکار صبح';

  @override
  String get coreChannelNight => 'طمأنينة - اذکار شامگاه';

  @override
  String get coreChannelSleep => 'طمأنينة - اذکار خواب';

  @override
  String get coreChannelGetUp => 'طمأنينة - اذکار بیداری';

  @override
  String get coreChannelMiddleNight => 'طمأنينة - قیام شب';

  @override
  String get coreChannelRandomThikr => 'طمأنينة - اذکار تصادفی';

  @override
  String get coreChannelAstgferAllh => 'طمأنينة - استغفار';

  @override
  String get coreChannelHasbnaAllh => 'طمأنينة - حسبنا الله';

  @override
  String get coreChannelLaHawla => 'طمأنينة - لا حول ولا قوة إلا بالله';

  @override
  String get coreChannelSubhanAllh => 'طمأنينة - سبحان الله';

  @override
  String get coreChannelDefaultChannel => 'طمأنينة - اعلان‌های عمومی';

  @override
  String get coreChannelSmartOutreach => 'طمأنينة - همراه نماز صبح';

  @override
  String get coreFcmChannelHighImportance => 'طمأنينة - اعلان‌های مهم';

  @override
  String get coreFcmChannelChat => 'طمأنينة - پیام‌ها';

  @override
  String get coreFcmChannelUpdates => 'طمأنينة - به‌روزرسانی‌ها';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'کانال اعلان‌های مهم در برنامهٔ طمأنينة';

  @override
  String get coreFcmChannelDefaultDescription =>
      'کانال اعلان‌های عمومی در برنامهٔ طمأنينة';

  @override
  String get coreFcmChannelChatDescription =>
      'کانال پیام‌ها و هشدارهای برنامهٔ طمأنينة';

  @override
  String get coreFcmChannelUpdatesDescription =>
      'کانال به‌روزرسانی‌های برنامهٔ طمأنينة';

  @override
  String get languageTitle => 'زبان خود را انتخاب کنید';

  @override
  String get languageSubtitle => 'بعداً می‌توانید آن را از تنظیمات تغییر دهید.';

  @override
  String get languageSettingTitle => 'زبان';

  @override
  String get languageSettingSubtitle => 'زبان رابط برنامه';

  @override
  String get languageReligiousTextNote =>
      'قرآن کریم، اذکار و دعاها با متن عربی اصلی خود نمایش داده می‌شوند.';

  @override
  String get outreachTitle => 'همراه نماز صبح';

  @override
  String get outreachTagline =>
      'فهرست‌های تماس آرام که روز عزیزانتان را با خیر آغاز می‌کنند';

  @override
  String get outreachActionCallOnly => 'فقط تماس';

  @override
  String get outreachErrorScheduleNotFound => 'این فهرست وجود ندارد.';

  @override
  String get outreachContactsPermissionDenied =>
      'برای انتخاب خودکار شماره، باید دسترسی به مخاطبین را مجاز کنید.';

  @override
  String get outreachContactNoPhone => 'مخاطب انتخاب‌شده شمارهٔ تلفن ندارد.';

  @override
  String get outreachContactPickError => 'هنگام انتخاب مخاطب خطایی رخ داد.';

  @override
  String get outreachUnnamed => 'بی‌نام';

  @override
  String get outreachPermissionPhone => 'تماس تلفنی';

  @override
  String get outreachPermissionContacts => 'مخاطبین';

  @override
  String get outreachPermissionNotifications => 'اعلان‌ها';

  @override
  String get outreachListSeparator => '، ';

  @override
  String get outreachValidationTitleRequired => 'یک نام برای فهرست بنویسید.';

  @override
  String get outreachValidationAddNumber => 'دست‌کم یک شماره اضافه کنید.';

  @override
  String get outreachValidationEmptyPhone =>
      'هر خانه باید یک شمارهٔ تلفن داشته باشد.';

  @override
  String get outreachValidationIncompleteNumber => 'یک شمارهٔ ناقص وجود دارد.';

  @override
  String get outreachValidationDuplicateNumber =>
      'یک شمارهٔ تکراری در همین فهرست وجود دارد.';

  @override
  String get outreachValidationPickDay => 'دست‌کم یک روز انتخاب کنید.';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'فهرست بدون شماره را نمی‌توان فعال کرد.';

  @override
  String get outreachCallLogsTitle => 'گزارش تماس‌ها';

  @override
  String get outreachClearLog => 'پاک کردن گزارش';

  @override
  String get outreachStatTotal => 'مجموع';

  @override
  String get outreachStatAnswered => 'پاسخ دادند';

  @override
  String get outreachStatNotAnswered => 'پاسخ ندادند';

  @override
  String get outreachStatFailed => 'ناموفق';

  @override
  String get outreachResultsHeader => 'نتایج';

  @override
  String get outreachNoResultsTitle => 'هنوز نتیجه‌ای نیست';

  @override
  String get outreachNoResultsMessage =>
      'نتیجهٔ هر تماس پس از نخستین اجرا این‌جا نمایش داده می‌شود.';

  @override
  String outreachSecondsShort(int seconds) {
    return '$secondsث';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds ثانیه';
  }

  @override
  String get outreachCallStatusAnswered => 'پاسخ داده شد';

  @override
  String get outreachCallStatusNotAnswered => 'پاسخ داده نشد';

  @override
  String get outreachCallStatusFailed => 'تماس ناموفق بود';

  @override
  String get outreachExecutionTitle => 'شروع تماس‌ها';

  @override
  String get outreachCallsStartedFromAlert => 'تماس‌ها از طریق هشدار آغاز شد.';

  @override
  String get outreachCallsStartedNow => 'تماس‌ها اکنون آغاز شد.';

  @override
  String get outreachCallsStartFailed =>
      'در حال حاضر آغاز تماس‌ها ممکن نیست. دوباره تلاش کنید.';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'پس از پایان فهرست ببینید چه کسی پاسخ داد و چه کسی نه';

  @override
  String get outreachPreparingCalls => 'در حال آماده‌سازی تماس‌ها...';

  @override
  String get outreachDontCloseHint => 'تا آغاز عملیات صفحه را نبندید.';

  @override
  String get outreachCanCloseHint =>
      'اکنون می‌توانید صفحه را ببندید و نتیجه را در گزارش ببینید.';

  @override
  String get outreachAddList => 'افزودن فهرست';

  @override
  String get outreachStatLists => 'فهرست‌ها';

  @override
  String get outreachStatEnabled => 'فعال';

  @override
  String get outreachStatNumbers => 'شماره‌ها';

  @override
  String get outreachListsHeader => 'فهرست‌های تماس';

  @override
  String get outreachToolsHeader => 'ابزارها';

  @override
  String get outreachCallLogsSubtitle =>
      'نتیجهٔ هر تماس: چه کسی پاسخ داد و چه کسی نه';

  @override
  String get outreachSettingsTitle => 'تنظیمات تماس';

  @override
  String get outreachSettingsSubtitle =>
      'مدت‌های پیش‌فرض و رفتار فهرست‌های جدید';

  @override
  String get outreachNoListsTitle => 'هنوز فهرستی نیست';

  @override
  String get outreachNoListsMessage =>
      'یک فهرست اضافه کنید و زمان آن و شماره‌هایی را که می‌خواهید تماس بگیرید تعیین کنید.';

  @override
  String get outreachStartsNow => 'همین حالا آغاز می‌شود';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقهٔ دیگر',
      one: '$count دقیقهٔ دیگر',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعت دیگر',
      one: '$count ساعت دیگر',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return '$hours ساعت و $minutes دقیقهٔ دیگر';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز دیگر',
      one: '$count روز دیگر',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'ابتدا باید این مجوزها را فعال کنید: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'مجوزهای لازم کامل نیست. برای اجرای به‌موقع فهرست‌ها این‌ها را فعال کنید: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'دادن مجوزها';

  @override
  String get outreachOpenSettings => 'باز کردن تنظیمات';

  @override
  String get outreachSettingsSaved => 'تنظیمات ذخیره شد.';

  @override
  String get outreachSettingsIntro =>
      'این مقادیر روی هر فهرست جدید اعمال می‌شوند.';

  @override
  String get outreachDefaultDurationsHeader => 'مدت‌های پیش‌فرض';

  @override
  String get outreachRingTimeout => 'مدت انتظار برای پاسخ';

  @override
  String get outreachHangupDelay => 'انتظار پس از پاسخ';

  @override
  String get outreachDelayBetweenEach => 'فاصله بین هر شماره';

  @override
  String get outreachBehaviorHeader => 'رفتار فهرست‌ها';

  @override
  String get outreachStopAfterFirstAnswerList => 'توقف فهرست پس از نخستین پاسخ';

  @override
  String get outreachRetryIfNoAnswer => 'تماس دوباره در صورت پاسخ ندادن';

  @override
  String get outreachRestartAfterFinish => 'شروع دوباره پس از پایان';

  @override
  String get outreachSaveSettings => 'ذخیرهٔ تنظیمات';

  @override
  String get outreachBackgroundHeader => 'اجرا در پس‌زمینه';

  @override
  String get outreachBatteryTitle => 'مستثنا کردن برنامه از صرفه‌جویی باتری';

  @override
  String get outreachBatterySubtitle =>
      'اگر فهرست‌ها در پس‌زمینه متوقف می‌شوند، از تنظیمات باتری اجازهٔ اجرا به برنامه بدهید.';

  @override
  String get outreachEditList => 'ویرایش فهرست';

  @override
  String get outreachNewList => 'فهرست جدید';

  @override
  String get outreachCallTimeHeader => 'زمان تماس';

  @override
  String get outreachManualTime => 'انتخاب دستی زمان';

  @override
  String get outreachManualTimeSubtitle => 'ساعت و دقیقه را خودتان تعیین کنید';

  @override
  String get outreachUseFajrTime => 'استفاده از وقت نماز صبح';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'استفاده از وقت نماز صبح · $time';
  }

  @override
  String get outreachPrayerTimesNotReady => 'اوقات نماز هنوز آماده نیست';

  @override
  String get outreachFajrAutoFill =>
      'زمان به‌طور خودکار از اوقات امروز پر می‌شود';

  @override
  String get outreachFajrUnavailable =>
      'وقت نماز صبح اکنون در دسترس نیست. کمی بعد امتحان کنید.';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'وقت نماز صبح استفاده شد: $time';
  }

  @override
  String get outreachContactFetchFailed =>
      'اکنون نتوانستیم مخاطب را دریافت کنیم.';

  @override
  String get outreachExactAlarmHint =>
      'برای اجرای دقیق و به‌موقع «همراه نماز صبح»، مجوز هشدارهای دقیق را از تنظیمات دستگاه فعال کنید.';

  @override
  String get outreachListNameHeader => 'نام فهرست';

  @override
  String get outreachStartTime => 'زمان شروع';

  @override
  String get outreachStartTimeHint =>
      'زمانی را دستی انتخاب کنید یا از وقت نماز صبح استفاده کنید';

  @override
  String outreachFajrTimeToday(String time) {
    return 'وقت نماز صبح امروز $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'مخاطبین · $count';
  }

  @override
  String get outreachPickFromContacts => 'انتخاب از مخاطبین';

  @override
  String get outreachPickFromContactsSubtitle =>
      'یک شمارهٔ جدید به این فهرست اضافه کنید';

  @override
  String get outreachAdvancedSettings => 'تنظیمات پیشرفته';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'روزها، مدت‌های انتظار و رفتار تکرار';

  @override
  String get outreachSaving => 'در حال ذخیره...';

  @override
  String get outreachSaveList => 'ذخیرهٔ فهرست';

  @override
  String get outreachNoNumbersYet => 'هنوز شماره‌ای اضافه نشده است.';

  @override
  String get outreachEnableList => 'فعال‌سازی این فهرست';

  @override
  String get outreachDailyRepeat => 'تکرار روزانه';

  @override
  String get outreachEveryDay => 'هر روز';

  @override
  String get outreachSelectedWeekdays => 'روزهای منتخب هفته';

  @override
  String get outreachDelayBetweenNumbers => 'فاصله بین شماره‌ها';

  @override
  String get outreachStopAfterFirstAnswer => 'توقف پس از نخستین پاسخ';

  @override
  String get outreachRetryOnNoAnswer => 'تکرار در صورت پاسخ ندادن';

  @override
  String get outreachRepeatWholeCycle => 'تکرار کل چرخه';

  @override
  String get outreachListNameHint => 'مثال: یادآور نماز صبح';

  @override
  String get outreachTitleFieldRequired => 'یک نام برای فهرست بنویسید';

  @override
  String get outreachPickNumber => 'انتخاب شماره';

  @override
  String get outreachMultipleNumbers => 'این نام بیش از یک شماره دارد.';

  @override
  String get outreachNoDays => 'بدون روز مشخص';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شماره',
      one: '$count شماره',
      zero: 'بدون شماره',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'انتظار $secondsث';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'پس از پاسخ $secondsث';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'بین شماره‌ها $secondsث';
  }

  @override
  String get outreachNearest => 'نزدیک‌ترین';

  @override
  String get outreachStartNow => 'شروع کن';

  @override
  String get outreachStatusActive => 'فعال';

  @override
  String get outreachStatusStopped => 'متوقف';

  @override
  String outreachStatusSemantics(String status) {
    return 'وضعیت: $status';
  }

  @override
  String get outreachWeekday1 => 'دوشنبه';

  @override
  String get outreachWeekday2 => 'سه‌شنبه';

  @override
  String get outreachWeekday3 => 'چهارشنبه';

  @override
  String get outreachWeekday4 => 'پنجشنبه';

  @override
  String get outreachWeekday5 => 'جمعه';

  @override
  String get outreachWeekday6 => 'شنبه';

  @override
  String get outreachWeekday7 => 'یکشنبه';

  @override
  String get travelerServicesTitle => 'خدمات مسافر';

  @override
  String get travelerNearbyMosques => 'مساجد نزدیک';

  @override
  String get travelerNearbyHalalRestaurants => 'رستوران‌های حلال نزدیک';

  @override
  String get travelerHalalRestaurants => 'رستوران‌های حلال';

  @override
  String get travelerHintAroundYou => 'اطراف شما';

  @override
  String get travelerHintWithCounter => 'با شمارنده';

  @override
  String get travelerHintByCountry => 'بر اساس کشور شما';

  @override
  String get travelerFlightPrayer => 'نماز در هواپیما';

  @override
  String get travelerHintByFlightNumber => 'با شمارهٔ پرواز';

  @override
  String get travelerSetLocationForMakkah =>
      'موقعیت خود را در بخش اوقات تعیین کنید تا فاصله تا مکه نمایش داده شود.';

  @override
  String get travelerInMakkah => 'شما در مکهٔ مکرمه هستید — تقبل الله.';

  @override
  String get travelerYourLocation => 'موقعیت شما';

  @override
  String get travelerMakkah => 'مکهٔ مکرمه';

  @override
  String get travelerQibla => 'قبله';

  @override
  String travelerDistanceMeters(String value) {
    return '$value متر';
  }

  @override
  String travelerDistanceKm(String value) {
    return '$value کیلومتر';
  }

  @override
  String get travelerListSeparator => '، ';

  @override
  String get travelerDirectionN => 'شمال';

  @override
  String get travelerDirectionNE => 'شمال شرق';

  @override
  String get travelerDirectionE => 'شرق';

  @override
  String get travelerDirectionSE => 'جنوب شرق';

  @override
  String get travelerDirectionS => 'جنوب';

  @override
  String get travelerDirectionSW => 'جنوب غرب';

  @override
  String get travelerDirectionW => 'غرب';

  @override
  String get travelerDirectionNW => 'شمال غرب';

  @override
  String get travelerPrayerUnknown => 'نامشخص';

  @override
  String get travelerPrayerShortFajr => 'صبح';

  @override
  String get travelerPrayerShortSunrise => 'طلوع';

  @override
  String get travelerPrayerShortDhuhr => 'ظهر';

  @override
  String get travelerPrayerShortAsr => 'عصر';

  @override
  String get travelerPrayerShortMaghrib => 'مغرب';

  @override
  String get travelerPrayerShortIsha => 'عشا';

  @override
  String get travelerNoMosquesFound => 'در محدودهٔ فعلی مسجدی پیدا نشد.';

  @override
  String get travelerNoRestaurantsFound =>
      'در این محدوده رستوران حلالی پیدا نشد.';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه پیاده',
      one: '$count دقیقه پیاده',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'مسجد نزدیک';

  @override
  String get travelerDefaultRestaurantName => 'رستوران حلال';

  @override
  String get travelerNoDetailedAddress => 'بدون نشانی دقیق';

  @override
  String get travelerRepeatBySituation => 'بسته به موقعیت';

  @override
  String get travelerRepeatOnce => 'یک بار';

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
  String get travelerStageStart => 'هنگام آغاز سفر';

  @override
  String get travelerStageOnTheWay => 'در طول راه';

  @override
  String get travelerStageStop => 'هنگام توقف';

  @override
  String get travelerStageReturn => 'هنگام بازگشت';

  @override
  String get travelerStageFarewell => 'بدرقهٔ مسافر';

  @override
  String get travelerStageFarewellReply => 'دعا برای مسافر';

  @override
  String get travelerAthkarTitle => 'اذکار سفر';

  @override
  String get travelerAthkarLoadFailed => 'بارگیری اذکار سفر ممکن نشد.';

  @override
  String get travelerFarewellTitle => 'برای کسی که مسافری را بدرقه می‌کند';

  @override
  String get travelerFarewellCaption =>
      'این‌ها برای راه شما نیست، برای کسانی است که پشت سر می‌مانند';

  @override
  String get travelerRoadComplete => 'اذکار راهتان را کامل کردید';

  @override
  String get travelerRoadStations => 'ایستگاه‌های راه';

  @override
  String get travelerRoadCompleteCaption => 'به سلامت.';

  @override
  String get travelerRoadCaption =>
      'هر ذکر در جای خودش از سفر — ایستگاهی را که در آن هستید باز کنید.';

  @override
  String travelerShareVirtue(String virtue) {
    return 'فضیلت: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'منبع: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'صفر کردن شمارنده';

  @override
  String get travelerCounterDone => 'تمام';

  @override
  String get travelerCounterCount => 'شمارش';

  @override
  String get travelerCountDhikr => 'شمارش ذکر';

  @override
  String get travelerFlightPrayerTitle => 'اوقات نماز در هواپیما';

  @override
  String get travelerShowTimes => 'نمایش اوقات';

  @override
  String get travelerShowMap => 'نمایش نقشه';

  @override
  String get travelerShowList => 'نمایش فهرست';

  @override
  String get travelerSearchByFlightNumber => 'جستجو با شمارهٔ پرواز';

  @override
  String get travelerRunSearchNow => 'جستجو کن';

  @override
  String get travelerFlightAttemptsExhausted =>
      'تلاش‌ها تمام شد. برای تلاش دوباره صفحه را دوباره باز کنید.';

  @override
  String get travelerFlightNumberInvalid =>
      'شمارهٔ پرواز نادرست است. مثال: EK202 یا MS985';

  @override
  String get travelerFlightFetchFailed =>
      'در حال حاضر دریافت اطلاعات پرواز ممکن نیست.';

  @override
  String get travelerSourceMock => 'شبیه‌سازی محلی (بدون API)';

  @override
  String get travelerCityRiyadh => 'ریاض';

  @override
  String get travelerCityJeddah => 'جده';

  @override
  String get travelerCityDubai => 'دبی';

  @override
  String get travelerCityDoha => 'دوحه';

  @override
  String get travelerCityIstanbul => 'استانبول';

  @override
  String get travelerCityCairo => 'قاهره';

  @override
  String get travelerCityKualaLumpur => 'کوالالامپور';

  @override
  String get travelerCityLondon => 'لندن';

  @override
  String get travelerCityParis => 'پاریس';

  @override
  String get travelerCityNewYork => 'نیویورک';

  @override
  String get travelerAttemptsRemaining => 'تلاش‌های باقی‌مانده';

  @override
  String get travelerLiveTrack => 'مسیر زنده';

  @override
  String get travelerTakeoff => 'برخاستن';

  @override
  String get travelerLanding => 'فرود';

  @override
  String get travelerFlightEnded =>
      'پرواز به پایان رسید — وقت نمازی در طول پرواز باقی نمانده است.';

  @override
  String get travelerNoPrayerDuringFlight =>
      'در طول این پرواز وقت هیچ نمازی نمی‌رسد.';

  @override
  String get travelerAllFlightPrayersPassed =>
      'همهٔ اوقات این پرواز گذشته است.';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return '$hours س و $minutes د دیگر';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقهٔ دیگر',
      one: '$count دقیقهٔ دیگر',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return '$prayer در هواپیما — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'نخستین نماز در هواپیما: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return '$time به وقت محل هواپیما ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane => 'به وقت محلیِ زیر هواپیما';

  @override
  String get travelerTapStopHint =>
      'روی هر ایستگاه بزنید تا جای آن را روی نقشه ببینید';

  @override
  String get travelerUpcoming => 'پیش رو';

  @override
  String get travelerNext => 'بعدی';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · گرینویچ $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader => 'جستجو با شمارهٔ پرواز';

  @override
  String get travelerRun => 'اجرا';

  @override
  String get travelerFlightSearchHint =>
      'شمارهٔ پرواز را بنویسید تا اوقات نماز را در طول مسیر محاسبه کنیم.';

  @override
  String get travelerFlightDetails => 'جزئیات پرواز';

  @override
  String get travelerFlightNumber => 'شمارهٔ پرواز';

  @override
  String get travelerFrom => 'از';

  @override
  String get travelerTo => 'به';

  @override
  String get travelerDataSource => 'منبع داده';

  @override
  String get travelerFlightTimeline => 'خط زمانی پرواز';

  @override
  String get travelerNoTimesDuringFlight =>
      'در طول این پرواز وقتی نمایش داده نشد.';

  @override
  String get travelerFlightNumberExample => 'مثال: EK202';

  @override
  String get travelerShowFullRoute => 'نمایش کامل مسیر';

  @override
  String get travelerZoomIn => 'بزرگ‌نمایی';

  @override
  String get travelerZoomOut => 'کوچک‌نمایی';

  @override
  String get travelerLocationFailed =>
      'تعیین موقعیت فعلی شما ممکن نشد. دوباره تلاش کنید.';

  @override
  String get travelerLocationServiceDisabled =>
      'سرویس موقعیت مکانی خاموش است. برای نمایش نتایج نزدیک آن را روشن کنید.';

  @override
  String get travelerLocationPermissionRequired =>
      'برای کارکرد این قابلیت باید مجوز موقعیت مکانی را بدهید.';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'مجوز موقعیت مکانی برای همیشه رد شده است. تنظیمات برنامه را باز کنید.';

  @override
  String get travelerPlacesFetchFailed =>
      'اکنون دریافت نتایج نزدیک ممکن نیست. دوباره تلاش کنید.';

  @override
  String get travelerExpandRadius => 'گسترش محدوده';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'همه در محدودهٔ $radius — پیکان جهت هر کدام را نشان می‌دهد.';
  }

  @override
  String get travelerRadius => 'محدوده';

  @override
  String get travelerNearestPlaces => 'نزدیک‌ترین مکان‌ها';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتیجه در نزدیکی شما پیدا شد',
      one: '$count نتیجه در نزدیکی شما پیدا شد',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'خطای غیرمنتظره‌ای رخ داد';

  @override
  String get travelerHalalRestricted =>
      'جستجوی رستوران حلال در کشورهای اسلامی نمایش داده نمی‌شود،\nچون رستوران‌های آن‌جا از اساس حلال‌اند.';

  @override
  String get travelerOpenMapsFailed => 'باز کردن برنامهٔ نقشه ممکن نشد.';

  @override
  String get travelerNearestMosque => 'نزدیک‌ترین مسجد به شما';

  @override
  String get travelerNearestRestaurant => 'نزدیک‌ترین رستوران حلال';

  @override
  String get travelerTakeMeThere => 'مرا به آن‌جا ببر';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'به نماز $prayer می‌رسید — $count دقیقه مانده',
      one: 'به نماز $prayer می‌رسید — $count دقیقه مانده',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'شاید پیاده به نماز $prayer نرسید — $count دقیقه مانده',
      one: 'شاید پیاده به نماز $prayer نرسید — $count دقیقه مانده',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'باز کردن در نقشهٔ گوگل';

  @override
  String get travelerTapMarkerHint => 'برای دیدن جزئیات روی نشانگر بزنید';

  @override
  String get travelerOpenPhoneFailed => 'باز کردن برنامهٔ تماس ممکن نشد.';

  @override
  String get travelerOpenLinkFailed => 'باز کردن پیوند ممکن نشد.';

  @override
  String get travelerDirections => 'مسیریابی';

  @override
  String get travelerGoogleMaps => 'نقشهٔ گوگل';

  @override
  String get travelerCall => 'تماس';

  @override
  String get travelerUpdating => 'در حال به‌روزرسانی…';

  @override
  String travelerResultsCount(int count) {
    return 'تعداد نتایج: $count';
  }

  @override
  String get travelerMyCurrentLocation => 'موقعیت فعلی من';

  @override
  String get travelerMaps => 'نقشه‌ها';

  @override
  String get travelerMyLocation => 'موقعیت من';

  @override
  String get qiblahTitle => 'قبله';

  @override
  String get qiblahRefreshTooltip => 'به‌روزرسانی جهت';

  @override
  String get qiblahErrorNoSensor =>
      'دستگاه شما از حسگر جهت‌یابی پشتیبانی نمی‌کند';

  @override
  String get qiblahErrorPermissionRequired =>
      'برای تعیین جهت قبله باید دسترسی به موقعیت مکانی را مجاز کنید';

  @override
  String qiblahErrorGeneric(String error) {
    return 'خطا در تعیین جهت قبله: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'سرویس موقعیت مکانی خاموش است. لطفاً آن را از تنظیمات روشن کنید';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'مجوزهای موقعیت مکانی برای همیشه رد شده است. لطفاً آن را از تنظیمات برنامه فعال کنید';

  @override
  String get qiblahErrorLocationFailed => 'دریافت موقعیت فعلی ناموفق بود';

  @override
  String get qiblahUnknownLocation => 'موقعیت نامعلوم';

  @override
  String qiblahErrorDirection(String error) {
    return 'خطا در تعیین جهت: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'آغاز ردیابی جهت ناموفق بود';

  @override
  String get qiblahLocating => 'در حال تعیین موقعیت...';

  @override
  String get qiblahAligned => 'رو به قبله هستید';

  @override
  String qiblahTurnLeft(int degrees) {
    return '$degrees° به چپ بچرخید';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return '$degrees° به راست بچرخید';
  }

  @override
  String get qiblahLoadingTitle => 'در حال تعیین جهت قبله';

  @override
  String get qiblahLoadingSubtitle =>
      'مطمئن شوید موقعیت مکانی روشن است و مجوزها داده شده‌اند';

  @override
  String get qiblahHintAligned =>
      'دستگاه را ثابت نگه دارید؛ پیکان روی نشانهٔ قبله است';

  @override
  String get qiblahHintMove =>
      'دستگاه را آرام حرکت دهید تا پیکان به نشانه برسد';

  @override
  String get qiblahReadingsHeader => 'خوانش قطب‌نما';

  @override
  String get qiblahCurrentHeading => 'جهت فعلی شما';

  @override
  String get qiblahAngle => 'زاویهٔ قبله';

  @override
  String get qiblahCurrentLocation => 'موقعیت فعلی شما';

  @override
  String get qiblahDistanceToMecca => 'فاصله تا مکه';

  @override
  String qiblahDistanceKm(int km) {
    return '$km کیلومتر';
  }

  @override
  String get qiblahInstructionsHeader => 'راهنمای استفاده';

  @override
  String get qiblahInstructions =>
      '• گوشی را صاف و روبه‌روی خود نگه دارید.\n• آرام بچرخید تا پیکان طلایی به نشانهٔ بالایی برسد.\n• هنگام هم‌راستایی، حلقه روشن می‌شود و لرزش ملایمی حس می‌کنید.\n• اجسام فلزی را از گوشی دور کنید.\n• اگر نشانگر ناپایدار شد، گوشی را به شکل عدد ۸ حرکت دهید.';

  @override
  String get qiblahCompassNorth => 'شمال';

  @override
  String get qiblahCompassEast => 'شرق';

  @override
  String get qiblahCompassSouth => 'جنوب';

  @override
  String get qiblahCompassWest => 'غرب';

  @override
  String get homeSectionYourDay => 'روز شما';

  @override
  String get homeSectionAyah => 'آیه‌ای از قرآن';

  @override
  String get homeSectionFeatures => 'امکانات';

  @override
  String get homeSectionKids => 'بخش کودکان';

  @override
  String get homeYoungMuslimTitle => 'مسلمان کوچک';

  @override
  String get homeYoungMuslimSubtitle => 'داستان، آداب و اذکار برای کودک';

  @override
  String homeUpdateAvailable(String version) {
    return 'به‌روزرسانی جدید موجود است · نسخهٔ $version';
  }

  @override
  String get homeUpdateAction => 'به‌روزرسانی';

  @override
  String get homeContinueReading => 'ادامهٔ قرائت';

  @override
  String get homeStartReading => 'شروع قرائت';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · صفحهٔ $page';
  }

  @override
  String get homeStartReadingPosition => 'از سورهٔ فاتحه · صفحهٔ ۱';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · آیهٔ $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'آیهٔ $number';
  }

  @override
  String get homeAnotherAyah => 'آیهٔ دیگر';

  @override
  String get homeReadInMushaf => 'خواندن در مصحف';

  @override
  String get homeTrackerComplete => 'نمازهای امروز را کامل کردید، تقبل الله';

  @override
  String get homeTrackerPrompt => 'نمازهایی را که امروز خوانده‌اید علامت بزنید';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$count از $total';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز پیاپی',
      one: '$days روز پیاپی',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'خانه';

  @override
  String get homeNavSections => 'بخش‌ها';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '  $prayer : $time  \n زمان باقی‌مانده : $remaining ';
  }

  @override
  String get prayerTimeHighLatAuto => 'خودکار';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'تنظیم را به مقدار پیش‌فرض روش محاسبه می‌سپارد.';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'نیمه‌شب';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'صبح پیش از نیمه‌شب نمی‌افتد و عشا از آن دیرتر نمی‌شود.';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'یک‌هفتم شب';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'برای صبح بر یک‌هفتم پایانی شب و برای عشا بر یک‌هفتم آغازین آن تکیه دارد.';

  @override
  String get prayerTimeHighLatTwilightAngle => 'زاویهٔ شفق';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'شب را بر اساس زاویه‌های انتخاب‌شدهٔ صبح و عشا تقسیم می‌کند.';

  @override
  String get prayerTimeIshaModeAngle => 'عشا با زاویه';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'عشا با زاویهٔ خورشید زیر افق محاسبه می‌شود.';

  @override
  String get prayerTimeIshaModeInterval => 'عشا با فاصلهٔ زمانی';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'عشا با تعداد دقیقهٔ ثابت پس از مغرب محاسبه می‌شود.';

  @override
  String get prayerTimeMethodUmmAlQura => 'ام‌القری - مکهٔ مکرمه';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'رابطهٔ جهان اسلام';

  @override
  String get prayerTimeMethodEgyptian => 'سازمان عمومی نقشه‌برداری مصر';

  @override
  String get prayerTimeMethodKarachi => 'دانشگاه علوم اسلامی - کراچی';

  @override
  String get prayerTimeMethodDubai => 'دبی';

  @override
  String get prayerTimeMethodQatar => 'قطر';

  @override
  String get prayerTimeMethodKuwait => 'کویت';

  @override
  String get prayerTimeMethodSingapore => 'سنگاپور';

  @override
  String get prayerTimeMethodTurkey => 'دیانت - ترکیه';

  @override
  String get prayerTimeMethodTehran => 'مؤسسهٔ ژئوفیزیک دانشگاه تهران';

  @override
  String get prayerTimeMethodMoonSighting => 'کمیتهٔ رؤیت هلال';

  @override
  String get prayerTimeMethodNorthAmerica =>
      'انجمن اسلامی آمریکای شمالی (ISNA)';

  @override
  String get prayerTimeMethodCustom => 'تنظیم سفارشی';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'صبح 18.5° و عشا ۹۰ دقیقه پس از مغرب.';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'صبح 18° و عشا 17°.';

  @override
  String get prayerTimeMethodEgyptianDesc => 'صبح 19.5° و عشا 17.5°.';

  @override
  String get prayerTimeMethodKarachiDesc => 'صبح 18° و عشا 18°.';

  @override
  String get prayerTimeMethodDubaiDesc => 'صبح و عشا 18.2°.';

  @override
  String get prayerTimeMethodQatarDesc => 'صبح 18° و عشا ۹۰ دقیقه پس از مغرب.';

  @override
  String get prayerTimeMethodKuwaitDesc => 'صبح 18° و عشا 17.5°.';

  @override
  String get prayerTimeMethodSingaporeDesc => 'صبح 20° و عشا 18°.';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'صبح 18° و عشا 17° با تعدیلات دیانت.';

  @override
  String get prayerTimeMethodTehranDesc => 'صبح 17.7°، عشا 14° و مغرب 4.5°.';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'صبح 18° و عشا 18° با تعدیلات فصلی.';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'صبح 15° و عشا 15°.';

  @override
  String get prayerTimeMethodCustomDesc =>
      'زاویه‌های صبح، عشا و مغرب را خودتان تعیین کنید.';

  @override
  String get prayerTimeMadhabShafi => 'شافعی، مالکی و حنبلی';

  @override
  String get prayerTimeMadhabHanafi => 'حنفی';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'عصر وقتی است که سایهٔ هر چیز به اندازهٔ خودش شود؛ مالکی و حنبلی نیز همین نظر را دارند.';

  @override
  String get prayerTimeMadhabHanafiDesc =>
      'عصر وقتی است که سایهٔ هر چیز دو برابر خودش شود.';

  @override
  String get prayerTimeCalcIntro =>
      'تقویمی را که مرجع محلی شما به کار می‌برد انتخاب کنید و در صورت نیاز، اوقات را برای هماهنگی با مسجد محل دستی تنظیم کنید.';

  @override
  String get prayerTimeCalcMethod => 'روش محاسبه';

  @override
  String get prayerTimeCalcAsrMadhab => 'مذهب محاسبهٔ عصر';

  @override
  String get prayerTimeMadhabShafiShort => 'شافعی';

  @override
  String get prayerTimeCalcHighLatitude => 'عرض‌های جغرافیایی بالا';

  @override
  String get prayerTimeCalcRamadanIsha => 'تأخیر عشا در رمضان';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'در تمام ماه، مانند تقویم ام‌القری، ۳۰ دقیقه به عشا اضافه می‌کند.';

  @override
  String get prayerTimeCalcRestoreDefaults => 'بازگردانی تنظیمات ام‌القری';

  @override
  String get prayerTimeCalcCustomAngles => 'زاویه‌های محاسبهٔ سفارشی';

  @override
  String get prayerTimeCalcFajrAngle => 'زاویهٔ صبح';

  @override
  String get prayerTimeCalcIshaMode => 'محاسبهٔ عشا';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'یا با زاویهٔ شفق، یا با فاصلهٔ ثابت پس از مغرب.';

  @override
  String get prayerTimeCalcIshaAngle => 'زاویهٔ عشا';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'عشا پس از مغرب';

  @override
  String get prayerTimeCalcMaghribAngleToggle => 'زاویهٔ مغرب به‌جای غروب';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'برای کسانی که مغرب را با زاویهٔ شفق حساب می‌کنند، نه لحظهٔ غروب.';

  @override
  String get prayerTimeCalcMaghribAngle => 'زاویهٔ مغرب';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value د';
  }

  @override
  String get prayerTimeMinutesZero => '۰ د';

  @override
  String get prayerTimeCalcManualAdjust => 'تنظیم دستی هر وقت';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'اوقات را دقیقه به دقیقه با مسجد محل هماهنگ کنید';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وقت دستی تنظیم شده',
      one: '$count وقت دستی تنظیم شده',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'نماز';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return 'اذان $prayer';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return 'اذان $prayer • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'حی علی الصلاة — روزت را با نور صبح آغاز کن.';

  @override
  String get prayerTimeAthanBodyDhuhr => 'آن را آرامشی برای دل قرار بده.';

  @override
  String get prayerTimeAthanBodyAsr => 'حضورت را با خدا تازه کن.';

  @override
  String get prayerTimeAthanBodyMaghrib =>
      'روزت را با طاعت و آرامش به پایان ببر.';

  @override
  String get prayerTimeAthanBodyIsha => 'آخرین نماز روز را از دست نده.';

  @override
  String get prayerTimeAthanBodyDefault => 'خداوند عبادتت را بپذیرد.';

  @override
  String get prayerTimeAthanExpandedHint =>
      'برای باز کردن هشدار نماز و جزئیات بزنید.';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return 'اکنون وقت اذان $prayer است';
  }

  @override
  String get prayerTimeAlertNow => 'اکنون وقت نماز است';

  @override
  String get prayerTimeAlertMessage =>
      'نمازت را با خشوع به‌پا دار؛ که نور دل و آرامش جان است.';

  @override
  String get prayerTimeAlertReady => 'برای نماز آماده‌ام';

  @override
  String get prayerTimeAlertOpenTimes => 'باز کردن صفحهٔ اوقات نماز';

  @override
  String get prayerTimeTitle => 'اوقات نماز';

  @override
  String get prayerTimeSettingsTitle => 'تنظیمات اوقات نماز';

  @override
  String get prayerTimeSheetAthanTime => 'وقت اذان';

  @override
  String get prayerTimeSheetUntilDhuhr => 'تا ظهر';

  @override
  String get prayerTimeSheetWindow => 'مدت وقت';

  @override
  String get prayerTimeSheetShift => 'تفاوت با امروز';

  @override
  String get prayerTimeWeekdaySat => 'ش';

  @override
  String get prayerTimeWeekdaySun => 'ی';

  @override
  String get prayerTimeWeekdayMon => 'د';

  @override
  String get prayerTimeWeekdayTue => 'س';

  @override
  String get prayerTimeWeekdayWed => 'چ';

  @override
  String get prayerTimeWeekdayThu => 'پ';

  @override
  String get prayerTimeWeekdayFri => 'ج';

  @override
  String get prayerTimeLessThanMinute => 'کمتر از یک دقیقه';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours س';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String get prayerTimeShiftSameDay => 'همان روز';

  @override
  String get prayerTimeShiftNone => 'بدون تفاوت';

  @override
  String prayerTimeShiftLater(int minutes) {
    return '$minutes د دیرتر';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return '$minutes د زودتر';
  }

  @override
  String get prayerTimeAm => 'ق.ظ';

  @override
  String get prayerTimePm => 'ب.ظ';

  @override
  String get prayerTimeLocationSourceManual => 'انتخاب دستی';

  @override
  String get prayerTimeLocationSourceDevice => 'موقعیت دستگاه';

  @override
  String get prayerTimeLocationPickHint =>
      'شهری انتخاب کنید یا از موقعیت دستگاه استفاده کنید';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'هنوز موقعیتی تعیین نشده است';

  @override
  String get prayerTimeMyLocation => 'موقعیت فعلی من';

  @override
  String get prayerTimeGrantPermission => 'دادن مجوز';

  @override
  String get prayerTimeEmptyWeekTitle =>
      'موقعیت خود را تعیین کنید تا جدول هفته نمایش داده شود';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'شهر خود را جستجو کنید یا از موقعیت دستگاه استفاده کنید';

  @override
  String get prayerTimeSetLocation => 'تعیین موقعیت';

  @override
  String get prayerTimeWeekNeedsCity =>
      'برای دیدن اوقات کل هفته، شهر خود را تعیین کنید';

  @override
  String get prayerTimeWeekHint =>
      'برای روزهای دیگر جدول را افقی بکشید · برای جزئیات روی هر وقت بزنید';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'قیام شب · $day';
  }

  @override
  String get prayerTimeMidnight => 'نیمه‌شب';

  @override
  String get prayerTimeMidnightHint => 'میانهٔ مغرب تا صبح';

  @override
  String get prayerTimeLastThird => 'ثلث آخر شب';

  @override
  String get prayerTimeLastThirdHint => 'بهترین وقت قیام و دعا';

  @override
  String get prayerTimeLocationHeader => 'موقعیت';

  @override
  String get prayerTimeLocationUpdateFailed =>
      'به‌روزرسانی موقعیت فعلی ممکن نشد.';

  @override
  String get prayerTimeToday => 'امروز';

  @override
  String get prayerTimeTomorrow => 'فردا';

  @override
  String get prayerTimeTablePrayerColumn => 'نماز';

  @override
  String get prayerTimeSettingsCalcHeader => 'روش محاسبهٔ اوقات';

  @override
  String get prayerTimeSettingsSilentHeader => 'بی‌صدا هنگام نماز';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'برای کارکرد این قابلیت، ابتدا مجوز «مزاحم نشوید» را بدهید.';

  @override
  String get prayerTimeSettingsSaved => 'تنظیمات اوقات نماز ذخیره شد.';

  @override
  String get prayerTimeSilentHint =>
      'در وقت نماز دستگاه را بی‌صدا می‌کند و سپس صدا را خودکار برمی‌گرداند.';

  @override
  String get prayerTimeSilentEnable => 'بی‌صدا شدن خودکار';

  @override
  String get prayerTimeSilentPermissionNote =>
      'این قابلیت به مجوز «مزاحم نشوید» سیستم نیاز دارد.';

  @override
  String get prayerTimeSilentDuration => 'مدت بی‌صدا پس از نماز';

  @override
  String get prayerTimeMinutesSuffix => 'د';

  @override
  String get prayerTimeSaving => 'در حال ذخیره';

  @override
  String get prayerTimeSaveSettings => 'ذخیرهٔ تنظیمات';

  @override
  String get prayerTimeSavedLocation => 'موقعیت ذخیره‌شده';

  @override
  String get prayerTimePickerMapPointLabel => 'نقطهٔ انتخاب‌شده روی نقشه';

  @override
  String get prayerTimePickerResolving =>
      'در حال خواندن نام موقعیت انتخاب‌شده...';

  @override
  String get prayerTimePickerTapMap => 'برای تعیین منطقه روی نقشه بزنید';

  @override
  String get prayerTimePickerTitle => 'انتخاب منطقه';

  @override
  String get prayerTimePickerSubtitle =>
      'جستجو کنید یا نقطه‌ای روی نقشه انتخاب کنید';

  @override
  String get prayerTimePickerUsingDevice =>
      'در حال استفاده از موقعیت دستگاه...';

  @override
  String get prayerTimePickerUseDevice => 'استفاده از موقعیت فعلی دستگاه';

  @override
  String get prayerTimePickerMapTab => 'نقشه';

  @override
  String get prayerTimePickerSearchHint => 'نام شهر یا کشور';

  @override
  String get prayerTimePickerNoResults => 'نتیجهٔ مطابقی پیدا نشد';

  @override
  String get prayerTimePickerStartTyping => 'نام شهر را تایپ کنید';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'برای انتخاب منطقه روی نقشه بزنید';

  @override
  String get prayerTimePickerApplying => 'در حال اعمال';

  @override
  String get prayerTimePickerApply => 'تأیید';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'نماز فعلی: $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'نماز بعدی: $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'روشن کردن موقعیت مکانی';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'پیش از تعیین منطقه نمی‌توان اوقات نماز را نمایش داد';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'شهری را دستی انتخاب کنید یا از موقعیت فعلی دستگاه استفاده کنید';

  @override
  String get prayerTimeTimelineChooseArea => 'انتخاب منطقه';

  @override
  String get prayerTimeNow => 'اکنون';

  @override
  String get prayerTimeNextBadge => 'بعدی';

  @override
  String get prayerTimeRowNext => 'نماز بعدی';

  @override
  String get prayerTimeRowCompleted => 'وقتش گذشته';

  @override
  String get prayerTimeRowLocalTime => 'وقت محلی';

  @override
  String get prayerTimeLoadingTimes => 'در حال بارگیری اوقات';

  @override
  String get prayerTimeLocatingShort => 'در حال تعیین موقعیت';

  @override
  String get prayerTimeNoticeUnavailable =>
      'برای نمایش دقیق اوقات نماز، موقعیت مکانی را روشن کنید یا مجوز بدهید.';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'اوقات فعلی از آخرین موقعیت ذخیره‌شده استفاده می‌کند. برای به‌روزرسانی خودکار، موقعیت مکانی را روشن کنید.';

  @override
  String get prayerTimeNoticeServiceOff =>
      'سرویس موقعیت مکانی خاموش است. برای نمایش اوقات نماز بر اساس موقعیت فعلی، آن را روشن کنید.';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'اوقات فعلی از آخرین موقعیت ذخیره‌شده استفاده می‌کند. برای به‌روزرسانی، دسترسی به موقعیت مکانی را مجاز کنید.';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'مجوز موقعیت مکانی داده نشده است. برای نمایش اوقات بر اساس موقعیت فعلی، آن را مجاز کنید.';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'اوقات فعلی از آخرین موقعیت ذخیره‌شده استفاده می‌کند. برای فعال‌سازی دوبارهٔ مجوز موقعیت، تنظیمات را باز کنید.';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'مجوز موقعیت مکانی برای همیشه رد شده است. برای نمایش دقیق اوقات، تنظیمات را باز کنید و آن را فعال کنید.';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'اکنون به‌روزرسانی موقعیت ممکن نشد؛ بنابراین از آخرین موقعیت ذخیره‌شده استفاده می‌شود.';

  @override
  String get prayerTimeNoticeError =>
      'در حال حاضر تعیین موقعیت ممکن نیست. برای نمایش اوقات، موقعیت مکانی را روشن کنید یا مجوز بدهید.';

  @override
  String get prayerTimeOpenSettings => 'باز کردن تنظیمات';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return 'اکنون وقت $prayer است';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return '$prayer کمتر از یک دقیقهٔ دیگر';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقیقهٔ دیگر',
      one: '$minutes دقیقهٔ دیگر',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ساعت دیگر',
      one: '$hours ساعت دیگر',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer $hours س $minutes د دیگر';
  }

  @override
  String get prayerTimeRemainingNow => 'وقتش رسید';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return '$minutes د مانده';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return '$hours س مانده';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return '$hours س $minutes د مانده';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'موقعیت فعلی';

  @override
  String get prayerTimeYouAreInTime => 'اکنون در وقت';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · تقویم ام‌القری';
  }

  @override
  String get prayerTimeAllTimes => 'همهٔ اوقات';

  @override
  String get prayerTimeMuteAthan => 'بی‌صدا کردن اذان این نماز';

  @override
  String get prayerTimeUnmuteAthan => 'فعال کردن اذان این نماز';

  @override
  String get prayerTimeQuickMushaf => 'مصحف';

  @override
  String get prayerTimeQuickPrayerTimes => 'اوقات نماز';

  @override
  String get prayerTimeQuickAdhkar => 'کتابخانهٔ اذکار';

  @override
  String get prayerTimeErrorLoad => 'در حال حاضر بارگیری اوقات نماز ممکن نیست';

  @override
  String get prayerTimeErrorUpdateArea =>
      'به‌روزرسانی منطقهٔ انتخاب‌شده ممکن نشد';

  @override
  String get prayerTimeErrorApplySettings =>
      'به‌روزرسانی اوقات با تنظیمات جدید ممکن نشد';

  @override
  String get prayerTimeErrorServiceOff =>
      'سرویس موقعیت مکانی خاموش است. آن را روشن کنید یا شهری را دستی انتخاب کنید.';

  @override
  String get prayerTimeErrorPermission =>
      'باید مجوز موقعیت مکانی را بدهید یا شهری را دستی انتخاب کنید.';

  @override
  String get prayerTimeErrorDeniedForever =>
      'مجوز موقعیت مکانی برای همیشه رد شده است. تنظیمات را باز کنید یا شهری انتخاب کنید.';

  @override
  String get prayerTimeErrorDeviceLocation =>
      'در حال حاضر تعیین موقعیت دستگاه ممکن نیست';

  @override
  String get homeWidgetsPinFailed =>
      'باز کردن پنجرهٔ افزودن ممکن نشد. آن را دستی از صفحهٔ اصلی اضافه کنید.';

  @override
  String get homeWidgetsSyncSuccess => 'ویجت‌ها به‌روز شدند';

  @override
  String get homeWidgetsSyncFailed =>
      'به‌روزرسانی ممکن نشد. مطمئن شوید موقعیتتان تعیین شده است.';

  @override
  String get homeWidgetsAddTooltip => 'افزودن به صفحهٔ اصلی';

  @override
  String get homeWidgetsTitle => 'ویجت‌های صفحهٔ اصلی';

  @override
  String get homeWidgetsHowToHeader => 'روش افزودن';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'دکمهٔ افزودن کنار ویجت را بزنید، یا روی فضای خالی صفحهٔ اصلی انگشت خود را نگه دارید، سپس «ابزارک‌ها» را بزنید و «$appName» را جستجو کنید.';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'روی فضای خالی صفحهٔ اصلی انگشت خود را نگه دارید، سپس دکمهٔ «+» بالای صفحه را بزنید و «$appName» را جستجو کنید. ویجت نماز بعدی برای صفحهٔ قفل هم در دسترس است.';
  }

  @override
  String get homeWidgetsListHeader => 'ویجت‌ها';

  @override
  String get homeWidgetsNextPrayerTitle => 'نماز بعدی';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'نام و وقت نماز با شمارش معکوس زنده';

  @override
  String get homeWidgetsNextPrayerSubtitleIos => 'کوچک · و صفحهٔ قفل در سه شکل';

  @override
  String get homeWidgetsTodayTimesTitle => 'اوقات امروز';

  @override
  String get homeWidgetsTodayTimesSubtitle =>
      'شش وقت نماز با تاریخ هجری قمری و شهر';

  @override
  String get homeWidgetsDailyAyahTitle => 'آیهٔ روز';

  @override
  String get homeWidgetsDailyAyahSubtitle =>
      'آیه‌ای کوتاه که هر روز تازه می‌شود';

  @override
  String get homeWidgetsSyncHeader => 'همگام‌سازی';

  @override
  String get homeWidgetsSyncNow => 'به‌روزرسانی ویجت‌ها';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '$days روز',
    );
    return 'اوقات $_temp0 را با موقعیت و تنظیمات فعلی شما محاسبه می‌کند';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '$days روز',
    );
    return 'ویجت‌ها $_temp0 بدون باز کردن برنامه کار می‌کنند و خودکار در پس‌زمینه تازه می‌شوند. با تغییر موقعیت یا روش محاسبه، خودشان به‌روز می‌شوند.';
  }

  @override
  String get settingsDeveloperName => 'معتصم الهلالی';

  @override
  String get settingsUpdateStarting => 'در حال آغاز به‌روزرسانی برنامه...';

  @override
  String get settingsUpdateUpToDate =>
      'از جدیدترین نسخهٔ برنامه استفاده می‌کنید.';

  @override
  String get settingsUpdateCheckFailed =>
      'بررسی به‌روزرسانی ممکن نشد؛ بعداً تلاش کنید.';

  @override
  String get settingsGroupPreferences => 'ترجیحات';

  @override
  String get settingsDarkModeTitle => 'حالت تیره';

  @override
  String get settingsStatusOn => 'روشن';

  @override
  String get settingsStatusOff => 'خاموش';

  @override
  String get settingsNotificationsTitle => 'تنظیمات اعلان‌ها';

  @override
  String get settingsNotificationsSubtitle =>
      'هر اعلانی را که از برنامه دریافت می‌کنید مدیریت کنید';

  @override
  String get settingsDownloadsTitle => 'تنظیمات دانلود';

  @override
  String get settingsDownloadsSubtitle =>
      'مدیریت فایل‌های دانلودشده و فضای ذخیره‌سازی';

  @override
  String get settingsGroupApp => 'برنامه';

  @override
  String get settingsCheckUpdatesTitle => 'بررسی به‌روزرسانی';

  @override
  String get settingsCheckUpdatesSubtitle =>
      'مطمئن شوید از جدیدترین نسخه استفاده می‌کنید';

  @override
  String get settingsAboutUsTitle => 'دربارهٔ ما';

  @override
  String get settingsAboutUsSubtitle =>
      'با برنامهٔ طمأنينة و رسالت آن آشنا شوید';

  @override
  String get settingsRateAppTitle => 'به برنامه امتیاز دهید';

  @override
  String get settingsRateAppSubtitle =>
      'با امتیازدادن در فروشگاه، در نشر خیر سهیم شوید';

  @override
  String get settingsGroupPrivacy => 'حریم خصوصی و امنیت';

  @override
  String get settingsPrivacyPolicyTitle => 'سیاست حفظ حریم خصوصی';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'برنامه چگونه با داده‌ها و مجوزهای شما رفتار می‌کند';

  @override
  String get settingsDataSafetyTitle => 'امنیت داده‌ها';

  @override
  String get settingsDataSafetySubtitle =>
      'خلاصهٔ داده‌ها و مجوزها و نحوهٔ استفاده از آن‌ها';

  @override
  String get settingsGroupDeveloper => 'توسعه‌دهنده';

  @override
  String get settingsAboutDeveloperTitle => 'دربارهٔ توسعه‌دهنده';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'اطلاعات و راه‌های ارتباط با توسعه‌دهنده';

  @override
  String get settingsDeveloperContactSubtitle =>
      'ارتباط مستقیم از طریق وب‌سایت یا واتساپ';

  @override
  String get settingsPersonalWebsite => 'وب‌سایت شخصی';

  @override
  String get settingsGroupFollowNews => 'آخرین اخبار را دنبال کنید';

  @override
  String get settingsSocialTelegram => 'تلگرام';

  @override
  String get settingsSocialWhatsapp => 'واتساپ';

  @override
  String get settingsSocialFacebook => 'فیسبوک';

  @override
  String get settingsSocialInstagram => 'اینستاگرام';

  @override
  String get settingsSocialTwitter => 'توییتر';

  @override
  String get settingsPrivacyIntro =>
      'اطلاعاتی روشن و مختصر دربارهٔ نحوهٔ برخورد برنامه با داده‌های شما.';

  @override
  String get settingsPrivacyMattersTitle => 'حریم خصوصی شما برای ما مهم است';

  @override
  String get settingsPrivacyMattersBody =>
      'در طمأنينة می‌کوشیم تجربهٔ استفاده از برنامه روشن و امن باشد. تنها از داده‌های ضروری برای اجرای امکانات برنامه و بهبود آن‌ها استفاده می‌کنیم و داده‌های کاربران را نمی‌فروشیم و برای اهداف تبلیغاتی به اشتراک نمی‌گذاریم.';

  @override
  String get settingsPrivacyDataUsedTitle =>
      'داده‌هایی که برنامه ممکن است استفاده کند';

  @override
  String get settingsPrivacyDataUsedBody =>
      'برنامه ممکن است از موقعیت مکانی برای محاسبهٔ اوقات نماز و قبله، از اعلان‌ها برای هشدار اذان و اذکار، از فضای ذخیره‌سازی برای نگهداری محتوای دانلودشده و تنظیمات محلی، و از مخاطبین تنها در قابلیت‌هایی که کاربر فعال می‌کند (مانند «همراه نماز صبح») استفاده کند.';

  @override
  String get settingsPrivacyControlTitle => 'کنترل داده‌های شما';

  @override
  String get settingsPrivacyControlBody =>
      'می‌توانید اعلان‌ها را از تنظیمات اعلان‌ها در برنامه غیرفعال یا ویرایش کنید و هر زمان مجوزهای سیستم را از تنظیمات دستگاه خود مدیریت کنید.';

  @override
  String get settingsPrivacyThirdPartyTitle => 'سرویس‌های خارجی';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'برنامه ممکن است از سرویس‌هایی مانند Firebase Remote Config و Firebase Messaging برای به‌روزرسانی تنظیمات و ارسال اعلان‌های عمومی استفاده کند. این سرویس‌ها فقط برای اجرای برنامه و بهبود تجربه به کار می‌روند.';

  @override
  String get settingsDataSafetyIntro =>
      'خلاصه‌ای از داده‌هایی که برنامه استفاده می‌کند و نحوهٔ نگهداری و اشتراک آن‌ها.';

  @override
  String get settingsDataSafetySensitiveTitle => 'داده‌های حساس';

  @override
  String get settingsDataSafetySensitiveBody =>
      'برنامه داده‌های حساس را فقط هنگام نیاز برای قابلیتی مشخص که کاربر انتخاب می‌کند درخواست می‌کند. برخی داده‌ها مانند زمان هشدارها، ترجیحات و برنامه‌های قرائت به‌صورت محلی روی دستگاه ذخیره می‌شوند.';

  @override
  String get settingsDataSafetyLocationTitle => 'موقعیت مکانی';

  @override
  String get settingsDataSafetyLocationBody =>
      'موقعیت مکانی برای محاسبهٔ اوقات نماز، جهت قبله و خدمات مبتنی بر مکان استفاده می‌شود. کاربر می‌تواند مجوز موقعیت را از تنظیمات سیستم غیرفعال کند.';

  @override
  String get settingsDataSafetyNotificationsTitle => 'اعلان‌ها';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'برنامه از اعلان‌ها برای اذان، اذکار، یادآورها و برخی پیام‌های عمومی برنامه استفاده می‌کند. هر نوع اعلان را می‌توان از صفحهٔ تنظیمات اعلان‌ها کنترل کرد.';

  @override
  String get settingsDataSafetyStorageTitle => 'ذخیره‌سازی و دانلود';

  @override
  String get settingsDataSafetyStorageBody =>
      'برنامه ممکن است از فضای ذخیره‌سازی برای نگهداری فایل‌ها و محتوایی که کاربر دانلود می‌کند، مانند صوتی‌ها یا مطالب موجود در برنامه، استفاده کند.';

  @override
  String get settingsDataSafetySharingTitle => 'اشتراک‌گذاری';

  @override
  String get settingsDataSafetySharingBody =>
      'داده‌های شخصی شما برای فروش یا بازاریابی با اشخاص ثالث به اشتراک گذاشته نمی‌شود. هر اشتراکی فقط در چارچوب سرویس‌های ضروری اجرای برنامه یا اقدامی است که خود کاربر آغاز می‌کند.';

  @override
  String get settingsAboutAppBody =>
      'برنامه‌ای قرآنی و عبادی که با آرامش و به شیوه‌ای نزدیک به کاربر، در نماز، ذکر، تلاوت قرآن و پایبندی به ورد روزانه یاری‌تان می‌کند.';

  @override
  String get settingsAboutMissionTitle => 'رسالت ما';

  @override
  String get settingsAboutMissionBody =>
      'این‌که برنامه همراهی سبک باشد که بی‌مزاحمت کاربر را در طاعت یاری کند و ابزارهای مهم روزانه مانند مصحف، اذکار، اوقات نماز، هشدارها و امکانات کمکی برای خانواده را یک‌جا گرد آورد.';

  @override
  String get settingsAboutOfferTitle => 'آنچه ارائه می‌دهیم';

  @override
  String get settingsAboutOfferBody =>
      'مصحف، اذکار، اوقات نماز، قبله، ورد روزانه، ویجت‌ها، همراه نماز صبح، مسلمان کوچک، خدمات مسافر و هشدارهای قابل تنظیم بر اساس نیاز کاربر.';

  @override
  String get settingsDeveloperHeroBody =>
      'مهندس نرم‌افزار Full Stack و Mobile با بیش از ۷ سال تجربه، متخصص در Flutter، Laravel و Next.js و ساخت برنامه‌های عملیاتی برای وب و موبایل.';

  @override
  String get settingsDeveloperBioTitle => 'معرفی کوتاه';

  @override
  String get settingsDeveloperBioBody =>
      'معتصم الهلالی برنامه‌ها و پلتفرم‌های دیجیتالی می‌سازد که به کاربران واقعی خدمت می‌کنند، با توجه ویژه به برنامه‌های موبایل، سیستم‌های بک‌اند، رابط‌های کاربری و پلتفرم‌های Fintech و SaaS.';

  @override
  String get settingsDeveloperFieldsTitle => 'حوزه‌های فعالیت';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter، Laravel، Next.js، React، API Development، برنامه‌های موبایل، برنامه‌های وب، راهکارهای Fintech و پلتفرم‌های SaaS.';

  @override
  String get settingsDeveloperContactTitle => 'راه‌های ارتباط';

  @override
  String get settingsContactWebsite => 'وب‌سایت';

  @override
  String get settingsContactEmail => 'ایمیل';

  @override
  String get settingsAppLinksTitle => 'پیوندهای برنامه';

  @override
  String get notifSettingsLabelAppNotifications => 'اعلان‌های برنامه';

  @override
  String get notifSettingsLabelAllAthan => 'اعلان همهٔ اذان‌ها';

  @override
  String notifSettingsAthanOf(String prayer) {
    return 'اذان $prayer';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'قیام شب';

  @override
  String get notifSettingsLabelThikrMorning => 'اذکار صبح';

  @override
  String get notifSettingsLabelThikrEvening => 'اذکار شامگاه';

  @override
  String get notifSettingsLabelThikrWakeUp => 'اذکار بیداری';

  @override
  String get notifSettingsLabelThikrSleep => 'اذکار خواب';

  @override
  String get notifSettingsLabelSalawat => 'صلوات بر محمد ﷺ';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'اذکار صوتی تصادفی';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'اذکار شناور و هشدارهای جایگزین';

  @override
  String get notifSettingsLabelDailyQuranWird => 'ورد قرآنی روزانه';

  @override
  String get notifSettingsLabelReadSurahMulk => 'خواندن سورهٔ ملک';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'خواندن سورهٔ مشخص';

  @override
  String get notifSettingsLabelReadSurahKahf => 'خواندن سورهٔ کهف';

  @override
  String get notifSettingsLabelFasting => 'یادآور روزه';

  @override
  String get notifSettingsLabelFastingMonday => 'روزهٔ دوشنبه';

  @override
  String get notifSettingsLabelFastingThursday => 'روزهٔ پنجشنبه';

  @override
  String get notifSettingsLabelBestDua =>
      'از بهترین دعاهای محبوب نزد خداوند سبحان با اثری بزرگ';

  @override
  String get notifSettingsLabelWirdMorning => 'ورد صبح';

  @override
  String get notifSettingsLabelWirdEvening => 'ورد شامگاه';

  @override
  String get notifSettingsLabelWirdNight => 'ورد پیش از خواب';

  @override
  String get notifSettingsLabelWirdSummary => 'خلاصهٔ ورد روزانه';

  @override
  String get notifSettingsLabelYoungMuslim => 'یادآور مسلمان کوچک';

  @override
  String get notifSettingsLabelQuranPlan => 'یادآور برنامه‌های قرآن';

  @override
  String get notifSettingsLabelGeneral => 'اعلان‌های عمومی برنامه';

  @override
  String get notifSettingsTitleRandomThikr => 'ذکر تصادفی';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'اذکار شناور';

  @override
  String get notifSettingsTitlePrayerAthan => 'اذان نماز';

  @override
  String get notifSettingsBodyThikrMorning => 'اذکار صبح را فراموش نکنید!';

  @override
  String get notifSettingsBodyThikrEvening => 'اذکار شامگاه را فراموش نکنید!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'وقت قیام شب است؛ از ثلث آخر شب بهره ببرید.';

  @override
  String get notifSettingsBodySalawat =>
      'بر پیامبر ﷺ صلوات بفرستید تا روزتان خوش باشد.';

  @override
  String get notifSettingsBodyRememberAllah =>
      'خدا را یاد کنید تا شما را یاد کند!';

  @override
  String get notifSettingsBodyReadQuran =>
      'برای ورد قرآنی روزانه‌تان وقت بگذارید.';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'خواندن سورهٔ ملک را امشب فراموش نکنید.';

  @override
  String get notifSettingsBodyThikrSleep =>
      'اذکار خواب پیش از آن‌که به خواب بروید.';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'روزتان را پس از بیداری با یاد خدا آغاز کنید.';

  @override
  String get notifSettingsBodyReadSurah =>
      'خواندن سوره‌ای را که انتخاب کرده‌اید امروز فراموش نکنید.';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'خواندن سورهٔ کهف را در روز جمعه فراموش نکنید.';

  @override
  String get notifSettingsBodyFasting => 'یادآور روزهٔ مستحبی.';

  @override
  String get notifSettingsBodyFastingMonday => 'یادآور روزهٔ دوشنبه.';

  @override
  String get notifSettingsBodyFastingThursday => 'یادآور روزهٔ پنجشنبه.';

  @override
  String get notifSettingsBodyAthanTime => 'اکنون وقت اذان است.';

  @override
  String get notifSettingsBodyWirdMorning =>
      'روزتان را با توشهٔ عبادی آغاز کنید.';

  @override
  String get notifSettingsBodyWirdEvening =>
      'پیوندتان را با خدا در توشهٔ شامگاه تازه کنید.';

  @override
  String get notifSettingsBodyWirdNight =>
      'روزتان را با ذکر و دعا به پایان ببرید.';

  @override
  String get notifSettingsBodyWirdSummary =>
      'توشهٔ عبادی امروزتان را مرور کنید.';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'یادآوری برای بازگشت به محتوای مسلمان کوچک.';

  @override
  String get notifSettingsBodyQuranPlan =>
      'جلسهٔ امروز برنامهٔ قرآنی‌تان را فراموش نکنید.';

  @override
  String get notifSettingsBodyGeneral =>
      'اعلان‌ها و هشدارهای عمومی برنامهٔ طمأنينة.';

  @override
  String get notifSettingsAllPrayers => 'همهٔ نمازها';

  @override
  String get notifSettingsSalawatShort => 'صلوات بر محمد';

  @override
  String get notifSettingsQuranWirdShort => 'ورد قرآنی';

  @override
  String get notifSettingsGroupGeneral => 'عمومی';

  @override
  String get notifSettingsGroupAthan => 'اذان';

  @override
  String get notifSettingsGroupDailyWird => 'ورد روزانه';

  @override
  String get notifSettingsGroupAdhkar => 'اذکار';

  @override
  String get notifSettingsGroupQuran => 'قرآن';

  @override
  String get notifSettingsGroupAppSections => 'بخش‌های برنامه';

  @override
  String get notifSettingsGroupNightAndWaking => 'شب و بیداری';

  @override
  String get notifSettingsGroupFasting => 'روزه';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'اذکار تکراری';

  @override
  String get notifSettingsGroupSystem => 'سیستم';

  @override
  String get notifSettingsMasterTitle => 'همهٔ اعلان‌های برنامه';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'اعلان‌ها فعال‌اند و می‌توانید هر نوع را در پایین تنظیم کنید';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'همهٔ اعلان‌ها تا فعال کردن این کلید متوقف‌اند';

  @override
  String get notifSettingsSystemTitle => 'اعلان‌های سیستم';

  @override
  String get notifSettingsSystemSubtitle =>
      'اعلان‌های زمان‌بندی‌شده و فعال روی دستگاهتان را ببینید';

  @override
  String get notifSettingsStatusStopped => 'متوقف';

  @override
  String get notifSettingsStatusEnabled => 'فعال';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'روزانه · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'هر ساعت در دقیقهٔ $minute';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count دقیقه',
      one: 'هر $count دقیقه',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => '، ';

  @override
  String get notifSettingsNoDaysSelected => 'بدون روز مشخص';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'هفتگی ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'زمان‌بندی سفارشی · $count زمان',
      one: 'زمان‌بندی سفارشی · $count زمان',
      zero: 'زمان‌بندی سفارشی · بدون زمان',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'زمان‌های هشدار';

  @override
  String get notifSettingsEditScheduleTitle => 'ویرایش زمان‌بندی';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'نوع تکرار و زمان هشدار را تغییر دهید';

  @override
  String get notifSettingsExtraSchedulesTitle => 'مدیریت زمان‌های اضافی';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'برای این اعلان بیش از یک زمان اضافه کنید';

  @override
  String get notifScheduleBodyAllAthan =>
      'هشدار همهٔ اذان‌ها در اوقات تعیین‌شده تکرار می‌شود.';

  @override
  String get notifScheduleBodyAthanFajr =>
      'اکنون وقت اذان صبح است؛ به سوی نماز بشتابید.';

  @override
  String get notifScheduleBodyAthanDhuhr => 'اکنون وقت اذان ظهر است.';

  @override
  String get notifScheduleBodyAthanAsr => 'اکنون وقت اذان عصر است.';

  @override
  String get notifScheduleBodyAthanMaghrib => 'اکنون وقت اذان مغرب است.';

  @override
  String get notifScheduleBodyAthanIsha => 'اکنون وقت اذان عشا است.';

  @override
  String get notifScheduleBodyMiddleNight =>
      'وقت قیام شب است! برخیزید و با خدای رحمان مناجات کنید.';

  @override
  String get notifScheduleBodyThikrMorning => 'اذکار صبح را فراموش نکنید!';

  @override
  String get notifScheduleBodyThikrEvening => 'اذکار شامگاه را فراموش نکنید!';

  @override
  String get notifScheduleBodySalawat =>
      'بر پیامبر گرامی ﷺ صلوات بفرستید؛ ده حسنه برایتان نوشته می‌شود.';

  @override
  String get notifScheduleBodyReadQuran =>
      'ورد قرآنی امروزتان را فراموش نکنید.';

  @override
  String get notifScheduleBodyReadSurahMulk =>
      'پیش از خواب سورهٔ ملک را بخوانید.';

  @override
  String get notifScheduleBodyThikrSleep =>
      'پیش از خواب اذکار خواب را بخوانید.';

  @override
  String get notifScheduleBodyThikrWakeUp =>
      'روزتان را با اذکار بیداری آغاز کنید.';

  @override
  String get notifScheduleBodyReadSurah =>
      'خواندن سورهٔ تعیین‌شده برای امروز را فراموش نکنید.';

  @override
  String get notifScheduleBodyReadSurahKahf => 'روز جمعه سورهٔ کهف را بخوانید.';

  @override
  String get notifScheduleBodyFasting =>
      'روزهٔ مستحبی پاداشی بزرگ دارد؛ این فرصت را از دست ندهید.';

  @override
  String get notifScheduleTitleRandomThikr => 'زمان‌بندی سفارشی اذکار تصادفی';

  @override
  String get notifScheduleValidateTime => 'ابتدا زمان هشدار را تعیین کنید';

  @override
  String get notifScheduleValidateMinute => 'دقیقه را در هر ساعت تعیین کنید';

  @override
  String get notifScheduleValidateWeekday =>
      'دست‌کم یک روز از هفته را انتخاب کنید';

  @override
  String get notifScheduleValidateInterval =>
      'تعداد دقیقه‌ها را وارد کنید (بزرگ‌تر از صفر)';

  @override
  String get notifScheduleValidateDate => 'دست‌کم یک تاریخ اضافه کنید';

  @override
  String get notifScheduleDetails => 'جزئیات';

  @override
  String get notifScheduleMinuteOfHourTitle => 'دقیقه در هر ساعت';

  @override
  String get notifScheduleMinuteOfHourSubtitle => 'عددی بین ۰ و ۵۹';

  @override
  String get notifScheduleMinuteUnit => 'دقیقه';

  @override
  String get notifScheduleRepeatTitle => 'تکرار';

  @override
  String get notifScheduleRepeatSubtitle => 'فاصلهٔ هر هشدار تا هشدار بعدی';

  @override
  String get notifScheduleCustomTime => 'زمان سفارشی';

  @override
  String get notifScheduleDeleteTime => 'حذف زمان';

  @override
  String get notifScheduleNoTimesYet => 'هنوز زمانی اضافه نکرده‌اید';

  @override
  String get notifScheduleAddTime => 'افزودن زمان';

  @override
  String get notifScheduleSaveSchedule => 'ذخیرهٔ زمان‌بندی';

  @override
  String get notifScheduleAddNewTitle => 'افزودن زمان جدید';

  @override
  String get notifScheduleEditTitle => 'ویرایش زمان';

  @override
  String get notifScheduleOptionalLabel => 'توضیح اختیاری';

  @override
  String get notifScheduleAddConfirm => 'افزودن زمان';

  @override
  String get notifScheduleSaveEdit => 'ذخیرهٔ ویرایش';

  @override
  String get notifScheduleTypeDaily => 'روزانه';

  @override
  String get notifScheduleTypeHourly => 'هر ساعت';

  @override
  String get notifScheduleTypeEveryNMinutes => 'هر چند دقیقه';

  @override
  String get notifScheduleTypeWeekly => 'هفتگی';

  @override
  String get notifScheduleTypeCustomDates => 'تاریخ‌های سفارشی';

  @override
  String get notifScheduleTypeDailyDesc => 'هر روز در همان زمان تکرار می‌شود';

  @override
  String get notifScheduleTypeHourlyDesc =>
      'هر ساعت در دقیقه‌ای مشخص تکرار می‌شود';

  @override
  String get notifScheduleTypeEveryNMinutesDesc =>
      'در فاصلهٔ زمانی دلخواه شما تکرار می‌شود';

  @override
  String get notifScheduleTypeWeeklyDesc =>
      'در روزهای مشخصی از هفته تکرار می‌شود';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'در تاریخ‌ها و ساعت‌هایی که انتخاب می‌کنید نمایش داده می‌شود';

  @override
  String get notifScheduleTypeTitle => 'نوع زمان‌بندی';

  @override
  String get notifScheduleTimeTitle => 'زمان هشدار';

  @override
  String get notifScheduleTimeSubtitle => 'برای انتخاب ساعت و دقیقه بزنید';

  @override
  String get notifScheduleLabelHint => 'توضیح کوتاهی برای این زمان اضافه کنید';

  @override
  String notifScheduleRowDaily(String time) {
    return 'هر روز · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'بدون روز';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count زمان سفارشی',
      one: '$count زمان سفارشی',
      zero: 'زمان سفارشی ندارد',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'دوشنبه';

  @override
  String get notifScheduleDayShort2 => 'سه‌شنبه';

  @override
  String get notifScheduleDayShort3 => 'چهارشنبه';

  @override
  String get notifScheduleDayShort4 => 'پنجشنبه';

  @override
  String get notifScheduleDayShort5 => 'جمعه';

  @override
  String get notifScheduleDayShort6 => 'شنبه';

  @override
  String get notifScheduleDayShort7 => 'یکشنبه';

  @override
  String get notifScheduleAllDays => 'همهٔ روزها';

  @override
  String get notifScheduleWorkDays => 'روزهای کاری';

  @override
  String get notifScheduleWeekend => 'تعطیلات آخر هفته';

  @override
  String get notifScheduleClear => 'پاک کردن';

  @override
  String get notifScheduleStatTotal => 'مجموع';

  @override
  String get notifScheduleStatEnabled => 'فعال';

  @override
  String get notifScheduleStatStopped => 'متوقف';

  @override
  String get notifScheduleUnexpectedError => 'خطای غیرمنتظره‌ای رخ داد';

  @override
  String get notifScheduleSaved => 'ذخیره شد';

  @override
  String get notifScheduleScreenTitle => 'زمان‌های اعلان';

  @override
  String get notifScheduleListTitle => 'زمان‌ها';

  @override
  String get notifScheduleEmpty =>
      'هنوز زمانی نیست — با دکمهٔ «افزودن زمان» یکی اضافه کنید.';

  @override
  String get notifScheduleDeleteTitle => 'حذف زمان';

  @override
  String get notifScheduleDeleteMessage =>
      'آیا از حذف این زمان مطمئنید؟\nهمهٔ اعلان‌های مرتبط با آن لغو می‌شود.';

  @override
  String get notifScheduleSaving => 'در حال ذخیره...';

  @override
  String get notifScheduleLoading => 'در حال بارگیری زمان‌ها...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'بارگیری زمان‌ها ناموفق بود: $error';
  }

  @override
  String get notifScheduleAdded => 'زمان با موفقیت اضافه شد';

  @override
  String notifScheduleAddFailed(String error) {
    return 'افزودن زمان ناموفق بود: $error';
  }

  @override
  String get notifScheduleUpdated => 'زمان با موفقیت به‌روز شد';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'به‌روزرسانی زمان ناموفق بود: $error';
  }

  @override
  String get notifScheduleDeleted => 'زمان با موفقیت حذف شد';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'حذف زمان ناموفق بود: $error';
  }

  @override
  String get notifScheduleActivated => 'زمان فعال شد';

  @override
  String get notifScheduleDeactivated => 'زمان غیرفعال شد';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'تغییر وضعیت زمان ناموفق بود: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'زمان‌بندی‌شده';

  @override
  String get notifSettingsNoScheduled =>
      'در حال حاضر اعلان زمان‌بندی‌شده‌ای وجود ندارد';

  @override
  String get notifSettingsShownNowGroup => 'در حال نمایش';

  @override
  String get notifSettingsNoShown =>
      'اعلانی در نوار اعلان‌ها نمایش داده نمی‌شود';

  @override
  String get notifSettingsUntitled => 'اعلان بی‌عنوان';

  @override
  String get notifSettingsDismiss => 'پنهان کردن اعلان';

  @override
  String get notifSettingsCancelNotification => 'لغو اعلان';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return 'اکنون وقت اذان $prayer است';
  }

  @override
  String get downloadTitle => 'دانلودها';

  @override
  String get downloadEmptyAll =>
      'هنوز دانلودی نیست؛ برای شروع یک دانلود اضافه کنید.';

  @override
  String get downloadEmptyActive => 'دانلود فعالی وجود ندارد';

  @override
  String get downloadEmptyCompleted => 'دانلود کامل‌شده‌ای وجود ندارد';

  @override
  String get downloadEmptyPaused => 'دانلود متوقف‌شده‌ای وجود ندارد';

  @override
  String get downloadEmptyFailed => 'دانلود ناموفقی وجود ندارد';

  @override
  String get downloadCancelAll => 'لغو همه';

  @override
  String get downloadCancelAllConfirm =>
      'آیا از لغو همهٔ دانلودهای فعال مطمئنید؟';

  @override
  String get downloadAdd => 'افزودن دانلود';

  @override
  String get downloadFilterAll => 'همه';

  @override
  String get downloadStatusActive => 'فعال';

  @override
  String get downloadStatusCompleted => 'کامل‌شده';

  @override
  String get downloadStatusPaused => 'متوقف';

  @override
  String get downloadStatusFailed => 'ناموفق';

  @override
  String get downloadStarted => 'دانلود آغاز شد';

  @override
  String get downloadAddNewTitle => 'افزودن دانلود جدید';

  @override
  String get downloadUrlLabel => 'پیوند فایل';

  @override
  String get downloadUrlRequired => 'لطفاً پیوند دانلود را وارد کنید';

  @override
  String get downloadUrlInvalid => 'لطفاً پیوند معتبری وارد کنید';

  @override
  String get downloadFileNameLabel => 'نام فایل';

  @override
  String get downloadOptional => 'اختیاری';

  @override
  String get downloadPublicStorageTitle => 'حافظهٔ عمومی';

  @override
  String get downloadPublicStorageSubtitle => 'ذخیره در پوشهٔ دانلودها';

  @override
  String get downloadAllowCellularTitle => 'اجازهٔ دادهٔ تلفن همراه';

  @override
  String get downloadAllowCellularSubtitle => 'دانلود با اینترنت همراه';

  @override
  String get downloadStart => 'شروع دانلود';

  @override
  String get downloadPause => 'توقف موقت';

  @override
  String get downloadResume => 'ادامه';

  @override
  String get downloadOpenFile => 'باز کردن فایل';

  @override
  String get downloadRemoveFromList => 'حذف از فهرست';

  @override
  String get downloadDeleteFile => 'حذف فایل';

  @override
  String get downloadTotal => 'مجموع';

  @override
  String get downloadInProgressNow => 'در حال دانلود';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'و $count مورد دیگر',
      one: 'و $count مورد دیگر',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'نماز بعدی';

  @override
  String get widgetLabelDailyAyah => 'آیهٔ روز';

  @override
  String get widgetLabelOpenApp => 'طمأنينة را باز کنید';

  @override
  String get widgetLabelSetLocation => 'موقعیت خود را در برنامه تعیین کنید';

  @override
  String get widgetLabelRefreshNeeded => 'برای به‌روزرسانی اوقات';

  @override
  String widgetLabelNextIn(String prayer) {
    return 'تا $prayer';
  }

  @override
  String get dailyWirdTitle => 'توشهٔ شبانه‌روز';

  @override
  String get dailyWirdSettingsTooltip => 'تنظیمات توشه';

  @override
  String get dailyWirdUnexpectedError => 'خطای غیرمنتظره‌ای رخ داد.';

  @override
  String get dailyWirdRemindersHeader => 'یادآورها';

  @override
  String get dailyWirdReminderSleepLabel => 'اذکار خواب';

  @override
  String get dailyWirdProgramHeader => 'برنامه';

  @override
  String get dailyWirdSaveSetup => 'ذخیرهٔ تنظیمات';

  @override
  String get dailyWirdSetupFailed => 'راه‌اندازی توشهٔ عبادی ممکن نشد.';

  @override
  String get dailyWirdItemNotFound => 'این مورد از توشهٔ عبادی پیدا نشد.';

  @override
  String get dailyWirdTodayTasksHeader => 'اعمال امروز';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'پیوستگی: $count روز',
      one: 'پیوستگی: $count روز',
      zero: 'پیوستگی: ۰ روز',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'پایبندی هفته $percent٪';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'توشهٔ عبادی خود را انتخاب کنید';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'با یک برنامهٔ آماده شروع کنید و سپس آن را به دلخواه تنظیم کنید';

  @override
  String get dailyWirdItemOptions => 'گزینه‌های عمل';

  @override
  String get dailyWirdEditTargetCount => 'ویرایش تعداد هدف';

  @override
  String get dailyWirdStartOver => 'شروع دوباره';

  @override
  String get dailyWirdMoveUp => 'انتقال به بالا';

  @override
  String get dailyWirdMoveDown => 'انتقال به پایین';

  @override
  String get dailyWirdHideItem => 'پنهان کردن از توشه';

  @override
  String get dailyWirdCountHint => 'مثال: ۵۰ بار';

  @override
  String get dailyWirdTimeMorning => 'صبح';

  @override
  String get dailyWirdTimeEvening => 'شامگاه';

  @override
  String get dailyWirdTimeNight => 'شب';

  @override
  String get dailyWirdTimeAny => 'هر زمان';

  @override
  String get dailyWirdTimeMorningLong => 'وقت صبح';

  @override
  String get dailyWirdTimeEveningLong => 'وقت شامگاه';

  @override
  String get dailyWirdTimeNightLong => 'پیش از خواب';

  @override
  String get dailyWirdTimeAnyLong => 'در هر زمان';

  @override
  String get dailyWirdTypeDhikrSet => 'اذکار';

  @override
  String get dailyWirdTypeCountedDhikr => 'ذکر شمارشی';

  @override
  String get dailyWirdTypeQuran => 'ورد قرآن';

  @override
  String get dailyWirdTypeDua => 'دعا';

  @override
  String get dailyWirdTypeSurah => 'سوره';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$done از $total';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return '$done از $total$unit را انجام دادید';
  }

  @override
  String get dailyWirdItemDone => 'انجام شد';

  @override
  String get dailyWirdMarkComplete => 'اتمام';

  @override
  String get dailyWirdCountOnce => 'شمارش یک بار';

  @override
  String get dailyWirdCompleteThis => 'اتمام این عمل';

  @override
  String get dailyWirdUncomplete => 'لغو اتمام';

  @override
  String get dailyWirdReminderMorningTitle => 'توشهٔ صبح';

  @override
  String get dailyWirdReminderMorningBody =>
      'روزتان را با یاد خدا، تلاوت کتابش و دعا آغاز کنید.';

  @override
  String get dailyWirdReminderEveningTitle => 'توشهٔ شامگاه';

  @override
  String get dailyWirdReminderEveningBody =>
      'پیوندتان را با خدا تازه کنید و آنچه از توشهٔ شامگاه میسر است به انجام برسانید.';

  @override
  String get dailyWirdReminderNightTitle => 'توشهٔ پیش از خواب';

  @override
  String get dailyWirdReminderNightBody =>
      'روزتان را با ذکر و دعا و باقی‌ماندهٔ توشهٔ عبادی‌تان به پایان ببرید.';

  @override
  String get dailyWirdReminderSummaryTitle => 'محاسبهٔ پایان روز';

  @override
  String get dailyWirdReminderSummaryBody =>
      'توشهٔ عبادی امروزتان را مرور کنید و ببینید چه مقدار از آن را انجام داده‌اید.';

  @override
  String get wirdMorningAdhkar => 'اذکار صبح';

  @override
  String get wirdEveningAdhkar => 'اذکار شامگاه';

  @override
  String get wirdMorningTitle => 'ورد صبحگاهی';

  @override
  String get wirdEveningTitle => 'ورد شامگاهی';

  @override
  String get wirdSearchHint => 'جستجوی ذکر';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'ذکر $current از $total';
  }

  @override
  String get wirdPrevious => 'قبلی';

  @override
  String get wirdNext => 'بعدی';

  @override
  String get wirdShowSingle => 'نمایش تک‌ذکر';

  @override
  String get wirdShowList => 'نمایش اذکار به‌صورت فهرست';

  @override
  String get wirdTypeMorningOnly => 'فقط صبح';

  @override
  String get wirdTypeEveningOnly => 'فقط شامگاه';

  @override
  String get wirdTypeBoth => 'صبح و شامگاه';

  @override
  String get wirdNoAudio => 'فایل صوتی وجود ندارد';

  @override
  String get wirdPause => 'توقف موقت';

  @override
  String get wirdReplay => 'پخش دوباره';

  @override
  String get wirdPlayAudio => 'پخش صدا';

  @override
  String wirdRemaining(int remaining, int total) {
    return '$remaining از $total مانده';
  }

  @override
  String get wirdCompleted => 'کامل شد';

  @override
  String get wirdResetCount => 'شمارش از نو';

  @override
  String get wirdCopyDhikr => 'کپی ذکر';

  @override
  String get wirdSource => 'منبع';

  @override
  String get wirdShowDetails => 'نمایش جزئیات';

  @override
  String get wirdHideDetails => 'پنهان کردن جزئیات';

  @override
  String get wirdVirtue => 'فضیلت';

  @override
  String get wirdHadithText => 'متن حدیث';

  @override
  String get wirdWordExplanations => 'شرح واژه‌های برگزیده';

  @override
  String get wirdReadOnce => 'یک بار خواندم';

  @override
  String get wirdPlayAll => 'پخش کامل ورد';

  @override
  String get wirdPreparingAudio => 'آماده‌سازی صدا';

  @override
  String get wirdReplayAll => 'پخش دوبارهٔ ورد';

  @override
  String get wirdPlayAllFinished => 'پخش همهٔ اذکار به پایان رسید.';

  @override
  String get wirdNowPlaying => 'در حال پخش';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'تکرار $current از $total';
  }

  @override
  String get thikrLibraryTitle => 'کتابخانهٔ اذکار';

  @override
  String get thikrGroupDaily => 'اذکار روزانهٔ شما';

  @override
  String get thikrMorningSubtitle => 'ورد شما از پس از نماز صبح تا برآمدن روز';

  @override
  String get thikrEveningSubtitle => 'ورد شما از پس از نماز عصر تا شب';

  @override
  String get thikrSleepTitle => 'اذکار خواب و رؤیا';

  @override
  String get thikrSleepSubtitle =>
      'آنچه پیش از خواب و هنگام ترسیدن در خواب می‌گویید';

  @override
  String get thikrPrayerJumuahTitle => 'اذکار نماز و جمعه';

  @override
  String get thikrPrayerJumuahSubtitle => 'اذکار اذان، پس از نماز و روز جمعه';

  @override
  String get thikrGroupDuas => 'دعاهای مأثور';

  @override
  String get thikrQuranicDuasTitle => 'دعاهای قرآنی';

  @override
  String get thikrQuranicDuasSubtitle =>
      'دعای پیامبران آن‌گونه که در کتاب خدا آمده است';

  @override
  String get thikrComprehensiveDuasTitle => 'دعاهای جامع';

  @override
  String get thikrComprehensiveDuasSubtitle =>
      'دعاهایی که خیر دنیا و آخرت را در بر دارند';

  @override
  String get thikrHajjTitle => 'دعاهای حج و عمره';

  @override
  String get thikrHajjSubtitle => 'دعای احرام، طواف، سعی و مشاعر';

  @override
  String get thikrFuneralTitle => 'دعا برای میت و جنازه';

  @override
  String get thikrFuneralSubtitle => 'آنچه در نماز میت و کنار قبر گفته می‌شود';

  @override
  String get thikrGroupTools => 'ابزارهای شما';

  @override
  String get thikrTasbeehTitle => 'تسبیح';

  @override
  String get thikrTasbeehSubtitle =>
      'شمارنده‌ای که تسبیح شما را می‌شمارد و حاصل روزتان را نگه می‌دارد';

  @override
  String get thikrMyDuasSubtitle =>
      'دعاهایی که خودتان اضافه کرده‌اید، در یک جا';

  @override
  String get thikrSliderSubtitle => 'ورد این وقت؛ همین حالا بازش کنید';

  @override
  String get afterPrayerTitle => 'اذکار پس از نماز';

  @override
  String get afterPrayerSubtitle => 'اذکار بعد از نماز';

  @override
  String get afterPrayerSearchHint => 'جستجوی اذکار';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'ذکر پس از نماز $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'تعداد تکرار: $count';
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
  String get afterPrayerMentioned => 'ذکر شده';

  @override
  String get afterPrayerNotMentioned => 'ذکر نشده';

  @override
  String get afterPrayerTextSection => 'متن ذکر';

  @override
  String get afterPrayerVirtueSection => 'فضیلت ذکر';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار',
      one: '$count بار',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'نتیجهٔ مطابقی یافت نشد';

  @override
  String get afterPrayerShowAll => 'نمایش همهٔ اذکار';

  @override
  String get myDuasTitle => 'دعاهای من';

  @override
  String get myDuasActionFailed => 'انجام عملیات ممکن نشد.';

  @override
  String get myDuasEmptyCustomTitle => 'دعایی اضافه نشده است';

  @override
  String get myDuasEmptyCustomMessage =>
      'این بخش فقط دعاهایی را نشان می‌دهد که خودتان اضافه کرده‌اید.';

  @override
  String get myDuasEmptyTitle => 'هنوز دعایی نیست';

  @override
  String get myDuasEmptyMessage =>
      'اولین دعای خود را اضافه کنید تا بی‌درنگ این‌جا نمایش داده شود.';

  @override
  String get myDuasAddNew => 'افزودن دعای جدید';

  @override
  String get myDuasAdd => 'افزودن دعا';

  @override
  String get myDuasAddSubtitle =>
      'دعا را بنویسید تا در میان دعاهای شخصی‌تان نمایش داده شود.';

  @override
  String get myDuasEditTitle => 'ویرایش دعا';

  @override
  String get myDuasEditSubtitle =>
      'می‌توانید متن یا توضیح را ویرایش کنید و تغییرات را فوراً ذخیره کنید.';

  @override
  String get myDuasCountLabel => 'تعداد دعاها';

  @override
  String get myDuasTodayLabel => 'تکرار امروز';

  @override
  String get myDuasOptions => 'گزینه‌های دعا';

  @override
  String get myDuasResetToday => 'صفر کردن شمارندهٔ امروز';

  @override
  String get ruqyahTitle => 'رقیهٔ شرعی';

  @override
  String get ruqyahSearchHint => 'جستجوی رقیه';

  @override
  String get ruqyahDefaultReference => 'قرآن کریم';

  @override
  String get ruqyahUnspecified => 'نامشخص';

  @override
  String ruqyahRepeatLine(String count) {
    return 'تکرار: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'منبع: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'توضیح: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'رقیهٔ $number';
  }

  @override
  String get ruqyahTextSection => 'متن رقیه';

  @override
  String get ruqyahDescriptionSection => 'توضیح';

  @override
  String get ruqyahNoResultsTitle => 'نتیجه‌ای یافت نشد';

  @override
  String get ruqyahNoResultsMessage => 'رقیه‌ای مطابق جستجوی شما پیدا نشد.';

  @override
  String get ruqyahShowAll => 'نمایش همهٔ رقیه‌ها';

  @override
  String get radioTitle => 'رادیو';

  @override
  String get radioKindReciters => 'قاریان';

  @override
  String get radioKindPrograms => 'برنامه‌ها و تلاوت‌ها';

  @override
  String get radioLoadFailed => 'در حال حاضر بارگیری رادیوها ممکن نیست.';

  @override
  String get radioPlayFailed => 'اکنون پخش رادیو ممکن نیست.';

  @override
  String get radioToggleFailed => 'تغییر وضعیت پخش ممکن نشد.';

  @override
  String get radioStopFailed => 'توقف رادیو ممکن نشد.';

  @override
  String get radioNoMatch => 'ایستگاهی با این نام وجود ندارد.';

  @override
  String get radioSearchHint => 'جستجوی قاری یا برنامه';

  @override
  String get radioFavouritesHint =>
      'برای افزودن هر ایستگاه به علاقه‌مندی‌ها، روی آن انگشت نگه دارید.';

  @override
  String get radioAddFavourite => 'افزودن به علاقه‌مندی‌ها';

  @override
  String get radioRemoveFavourite => 'حذف از علاقه‌مندی‌ها';

  @override
  String radioAddedToFavourites(String station) {
    return '$station به علاقه‌مندی‌ها اضافه شد';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return '$station از علاقه‌مندی‌ها حذف شد';
  }

  @override
  String get radioSleepTimer => 'زمان‌سنج خواب';

  @override
  String get radioSleepTimerDescription =>
      'پخش پس از مدت انتخاب‌شده خودبه‌خود متوقف می‌شود.';

  @override
  String radioStopsIn(String time) {
    return 'توقف پس از $time';
  }

  @override
  String get radioCancelTimer => 'لغو زمان‌سنج';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه',
      one: '$count دقیقه',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'توقف پخش';

  @override
  String get radioTuning => 'در حال اتصال…';

  @override
  String get radioLive => 'پخش زنده';

  @override
  String get radioPaused => 'متوقف موقت';

  @override
  String get radioTapToPlay => 'برای پخش بزنید';

  @override
  String get radioPause => 'توقف موقت';

  @override
  String get radioPlay => 'پخش';
}
