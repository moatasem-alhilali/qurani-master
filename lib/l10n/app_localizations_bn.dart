// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class L10nBn extends L10n {
  L10nBn([String locale = 'bn']) : super(locale);

  @override
  String get floatingAdhkarTitle => 'ভাসমান জিকির';

  @override
  String get floatingAdhkarSourceBuiltIn => 'ডিফল্ট';

  @override
  String get floatingAdhkarSourceCustom => 'কাস্টম';

  @override
  String get floatingAdhkarSourceMyAdhkar => 'আমার জিকিরসমূহ';

  @override
  String get floatingAdhkarSourceAppLibrary => 'অ্যাপ লাইব্রেরি';

  @override
  String get floatingAdhkarDefaultDhikrTitle => 'ডিফল্ট জিকির';

  @override
  String get floatingAdhkarRandomDhikrTitle => 'এলোমেলো জিকির';

  @override
  String get floatingAdhkarIosNotificationSubtitle => 'এলোমেলো জিকির';

  @override
  String get floatingAdhkarOverlayServiceTitle => 'ভাসমান এলোমেলো জিকির';

  @override
  String get floatingAdhkarOverlayServiceContent =>
      'ভাসমান জিকির সেবা ব্যাকগ্রাউন্ডে চলছে';

  @override
  String get floatingAdhkarErrorUnsupportedPlatform =>
      'এই ফিচারটি এই প্ল্যাটফর্মে উপলব্ধ নয়।';

  @override
  String get floatingAdhkarErrorIosNotificationsToEnable =>
      'iPhone-এ জিকিরের রিমাইন্ডার চালু করতে নোটিফিকেশনের অনুমতি দিতে হবে।';

  @override
  String get floatingAdhkarErrorOverlayPermissionFirst =>
      'প্রথমে অন্য অ্যাপের উপরে দেখানোর অনুমতি দিতে হবে।';

  @override
  String get floatingAdhkarErrorNoSource =>
      'ভাসমান জিকিরের জন্য অন্তত একটি উৎস চালু করুন।';

  @override
  String get floatingAdhkarErrorIosNotificationsRequired =>
      'iPhone রিমাইন্ডার চালু করতে নোটিফিকেশনের অনুমতি প্রয়োজন।';

  @override
  String get floatingAdhkarErrorOverlayPermissionRequired =>
      'ভাসমান উইন্ডো চালু করতে অনুমতি প্রয়োজন।';

  @override
  String get floatingAdhkarErrorTitleAndTextRequired =>
      'ডিফল্ট জিকির হালনাগাদ করতে শিরোনাম ও লেখা দুটোই প্রয়োজন।';

  @override
  String get floatingAdhkarErrorNotificationsDenied =>
      'নোটিফিকেশনের অনুমতি দেওয়া হয়নি।';

  @override
  String get floatingAdhkarErrorOverlayDenied =>
      'অন্য অ্যাপের উপরে দেখানোর অনুমতি দেওয়া হয়নি।';

  @override
  String get floatingAdhkarErrorEnableBeforePreview =>
      'আগে ফিচারটি চালু করুন, তারপর লাইভ প্রিভিউ ব্যবহার করুন।';

  @override
  String get floatingAdhkarErrorPreviewNotificationsRequired =>
      'এখনই জিকির দেখাতে নোটিফিকেশনের অনুমতি প্রয়োজন।';

  @override
  String get floatingAdhkarErrorPreviewOverlayRequired =>
      'ভাসমান জিকির দেখাতে অনুমতি প্রয়োজন।';

  @override
  String get floatingAdhkarStatusUnsupported => 'সমর্থিত নয়';

  @override
  String get floatingAdhkarStatusPermissionRequired => 'অনুমতি প্রয়োজন';

  @override
  String get floatingAdhkarStatusMisconfigured => 'সেটআপ প্রয়োজন';

  @override
  String get floatingAdhkarStatusActive => 'এখন চলছে';

  @override
  String get floatingAdhkarStatusInactive => 'বন্ধ';

  @override
  String get floatingAdhkarManageTitle => 'জিকির পরিচালনা';

  @override
  String get floatingAdhkarManageSubtitle =>
      'ডিফল্ট থেকে কোনগুলো দেখাবে বেছে নিন এবং নিজের জিকির যোগ করুন';

  @override
  String get floatingAdhkarAddPrivateTooltip => 'নিজস্ব জিকির যোগ করুন';

  @override
  String get floatingAdhkarAddCustomTitle => 'কাস্টম জিকির যোগ করুন';

  @override
  String get floatingAdhkarAddCustomSubtitle =>
      'চালু করলে এটি ভাসমান জিকিরে যুক্ত হবে।';

  @override
  String get floatingAdhkarEditTitle => 'জিকির সম্পাদনা';

  @override
  String get floatingAdhkarEditSubtitle =>
      'লেখা হালনাগাদ করে সরাসরি পরিবর্তন সংরক্ষণ করুন।';

  @override
  String floatingAdhkarEnabledOfTotal(int enabled, int total) {
    return '$total-এর মধ্যে $enabled';
  }

  @override
  String get floatingAdhkarEmptyBuiltInTitle => 'কোনো ডিফল্ট জিকির নেই';

  @override
  String get floatingAdhkarEmptyBuiltInMessage =>
      'অ্যাপের ভেতরে ডিফল্ট জিকিরের লাইব্রেরি পাওয়া যায়নি।';

  @override
  String get floatingAdhkarEmptyCustomTitle => 'এখনো কোনো নিজস্ব জিকির নেই';

  @override
  String get floatingAdhkarEmptyCustomMessage =>
      'আপনার জিকির বা দোয়া যোগ করুন, তা ভাসমান এলোমেলো ঘূর্ণনে যুক্ত হবে।';

  @override
  String get floatingAdhkarAddNewDhikr => 'নতুন জিকির যোগ করুন';

  @override
  String get floatingAdhkarItemOptions => 'জিকিরের অপশন';

  @override
  String get floatingAdhkarTabBuiltIn => 'ডিফল্ট জিকির';

  @override
  String get floatingAdhkarTabCustom => 'নিজস্ব জিকির';

  @override
  String get floatingAdhkarPreviewHeader => 'জিকিরের প্রিভিউ';

  @override
  String get floatingAdhkarAdvancedTitle => 'উন্নত সেটিংস';

  @override
  String get floatingAdhkarAdvancedSubtitle => 'দেখানোর হার, স্থায়িত্ব ও উৎস';

  @override
  String get floatingAdhkarFrequencyTitle => 'দেখানোর হার';

  @override
  String get floatingAdhkarVisibleDurationTitle => 'জিকির কতক্ষণ থাকবে';

  @override
  String floatingAdhkarSecondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সেকেন্ড',
      one: '$count সেকেন্ড',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesTitle => 'জিকিরের উৎস';

  @override
  String get floatingAdhkarAllowNotifications => 'নোটিফিকেশনের অনুমতি দিন';

  @override
  String get floatingAdhkarGrantPermission => 'প্রয়োজনীয় অনুমতি দিন';

  @override
  String get floatingAdhkarPermissionHint =>
      'এটি ছাড়া জিকির অন্য অ্যাপের উপরে দেখাবে না';

  @override
  String get floatingAdhkarSendNow => 'এখনই জিকির পাঠান';

  @override
  String get floatingAdhkarShowNow => 'এখনই জিকির দেখান';

  @override
  String get floatingAdhkarPreviewReadyHint =>
      'জিকিরটি আপনার সামনে কেমন দেখাবে, পরীক্ষা করে দেখুন';

  @override
  String get floatingAdhkarPreviewDisabledHint =>
      'আগে সেবাটি চালু করুন এবং অনুমতি দিন';

  @override
  String get floatingAdhkarIosReminders => 'iPhone রিমাইন্ডার';

  @override
  String get floatingAdhkarFloatingService => 'ভাসমান সেবা';

  @override
  String get floatingAdhkarUnsupportedPlatform => 'এই প্ল্যাটফর্মে সমর্থিত নয়';

  @override
  String get floatingAdhkarStatBuiltIn => 'ডিফল্ট';

  @override
  String get floatingAdhkarStatCustom => 'নিজস্ব';

  @override
  String get floatingAdhkarSettingsTitleIos => 'জিকির রিমাইন্ডার সেটিংস';

  @override
  String get floatingAdhkarSettingsTitle => 'ভাসমান জিকির সেটিংস';

  @override
  String get floatingAdhkarReminderTiming => 'রিমাইন্ডারের সময়';

  @override
  String get floatingAdhkarAppearanceTiming => 'দেখানোর সময়';

  @override
  String get floatingAdhkarReminderFrequency => 'রিমাইন্ডারের পুনরাবৃত্তি';

  @override
  String get floatingAdhkarAppearanceFrequency => 'দেখানোর পুনরাবৃত্তি';

  @override
  String get floatingAdhkarBuiltInSourceSubtitle =>
      'অ্যাপের মূল অভ্যন্তরীণ উৎস';

  @override
  String get floatingAdhkarCustomSourceSubtitle =>
      'আপনি নিজে যে জিকিরগুলো যোগ করেছেন';

  @override
  String get floatingAdhkarMixSources => 'উৎসগুলো মিশিয়ে দিন';

  @override
  String get floatingAdhkarMixSourcesOn =>
      'একটি সম্মিলিত তালিকা থেকে বাছাই হবে';

  @override
  String get floatingAdhkarMixSourcesOff => 'ডিফল্ট ও কাস্টম পালাক্রমে আসবে';

  @override
  String get floatingAdhkarSaveNeedsSource =>
      'সংরক্ষণের আগে অন্তত একটি উৎস চালু করুন।';

  @override
  String get floatingAdhkarMasterSwitch => 'ফিচারটি সম্পূর্ণ চালু করুন';

  @override
  String get floatingAdhkarMasterSwitchIosHint =>
      'iPhone-এ জিকিরের নোটিফিকেশন নির্ধারণ করা হবে';

  @override
  String get floatingAdhkarMasterSwitchHint =>
      'ব্যাকগ্রাউন্ড সেবা জিকির দেখানো শুরু করবে';

  @override
  String get floatingAdhkarSaveSettings => 'সেটিংস সংরক্ষণ করুন';

  @override
  String floatingAdhkarEveryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count মিনিটে',
      one: 'প্রতি $count মিনিটে',
    );
    return '$_temp0';
  }

  @override
  String get floatingAdhkarSourcesMixed => 'ডিফল্ট ও কাস্টম মিশ্রিত';

  @override
  String get floatingAdhkarSourcesAlternating => 'ডিফল্ট ও কাস্টম পালাক্রমে';

  @override
  String get floatingAdhkarSourcesBuiltInOnly => 'শুধু ডিফল্ট জিকির';

  @override
  String get floatingAdhkarSourcesCustomOnly => 'শুধু ব্যবহারকারীর জিকির';

  @override
  String get floatingAdhkarSourcesNone => 'কোনো উৎস চালু নেই';

  @override
  String get sabihTitle => 'তাসবিহ';

  @override
  String get sabihBeadWalnut => 'আখরোট';

  @override
  String get sabihBeadOak => 'ওক';

  @override
  String get sabihBeadEmerald => 'পান্না';

  @override
  String get sabihBeadOnyx => 'কালো অনিক্স';

  @override
  String get sabihBeadAmber => 'অ্যাম্বার';

  @override
  String get sabihBeadMahogany => 'মেহগনি';

  @override
  String get sabihBeadSage => 'জলপাই সবুজ';

  @override
  String get sabihBeadGarnet => 'লাল আকিক';

  @override
  String get sabihErrorRefreshList => 'জিকিরের তালিকা হালনাগাদ করা যায়নি।';

  @override
  String get sabihErrorLoad => 'জিকির লোড করা যায়নি।';

  @override
  String get sabihErrorRecord => 'জিকির রেকর্ড করা যায়নি।';

  @override
  String get sabihErrorResetToday => 'আজকের গণনা শূন্য করা যায়নি।';

  @override
  String get sabihAnalyticsTitle => 'পরিসংখ্যান';

  @override
  String get sabihTabOverview => 'সংক্ষিপ্ত চিত্র';

  @override
  String get sabihTabDetails => 'জিকিরের বিস্তারিত';

  @override
  String get sabihDhikrSettingsTooltip => 'জিকির সেটিংস';

  @override
  String get sabihAddCustomDhikr => 'কাস্টম জিকির যোগ করুন';

  @override
  String get sabihEmptyMessage => 'কোনো জিকির পাওয়া যায়নি';

  @override
  String get sabihAddFirst => 'আপনার প্রথম জিকির যোগ করুন';

  @override
  String get sabihSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get sabihAddDhikr => 'জিকির যোগ করুন';

  @override
  String get sabihSaveFailed => 'জিকির সংরক্ষণ করা যায়নি।';

  @override
  String get sabihUpdatedSuccess => 'জিকির সফলভাবে হালনাগাদ হয়েছে।';

  @override
  String get sabihAddedSuccess => 'জিকির সফলভাবে যোগ হয়েছে।';

  @override
  String get sabihEditDhikr => 'জিকির সম্পাদনা';

  @override
  String get sabihFieldText => 'জিকিরের লেখা';

  @override
  String sabihExampleHint(String example) {
    return 'উদাহরণ: $example';
  }

  @override
  String get sabihTextRequired => 'অনুগ্রহ করে জিকিরের লেখা দিন';

  @override
  String get sabihTextTooShort => 'জিকিরের লেখা খুব ছোট';

  @override
  String get sabihFieldVirtue => 'ফজিলত বা সংক্ষিপ্ত বিবরণ (ঐচ্ছিক)';

  @override
  String get sabihPeriodToday => 'আজ';

  @override
  String get sabihPeriodWeek => 'সপ্তাহ';

  @override
  String get sabihPeriodMonth => 'মাস';

  @override
  String get sabihPeriodYear => 'বছর';

  @override
  String get sabihPeriodAll => 'সব';

  @override
  String get sabihThisWeek => 'এই সপ্তাহ';

  @override
  String get sabihThisMonth => 'এই মাস';

  @override
  String get sabihAllTime => 'সব সময়';

  @override
  String get sabihMostUsed => 'সবচেয়ে বেশি পড়া জিকির';

  @override
  String get sabihTotalCount => 'মোট জিকিরের সংখ্যা';

  @override
  String get sabihNoDataYet => 'এখনো কোনো তথ্য নেই';

  @override
  String get sabihResetTodayCounter => 'আজকের গণনা রিসেট করুন';

  @override
  String get sabihEditThisDhikr => 'এই জিকির সম্পাদনা করুন';

  @override
  String get sabihDeleteThisDhikr => 'এই জিকির মুছুন';

  @override
  String get sabihCustomBadge => 'কাস্টম';

  @override
  String get sabihNoCustomDhikr => 'কোনো কাস্টম জিকির নেই';

  @override
  String get sabihSummaryTitle => 'জিকিরের সারসংক্ষেপ';

  @override
  String get sabihTodayNotStarted => 'আজ এখনো জিকির শুরু করেননি';

  @override
  String sabihTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আজ $count বার জিকির করেছেন',
      one: 'আজ $count বার জিকির করেছেন',
    );
    return '$_temp0';
  }

  @override
  String get sabihCounterSemantics => 'তাসবিহ';

  @override
  String sabihTargetReached(int target) {
    return '$target পূর্ণ হয়েছে';
  }

  @override
  String sabihTargetOf(int target) {
    return '$target-এর মধ্যে';
  }

  @override
  String sabihTargetLabel(int target) {
    return 'লক্ষ্য $target';
  }

  @override
  String get sabihTapAnywhere => 'তাসবিহ গুনতে যেকোনো জায়গায় স্পর্শ করুন';

  @override
  String get sabihCountSemantics => 'তাসবিহের সংখ্যা';

  @override
  String get sabihInvalidNumber => 'শূন্যের চেয়ে বড় একটি সঠিক সংখ্যা দিন';

  @override
  String get sabihSettingsTitle => 'তাসবিহ সেটিংস';

  @override
  String get sabihTargetSection => 'জিকিরের লক্ষ্য';

  @override
  String get sabihTargetAutoHint =>
      'যেমন আছে রেখে দিলে স্বয়ংক্রিয়ভাবে বাড়বে: ৩৩, তারপর ৯৯, তারপর প্রতি ১০০।';

  @override
  String get sabihFontSize => 'লেখার আকার';

  @override
  String get sabihFontSizeGlyph => 'অ';

  @override
  String sabihPercent(int value) {
    return '$value%';
  }

  @override
  String get sabihVibration => 'কম্পন';

  @override
  String get sabihVibrationTitle => 'প্রতিটি তাসবিহে হালকা কম্পন';

  @override
  String get sabihVibrationSubtitle => 'এবং লক্ষ্য পূরণ হলে স্পষ্ট কম্পন';

  @override
  String get sabihBeadDesign => 'তাসবিহের ডিজাইন';

  @override
  String get sabihResetTodayCounterAction => 'আজকের গণনা রিসেট করুন';

  @override
  String get anotherScreenGroupDaily => 'আপনার দৈনিক আমল';

  @override
  String get anotherScreenGroupKnowledge => 'জ্ঞান ও তিলাওয়াত';

  @override
  String get anotherScreenGroupTools => 'জিকির ও টুলস';

  @override
  String get anotherScreenDailyWird => 'দিন-রাতের পাথেয়';

  @override
  String get anotherScreenDailyWirdSubtitle =>
      'দৈনিক জিকির ও তিলাওয়াতের জন্য সুবিন্যস্ত আমল';

  @override
  String get anotherScreenKhatmaPlans => 'খতমের পরিকল্পনা';

  @override
  String get anotherScreenKhatmaPlansSubtitle =>
      'আপনার সুবিধামতো কুরআন খতমের সাজানো পরিকল্পনা';

  @override
  String get anotherScreenTasbihSubtitle =>
      'আরামদায়ক ও স্পষ্ট কাউন্টারে সহজ তাসবিহ';

  @override
  String get anotherScreenFloatingAdhkarSubtitle =>
      'অন্য অ্যাপের উপরে ভেসে ওঠা ছোট জিকির';

  @override
  String get anotherScreenFajrCompanion => 'ফজরের সাথী';

  @override
  String get anotherScreenFajrCompanionSubtitle =>
      'দাওয়াতি রিমাইন্ডার ও নির্ধারিত কল';

  @override
  String get anotherScreenSurahEncyclopedia => 'সূরা বিশ্বকোষ';

  @override
  String get anotherScreenSurahEncyclopediaSubtitle =>
      'সূরাসমূহ, সেগুলোর ফজিলত ও বিষয়বস্তু দেখুন';

  @override
  String get anotherScreenNawawi40 => 'ইমাম নববীর চল্লিশ হাদিস';

  @override
  String get anotherScreenNawawi40Subtitle =>
      'দ্বীনের বিভিন্ন অধ্যায়ের ব্যাপক অর্থবোধক হাদিস';

  @override
  String get anotherScreenNamesOfAllah => 'আসমাউল হুসনা';

  @override
  String get anotherScreenNamesOfAllahSubtitle =>
      'আল্লাহর নামসমূহ ও সেগুলোর বরকতময় অর্থ নিয়ে চিন্তা করুন';

  @override
  String get anotherScreenRadio => 'রেডিও';

  @override
  String get anotherScreenRadioSubtitle =>
      'কুরআন ও ইসলামি রেডিওর নিরবচ্ছিন্ন সরাসরি সম্প্রচার';

  @override
  String get anotherScreenHisnMuslim => 'হিসনুল মুসলিম';

  @override
  String get anotherScreenHisnMuslimSubtitle =>
      'বিভিন্ন অবস্থা ও উপলক্ষের জন্য সাজানো জিকির';

  @override
  String get anotherScreenMyDuas => 'আমার দোয়াসমূহ';

  @override
  String get anotherScreenMyDuasSubtitle =>
      'আপনার ব্যক্তিগত দোয়াগুলো এক জায়গায় রাখুন';

  @override
  String get anotherScreenTraveler => 'মুসাফির';

  @override
  String get anotherScreenTravelerSubtitle =>
      'সফরের দোয়া, যাত্রাপথে নামাজের সময় ও দরকারি স্থান';

  @override
  String get anotherScreenHomeWidgets => 'হোম স্ক্রিন উইজেট';

  @override
  String get anotherScreenHomeWidgetsSubtitle =>
      'পরবর্তী নামাজ, আজকের সময়সূচি ও আজকের আয়াত';

  @override
  String get anotherScreenFootnotes => 'টীকা';

  @override
  String anotherScreenChapterNumber(int number) {
    return 'অধ্যায় $number';
  }

  @override
  String anotherScreenTextsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেখা',
      one: '$countটি লেখা',
    );
    return '$_temp0';
  }

  @override
  String anotherScreenFootnotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি টীকা',
      one: '$countটি টীকা',
    );
    return '$_temp0';
  }

  @override
  String get anotherScreenDhikrText => 'জিকিরের লেখা';

  @override
  String get anotherScreenHisnSearchHint => 'হিসনুল মুসলিমে খুঁজুন';

  @override
  String get anotherScreenNoResults => 'কোনো ফলাফল নেই';

  @override
  String get anotherScreenHisnNoResultsMessage =>
      'হিসনুল মুসলিমে আপনার অনুসন্ধানের সাথে মেলে এমন কোনো অধ্যায় পাওয়া যায়নি।';

  @override
  String get anotherScreenShowAllAdhkar => 'সব জিকির দেখুন';

  @override
  String get anotherScreenSurahSearchHint => 'সূরা খুঁজুন';

  @override
  String anotherScreenSurahTitle(String name) {
    return 'সূরা $name';
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
  String get anotherScreenSurahOrder => 'ক্রম';

  @override
  String get anotherScreenSurahNumber => 'সূরা নম্বর';

  @override
  String get anotherScreenAyahCount => 'আয়াত সংখ্যা';

  @override
  String get anotherScreenSurahNameMeaning => 'সূরার নামের অর্থ';

  @override
  String get anotherScreenSurahNamingReason => 'নামকরণের কারণ';

  @override
  String get anotherScreenSurahOtherNamesShort => 'অন্যান্য নাম';

  @override
  String get anotherScreenSurahOtherNames => 'সূরার অন্যান্য নাম';

  @override
  String get anotherScreenSurahPurpose => 'মূল উদ্দেশ্য';

  @override
  String get anotherScreenSurahRevelationReason => 'শানে নুযুল';

  @override
  String get anotherScreenSurahVirtues => 'সূরার ফজিলত';

  @override
  String get anotherScreenSurahRelations => 'সূরার পারস্পরিক সম্পর্ক';

  @override
  String anotherScreenAyahsLabel(String count) {
    return '$count আয়াত';
  }

  @override
  String get anotherScreenNoMatchingResults => 'মিলে যাওয়া কোনো ফলাফল নেই';

  @override
  String get anotherScreenShowAllSurahs => 'সব সূরা দেখুন';

  @override
  String get quranPlanAnalysisStartFirst =>
      'আপনার অগ্রগতি বিশ্লেষণের জন্য প্রথম সেশন শুরু করুন।';

  @override
  String get quranPlanAnalysisFinished =>
      'মোবারক! আপনি পরিকল্পনাটি সম্পন্ন করেছেন।';

  @override
  String get quranPlanAnalysisOnTrack =>
      'আপনি সঠিক পথে আছেন, নির্ধারিত সময়ের আগেই খতম করবেন বলে আশা করা যায়!';

  @override
  String get quranPlanAnalysisBehind =>
      'আপনি সময়ের চেয়ে কিছুটা পিছিয়ে পড়তে পারেন। পড়ার গতি একটু বাড়ানোর চেষ্টা করুন।';

  @override
  String quranPlanReminderTitle(String title) {
    return 'কুরআন খতমের পরিকল্পনা: $title';
  }

  @override
  String quranPlanReminderBody(String title) {
    return 'আপনার \"$title\" পরিকল্পনার আজকের সেশন ভুলবেন না!';
  }

  @override
  String get quranPlanAddTitle => 'নতুন খতম পরিকল্পনা যোগ করুন';

  @override
  String get quranPlanDetailsHeader => 'পরিকল্পনার বিস্তারিত';

  @override
  String get quranPlanTitleLabel => 'পরিকল্পনার শিরোনাম';

  @override
  String get quranPlanTitleHint => 'পরিকল্পনার নাম';

  @override
  String get quranPlanTitleRequired => 'একটি শিরোনাম দিন';

  @override
  String get quranPlanFromJuz => 'শুরুর পারা';

  @override
  String get quranPlanToJuz => 'শেষের পারা';

  @override
  String get quranPlanChooseStart => 'শুরু বেছে নিন';

  @override
  String get quranPlanChooseEnd => 'শেষ বেছে নিন';

  @override
  String get quranPlanEndBeforeStart => 'শেষ অংশটি শুরুর আগে হতে পারে না';

  @override
  String get quranPlanDaysLabel => 'দিনের সংখ্যা';

  @override
  String get quranPlanDaysHint => 'উদাহরণ: 30';

  @override
  String get quranPlanDaysInvalid => 'দিনের সংখ্যা সঠিকভাবে দিন';

  @override
  String get quranPlanSave => 'পরিকল্পনা সংরক্ষণ করুন';

  @override
  String get quranPlanChoose => 'বেছে নিন';

  @override
  String quranPlanJuz(int number) {
    return 'পারা $number';
  }

  @override
  String get quranPlanDailyReminder => 'দৈনিক রিমাইন্ডার';

  @override
  String get quranPlanNotSet => 'নির্ধারিত নয়';

  @override
  String get quranPlanListTitle => 'খতমের পরিকল্পনা';

  @override
  String get quranPlanNewTooltip => 'নতুন পরিকল্পনা';

  @override
  String get quranPlanSearchHint => 'পরিকল্পনা খুঁজুন';

  @override
  String quranPlanJuzRange(int start, int end) {
    return 'পারা $start থেকে $end';
  }

  @override
  String quranPlanDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন',
      one: '$count দিন',
    );
    return '$_temp0';
  }

  @override
  String quranPlanLoadedSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেশন লোড হয়েছে',
      one: '$countটি সেশন লোড হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String quranPlanProgress(int done, int total) {
    return '$total-এর মধ্যে $done';
  }

  @override
  String get quranPlanDeleteConfirm => 'পরিকল্পনাটি মুছে ফেলবেন?';

  @override
  String get quranPlanConfirm => 'নিশ্চিত করুন';

  @override
  String get quranPlanDelete => 'পরিকল্পনা মুছুন';

  @override
  String get quranPlanStagnationWarning =>
      'সতর্কতা: আপনি কয়েক দিন পড়েননি। আজ একটি ছোট সেশনই ছন্দ ফিরিয়ে আনতে যথেষ্ট।';

  @override
  String get quranPlanLoadFailed =>
      'এই মুহূর্তে পরিকল্পনাটি লোড করা যাচ্ছে না।';

  @override
  String get quranPlanTodaySession => 'আজকের সেশন';

  @override
  String get quranPlanAllSessionsDone =>
      'আপনি এই পরিকল্পনার সব সেশন সম্পন্ন করেছেন, বারাকাল্লাহু ফিক।';

  @override
  String get quranPlanRhythm => 'পরিকল্পনার ছন্দ';

  @override
  String get quranPlanPath => 'খতমের পথ';

  @override
  String get quranPlanNoSessions => 'এখনো দেখানোর মতো কোনো সেশন নেই।';

  @override
  String get quranPlanCompleteConfirm => 'সেশনটি শেষ করবেন?';

  @override
  String quranPlanSessionNumber(int number) {
    return 'সেশন $number';
  }

  @override
  String get quranPlanSessionDone => 'সম্পন্ন';

  @override
  String get quranPlanCurrentSession => 'আপনার বর্তমান সেশন';

  @override
  String get quranPlanOpenMushafHint => 'সেশন শুরুতে মুসহাফ খুলুন';

  @override
  String get quranPlanSessionCompleted => 'সম্পন্ন সেশন';

  @override
  String get quranPlanCompleteSession => 'সেশন শেষ করুন';

  @override
  String quranPlanSurahFallback(int number) {
    return 'সূরা $number';
  }

  @override
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah) {
    return '$fromSurah আয়াত $fromAyah থেকে $toSurah আয়াত $toAyah পর্যন্ত';
  }

  @override
  String quranPlanCompletedAt(String date) {
    return 'সম্পন্ন · $date';
  }

  @override
  String get quranPlanExpectedFinish => 'সম্ভাব্য খতমের দিন';

  @override
  String get quranPlanAverageInterval => 'সেশনগুলোর মধ্যে গড় বিরতি';

  @override
  String quranPlanAverageIntervalValue(String days) {
    return '$days দিন';
  }

  @override
  String get quranPlanMostActiveDay => 'সবচেয়ে সক্রিয় দিন';

  @override
  String get quranPlanLeastActiveDay => 'সবচেয়ে কম সক্রিয় দিন';

  @override
  String get quranPlanCompletionProbability => 'পরিকল্পনা পূরণের সম্ভাবনা';

  @override
  String quranPlanPercentValue(int percent) {
    return '$percent শতাংশ';
  }

  @override
  String get quranPlanStagnationDays => 'বিরতির দিনগুলো';

  @override
  String get cleanupRouteNotFound => 'পৃষ্ঠাটি পাওয়া যায়নি';

  @override
  String get cleanupNotificationSubtitle => 'নতুন বিজ্ঞপ্তি';

  @override
  String get cleanupNotificationActionView => 'দেখুন';

  @override
  String get cleanupNotificationActionDismiss => 'বাদ দিন';

  @override
  String get cleanupDownloadActionFailed =>
      'ডাউনলোডের কাজটি সম্পন্ন করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get cleanupDownloadStatusQueued => 'অপেক্ষমাণ';

  @override
  String get cleanupDownloadStatusCanceled => 'বাতিল হয়েছে';

  @override
  String get cleanupDownloadStatusUnknown => 'অজানা';

  @override
  String get cleanupRadioMediaArtist => 'কুরআনুল কারিম রেডিও';

  @override
  String get cleanupDhikrMeaningSubhanAllah => 'আল্লাহ পবিত্র';

  @override
  String get cleanupDhikrMeaningAlhamdulillah => 'সকল প্রশংসা আল্লাহর';

  @override
  String get cleanupDhikrMeaningLaIlaha => 'আল্লাহ ছাড়া কোনো উপাস্য নেই';

  @override
  String get cleanupDhikrMeaningAllahuAkbar => 'আল্লাহ সর্বশ্রেষ্ঠ';

  @override
  String get cleanupDhikrMeaningLaHawla =>
      'আল্লাহর সাহায্য ছাড়া কোনো শক্তি ও সামর্থ্য নেই';

  @override
  String get cleanupDhikrMeaningAstaghfirullah => 'আমি আল্লাহর কাছে ক্ষমা চাই';

  @override
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi =>
      'আল্লাহ পবিত্র ও সকল প্রশংসা তাঁর, মহান আল্লাহ পবিত্র';

  @override
  String get appName => 'তামানিনা';

  @override
  String get commonContinue => 'চালিয়ে যান';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonOk => 'ঠিক আছে';

  @override
  String get commonClose => 'বন্ধ করুন';

  @override
  String get commonDone => 'সম্পন্ন';

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonSearch => 'খুঁজুন';

  @override
  String get commonSettings => 'সেটিংস';

  @override
  String get commonLoading => 'লোড হচ্ছে…';

  @override
  String get commonError => 'একটি সমস্যা হয়েছে';

  @override
  String get commonDelete => 'মুছুন';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get commonAdd => 'যোগ করুন';

  @override
  String get commonShare => 'শেয়ার';

  @override
  String get commonCopy => 'কপি';

  @override
  String get commonCopied => 'কপি হয়েছে';

  @override
  String get commonBack => 'ফিরে যান';

  @override
  String get commonYes => 'হ্যাঁ';

  @override
  String get commonNo => 'না';

  @override
  String get commonRefresh => 'রিফ্রেশ';

  @override
  String get commonSeeAll => 'সব দেখুন';

  @override
  String get commonEnable => 'চালু করুন';

  @override
  String get commonDisable => 'বন্ধ করুন';

  @override
  String get commonLater => 'পরে';

  @override
  String get prayerFajr => 'ফজর';

  @override
  String get prayerSunrise => 'সূর্যোদয়';

  @override
  String get prayerDhuhr => 'যোহর';

  @override
  String get prayerAsr => 'আসর';

  @override
  String get prayerMaghrib => 'মাগরিব';

  @override
  String get prayerIsha => 'ইশা';

  @override
  String get prayerJumuah => 'জুমা';

  @override
  String get hijriMonth1 => 'মহররম';

  @override
  String get hijriMonth2 => 'সফর';

  @override
  String get hijriMonth3 => 'রবিউল আউয়াল';

  @override
  String get hijriMonth4 => 'রবিউস সানি';

  @override
  String get hijriMonth5 => 'জমাদিউল আউয়াল';

  @override
  String get hijriMonth6 => 'জমাদিউস সানি';

  @override
  String get hijriMonth7 => 'রজব';

  @override
  String get hijriMonth8 => 'শাবান';

  @override
  String get hijriMonth9 => 'রমজান';

  @override
  String get hijriMonth10 => 'শাওয়াল';

  @override
  String get hijriMonth11 => 'জিলকদ';

  @override
  String get hijriMonth12 => 'জিলহজ';

  @override
  String hijriDate(String day, String month, String year) {
    return '$day $month $year হিজরি';
  }

  @override
  String get youngMuslimTitle => 'ছোট্ট মুসলিম';

  @override
  String get youngMuslimQuizUnanswered => 'উত্তর দেওয়া হয়নি';

  @override
  String get youngMuslimResumeReminderTitle => 'ছোট্ট মুসলিমে দেখা চালিয়ে যাও';

  @override
  String youngMuslimResumeReminderBody(String topic) {
    return '\"$topic\"-এ ফিরে এসো আর ধীরে-সুস্থে তোমার যাত্রা চালিয়ে যাও।';
  }

  @override
  String get youngMuslimAudienceKidsSafe => 'শিশুদের জন্য নিরাপদ';

  @override
  String get youngMuslimAudienceGeneral => 'সবার জন্য';

  @override
  String get youngMuslimStatSeries => 'সিরিজ';

  @override
  String get youngMuslimStatEpisode => 'পর্ব';

  @override
  String get youngMuslimChooseSeries => 'সিরিজ বেছে নাও';

  @override
  String get youngMuslimEpisodes => 'পর্বসমূহ';

  @override
  String youngMuslimEpisodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পর্ব',
      one: '$countটি পর্ব',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoEpisodesTitle => 'এখন কোনো পর্ব নেই';

  @override
  String get youngMuslimNoEpisodesSubtitle =>
      'অন্য সিরিজ বেছে নাও অথবা ফিল্টার হালনাগাদের পর আবার এসো।';

  @override
  String get youngMuslimCategoryLoadError => 'বিভাগটি লোড করা যায়নি';

  @override
  String get youngMuslimTryAgainShortly => 'কিছুক্ষণ পরে আবার চেষ্টা করো।';

  @override
  String get youngMuslimSearchHint => 'গল্প খুঁজে দেখো...';

  @override
  String get youngMuslimAchievements => 'অর্জনসমূহ';

  @override
  String get youngMuslimQuickFilter => 'দ্রুত ফিল্টার';

  @override
  String get youngMuslimFilterResults => 'ফিল্টারের ফলাফল';

  @override
  String youngMuslimResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ফলাফল',
      one: '$countটি ফলাফল',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoMatchesTitle => 'মিলে যাওয়া কোনো ফলাফল নেই';

  @override
  String get youngMuslimNoMatchesSubtitle =>
      'আরও সহজ শব্দ লিখে দেখো বা ফিল্টার বদলাও, তাহলে আরও পর্ব দেখা যাবে।';

  @override
  String get youngMuslimSections => 'বিভাগসমূহ';

  @override
  String get youngMuslimContinueWatching => 'দেখা চালিয়ে যাও';

  @override
  String get youngMuslimRecentlyWatched => 'সম্প্রতি দেখা';

  @override
  String get youngMuslimFavorites => 'প্রিয়';

  @override
  String get youngMuslimWatchLater => 'পরে দেখব';

  @override
  String get youngMuslimSuggestions => 'তোমার জন্য পরামর্শ';

  @override
  String get youngMuslimGreetingWelcome => 'গল্প আর শেখার জগতে তোমাকে স্বাগতম';

  @override
  String get youngMuslimGreetingPickNew =>
      'নতুন একটি গল্প বেছে নাও আর আজই যাত্রা শুরু করো';

  @override
  String youngMuslimGreetingWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পর্ব তোমার ফিরে আসার অপেক্ষায়',
      one: '$countটি পর্ব তোমার ফিরে আসার অপেক্ষায়',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimRewardsTitle => 'আমার পয়েন্ট ও অর্জন';

  @override
  String youngMuslimLevelAndPoints(int level, int points) {
    return 'লেভেল $level · $points পয়েন্ট';
  }

  @override
  String get youngMuslimNextLevelProgress => 'পরবর্তী লেভেলের অগ্রগতি';

  @override
  String youngMuslimProgressOf(int current, int total) {
    return '$total-এর মধ্যে $current';
  }

  @override
  String get youngMuslimStatAchievements => 'অর্জন';

  @override
  String get youngMuslimStatEpisodes => 'পর্ব';

  @override
  String get youngMuslimStatAnswers => 'উত্তর';

  @override
  String get youngMuslimFilterAll => 'সব';

  @override
  String get youngMuslimStatusInProgress => 'দেখা চলছে';

  @override
  String get youngMuslimStatusCompleted => 'সম্পন্ন';

  @override
  String get youngMuslimStatusWatchLater => 'পরে';

  @override
  String get youngMuslimFiltersActiveNote =>
      'ফিল্টার এখন চালু আছে, উপরের ফিল্টার বোতাম থেকে বদলাতে পারো।';

  @override
  String get youngMuslimClearFilters => 'মুছুন';

  @override
  String get youngMuslimContentLoadError => 'কনটেন্ট লোড করা যায়নি';

  @override
  String get youngMuslimPullToRetry => 'আবার চেষ্টা করতে পেজটি নিচে টানো।';

  @override
  String get youngMuslimFilterSheetTitle => 'কনটেন্ট ফিল্টার';

  @override
  String get youngMuslimCategoryLabel => 'বিভাগ';

  @override
  String get youngMuslimFilterLanguage => 'ভাষা';

  @override
  String get youngMuslimLanguageArabic => 'আরবি';

  @override
  String get youngMuslimLanguageFrench => 'ফরাসি';

  @override
  String get youngMuslimLanguageMixed => 'মিশ্র';

  @override
  String get youngMuslimFilterContentType => 'কনটেন্টের ধরন';

  @override
  String get youngMuslimContentTypeStorySeries => 'গল্পের সিরিজ';

  @override
  String get youngMuslimApplyFilters => 'ফিল্টার প্রয়োগ করুন';

  @override
  String get youngMuslimPlayerTitle => 'শিশুদের জন্য নিরাপদ প্লেয়ার';

  @override
  String get youngMuslimEpisodeQuizTitle => 'দেখার পর পর্বের প্রশ্ন';

  @override
  String get youngMuslimSeriesChallenge => 'সিরিজের চ্যালেঞ্জ';

  @override
  String get youngMuslimPlayerLoadError => 'এখন প্লেয়ার লোড করা যাচ্ছে না।';

  @override
  String get youngMuslimWatchOptions => 'দেখার অপশন';

  @override
  String get youngMuslimPlayNextEpisode => 'পরের পর্ব চালাও';

  @override
  String youngMuslimNextEpisodeFromSeries(String episode) {
    return 'একই সিরিজের পর্ব $episode';
  }

  @override
  String get youngMuslimSeriesPlaylist => 'সিরিজের তালিকা';

  @override
  String get youngMuslimAutoPlayNext => 'পরের পর্ব স্বয়ংক্রিয়ভাবে চালাও';

  @override
  String get youngMuslimAutoPlayNextSubtitle =>
      'পর্ব শেষ হলে শুধু একই সিরিজের মধ্যে';

  @override
  String get youngMuslimResumeButton => 'দেখা চালিয়ে যাও';

  @override
  String get youngMuslimPlayNow => 'এখনই চালাও';

  @override
  String youngMuslimPercent(int percent) {
    return '$percent%';
  }

  @override
  String get youngMuslimProgress => 'অগ্রগতি';

  @override
  String get youngMuslimWatchCount => 'দেখার সংখ্যা';

  @override
  String get youngMuslimEpisodeDuration => 'পর্বের দৈর্ঘ্য';

  @override
  String youngMuslimLastWatched(String when) {
    return 'সর্বশেষ দেখা: $when';
  }

  @override
  String get youngMuslimEpisodeInfo => 'পর্বের তথ্য';

  @override
  String get youngMuslimStory => 'গল্প';

  @override
  String get youngMuslimSeries => 'সিরিজ';

  @override
  String get youngMuslimEpisodeNumber => 'পর্ব নম্বর';

  @override
  String get youngMuslimEpisodeTools => 'পর্বের টুলস';

  @override
  String get youngMuslimEpisodeQuestions => 'পর্বের প্রশ্ন';

  @override
  String get youngMuslimEpisodeQuestionsSubtitle =>
      'শিশু যা দেখেছে তা মনে রাখতে ছোট ছোট প্রশ্ন';

  @override
  String get youngMuslimAfterWatchQuestion => 'দেখার পরের প্রশ্ন';

  @override
  String get youngMuslimNextEpisode => 'পরের পর্ব';

  @override
  String get youngMuslimSimilarEpisodes => 'একই রকম পর্ব';

  @override
  String get youngMuslimDetailsLoadError => 'পর্বের বিস্তারিত লোড করা যায়নি';

  @override
  String get youngMuslimQuizIntro =>
      'সহজ কিছু প্রশ্ন, যা শিশুকে দেখা বিষয় মনে রাখতে সাহায্য করে।';

  @override
  String youngMuslimQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি প্রশ্ন',
      one: '$countটি প্রশ্ন',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimXpOnPass(int points) {
    return 'পাস করলে +$points পয়েন্ট';
  }

  @override
  String youngMuslimPassingScore(int score) {
    return 'পাস করতে $scoreটি সঠিক';
  }

  @override
  String get youngMuslimGrading => 'উত্তর যাচাই করা হচ্ছে';

  @override
  String get youngMuslimSubmitAnswers => 'উত্তর জমা দাও';

  @override
  String get youngMuslimAnswerHint => 'তোমার উত্তর এখানে পরিষ্কার করে লেখো...';

  @override
  String get youngMuslimQuizPassed => 'শাবাশ, চ্যাম্পিয়ন!';

  @override
  String get youngMuslimQuizAlmost => 'তুমি পুরো সঠিক উত্তরের খুব কাছে';

  @override
  String youngMuslimQuizScore(int correct, int total) {
    return '$totalটির মধ্যে $correctটি সঠিক উত্তর দিয়েছ';
  }

  @override
  String youngMuslimXpGained(int points) {
    return '+$points পয়েন্ট';
  }

  @override
  String youngMuslimLevel(int level) {
    return 'লেভেল $level';
  }

  @override
  String youngMuslimPoints(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points পয়েন্ট',
      one: '$points পয়েন্ট',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNewAchievements => 'নতুন অর্জন';

  @override
  String get youngMuslimReviewAnswers => 'উত্তরগুলো দেখে নাও';

  @override
  String get youngMuslimFinish => 'শেষ করো';

  @override
  String get youngMuslimYourAnswer => 'তোমার উত্তর';

  @override
  String get youngMuslimCorrectAnswer => 'সঠিক উত্তর';

  @override
  String get youngMuslimStatSeriesPlural => 'সিরিজ';

  @override
  String get youngMuslimStatPerfectScores => 'পূর্ণ নম্বর';

  @override
  String get youngMuslimUnlockedAchievements => 'আনলক হওয়া অর্জন';

  @override
  String youngMuslimAchievementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অর্জন',
      one: '$countটি অর্জন',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimNoAchievementsTitle => 'এখনো কোনো অর্জন নেই';

  @override
  String get youngMuslimNoAchievementsSubtitle =>
      'যাত্রা শুরু করতে প্রথম পর্বটি শেষ করো বা প্রথম প্রশ্নের উত্তর দাও।';

  @override
  String get youngMuslimUpcomingAchievements => 'আসন্ন অর্জন';

  @override
  String get youngMuslimAchievementUnlocked => 'এই অর্জনটি আনলক হয়েছে।';

  @override
  String youngMuslimAchievementUnlockedAt(String when) {
    return 'আনলক হয়েছে $when';
  }

  @override
  String get youngMuslimCurrentProgress => 'বর্তমান অগ্রগতি';

  @override
  String youngMuslimDurationHoursMinutes(int hours, int minutes) {
    return '$hoursঘ $minutesমি';
  }

  @override
  String youngMuslimDurationMinutes(int minutes) {
    return '$minutesমি';
  }

  @override
  String get youngMuslimNotWatchedYet => 'এখনো দেখা হয়নি';

  @override
  String get youngMuslimJustNow => 'এইমাত্র';

  @override
  String youngMuslimMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট আগে',
      one: '$count মিনিট আগে',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ঘণ্টা আগে',
      one: '$count ঘণ্টা আগে',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে',
      one: '$count দিন আগে',
    );
    return '$_temp0';
  }

  @override
  String get youngMuslimWatched => 'দেখা হয়েছে';

  @override
  String youngMuslimProgressPercent(int percent) {
    return '$percent% দেখা হয়েছে';
  }

  @override
  String get youngMuslimReadyToWatch => 'দেখার জন্য প্রস্তুত';

  @override
  String youngMuslimCategorySeriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সিরিজ',
      one: '$countটি সিরিজ',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimCategorySeriesCountKids(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সিরিজ · শিশুদের জন্য',
      one: '$countটি সিরিজ · শিশুদের জন্য',
    );
    return '$_temp0';
  }

  @override
  String youngMuslimEpisodeMeta(int episode, String duration) {
    return 'পর্ব $episode · $duration';
  }

  @override
  String get youngMuslimResumeWhereLeft =>
      'যেখানে থেমেছিলে সেখান থেকে চালিয়ে যাও';

  @override
  String youngMuslimTimeRemaining(String duration) {
    return 'আর $duration বাকি';
  }

  @override
  String get youngMuslimAlmostDone => 'প্রায় শেষ';

  @override
  String get categoriesRequestFailed => 'অনুরোধটি সম্পন্ন করা যায়নি';

  @override
  String get categoriesLibraryTitle => 'লাইব্রেরি';

  @override
  String get categoriesQuranSciencesHeader => 'আল-কুরআন ও কুরআনের জ্ঞান';

  @override
  String get categoriesTypesHeader => 'ধরন';

  @override
  String get categoriesSectionsHeader => 'বিভাগসমূহ';

  @override
  String get categoriesFamousRecitations => 'প্রসিদ্ধ তিলাওয়াত';

  @override
  String get categoriesKidsTeaching => 'শিশুদের শিক্ষা';

  @override
  String get categoriesRecitationsByNarration =>
      'বিভিন্ন রেওয়ায়েত ও কিরাআতে তিলাওয়াত';

  @override
  String get categoriesRecitationsByNarrationShort =>
      'রেওয়ায়েতভিত্তিক তিলাওয়াত';

  @override
  String get categoriesHaramainMushafs => 'হারামাইনের মুসহাফ';

  @override
  String get categoriesTypeVideos => 'ভিডিও';

  @override
  String get categoriesTypeBooks => 'বই';

  @override
  String get categoriesTypeStories => 'গল্প';

  @override
  String get categoriesTypeAudios => 'অডিও';

  @override
  String get categoriesTypeFatwas => 'ফতোয়া';

  @override
  String get categoriesTypeQuran => 'কুরআন';

  @override
  String get categoriesTypePresentations => 'প্রেজেন্টেশন';

  @override
  String get categoriesTypeNews => 'সংবাদ';

  @override
  String get categoriesTypeArticles => 'প্রবন্ধ';

  @override
  String get categoriesTypeApps => 'অ্যাপ';

  @override
  String get categoriesTypeSermons => 'খুতবা';

  @override
  String get categoriesTopicQuran => 'কুরআন';

  @override
  String get categoriesTopicSunnah => 'সুন্নাহ';

  @override
  String get categoriesTopicSeerah => 'সিরাতুন নবী';

  @override
  String get categoriesTopicAqeedah => 'আকিদা';

  @override
  String get categoriesTopicFiqh => 'ফিকহ';

  @override
  String get categoriesTopicHistory => 'ইতিহাস';

  @override
  String get categoriesTopicArabic => 'আরবি ভাষা';

  @override
  String get categoriesTopicIslamicStudies => 'ইসলামি শিক্ষা';

  @override
  String get categoriesTopicLessons => 'ইলমি দারস';

  @override
  String get categoriesTopicMajorSins => 'কবিরা গুনাহ ও হারাম বিষয়';

  @override
  String get categoriesNoSearchResults => 'এই অনুসন্ধানের কোনো ফলাফল নেই।';

  @override
  String categoriesItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি আইটেম',
      one: '$countটি আইটেম',
    );
    return '$_temp0';
  }

  @override
  String get categoriesItemAudio => 'অডিও';

  @override
  String get categoriesItemBook => 'বই';

  @override
  String get categoriesItemArticle => 'প্রবন্ধ';

  @override
  String get categoriesItemVideo => 'ভিডিও';

  @override
  String get categoriesFallbackTitle => 'বিভাগ';

  @override
  String get categoriesNoAttachments => 'এই বিষয়ের কোনো সংযুক্তি নেই।';

  @override
  String get categoriesAttachments => 'সংযুক্তি';

  @override
  String get categoriesActionWatch => 'দেখুন';

  @override
  String get categoriesActionRead => 'পড়ুন';

  @override
  String get categoriesActionOpen => 'খুলুন';

  @override
  String categoriesOrder(String order) {
    return 'ক্রম $order';
  }

  @override
  String get categoriesDownload => 'ডাউনলোড';

  @override
  String get categoriesAttachmentFallback => 'সংযুক্তি';

  @override
  String get categoriesNoChapters => 'এই বিভাগে কোনো অধ্যায় নেই।';

  @override
  String get categoriesClearSearch => 'অনুসন্ধান মুছুন';

  @override
  String get categoriesAudioLoadError => 'অডিও লোড করা যায়নি।';

  @override
  String categoriesAudioClipNumber(int number) {
    return 'ক্লিপ $number';
  }

  @override
  String get categoriesAudioClipFallback => 'অডিও ক্লিপ';

  @override
  String get booksTitle => 'বই';

  @override
  String get booksLoadError => 'এই মুহূর্তে বই লোড করা যাচ্ছে না।';

  @override
  String get booksEmpty => 'দেখানোর মতো কোনো বই নেই।';

  @override
  String get booksFilesHeader => 'বইয়ের ফাইল';

  @override
  String get booksNoFilesTitle => 'কোনো ফাইল নেই';

  @override
  String get booksNoFilesBody =>
      'এই বইয়ের সাথে ডাউনলোডযোগ্য কোনো ফাইল সংযুক্ত নেই।';

  @override
  String get booksDescriptionHeader => 'বিবরণ';

  @override
  String get booksReferenceHeader => 'তথ্যসূত্র';

  @override
  String booksFileNumber(int number) {
    return 'ফাইল $number';
  }

  @override
  String get booksReadTitle => 'বই পড়ুন';

  @override
  String get booksViewerFailed => 'অ্যাপের ভেতরে বইটি দেখানো যায়নি';

  @override
  String get booksOpenOutsideHint => 'আপনি এটি অ্যাপের বাইরে খুলতে পারেন';

  @override
  String get booksOpenOutside => 'অ্যাপের বাইরে খুলুন';

  @override
  String get hadith40Title => 'আরবাঈন নববী';

  @override
  String hadith40Number(int number) {
    return 'হাদিস $number';
  }

  @override
  String get hadith40SearchHint => 'হাদিস খুঁজুন';

  @override
  String get hadith40NoResults => 'এই অনুসন্ধানের কোনো ফলাফল নেই';

  @override
  String get hadith40ShowAll => 'সব হাদিস দেখুন';

  @override
  String hadith40SheetSubtitle(int number) {
    return 'আরবাঈন নববী · হাদিস $number';
  }

  @override
  String get hadith40Explanation => 'হাদিসের ব্যাখ্যা';

  @override
  String hadith40ShareText(String title, String hadith, String explanation) {
    return '$title\n\n$hadith\n\nহাদিসের ব্যাখ্যা:\n$explanation';
  }

  @override
  String get allahNamesTitle => 'আসমাউল হুসনা';

  @override
  String allahNamesNameOrder(int number) {
    return 'আসমাউল হুসনার $number নম্বর নাম';
  }

  @override
  String get allahNamesMeaning => 'অর্থ';

  @override
  String get allahNamesSearchHint => 'আসমাউল হুসনায় খুঁজুন';

  @override
  String get allahNamesNoResultsTitle => 'কোনো ফলাফল নেই';

  @override
  String get allahNamesNoResultsMessage =>
      'আপনার অনুসন্ধানের সাথে মেলে এমন কোনো নাম পাওয়া যায়নি।';

  @override
  String get allahNamesShowAll => 'সব নাম দেখুন';

  @override
  String get readQuranListen => 'শুনুন';

  @override
  String get readQuranAyah => 'আয়াত';

  @override
  String get readQuranTafsir => 'আয়াতের তাফসির';

  @override
  String get quranAudioPlayPause => 'চালু বা বিরতি';

  @override
  String audiosTrackNumber(int number) {
    return 'ট্র্যাক $number';
  }

  @override
  String get audiosTracksHeader => 'ট্র্যাকসমূহ';

  @override
  String get audiosSearchSeriesHint => 'সিরিজ খুঁজুন';

  @override
  String get audiosSeriesSubtitle => 'অডিও সিরিজ';

  @override
  String get audiosNoSeries => 'দেখানোর মতো কোনো সিরিজ নেই';

  @override
  String get audiosNoResults => 'আপনার অনুসন্ধানের কোনো ফলাফল নেই';

  @override
  String get audiosPrevious => 'আগেরটি';

  @override
  String get audiosNext => 'পরেরটি';

  @override
  String get audiosPause => 'বিরতি';

  @override
  String get audiosPlay => 'চালান';

  @override
  String get coreUpdateDownloaded =>
      'আপডেট ডাউনলোড হয়েছে, এখন ইনস্টল করতে পারেন।';

  @override
  String get coreUpdateInstallNow => 'এখনই ইনস্টল করুন';

  @override
  String get coreUpdateAvailableTitle => 'নতুন আপডেট এসেছে';

  @override
  String coreUpdateAvailableMessage(String version) {
    return 'সংস্করণ $version এখন App Store-এ পাওয়া যাচ্ছে।';
  }

  @override
  String get coreUpdateWhatsNew => 'এই সংস্করণে নতুন যা আছে:';

  @override
  String get coreUpdateNow => 'এখনই আপডেট করুন';

  @override
  String get coreExitDialogTitle => 'সতর্কতা';

  @override
  String get coreExitDialogMessage =>
      'আপনি কি নিশ্চিতভাবে অ্যাপ থেকে বের হতে চান?';

  @override
  String get coreExitConfirmMessage => 'আপনি কি নিশ্চিতভাবে বের হতে চান?';

  @override
  String get coreExitStay => 'থাকুন';

  @override
  String get coreExitAction => 'বের হন';

  @override
  String get coreDeleteDhikrTitle => 'জিকির মুছবেন?';

  @override
  String get coreDeleteDhikrMessage => 'আপনি কি নিশ্চিতভাবে জিকিরটি মুছতে চান?';

  @override
  String get coreFieldRequired => 'এই ঘরটি পূরণ করা আবশ্যক';

  @override
  String get coreNoData => 'কোনো তথ্য নেই।';

  @override
  String get coreNoDataToShow => 'দেখানোর মতো কোনো তথ্য নেই';

  @override
  String get coreContent => 'বিষয়বস্তু';

  @override
  String get coreGenericError =>
      'কিছু একটা সমস্যা হয়েছে, অনুগ্রহ করে আবার চেষ্টা করুন';

  @override
  String get coreLoadDataError => 'তথ্য লোড করার সময় সমস্যা হয়েছে';

  @override
  String coreErrorStatus(String code) {
    return 'স্ট্যাটাস: $code';
  }

  @override
  String get coreCloseSearch => 'অনুসন্ধান বন্ধ করুন';

  @override
  String get coreClear => 'মুছুন';

  @override
  String get coreSheetDefaultTitle => 'নতুন যোগ করুন';

  @override
  String get coreSheetDefaultSubtitle => 'বিষয়বস্তু নিজের মতো সাজান';

  @override
  String get coreCopiedSuccessfully => 'সফলভাবে কপি হয়েছে';

  @override
  String get coreDownloadStarted => 'ডাউনলোড শুরু হয়েছে';

  @override
  String get coreDownloadCompleted => 'ডাউনলোড হয়েছে';

  @override
  String get coreSaveReadingPositionPrompt =>
      'আপনার পড়ার স্থান সংরক্ষণ করবেন?';

  @override
  String get coreLocationServiceDisabled =>
      'লোকেশন সেবা বন্ধ আছে। নামাজের সময় নির্ধারণ করতে এটি চালু করুন।';

  @override
  String get coreLocationPermissionDenied => 'লোকেশনের অনুমতি দেওয়া হয়নি।';

  @override
  String get coreLocationPermissionDeniedForever =>
      'লোকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত। অ্যাপের সেটিংস থেকে চালু করুন।';

  @override
  String get coreNotNow => 'এখন নয়';

  @override
  String get coreAllow => 'অনুমতি দিন';

  @override
  String get coreOpenSettings => 'সেটিংস খুলুন';

  @override
  String get coreNotificationPermissionTitle => 'নোটিফিকেশনের অনুমতি';

  @override
  String get coreNotificationPermissionRationale =>
      'নামাজের সময় ও জিকিরের কথা মনে করিয়ে দিতে অ্যাপটির নোটিফিকেশনের অনুমতি প্রয়োজন।\nএটি আপনাকে সারাদিন ইসলামের শিক্ষার সাথে যুক্ত থাকতে সাহায্য করবে।';

  @override
  String get coreNotificationSettingsTitle => 'নোটিফিকেশন সেটিংস';

  @override
  String get coreNotificationPermanentlyDeniedMessage =>
      'নোটিফিকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত হয়েছে।\nঅনুগ্রহ করে সেটিংসে গিয়ে নিজে নোটিফিকেশন চালু করুন।';

  @override
  String get corePermissionStatusGranted => 'সব অনুমতি দেওয়া হয়েছে';

  @override
  String get corePermissionStatusDenied => 'নোটিফিকেশনের অনুমতি প্রত্যাখ্যাত';

  @override
  String get corePermissionStatusPermanentlyDenied =>
      'অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত';

  @override
  String get corePermissionStatusPartial => 'শুধু কিছু অনুমতি দেওয়া হয়েছে';

  @override
  String get corePermissionStatusUnknown => 'অনুমতির অবস্থা অজানা';

  @override
  String get corePermissionResultGranted => 'সব অনুমতি সফলভাবে দেওয়া হয়েছে';

  @override
  String get corePermissionResultDenied => 'অনুমতির অনুরোধ প্রত্যাখ্যাত হয়েছে';

  @override
  String get corePermissionResultPermanentlyDenied =>
      'অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত - অনুগ্রহ করে সেটিংসে যান';

  @override
  String get corePermissionResultPartial =>
      'কিছু অনুমতি দেওয়া হয়েছে - আরও অনুমতি লাগতে পারে';

  @override
  String get corePermissionResultError => 'অনুমতি চাওয়ার সময় সমস্যা হয়েছে';

  @override
  String get coreNotificationActionOpenApp => 'অ্যাপ খুলুন';

  @override
  String get coreNotificationActionDismiss => 'লুকান';

  @override
  String get coreNotificationActionMarkRead => 'পড়া হয়েছে';

  @override
  String get coreNotificationActionRemindLater => 'পরে মনে করিয়ে দিন';

  @override
  String get coreNotificationGroupName => 'ইসলামি নোটিফিকেশন';

  @override
  String get coreNotificationGroupDescription =>
      'ইসলামি অ্যাপের নোটিফিকেশন গ্রুপ';

  @override
  String coreNotificationChannelDescription(String channel) {
    return 'ইসলামি নোটিফিকেশনের $channel চ্যানেল';
  }

  @override
  String get coreNotificationAppLabel => 'তামানিনা অ্যাপ';

  @override
  String get coreNotificationMore => 'আরও...';

  @override
  String coreNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি নোটিফিকেশন',
      one: '$countটি নোটিফিকেশন',
      zero: 'কোনো নোটিফিকেশন নেই',
    );
    return '$_temp0';
  }

  @override
  String coreNotificationNewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি নতুন নোটিফিকেশন',
      one: '$countটি নতুন নোটিফিকেশন',
      zero: 'নতুন কোনো নোটিফিকেশন নেই',
    );
    return '$_temp0';
  }

  @override
  String coreAthanTicker(String prayer) {
    return 'এখন $prayer-এর আজানের সময় হয়েছে';
  }

  @override
  String coreAthanDescription(String prayer) {
    return '$prayer-এর আজান';
  }

  @override
  String get coreChannelAthan => 'তামানিনা - আজান';

  @override
  String get coreChannelMohammed => 'তামানিনা - দরুদ শরীফ';

  @override
  String get coreChannelMorning => 'তামানিনা - সকালের জিকির';

  @override
  String get coreChannelNight => 'তামানিনা - সন্ধ্যার জিকির';

  @override
  String get coreChannelSleep => 'তামানিনা - ঘুমের জিকির';

  @override
  String get coreChannelGetUp => 'তামানিনা - ঘুম থেকে ওঠার জিকির';

  @override
  String get coreChannelMiddleNight => 'তামানিনা - কিয়ামুল লাইল';

  @override
  String get coreChannelRandomThikr => 'তামানিনা - এলোমেলো জিকির';

  @override
  String get coreChannelAstgferAllh => 'তামানিনা - ইস্তিগফার';

  @override
  String get coreChannelHasbnaAllh => 'তামানিনা - হাসবুনাল্লাহ';

  @override
  String get coreChannelLaHawla =>
      'তামানিনা - লা হাওলা ওয়ালা কুওয়াতা ইল্লা বিল্লাহ';

  @override
  String get coreChannelSubhanAllh => 'তামানিনা - সুবহানাল্লাহ';

  @override
  String get coreChannelDefaultChannel => 'তামানিনা - সাধারণ নোটিফিকেশন';

  @override
  String get coreChannelSmartOutreach => 'তামানিনা - ফজরের সাথী';

  @override
  String get coreFcmChannelHighImportance =>
      'তামানিনা - গুরুত্বপূর্ণ নোটিফিকেশন';

  @override
  String get coreFcmChannelChat => 'তামানিনা - বার্তা';

  @override
  String get coreFcmChannelUpdates => 'তামানিনা - আপডেট';

  @override
  String get coreFcmChannelHighImportanceDescription =>
      'তামানিনা অ্যাপের গুরুত্বপূর্ণ নোটিফিকেশনের চ্যানেল';

  @override
  String get coreFcmChannelDefaultDescription =>
      'তামানিনা অ্যাপের সাধারণ নোটিফিকেশনের চ্যানেল';

  @override
  String get coreFcmChannelChatDescription =>
      'তামানিনা অ্যাপের বার্তা ও সতর্কবার্তার চ্যানেল';

  @override
  String get coreFcmChannelUpdatesDescription =>
      'তামানিনা অ্যাপের আপডেট চ্যানেল';

  @override
  String get languageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get languageSubtitle => 'পরে সেটিংস থেকে এটি বদলাতে পারবেন।';

  @override
  String get languageSettingTitle => 'ভাষা';

  @override
  String get languageSettingSubtitle => 'অ্যাপের ইন্টারফেসের ভাষা';

  @override
  String get languageReligiousTextNote =>
      'আল-কুরআন, জিকির ও দোয়া মূল আরবি লেখাতেই থাকবে।';

  @override
  String get outreachTitle => 'ফজরের সাথী';

  @override
  String get outreachTagline =>
      'প্রিয়জনের দিন কল্যাণ দিয়ে শুরু করাতে শান্ত কল-তালিকা';

  @override
  String get outreachActionCallOnly => 'শুধু কল';

  @override
  String get outreachErrorScheduleNotFound => 'এই তালিকাটি নেই।';

  @override
  String get outreachContactsPermissionDenied =>
      'স্বয়ংক্রিয়ভাবে নম্বর বাছাই করতে কন্টাক্টসের অনুমতি দিতে হবে।';

  @override
  String get outreachContactNoPhone =>
      'বাছাই করা কন্টাক্টে কোনো ফোন নম্বর নেই।';

  @override
  String get outreachContactPickError =>
      'কন্টাক্ট বাছাই করার সময় সমস্যা হয়েছে।';

  @override
  String get outreachUnnamed => 'নামহীন';

  @override
  String get outreachPermissionPhone => 'ফোন কল';

  @override
  String get outreachPermissionContacts => 'কন্টাক্টস';

  @override
  String get outreachPermissionNotifications => 'নোটিফিকেশন';

  @override
  String get outreachListSeparator => ', ';

  @override
  String get outreachValidationTitleRequired => 'তালিকার একটি নাম লিখুন।';

  @override
  String get outreachValidationAddNumber => 'অন্তত একটি নম্বর যোগ করুন।';

  @override
  String get outreachValidationEmptyPhone =>
      'প্রতিটি ঘরে একটি ফোন নম্বর থাকতে হবে।';

  @override
  String get outreachValidationIncompleteNumber => 'একটি নম্বর অসম্পূর্ণ আছে।';

  @override
  String get outreachValidationDuplicateNumber =>
      'একই তালিকায় একটি নম্বর দুবার আছে।';

  @override
  String get outreachValidationPickDay => 'অন্তত একটি দিন বেছে নিন।';

  @override
  String get outreachValidationEnableWithoutNumbers =>
      'নম্বর ছাড়া কোনো তালিকা চালু করা যায় না।';

  @override
  String get outreachCallLogsTitle => 'কল লগ';

  @override
  String get outreachClearLog => 'লগ মুছুন';

  @override
  String get outreachStatTotal => 'মোট';

  @override
  String get outreachStatAnswered => 'ধরেছেন';

  @override
  String get outreachStatNotAnswered => 'ধরেননি';

  @override
  String get outreachStatFailed => 'ব্যর্থ';

  @override
  String get outreachResultsHeader => 'ফলাফল';

  @override
  String get outreachNoResultsTitle => 'এখনো কোনো ফলাফল নেই';

  @override
  String get outreachNoResultsMessage =>
      'প্রথমবার চালানোর পর প্রতিটি কলের ফলাফল এখানে দেখাবে।';

  @override
  String outreachSecondsShort(int seconds) {
    return '$secondsসে';
  }

  @override
  String outreachSecondsValue(int seconds) {
    return '$seconds সে';
  }

  @override
  String get outreachCallStatusAnswered => 'কল ধরেছেন';

  @override
  String get outreachCallStatusNotAnswered => 'কল ধরেননি';

  @override
  String get outreachCallStatusFailed => 'কল ব্যর্থ হয়েছে';

  @override
  String get outreachExecutionTitle => 'কল শুরু';

  @override
  String get outreachCallsStartedFromAlert =>
      'সতর্কবার্তা থেকে কল শুরু হয়েছে।';

  @override
  String get outreachCallsStartedNow => 'এখন কল শুরু হয়েছে।';

  @override
  String get outreachCallsStartFailed =>
      'এখন কল শুরু করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get outreachCallLogsReviewSubtitle =>
      'তালিকা শেষ হওয়ার পর কে ধরেছেন আর কে ধরেননি তা দেখুন';

  @override
  String get outreachPreparingCalls => 'কল প্রস্তুত করা হচ্ছে...';

  @override
  String get outreachDontCloseHint =>
      'প্রক্রিয়া শুরু না হওয়া পর্যন্ত পেজটি বন্ধ করবেন না।';

  @override
  String get outreachCanCloseHint =>
      'এখন পেজটি বন্ধ করে লগ থেকে ফলাফল দেখতে পারেন।';

  @override
  String get outreachAddList => 'তালিকা যোগ করুন';

  @override
  String get outreachStatLists => 'তালিকা';

  @override
  String get outreachStatEnabled => 'চালু';

  @override
  String get outreachStatNumbers => 'নম্বর';

  @override
  String get outreachListsHeader => 'কল-তালিকা';

  @override
  String get outreachToolsHeader => 'টুলস';

  @override
  String get outreachCallLogsSubtitle =>
      'প্রতিটি কলের ফলাফল: কে ধরেছেন, কে ধরেননি';

  @override
  String get outreachSettingsTitle => 'কল সেটিংস';

  @override
  String get outreachSettingsSubtitle => 'ডিফল্ট সময়সীমা ও নতুন তালিকার আচরণ';

  @override
  String get outreachNoListsTitle => 'এখনো কোনো তালিকা নেই';

  @override
  String get outreachNoListsMessage =>
      'একটি তালিকা যোগ করুন এবং সময় ও যেসব নম্বরে কল করতে চান তা ঠিক করুন।';

  @override
  String get outreachStartsNow => 'এখনই শুরু';

  @override
  String outreachStartsInMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট পর',
      one: '$count মিনিট পর',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ঘণ্টা পর',
      one: '$count ঘণ্টা পর',
    );
    return '$_temp0';
  }

  @override
  String outreachStartsInHoursMinutes(int hours, int minutes) {
    return '$hours ঘণ্টা $minutes মিনিট পর';
  }

  @override
  String outreachStartsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন পর',
      one: '$count দিন পর',
    );
    return '$_temp0';
  }

  @override
  String outreachPermissionsRequiredSnack(String permissions) {
    return 'আগে এই অনুমতিগুলো চালু করতে হবে: $permissions';
  }

  @override
  String outreachPermissionsNotice(String permissions) {
    return 'প্রয়োজনীয় অনুমতি অসম্পূর্ণ। তালিকা সময়মতো চালাতে চালু করুন: $permissions';
  }

  @override
  String get outreachGrantPermissions => 'অনুমতি দিন';

  @override
  String get outreachOpenSettings => 'সেটিংস খুলুন';

  @override
  String get outreachSettingsSaved => 'সেটিংস সংরক্ষিত হয়েছে।';

  @override
  String get outreachSettingsIntro =>
      'এই মানগুলো প্রতিটি নতুন তালিকায় প্রযোজ্য হবে।';

  @override
  String get outreachDefaultDurationsHeader => 'ডিফল্ট সময়সীমা';

  @override
  String get outreachRingTimeout => 'রিং হওয়ার অপেক্ষা';

  @override
  String get outreachHangupDelay => 'কল ধরার পর অপেক্ষা';

  @override
  String get outreachDelayBetweenEach => 'প্রতিটি নম্বরের মধ্যে বিরতি';

  @override
  String get outreachBehaviorHeader => 'তালিকার আচরণ';

  @override
  String get outreachStopAfterFirstAnswerList => 'প্রথম কেউ ধরলেই তালিকা থামান';

  @override
  String get outreachRetryIfNoAnswer => 'কেউ না ধরলে আবার কল করুন';

  @override
  String get outreachRestartAfterFinish => 'শেষ হলে আবার শুরু করুন';

  @override
  String get outreachSaveSettings => 'সেটিংস সংরক্ষণ করুন';

  @override
  String get outreachBackgroundHeader => 'ব্যাকগ্রাউন্ডে চালানো';

  @override
  String get outreachBatteryTitle => 'ব্যাটারি সাশ্রয় থেকে অ্যাপটিকে বাদ দিন';

  @override
  String get outreachBatterySubtitle =>
      'ব্যাকগ্রাউন্ডে তালিকা থেমে গেলে ব্যাটারি সেটিংস থেকে অ্যাপটিকে চলার অনুমতি দিন।';

  @override
  String get outreachEditList => 'তালিকা সম্পাদনা';

  @override
  String get outreachNewList => 'নতুন তালিকা';

  @override
  String get outreachCallTimeHeader => 'কলের সময়';

  @override
  String get outreachManualTime => 'নিজে সময় বেছে নিন';

  @override
  String get outreachManualTimeSubtitle => 'ঘণ্টা ও মিনিট নিজে ঠিক করুন';

  @override
  String get outreachUseFajrTime => 'ফজরের সময় ব্যবহার করুন';

  @override
  String outreachUseFajrTimeWithTime(String time) {
    return 'ফজরের সময় ব্যবহার করুন · $time';
  }

  @override
  String get outreachPrayerTimesNotReady =>
      'নামাজের সময়সূচি এখনো প্রস্তুত নয়';

  @override
  String get outreachFajrAutoFill =>
      'আজকের সময়সূচি থেকে সময় স্বয়ংক্রিয়ভাবে বসবে';

  @override
  String get outreachFajrUnavailable =>
      'ফজরের সময় এখন পাওয়া যাচ্ছে না। একটু পরে চেষ্টা করুন।';

  @override
  String outreachFajrTimeUsed(String time) {
    return 'ফজরের সময় ব্যবহার করা হয়েছে: $time';
  }

  @override
  String get outreachContactFetchFailed => 'এই মুহূর্তে কন্টাক্টটি আনা যায়নি।';

  @override
  String get outreachExactAlarmHint =>
      'ফজরের সাথী যেন ঠিক সময়ে চলে, সেজন্য ডিভাইসের সেটিংস থেকে সুনির্দিষ্ট অ্যালার্মের অনুমতি চালু করুন।';

  @override
  String get outreachListNameHeader => 'তালিকার নাম';

  @override
  String get outreachStartTime => 'শুরুর সময়';

  @override
  String get outreachStartTimeHint =>
      'নিজে সময় বেছে নিন অথবা ফজরের সময় ব্যবহার করুন';

  @override
  String outreachFajrTimeToday(String time) {
    return 'আজ ফজরের সময় $time';
  }

  @override
  String outreachContactsHeader(int count) {
    return 'কন্টাক্টস · $count';
  }

  @override
  String get outreachPickFromContacts => 'কন্টাক্টস থেকে বাছাই করুন';

  @override
  String get outreachPickFromContactsSubtitle =>
      'এই তালিকায় নতুন নম্বর যোগ করুন';

  @override
  String get outreachAdvancedSettings => 'উন্নত সেটিংস';

  @override
  String get outreachAdvancedSettingsSubtitle =>
      'দিন, অপেক্ষার সময় ও পুনরাবৃত্তির আচরণ';

  @override
  String get outreachSaving => 'সংরক্ষণ করা হচ্ছে...';

  @override
  String get outreachSaveList => 'তালিকা সংরক্ষণ করুন';

  @override
  String get outreachNoNumbersYet => 'এখনো কোনো নম্বর যোগ করা হয়নি।';

  @override
  String get outreachEnableList => 'এই তালিকা চালু করুন';

  @override
  String get outreachDailyRepeat => 'প্রতিদিন পুনরাবৃত্তি';

  @override
  String get outreachEveryDay => 'প্রতিদিন';

  @override
  String get outreachSelectedWeekdays => 'সপ্তাহের নির্বাচিত দিন';

  @override
  String get outreachDelayBetweenNumbers => 'নম্বরগুলোর মধ্যে বিরতি';

  @override
  String get outreachStopAfterFirstAnswer => 'প্রথম কেউ ধরলে থামুন';

  @override
  String get outreachRetryOnNoAnswer => 'না ধরলে আবার কল';

  @override
  String get outreachRepeatWholeCycle => 'পুরো চক্র পুনরাবৃত্তি';

  @override
  String get outreachListNameHint => 'উদাহরণ: ফজরের রিমাইন্ডার';

  @override
  String get outreachTitleFieldRequired => 'তালিকার একটি নাম লিখুন';

  @override
  String get outreachPickNumber => 'নম্বর বেছে নিন';

  @override
  String get outreachMultipleNumbers => 'এই নামে একাধিক নম্বর আছে।';

  @override
  String get outreachNoDays => 'কোনো দিন নির্ধারিত নেই';

  @override
  String outreachContactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি নম্বর',
      one: '$countটি নম্বর',
      zero: 'কোনো নম্বর নেই',
    );
    return '$_temp0';
  }

  @override
  String outreachMetaRing(int seconds) {
    return 'অপেক্ষা $secondsসে';
  }

  @override
  String outreachMetaAfterAnswer(int seconds) {
    return 'ধরার পর $secondsসে';
  }

  @override
  String outreachMetaBetween(int seconds) {
    return 'নম্বরের মাঝে $secondsসে';
  }

  @override
  String get outreachNearest => 'সবচেয়ে কাছে';

  @override
  String get outreachStartNow => 'এখনই শুরু করুন';

  @override
  String get outreachStatusActive => 'সক্রিয়';

  @override
  String get outreachStatusStopped => 'বন্ধ';

  @override
  String outreachStatusSemantics(String status) {
    return 'অবস্থা: $status';
  }

  @override
  String get outreachWeekday1 => 'সোমবার';

  @override
  String get outreachWeekday2 => 'মঙ্গলবার';

  @override
  String get outreachWeekday3 => 'বুধবার';

  @override
  String get outreachWeekday4 => 'বৃহস্পতিবার';

  @override
  String get outreachWeekday5 => 'শুক্রবার';

  @override
  String get outreachWeekday6 => 'শনিবার';

  @override
  String get outreachWeekday7 => 'রবিবার';

  @override
  String get travelerServicesTitle => 'মুসাফিরের সেবা';

  @override
  String get travelerNearbyMosques => 'কাছের মসজিদ';

  @override
  String get travelerNearbyHalalRestaurants => 'কাছের হালাল রেস্তোরাঁ';

  @override
  String get travelerHalalRestaurants => 'হালাল রেস্তোরাঁ';

  @override
  String get travelerHintAroundYou => 'আপনার আশেপাশে';

  @override
  String get travelerHintWithCounter => 'কাউন্টারসহ';

  @override
  String get travelerHintByCountry => 'আপনার দেশ অনুযায়ী';

  @override
  String get travelerFlightPrayer => 'বিমানে নামাজ';

  @override
  String get travelerHintByFlightNumber => 'ফ্লাইট নম্বর দিয়ে';

  @override
  String get travelerSetLocationForMakkah =>
      'মক্কার দূরত্ব দেখতে নামাজের সময়সূচিতে আপনার লোকেশন নির্ধারণ করুন।';

  @override
  String get travelerInMakkah =>
      'আপনি মক্কা মুকাররমায় আছেন — আল্লাহ কবুল করুন।';

  @override
  String get travelerYourLocation => 'আপনার অবস্থান';

  @override
  String get travelerMakkah => 'মক্কা মুকাররমা';

  @override
  String get travelerQibla => 'কিবলা';

  @override
  String travelerDistanceMeters(String value) {
    return '$value মি';
  }

  @override
  String travelerDistanceKm(String value) {
    return '$value কিমি';
  }

  @override
  String get travelerListSeparator => ', ';

  @override
  String get travelerDirectionN => 'উত্তরে';

  @override
  String get travelerDirectionNE => 'উত্তর-পূর্বে';

  @override
  String get travelerDirectionE => 'পূর্বে';

  @override
  String get travelerDirectionSE => 'দক্ষিণ-পূর্বে';

  @override
  String get travelerDirectionS => 'দক্ষিণে';

  @override
  String get travelerDirectionSW => 'দক্ষিণ-পশ্চিমে';

  @override
  String get travelerDirectionW => 'পশ্চিমে';

  @override
  String get travelerDirectionNW => 'উত্তর-পশ্চিমে';

  @override
  String get travelerPrayerUnknown => 'অনির্ধারিত';

  @override
  String get travelerPrayerShortFajr => 'ফজর';

  @override
  String get travelerPrayerShortSunrise => 'সূর্যোদয়';

  @override
  String get travelerPrayerShortDhuhr => 'যোহর';

  @override
  String get travelerPrayerShortAsr => 'আসর';

  @override
  String get travelerPrayerShortMaghrib => 'মাগরিব';

  @override
  String get travelerPrayerShortIsha => 'ইশা';

  @override
  String get travelerNoMosquesFound =>
      'বর্তমান পরিসরে কোনো মসজিদ পাওয়া যায়নি।';

  @override
  String get travelerNoRestaurantsFound =>
      'এই পরিসরে কোনো হালাল রেস্তোরাঁ পাওয়া যায়নি।';

  @override
  String travelerWalkingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'হেঁটে $count মিনিট',
      one: 'হেঁটে $count মিনিট',
    );
    return '$_temp0';
  }

  @override
  String get travelerDefaultMosqueName => 'কাছের মসজিদ';

  @override
  String get travelerDefaultRestaurantName => 'হালাল রেস্তোরাঁ';

  @override
  String get travelerNoDetailedAddress => 'বিস্তারিত ঠিকানা নেই';

  @override
  String get travelerRepeatBySituation => 'পরিস্থিতি অনুযায়ী';

  @override
  String get travelerRepeatOnce => 'একবার';

  @override
  String travelerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার',
      one: '$count বার',
    );
    return '$_temp0';
  }

  @override
  String get travelerStageStart => 'সফরের শুরুতে';

  @override
  String get travelerStageOnTheWay => 'পথে চলার সময়';

  @override
  String get travelerStageStop => 'থামার সময়';

  @override
  String get travelerStageReturn => 'ফেরার সময়';

  @override
  String get travelerStageFarewell => 'মুসাফিরকে বিদায় জানানো';

  @override
  String get travelerStageFarewellReply => 'মুসাফিরের জন্য দোয়া';

  @override
  String get travelerAthkarTitle => 'সফরের দোয়া ও জিকির';

  @override
  String get travelerAthkarLoadFailed => 'সফরের জিকির লোড করা যায়নি।';

  @override
  String get travelerFarewellTitle => 'যিনি মুসাফিরকে বিদায় দিচ্ছেন';

  @override
  String get travelerFarewellCaption =>
      'এগুলো আপনার পথের জন্য নয় — বরং যারা পেছনে রয়ে গেলেন তাদের জন্য';

  @override
  String get travelerRoadComplete => 'আপনার পথের জিকির সম্পন্ন হয়েছে';

  @override
  String get travelerRoadStations => 'পথের ধাপসমূহ';

  @override
  String get travelerRoadCompleteCaption => 'নিরাপত্তা আপনার সঙ্গী হোক।';

  @override
  String get travelerRoadCaption =>
      'সফরের প্রতিটি ধাপের জন্য আলাদা জিকির — আপনি যে ধাপে আছেন সেটি খুলুন।';

  @override
  String travelerShareVirtue(String virtue) {
    return 'ফজিলত: $virtue';
  }

  @override
  String travelerShareSource(String source, String hadith) {
    return 'সূত্র: $source ($hadith)';
  }

  @override
  String get travelerResetCounter => 'গণনা শূন্য করুন';

  @override
  String get travelerCounterDone => 'সম্পন্ন';

  @override
  String get travelerCounterCount => 'গুনুন';

  @override
  String get travelerCountDhikr => 'জিকির গুনুন';

  @override
  String get travelerFlightPrayerTitle => 'বিমানযাত্রায় নামাজের সময়';

  @override
  String get travelerShowTimes => 'সময়সূচি দেখুন';

  @override
  String get travelerShowMap => 'মানচিত্র দেখুন';

  @override
  String get travelerShowList => 'তালিকা দেখুন';

  @override
  String get travelerSearchByFlightNumber => 'ফ্লাইট নম্বর দিয়ে খুঁজুন';

  @override
  String get travelerRunSearchNow => 'এখনই খুঁজুন';

  @override
  String get travelerFlightAttemptsExhausted =>
      'চেষ্টার সুযোগ শেষ। আবার চেষ্টা করতে পেজটি পুনরায় খুলুন।';

  @override
  String get travelerFlightNumberInvalid =>
      'ফ্লাইট নম্বর সঠিক নয়। উদাহরণ: EK202 বা MS985';

  @override
  String get travelerFlightFetchFailed =>
      'এই মুহূর্তে ফ্লাইটের তথ্য আনা যাচ্ছে না।';

  @override
  String get travelerSourceMock => 'স্থানীয় সিমুলেশন (API ছাড়া)';

  @override
  String get travelerCityRiyadh => 'রিয়াদ';

  @override
  String get travelerCityJeddah => 'জেদ্দা';

  @override
  String get travelerCityDubai => 'দুবাই';

  @override
  String get travelerCityDoha => 'দোহা';

  @override
  String get travelerCityIstanbul => 'ইস্তাম্বুল';

  @override
  String get travelerCityCairo => 'কায়রো';

  @override
  String get travelerCityKualaLumpur => 'কুয়ালালামপুর';

  @override
  String get travelerCityLondon => 'লন্ডন';

  @override
  String get travelerCityParis => 'প্যারিস';

  @override
  String get travelerCityNewYork => 'নিউ ইয়র্ক';

  @override
  String get travelerAttemptsRemaining => 'বাকি চেষ্টা';

  @override
  String get travelerLiveTrack => 'সরাসরি পথ';

  @override
  String get travelerTakeoff => 'উড্ডয়ন';

  @override
  String get travelerLanding => 'অবতরণ';

  @override
  String get travelerFlightEnded =>
      'ফ্লাইট শেষ — বিমানে আর কোনো নামাজের সময় বাকি নেই।';

  @override
  String get travelerNoPrayerDuringFlight =>
      'এই ফ্লাইটের সময়ের মধ্যে কোনো নামাজের ওয়াক্ত পড়েনি।';

  @override
  String get travelerAllFlightPrayersPassed =>
      'এই ফ্লাইটের সব নামাজের সময় পেরিয়ে গেছে।';

  @override
  String travelerCountdownHoursMinutes(int hours, int minutes) {
    return '$hours ঘ $minutes মি পর';
  }

  @override
  String travelerCountdownMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট পর',
      one: '$count মিনিট পর',
    );
    return '$_temp0';
  }

  @override
  String travelerNextPrayerAboard(String prayer, String countdown) {
    return 'বিমানে $prayer — $countdown';
  }

  @override
  String travelerFirstPrayerAboard(String prayer) {
    return 'বিমানে প্রথম নামাজ: $prayer';
  }

  @override
  String travelerAtPlaneLocalTime(String time, String offset) {
    return 'বিমানের অবস্থানের সময় অনুযায়ী $time ($offset)';
  }

  @override
  String get travelerLocalTimeAbovePlane =>
      'বিমানের নিচের স্থানীয় সময় অনুযায়ী';

  @override
  String get travelerTapStopHint =>
      'মানচিত্রে অবস্থান দেখতে যেকোনো ধাপে চাপ দিন';

  @override
  String get travelerUpcoming => 'আসন্ন';

  @override
  String get travelerNext => 'পরবর্তী';

  @override
  String travelerStopGmt(String place, String time) {
    return '$place · GMT $time';
  }

  @override
  String get travelerSearchByFlightNumberHeader => 'ফ্লাইট নম্বর দিয়ে খুঁজুন';

  @override
  String get travelerRun => 'চালান';

  @override
  String get travelerFlightSearchHint =>
      'ফ্লাইট নম্বর লিখুন, আমরা পুরো পথে নামাজের সময় হিসাব করে দেব।';

  @override
  String get travelerFlightDetails => 'ফ্লাইটের বিস্তারিত';

  @override
  String get travelerFlightNumber => 'ফ্লাইট নম্বর';

  @override
  String get travelerFrom => 'থেকে';

  @override
  String get travelerTo => 'পর্যন্ত';

  @override
  String get travelerDataSource => 'তথ্যের উৎস';

  @override
  String get travelerFlightTimeline => 'ফ্লাইটের সময়রেখা';

  @override
  String get travelerNoTimesDuringFlight =>
      'এই ফ্লাইটের সময়ের মধ্যে কোনো নামাজের সময় দেখা যায়নি।';

  @override
  String get travelerFlightNumberExample => 'উদাহরণ: EK202';

  @override
  String get travelerShowFullRoute => 'পুরো পথ দেখুন';

  @override
  String get travelerZoomIn => 'বড় করুন';

  @override
  String get travelerZoomOut => 'ছোট করুন';

  @override
  String get travelerLocationFailed =>
      'আপনার বর্তমান অবস্থান নির্ধারণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get travelerLocationServiceDisabled =>
      'লোকেশন সেবা বন্ধ। কাছের ফলাফল দেখতে এটি চালু করুন।';

  @override
  String get travelerLocationPermissionRequired =>
      'এই ফিচার চালাতে লোকেশনের অনুমতি দিতে হবে।';

  @override
  String get travelerLocationPermissionDeniedForever =>
      'লোকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত। অ্যাপের সেটিংস খুলুন।';

  @override
  String get travelerPlacesFetchFailed =>
      'এখন কাছের ফলাফল আনা যাচ্ছে না। আবার চেষ্টা করুন।';

  @override
  String get travelerExpandRadius => 'পরিসর বাড়ান';

  @override
  String travelerAllWithinRadius(String radius) {
    return 'সবগুলো $radius-এর মধ্যে — তীরচিহ্ন প্রতিটির দিক দেখায়।';
  }

  @override
  String get travelerRadius => 'পরিসর';

  @override
  String get travelerNearestPlaces => 'সবচেয়ে কাছের স্থান';

  @override
  String travelerFoundResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার কাছে $countটি ফলাফল পাওয়া গেছে',
      one: 'আপনার কাছে $countটি ফলাফল পাওয়া গেছে',
    );
    return '$_temp0';
  }

  @override
  String get travelerUnexpectedError => 'একটি অপ্রত্যাশিত সমস্যা হয়েছে';

  @override
  String get travelerHalalRestricted =>
      'মুসলিম দেশগুলোতে হালাল রেস্তোরাঁর অনুসন্ধান দেখানো হয় না,\nকারণ সেখানকার রেস্তোরাঁ এমনিতেই হালাল।';

  @override
  String get travelerOpenMapsFailed => 'মানচিত্র অ্যাপ খোলা যায়নি।';

  @override
  String get travelerNearestMosque => 'আপনার সবচেয়ে কাছের মসজিদ';

  @override
  String get travelerNearestRestaurant => 'সবচেয়ে কাছের হালাল রেস্তোরাঁ';

  @override
  String get travelerTakeMeThere => 'সেখানে নিয়ে চলুন';

  @override
  String travelerWillMakeIt(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$prayer ধরতে পারবেন — আর $count মিনিট বাকি',
      one: '$prayer ধরতে পারবেন — আর $count মিনিট বাকি',
    );
    return '$_temp0';
  }

  @override
  String travelerMightMiss(int count, String prayer) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'হেঁটে গেলে $prayer ছুটে যেতে পারে — আর $count মিনিট বাকি',
      one: 'হেঁটে গেলে $prayer ছুটে যেতে পারে — আর $count মিনিট বাকি',
    );
    return '$_temp0';
  }

  @override
  String get travelerOpenInGoogleMaps => 'গুগল ম্যাপসে খুলুন';

  @override
  String get travelerTapMarkerHint => 'বিস্তারিত দেখতে চিহ্নে চাপ দিন';

  @override
  String get travelerOpenPhoneFailed => 'ফোন অ্যাপ খোলা যায়নি।';

  @override
  String get travelerOpenLinkFailed => 'লিংকটি খোলা যায়নি।';

  @override
  String get travelerDirections => 'দিকনির্দেশনা';

  @override
  String get travelerGoogleMaps => 'গুগল ম্যাপস';

  @override
  String get travelerCall => 'কল করুন';

  @override
  String get travelerUpdating => 'হালনাগাদ হচ্ছে…';

  @override
  String travelerResultsCount(int count) {
    return 'ফলাফলের সংখ্যা $count';
  }

  @override
  String get travelerMyCurrentLocation => 'আমার বর্তমান অবস্থান';

  @override
  String get travelerMaps => 'মানচিত্র';

  @override
  String get travelerMyLocation => 'আমার অবস্থান';

  @override
  String get qiblahTitle => 'কিবলা';

  @override
  String get qiblahRefreshTooltip => 'দিক হালনাগাদ করুন';

  @override
  String get qiblahErrorNoSensor => 'আপনার ডিভাইসে দিক নির্ণয়ের সেন্সর নেই';

  @override
  String get qiblahErrorPermissionRequired =>
      'কিবলার দিক নির্ধারণ করতে লোকেশনের অনুমতি দিতে হবে';

  @override
  String qiblahErrorGeneric(String error) {
    return 'কিবলার দিক নির্ধারণে সমস্যা হয়েছে: $error';
  }

  @override
  String get qiblahErrorLocationServiceOff =>
      'লোকেশন সেবা বন্ধ আছে। অনুগ্রহ করে সেটিংস থেকে চালু করুন';

  @override
  String get qiblahErrorPermissionDeniedForever =>
      'লোকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত। অনুগ্রহ করে অ্যাপের সেটিংস থেকে চালু করুন';

  @override
  String get qiblahErrorLocationFailed => 'বর্তমান অবস্থান পাওয়া যায়নি';

  @override
  String get qiblahUnknownLocation => 'অজানা অবস্থান';

  @override
  String qiblahErrorDirection(String error) {
    return 'দিক নির্ধারণে সমস্যা: $error';
  }

  @override
  String get qiblahErrorStreamFailed => 'দিক অনুসরণ শুরু করা যায়নি';

  @override
  String get qiblahLocating => 'অবস্থান নির্ধারণ করা হচ্ছে...';

  @override
  String get qiblahAligned => 'আপনি কিবলামুখী আছেন';

  @override
  String qiblahTurnLeft(int degrees) {
    return 'বাঁ দিকে $degrees° ঘুরুন';
  }

  @override
  String qiblahTurnRight(int degrees) {
    return 'ডান দিকে $degrees° ঘুরুন';
  }

  @override
  String get qiblahLoadingTitle => 'কিবলার দিক নির্ধারণ করা হচ্ছে';

  @override
  String get qiblahLoadingSubtitle =>
      'লোকেশন চালু আছে ও অনুমতি দেওয়া হয়েছে কি না নিশ্চিত করুন';

  @override
  String get qiblahHintAligned => 'ডিভাইস স্থির রাখুন, তীর কিবলার চিহ্নে আছে';

  @override
  String get qiblahHintMove =>
      'তীর চিহ্নে না পৌঁছা পর্যন্ত ডিভাইসটি ধীরে ধীরে ঘোরান';

  @override
  String get qiblahReadingsHeader => 'কম্পাসের রিডিং';

  @override
  String get qiblahCurrentHeading => 'আপনার বর্তমান দিক';

  @override
  String get qiblahAngle => 'কিবলার কোণ';

  @override
  String get qiblahCurrentLocation => 'আপনার বর্তমান অবস্থান';

  @override
  String get qiblahDistanceToMecca => 'মক্কার দূরত্ব';

  @override
  String qiblahDistanceKm(int km) {
    return '$km কিমি';
  }

  @override
  String get qiblahInstructionsHeader => 'ব্যবহারের নির্দেশনা';

  @override
  String get qiblahInstructions =>
      '• ফোনটি আপনার সামনে সমতলভাবে ধরুন।\n• সোনালি তীর উপরের চিহ্নের সাথে না মেলা পর্যন্ত ধীরে ধীরে ঘুরুন।\n• ঠিকঠাক মিললে বৃত্তটি আলোকিত হবে এবং হালকা কম্পন অনুভব করবেন।\n• ধাতব বস্তু ফোন থেকে দূরে রাখুন।\n• নির্দেশক অস্থির হলে ফোনটি ৮ সংখ্যার আকারে ঘোরান।';

  @override
  String get qiblahCompassNorth => 'উ';

  @override
  String get qiblahCompassEast => 'পূ';

  @override
  String get qiblahCompassSouth => 'দ';

  @override
  String get qiblahCompassWest => 'প';

  @override
  String get homeSectionYourDay => 'আপনার দিন';

  @override
  String get homeSectionAyah => 'কুরআনের একটি আয়াত';

  @override
  String get homeSectionFeatures => 'ফিচারসমূহ';

  @override
  String get homeSectionKids => 'শিশুদের বিভাগ';

  @override
  String get homeYoungMuslimTitle => 'ছোট্ট মুসলিম';

  @override
  String get homeYoungMuslimSubtitle => 'শিশুদের জন্য গল্প, আদব ও জিকির';

  @override
  String homeUpdateAvailable(String version) {
    return 'নতুন আপডেট এসেছে · সংস্করণ $version';
  }

  @override
  String get homeUpdateAction => 'আপডেট';

  @override
  String get homeContinueReading => 'পড়া চালিয়ে যান';

  @override
  String get homeStartReading => 'পড়া শুরু করুন';

  @override
  String homeContinueReadingPosition(String surah, int page) {
    return '$surah · পৃষ্ঠা $page';
  }

  @override
  String get homeStartReadingPosition => 'সূরা আল-ফাতিহা থেকে · পৃষ্ঠা ১';

  @override
  String homeAyahReference(String surah, int number) {
    return '$surah · আয়াত $number';
  }

  @override
  String homeAyahNumber(int number) {
    return 'আয়াত $number';
  }

  @override
  String get homeAnotherAyah => 'অন্য আয়াত';

  @override
  String get homeReadInMushaf => 'মুসহাফে পড়ুন';

  @override
  String get homeTrackerComplete =>
      'আজকের সব নামাজ আদায় করেছেন, আল্লাহ কবুল করুন';

  @override
  String get homeTrackerPrompt => 'আজ যা আদায় করেছেন তা চিহ্নিত করুন';

  @override
  String homeTrackerProgress(int count, int total) {
    return '$total-এর মধ্যে $count';
  }

  @override
  String homeTrackerStreak(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'টানা $days দিন',
      one: 'টানা $days দিন',
    );
    return '$_temp0';
  }

  @override
  String get homeNavHome => 'হোম';

  @override
  String get homeNavSections => 'বিভাগ';

  @override
  String homeNextPrayerRemaining(String prayer, String time, String remaining) {
    return '  $prayer : $time  \n বাকি সময় : $remaining ';
  }

  @override
  String get prayerTimeHighLatAuto => 'স্বয়ংক্রিয়';

  @override
  String get prayerTimeHighLatAutoDesc =>
      'হিসাব পদ্ধতির ডিফল্ট মান অনুযায়ী সমন্বয় করা হবে।';

  @override
  String get prayerTimeHighLatMiddleOfNight => 'মধ্যরাত';

  @override
  String get prayerTimeHighLatMiddleOfNightDesc =>
      'ফজর মধ্যরাতের আগে হবে না এবং ইশা মধ্যরাতের পরে যাবে না।';

  @override
  String get prayerTimeHighLatSeventhOfNight => 'রাতের এক-সপ্তমাংশ';

  @override
  String get prayerTimeHighLatSeventhOfNightDesc =>
      'ফজরের জন্য রাতের শেষ সপ্তমাংশ এবং ইশার জন্য প্রথম সপ্তমাংশ ধরা হয়।';

  @override
  String get prayerTimeHighLatTwilightAngle => 'গোধূলির কোণ';

  @override
  String get prayerTimeHighLatTwilightAngleDesc =>
      'নির্বাচিত ফজর ও ইশার কোণ অনুযায়ী রাত ভাগ করা হয়।';

  @override
  String get prayerTimeIshaModeAngle => 'কোণ অনুযায়ী ইশা';

  @override
  String get prayerTimeIshaModeAngleDesc =>
      'দিগন্তের নিচে সূর্যের কোণ দিয়ে ইশা হিসাব করা হয়।';

  @override
  String get prayerTimeIshaModeInterval => 'সময়ের ব্যবধানে ইশা';

  @override
  String get prayerTimeIshaModeIntervalDesc =>
      'মাগরিবের পর নির্দিষ্ট মিনিট যোগ করে ইশা হিসাব করা হয়।';

  @override
  String get prayerTimeMethodUmmAlQura => 'উম্মুল কুরা - মক্কা মুকাররমা';

  @override
  String get prayerTimeMethodMuslimWorldLeague => 'মুসলিম ওয়ার্ল্ড লীগ';

  @override
  String get prayerTimeMethodEgyptian => 'মিশরীয় জেনারেল অথরিটি অব সার্ভে';

  @override
  String get prayerTimeMethodKarachi =>
      'ইউনিভার্সিটি অব ইসলামিক সায়েন্সেস - করাচি';

  @override
  String get prayerTimeMethodDubai => 'দুবাই';

  @override
  String get prayerTimeMethodQatar => 'কাতার';

  @override
  String get prayerTimeMethodKuwait => 'কুয়েত';

  @override
  String get prayerTimeMethodSingapore => 'সিঙ্গাপুর';

  @override
  String get prayerTimeMethodTurkey => 'দিয়ানেত - তুরস্ক';

  @override
  String get prayerTimeMethodTehran =>
      'তেহরান বিশ্ববিদ্যালয়ের ভূপদার্থবিদ্যা ইনস্টিটিউট';

  @override
  String get prayerTimeMethodMoonSighting => 'মুনসাইটিং কমিটি';

  @override
  String get prayerTimeMethodNorthAmerica =>
      'ইসলামিক সোসাইটি অব নর্থ আমেরিকা (ISNA)';

  @override
  String get prayerTimeMethodCustom => 'কাস্টম সেটআপ';

  @override
  String get prayerTimeMethodUmmAlQuraDesc =>
      'ফজর 18.5° এবং মাগরিবের 90 মিনিট পর ইশা।';

  @override
  String get prayerTimeMethodMuslimWorldLeagueDesc => 'ফজর 18° এবং ইশা 17°।';

  @override
  String get prayerTimeMethodEgyptianDesc => 'ফজর 19.5° এবং ইশা 17.5°।';

  @override
  String get prayerTimeMethodKarachiDesc => 'ফজর 18° এবং ইশা 18°।';

  @override
  String get prayerTimeMethodDubaiDesc => 'ফজর ও ইশা 18.2°।';

  @override
  String get prayerTimeMethodQatarDesc =>
      'ফজর 18° এবং মাগরিবের 90 মিনিট পর ইশা।';

  @override
  String get prayerTimeMethodKuwaitDesc => 'ফজর 18° এবং ইশা 17.5°।';

  @override
  String get prayerTimeMethodSingaporeDesc => 'ফজর 20° এবং ইশা 18°।';

  @override
  String get prayerTimeMethodTurkeyDesc =>
      'ফজর 18° এবং ইশা 17°, দিয়ানেতের সমন্বয়সহ।';

  @override
  String get prayerTimeMethodTehranDesc =>
      'ফজর 17.7°, ইশা 14° এবং মাগরিব 4.5°।';

  @override
  String get prayerTimeMethodMoonSightingDesc =>
      'ফজর 18° এবং ইশা 18°, মৌসুমি সমন্বয়সহ।';

  @override
  String get prayerTimeMethodNorthAmericaDesc => 'ফজর 15° এবং ইশা 15°।';

  @override
  String get prayerTimeMethodCustomDesc =>
      'ফজর, ইশা ও মাগরিবের কোণ নিজে নির্ধারণ করুন।';

  @override
  String get prayerTimeMadhabShafi => 'শাফেয়ি, মালেকি ও হাম্বলি';

  @override
  String get prayerTimeMadhabHanafi => 'হানাফি';

  @override
  String get prayerTimeMadhabShafiDesc =>
      'বস্তুর ছায়া তার সমান হলে আসর শুরু হয়; মালেকি ও হাম্বলি মাযহাবও এই মত পোষণ করে।';

  @override
  String get prayerTimeMadhabHanafiDesc =>
      'বস্তুর ছায়া তার দ্বিগুণ হলে আসর শুরু হয়।';

  @override
  String get prayerTimeCalcIntro =>
      'আপনার এলাকায় প্রচলিত ক্যালেন্ডার বেছে নিন, আর মহল্লার মসজিদের সাথে মেলাতে প্রয়োজনে নামাজের সময় নিজে সমন্বয় করুন।';

  @override
  String get prayerTimeCalcMethod => 'হিসাব পদ্ধতি';

  @override
  String get prayerTimeCalcAsrMadhab => 'আসরের হিসাবের মাযহাব';

  @override
  String get prayerTimeMadhabShafiShort => 'শাফেয়ি';

  @override
  String get prayerTimeCalcHighLatitude => 'উচ্চ অক্ষাংশ';

  @override
  String get prayerTimeCalcRamadanIsha => 'রমজানে ইশা পিছিয়ে দিন';

  @override
  String get prayerTimeCalcRamadanIshaHint =>
      'উম্মুল কুরা ক্যালেন্ডারের মতো পুরো মাসজুড়ে ইশায় ৩০ মিনিট যোগ করে।';

  @override
  String get prayerTimeCalcRestoreDefaults =>
      'উম্মুল কুরার সেটিংস ফিরিয়ে আনুন';

  @override
  String get prayerTimeCalcCustomAngles => 'কাস্টম হিসাবের কোণ';

  @override
  String get prayerTimeCalcFajrAngle => 'ফজরের কোণ';

  @override
  String get prayerTimeCalcIshaMode => 'ইশার হিসাব';

  @override
  String get prayerTimeCalcIshaModeHint =>
      'হয় গোধূলির কোণ দিয়ে, নয়তো মাগরিবের পর নির্দিষ্ট বিরতি দিয়ে।';

  @override
  String get prayerTimeCalcIshaAngle => 'ইশার কোণ';

  @override
  String get prayerTimeCalcIshaAfterMaghrib => 'মাগরিবের পর ইশা';

  @override
  String get prayerTimeCalcMaghribAngleToggle =>
      'সূর্যাস্তের বদলে মাগরিবের কোণ';

  @override
  String get prayerTimeCalcMaghribAngleToggleHint =>
      'যারা সূর্যাস্তের মুহূর্তের বদলে গোধূলির কোণ দিয়ে মাগরিব ধরেন তাদের জন্য।';

  @override
  String get prayerTimeCalcMaghribAngle => 'মাগরিবের কোণ';

  @override
  String prayerTimeMinutesShort(String value) {
    return '$value মি';
  }

  @override
  String get prayerTimeMinutesZero => '০ মি';

  @override
  String get prayerTimeCalcManualAdjust => 'প্রতিটি সময় নিজে সমন্বয় করুন';

  @override
  String get prayerTimeCalcManualAdjustHint =>
      'মহল্লার মসজিদের সাথে মিনিট ধরে সময় মিলিয়ে নিন';

  @override
  String prayerTimeCalcManualAdjustCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সময় নিজে সমন্বয় করা হয়েছে',
      one: '$countটি সময় নিজে সমন্বয় করা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get prayerTimeGenericPrayer => 'নামাজ';

  @override
  String prayerTimeAthanTitle(String prayer) {
    return '$prayer-এর আজান';
  }

  @override
  String prayerTimeAthanTitleWithTime(String prayer, String time) {
    return '$prayer-এর আজান • $time';
  }

  @override
  String get prayerTimeAthanBodyFajr =>
      'নামাজের দিকে আসুন — ফজরের আলোয় দিন শুরু করুন।';

  @override
  String get prayerTimeAthanBodyDhuhr => 'এটিকে হৃদয়ের বিশ্রাম বানিয়ে নিন।';

  @override
  String get prayerTimeAthanBodyAsr => 'আল্লাহর সাথে আপনার সংযোগ নবায়ন করুন।';

  @override
  String get prayerTimeAthanBodyMaghrib =>
      'ইবাদত ও প্রশান্তি দিয়ে দিনটি শেষ করুন।';

  @override
  String get prayerTimeAthanBodyIsha => 'দিনের শেষ নামাজটি ছেড়ে দেবেন না।';

  @override
  String get prayerTimeAthanBodyDefault => 'আল্লাহ আপনার ইবাদত কবুল করুন।';

  @override
  String get prayerTimeAthanExpandedHint =>
      'নামাজের সতর্কবার্তা ও বিস্তারিত খুলতে চাপ দিন।';

  @override
  String prayerTimeAthanTicker(String prayer) {
    return 'এখন $prayer-এর আজানের সময় হয়েছে';
  }

  @override
  String get prayerTimeAlertNow => 'এখন নামাজের সময় হয়েছে';

  @override
  String get prayerTimeAlertMessage =>
      'খুশু-খুযুর সাথে নামাজ আদায় করুন, এটি হৃদয়ের নূর ও আত্মার প্রশান্তি।';

  @override
  String get prayerTimeAlertReady => 'নামাজের জন্য প্রস্তুত';

  @override
  String get prayerTimeAlertOpenTimes => 'নামাজের সময়সূচি খুলুন';

  @override
  String get prayerTimeTitle => 'নামাজের সময়সূচি';

  @override
  String get prayerTimeSettingsTitle => 'নামাজের সময়ের সেটিংস';

  @override
  String get prayerTimeSheetAthanTime => 'আজানের সময়';

  @override
  String get prayerTimeSheetUntilDhuhr => 'যোহর পর্যন্ত';

  @override
  String get prayerTimeSheetWindow => 'ওয়াক্তের দৈর্ঘ্য';

  @override
  String get prayerTimeSheetShift => 'আজকের তুলনায় পার্থক্য';

  @override
  String get prayerTimeWeekdaySat => 'শনি';

  @override
  String get prayerTimeWeekdaySun => 'রবি';

  @override
  String get prayerTimeWeekdayMon => 'সোম';

  @override
  String get prayerTimeWeekdayTue => 'মঙ্গল';

  @override
  String get prayerTimeWeekdayWed => 'বুধ';

  @override
  String get prayerTimeWeekdayThu => 'বৃহঃ';

  @override
  String get prayerTimeWeekdayFri => 'শুক্র';

  @override
  String get prayerTimeLessThanMinute => 'এক মিনিটের কম';

  @override
  String prayerTimeHoursShort(int hours) {
    return '$hours ঘ';
  }

  @override
  String prayerTimeHoursMinutesShort(int hours, int minutes) {
    return '$hours ঘ $minutes মি';
  }

  @override
  String get prayerTimeShiftSameDay => 'আজকের দিনই';

  @override
  String get prayerTimeShiftNone => 'কোনো পার্থক্য নেই';

  @override
  String prayerTimeShiftLater(int minutes) {
    return '$minutes মি পরে';
  }

  @override
  String prayerTimeShiftEarlier(int minutes) {
    return '$minutes মি আগে';
  }

  @override
  String get prayerTimeAm => 'AM';

  @override
  String get prayerTimePm => 'PM';

  @override
  String get prayerTimeLocationSourceManual => 'নিজে বাছাই করা';

  @override
  String get prayerTimeLocationSourceDevice => 'ডিভাইসের লোকেশন';

  @override
  String get prayerTimeLocationPickHint =>
      'একটি শহর বেছে নিন অথবা ডিভাইসের লোকেশন ব্যবহার করুন';

  @override
  String prayerTimeLocationDetails(String details, String source) {
    return '$details · $source';
  }

  @override
  String get prayerTimeLocationNotSet => 'এখনো কোনো লোকেশন নির্ধারণ করা হয়নি';

  @override
  String get prayerTimeMyLocation => 'আমার বর্তমান লোকেশন';

  @override
  String get prayerTimeGrantPermission => 'অনুমতি দিন';

  @override
  String get prayerTimeEmptyWeekTitle =>
      'সাপ্তাহিক সূচি দেখতে আপনার লোকেশন নির্ধারণ করুন';

  @override
  String get prayerTimeEmptyWeekSubtitle =>
      'আপনার শহর খুঁজুন অথবা ডিভাইসের লোকেশন ব্যবহার করুন';

  @override
  String get prayerTimeSetLocation => 'লোকেশন নির্ধারণ করুন';

  @override
  String get prayerTimeWeekNeedsCity =>
      'পুরো সপ্তাহের সময়সূচি দেখতে আপনার শহর নির্ধারণ করুন';

  @override
  String get prayerTimeWeekHint =>
      'বাকি দিনগুলোর জন্য সূচিটি পাশে সরান · বিস্তারিত দেখতে যেকোনো সময়ে চাপ দিন';

  @override
  String prayerTimeNightPrayerHeader(String day) {
    return 'কিয়ামুল লাইল · $day';
  }

  @override
  String get prayerTimeMidnight => 'মধ্যরাত';

  @override
  String get prayerTimeMidnightHint => 'মাগরিব ও ফজরের মাঝামাঝি';

  @override
  String get prayerTimeLastThird => 'রাতের শেষ তৃতীয়াংশ';

  @override
  String get prayerTimeLastThirdHint => 'কিয়াম ও দোয়ার সর্বোত্তম সময়';

  @override
  String get prayerTimeLocationHeader => 'লোকেশন';

  @override
  String get prayerTimeLocationUpdateFailed =>
      'বর্তমান লোকেশন হালনাগাদ করা যায়নি।';

  @override
  String get prayerTimeToday => 'আজ';

  @override
  String get prayerTimeTomorrow => 'আগামীকাল';

  @override
  String get prayerTimeTablePrayerColumn => 'নামাজ';

  @override
  String get prayerTimeSettingsCalcHeader => 'সময় হিসাবের পদ্ধতি';

  @override
  String get prayerTimeSettingsSilentHeader => 'নামাজের সময় সাইলেন্ট';

  @override
  String get prayerTimeSilentNeedsPermission =>
      'ফিচারটি চালাতে আগে \"বিরক্ত করবেন না\"-এর অনুমতি দিন।';

  @override
  String get prayerTimeSettingsSaved =>
      'নামাজের সময়ের সেটিংস সংরক্ষিত হয়েছে।';

  @override
  String get prayerTimeSilentHint =>
      'নামাজের সময় ফোন সাইলেন্ট হয়ে যাবে, তারপর স্বয়ংক্রিয়ভাবে শব্দ ফিরে আসবে।';

  @override
  String get prayerTimeSilentEnable => 'স্বয়ংক্রিয় সাইলেন্ট চালু করুন';

  @override
  String get prayerTimeSilentPermissionNote =>
      'এই ফিচারের জন্য সিস্টেমের «বিরক্ত করবেন না» অনুমতি প্রয়োজন।';

  @override
  String get prayerTimeSilentDuration => 'নামাজের পর সাইলেন্টের সময়কাল';

  @override
  String get prayerTimeMinutesSuffix => 'মি';

  @override
  String get prayerTimeSaving => 'সংরক্ষণ করা হচ্ছে';

  @override
  String get prayerTimeSaveSettings => 'সেটিংস সংরক্ষণ করুন';

  @override
  String get prayerTimeSavedLocation => 'সংরক্ষিত লোকেশন';

  @override
  String get prayerTimePickerMapPointLabel => 'মানচিত্রে নির্বাচিত স্থান';

  @override
  String get prayerTimePickerResolving =>
      'নির্বাচিত স্থানের নাম খোঁজা হচ্ছে...';

  @override
  String get prayerTimePickerTapMap => 'এলাকা নির্ধারণ করতে মানচিত্রে চাপ দিন';

  @override
  String get prayerTimePickerTitle => 'এলাকা বাছাই';

  @override
  String get prayerTimePickerSubtitle =>
      'খুঁজুন অথবা মানচিত্র থেকে একটি স্থান বেছে নিন';

  @override
  String get prayerTimePickerUsingDevice =>
      'ডিভাইসের লোকেশন ব্যবহার করা হচ্ছে...';

  @override
  String get prayerTimePickerUseDevice =>
      'ডিভাইসের বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get prayerTimePickerMapTab => 'মানচিত্র';

  @override
  String get prayerTimePickerSearchHint => 'শহর বা দেশের নাম';

  @override
  String get prayerTimePickerNoResults =>
      'মিলে যাওয়া কোনো ফলাফল পাওয়া যায়নি';

  @override
  String get prayerTimePickerStartTyping => 'শহরের নাম লিখতে শুরু করুন';

  @override
  String get prayerTimePickerTapMapToChoose =>
      'এলাকা বেছে নিতে মানচিত্রে চাপ দিন';

  @override
  String get prayerTimePickerApplying => 'প্রয়োগ করা হচ্ছে';

  @override
  String get prayerTimePickerApply => 'প্রয়োগ করুন';

  @override
  String prayerTimeCurrentLabel(String prayer) {
    return 'বর্তমান: $prayer';
  }

  @override
  String prayerTimeNextLabel(String prayer) {
    return 'পরবর্তী: $prayer';
  }

  @override
  String get prayerTimeEnableLocation => 'লোকেশন চালু করুন';

  @override
  String get prayerTimeTimelineEmptyTitle =>
      'এলাকা নির্ধারণ না করা পর্যন্ত নামাজের সময় দেখানো যাবে না';

  @override
  String get prayerTimeTimelineEmptySubtitle =>
      'নিজে একটি শহর বেছে নিন অথবা ডিভাইসের বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get prayerTimeTimelineChooseArea => 'এলাকা বাছাই করুন';

  @override
  String get prayerTimeNow => 'এখন';

  @override
  String get prayerTimeNextBadge => 'পরবর্তী';

  @override
  String get prayerTimeRowNext => 'পরবর্তী নামাজ';

  @override
  String get prayerTimeRowCompleted => 'ওয়াক্ত শেষ';

  @override
  String get prayerTimeRowLocalTime => 'স্থানীয় সময়';

  @override
  String get prayerTimeLoadingTimes => 'সময়সূচি লোড হচ্ছে';

  @override
  String get prayerTimeLocatingShort => 'লোকেশন নির্ধারণ করা হচ্ছে';

  @override
  String get prayerTimeNoticeUnavailable =>
      'সঠিক নামাজের সময় দেখতে লোকেশন চালু করুন বা অনুমতি দিন।';

  @override
  String get prayerTimeNoticeServiceOffSaved =>
      'বর্তমান সময়সূচি সর্বশেষ সংরক্ষিত লোকেশন অনুযায়ী। স্বয়ংক্রিয়ভাবে হালনাগাদ করতে লোকেশন চালু করুন।';

  @override
  String get prayerTimeNoticeServiceOff =>
      'লোকেশন সেবা বন্ধ। বর্তমান অবস্থান অনুযায়ী নামাজের সময় দেখতে এটি চালু করুন।';

  @override
  String get prayerTimeNoticePermissionDeniedSaved =>
      'বর্তমান সময়সূচি সর্বশেষ সংরক্ষিত লোকেশন অনুযায়ী। এখনই হালনাগাদ করতে লোকেশনের অনুমতি দিন।';

  @override
  String get prayerTimeNoticePermissionDenied =>
      'লোকেশনের অনুমতি দেওয়া হয়নি। বর্তমান অবস্থান অনুযায়ী সময় দেখতে অনুমতি দিন।';

  @override
  String get prayerTimeNoticeDeniedForeverSaved =>
      'বর্তমান সময়সূচি সর্বশেষ সংরক্ষিত লোকেশন অনুযায়ী। লোকেশনের অনুমতি আবার চালু করতে সেটিংস খুলুন।';

  @override
  String get prayerTimeNoticeDeniedForever =>
      'লোকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত। সঠিক সময় দেখতে সেটিংস খুলে এটি চালু করুন।';

  @override
  String get prayerTimeNoticeErrorSaved =>
      'এখন লোকেশন হালনাগাদ করা যায়নি, তাই সর্বশেষ সংরক্ষিত লোকেশন ব্যবহার করা হচ্ছে।';

  @override
  String get prayerTimeNoticeError =>
      'এই মুহূর্তে লোকেশন নির্ধারণ করা যাচ্ছে না। সময় দেখতে লোকেশন চালু করুন বা অনুমতি দিন।';

  @override
  String get prayerTimeOpenSettings => 'সেটিংস খুলুন';

  @override
  String prayerTimeCountdownNow(String prayer) {
    return 'এখন $prayer-এর সময় হয়েছে';
  }

  @override
  String prayerTimeCountdownUnderMinute(String prayer) {
    return 'এক মিনিটেরও কম সময়ে $prayer';
  }

  @override
  String prayerTimeCountdownMinutes(String prayer, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes মিনিট পর',
      one: '$minutes মিনিট পর',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHours(String prayer, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ঘণ্টা পর',
      one: '$hours ঘণ্টা পর',
    );
    return '$prayer $_temp0';
  }

  @override
  String prayerTimeCountdownHoursMinutes(
      String prayer, int hours, int minutes) {
    return '$prayer $hours ঘ $minutes মি পর';
  }

  @override
  String get prayerTimeRemainingNow => 'সময় হয়েছে';

  @override
  String prayerTimeRemainingMinutes(int minutes) {
    return '$minutes মি বাকি';
  }

  @override
  String prayerTimeRemainingHours(int hours) {
    return '$hours ঘ বাকি';
  }

  @override
  String prayerTimeRemainingHoursMinutes(int hours, int minutes) {
    return '$hours ঘ $minutes মি বাকি';
  }

  @override
  String get prayerTimeCurrentLocationFallback => 'বর্তমান লোকেশন';

  @override
  String get prayerTimeYouAreInTime => 'এখন চলছে';

  @override
  String prayerTimeBoardHijriLine(String hijri) {
    return '$hijri · উম্মুল কুরা অনুযায়ী';
  }

  @override
  String get prayerTimeAllTimes => 'সব সময়সূচি';

  @override
  String get prayerTimeMuteAthan => 'এই নামাজের আজান বন্ধ করুন';

  @override
  String get prayerTimeUnmuteAthan => 'এই নামাজের আজান চালু করুন';

  @override
  String get prayerTimeQuickMushaf => 'মুসহাফ';

  @override
  String get prayerTimeQuickPrayerTimes => 'নামাজের সময়';

  @override
  String get prayerTimeQuickAdhkar => 'জিকির লাইব্রেরি';

  @override
  String get prayerTimeErrorLoad =>
      'এই মুহূর্তে নামাজের সময়সূচি লোড করা যাচ্ছে না';

  @override
  String get prayerTimeErrorUpdateArea => 'নির্বাচিত এলাকা হালনাগাদ করা যায়নি';

  @override
  String get prayerTimeErrorApplySettings =>
      'নতুন সেটিংস অনুযায়ী সময় হালনাগাদ করা যায়নি';

  @override
  String get prayerTimeErrorServiceOff =>
      'লোকেশন সেবা বন্ধ। এটি চালু করুন অথবা নিজে একটি শহর বেছে নিন।';

  @override
  String get prayerTimeErrorPermission =>
      'লোকেশনের অনুমতি দিন অথবা নিজে একটি শহর বেছে নিন।';

  @override
  String get prayerTimeErrorDeniedForever =>
      'লোকেশনের অনুমতি স্থায়ীভাবে প্রত্যাখ্যাত। সেটিংস খুলুন অথবা একটি শহর বেছে নিন।';

  @override
  String get prayerTimeErrorDeviceLocation =>
      'এই মুহূর্তে ডিভাইসের লোকেশন নির্ধারণ করা যাচ্ছে না';

  @override
  String get homeWidgetsPinFailed =>
      'যোগ করার উইন্ডো খোলা যায়নি। হোম স্ক্রিন থেকে নিজে যোগ করুন।';

  @override
  String get homeWidgetsSyncSuccess => 'উইজেট হালনাগাদ হয়েছে';

  @override
  String get homeWidgetsSyncFailed =>
      'হালনাগাদ করা যায়নি। আপনার লোকেশন নির্ধারিত আছে কি না নিশ্চিত করুন।';

  @override
  String get homeWidgetsAddTooltip => 'হোম স্ক্রিনে যোগ করুন';

  @override
  String get homeWidgetsTitle => 'হোম স্ক্রিন উইজেট';

  @override
  String get homeWidgetsHowToHeader => 'যেভাবে যোগ করবেন';

  @override
  String homeWidgetsHowToAndroid(String appName) {
    return 'উইজেটের পাশের যোগ বোতামে চাপ দিন, অথবা হোম স্ক্রিনের খালি জায়গায় কিছুক্ষণ চেপে ধরে «উইজেট» বেছে নিন এবং «$appName» খুঁজুন।';
  }

  @override
  String homeWidgetsHowToIos(String appName) {
    return 'হোম স্ক্রিনের খালি জায়গায় কিছুক্ষণ চেপে ধরুন, তারপর উপরের «+» বোতামে চাপ দিয়ে «$appName» খুঁজুন। পরবর্তী নামাজের উইজেট লক স্ক্রিনেও পাওয়া যায়।';
  }

  @override
  String get homeWidgetsListHeader => 'উইজেটসমূহ';

  @override
  String get homeWidgetsNextPrayerTitle => 'পরবর্তী নামাজ';

  @override
  String get homeWidgetsNextPrayerSubtitleAndroid =>
      'নামাজের নাম ও সময়, সাথে লাইভ কাউন্টডাউন';

  @override
  String get homeWidgetsNextPrayerSubtitleIos =>
      'ছোট আকার · এবং লক স্ক্রিনে তিনটি ধরনে';

  @override
  String get homeWidgetsTodayTimesTitle => 'আজকের সময়সূচি';

  @override
  String get homeWidgetsTodayTimesSubtitle => 'হিজরি তারিখ ও শহরসহ ছয়টি সময়';

  @override
  String get homeWidgetsDailyAyahTitle => 'আজকের আয়াত';

  @override
  String get homeWidgetsDailyAyahSubtitle =>
      'প্রতিদিন বদলে যাওয়া একটি ছোট আয়াত';

  @override
  String get homeWidgetsSyncHeader => 'সিঙ্ক';

  @override
  String get homeWidgetsSyncNow => 'এখনই উইজেট হালনাগাদ করুন';

  @override
  String homeWidgetsSyncSubtitle(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিনের',
      one: '$days দিনের',
    );
    return 'আপনার বর্তমান লোকেশন ও সেটিংস অনুযায়ী $_temp0 সময়সূচি হিসাব করে';
  }

  @override
  String homeWidgetsSyncHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন',
      one: '$days দিন',
    );
    return 'অ্যাপ না খুলেও উইজেট $_temp0 চলবে এবং ব্যাকগ্রাউন্ডে স্বয়ংক্রিয়ভাবে হালনাগাদ হবে। লোকেশন বা হিসাব পদ্ধতি বদলালে নিজে থেকেই হালনাগাদ হয়।';
  }

  @override
  String get settingsDeveloperName => 'মুতাসিম আল-হিলালি';

  @override
  String get settingsUpdateStarting => 'অ্যাপ আপডেট শুরু হচ্ছে...';

  @override
  String get settingsUpdateUpToDate =>
      'আপনি অ্যাপের সর্বশেষ সংস্করণ ব্যবহার করছেন।';

  @override
  String get settingsUpdateCheckFailed =>
      'আপডেট যাচাই করা যায়নি, পরে আবার চেষ্টা করুন।';

  @override
  String get settingsGroupPreferences => 'পছন্দসমূহ';

  @override
  String get settingsDarkModeTitle => 'ডার্ক মোড';

  @override
  String get settingsStatusOn => 'চালু';

  @override
  String get settingsStatusOff => 'বন্ধ';

  @override
  String get settingsNotificationsTitle => 'নোটিফিকেশন সেটিংস';

  @override
  String get settingsNotificationsSubtitle =>
      'অ্যাপ থেকে আসা প্রতিটি সতর্কবার্তা নিয়ন্ত্রণ করুন';

  @override
  String get settingsDownloadsTitle => 'ডাউনলোড সেটিংস';

  @override
  String get settingsDownloadsSubtitle =>
      'ডাউনলোড করা ফাইল ও জায়গা পরিচালনা করুন';

  @override
  String get settingsGroupApp => 'অ্যাপ';

  @override
  String get settingsCheckUpdatesTitle => 'আপডেট যাচাই করুন';

  @override
  String get settingsCheckUpdatesSubtitle =>
      'আপনি সর্বশেষ সংস্করণ ব্যবহার করছেন কি না নিশ্চিত হোন';

  @override
  String get settingsAboutUsTitle => 'আমাদের সম্পর্কে';

  @override
  String get settingsAboutUsSubtitle =>
      'তামানিনা অ্যাপ ও এর বার্তা সম্পর্কে জানুন';

  @override
  String get settingsRateAppTitle => 'অ্যাপটি রেট করুন';

  @override
  String get settingsRateAppSubtitle =>
      'স্টোরে রেটিং দিয়ে কল্যাণ ছড়িয়ে দিতে অংশ নিন';

  @override
  String get settingsGroupPrivacy => 'গোপনীয়তা ও নিরাপত্তা';

  @override
  String get settingsPrivacyPolicyTitle => 'গোপনীয়তা নীতি';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'অ্যাপটি আপনার তথ্য ও অনুমতি কীভাবে ব্যবহার করে';

  @override
  String get settingsDataSafetyTitle => 'তথ্যের নিরাপত্তা';

  @override
  String get settingsDataSafetySubtitle =>
      'তথ্য, অনুমতি ও সেগুলোর ব্যবহারের সারসংক্ষেপ';

  @override
  String get settingsGroupDeveloper => 'ডেভেলপার';

  @override
  String get settingsAboutDeveloperTitle => 'ডেভেলপার সম্পর্কে';

  @override
  String get settingsAboutDeveloperSubtitle =>
      'ডেভেলপারের তথ্য ও যোগাযোগের লিংক';

  @override
  String get settingsDeveloperContactSubtitle =>
      'ওয়েবসাইট বা হোয়াটসঅ্যাপে সরাসরি যোগাযোগ';

  @override
  String get settingsPersonalWebsite => 'ব্যক্তিগত ওয়েবসাইট';

  @override
  String get settingsGroupFollowNews => 'সর্বশেষ খবরের সাথে থাকুন';

  @override
  String get settingsSocialTelegram => 'টেলিগ্রাম';

  @override
  String get settingsSocialWhatsapp => 'হোয়াটসঅ্যাপ';

  @override
  String get settingsSocialFacebook => 'ফেসবুক';

  @override
  String get settingsSocialInstagram => 'ইনস্টাগ্রাম';

  @override
  String get settingsSocialTwitter => 'টুইটার';

  @override
  String get settingsPrivacyIntro =>
      'অ্যাপটি আপনার তথ্য কীভাবে ব্যবহার করে সে সম্পর্কে স্পষ্ট ও সংক্ষিপ্ত তথ্য।';

  @override
  String get settingsPrivacyMattersTitle =>
      'আপনার গোপনীয়তা আমাদের কাছে গুরুত্বপূর্ণ';

  @override
  String get settingsPrivacyMattersBody =>
      'তামানিনায় আমরা অ্যাপ ব্যবহারের অভিজ্ঞতা স্পষ্ট ও নিরাপদ রাখতে যত্নশীল। অ্যাপের ফিচার চালানো ও উন্নত করার জন্য আমরা শুধু প্রয়োজনীয় তথ্য ব্যবহার করি, এবং ব্যবহারকারীর তথ্য বিক্রি করি না বা বিজ্ঞাপনের উদ্দেশ্যে শেয়ার করি না।';

  @override
  String get settingsPrivacyDataUsedTitle => 'অ্যাপ যে তথ্য ব্যবহার করতে পারে';

  @override
  String get settingsPrivacyDataUsedBody =>
      'নামাজের সময় ও কিবলা হিসাব করতে অ্যাপটি লোকেশন, আজান ও জিকিরের সতর্কবার্তার জন্য নোটিফিকেশন, ডাউনলোড করা কনটেন্ট ও স্থানীয় সেটিংস সংরক্ষণে স্টোরেজ, এবং ফজরের সাথীর মতো ব্যবহারকারীর চালু করা ফিচারে শুধু কন্টাক্টস ব্যবহার করতে পারে।';

  @override
  String get settingsPrivacyControlTitle => 'আপনার তথ্যের নিয়ন্ত্রণ';

  @override
  String get settingsPrivacyControlBody =>
      'অ্যাপের নোটিফিকেশন সেটিংস থেকে নোটিফিকেশন বন্ধ বা পরিবর্তন করতে পারেন, এবং যেকোনো সময় ডিভাইসের সেটিংস থেকে সিস্টেমের অনুমতিগুলো পরিচালনা করতে পারেন।';

  @override
  String get settingsPrivacyThirdPartyTitle => 'বাহ্যিক সেবা';

  @override
  String get settingsPrivacyThirdPartyBody =>
      'সেটিংস হালনাগাদ ও সাধারণ সতর্কবার্তা পাঠাতে অ্যাপটি Firebase Remote Config ও Firebase Messaging-এর মতো সেবা ব্যবহার করতে পারে। এই সেবাগুলো শুধু অ্যাপ চালানো ও অভিজ্ঞতা উন্নত করতে ব্যবহৃত হয়।';

  @override
  String get settingsDataSafetyIntro =>
      'অ্যাপ যে তথ্য ব্যবহার করে এবং তা কীভাবে সংরক্ষণ ও শেয়ার হয় তার সারসংক্ষেপ।';

  @override
  String get settingsDataSafetySensitiveTitle => 'সংবেদনশীল তথ্য';

  @override
  String get settingsDataSafetySensitiveBody =>
      'ব্যবহারকারীর বেছে নেওয়া কোনো স্পষ্ট ফিচারের প্রয়োজন ছাড়া অ্যাপটি সংবেদনশীল তথ্য চায় না। সতর্কবার্তার সময়, পছন্দ ও পড়ার পরিকল্পনার মতো কিছু তথ্য ডিভাইসেই সংরক্ষিত থাকে।';

  @override
  String get settingsDataSafetyLocationTitle => 'লোকেশন';

  @override
  String get settingsDataSafetyLocationBody =>
      'নামাজের সময়, কিবলার দিক ও স্থানভিত্তিক সেবার জন্য লোকেশন ব্যবহার করা হয়। ব্যবহারকারী সিস্টেম সেটিংস থেকে লোকেশনের অনুমতি বন্ধ করতে পারেন।';

  @override
  String get settingsDataSafetyNotificationsTitle => 'নোটিফিকেশন';

  @override
  String get settingsDataSafetyNotificationsBody =>
      'অ্যাপটি আজান, জিকির, রিমাইন্ডার ও কিছু সাধারণ বার্তার জন্য নোটিফিকেশন ব্যবহার করে। নোটিফিকেশন সেটিংস পেজ থেকে প্রতিটি ধরন নিয়ন্ত্রণ করা যায়।';

  @override
  String get settingsDataSafetyStorageTitle => 'স্টোরেজ ও ডাউনলোড';

  @override
  String get settingsDataSafetyStorageBody =>
      'ব্যবহারকারী যেসব ফাইল ও কনটেন্ট ডাউনলোড করতে চান, যেমন অডিও বা অ্যাপের ভেতরের উপকরণ, তা সংরক্ষণে অ্যাপটি স্টোরেজ ব্যবহার করতে পারে।';

  @override
  String get settingsDataSafetySharingTitle => 'শেয়ারিং';

  @override
  String get settingsDataSafetySharingBody =>
      'আপনার ব্যক্তিগত তথ্য বিক্রি বা বিপণনের জন্য বাইরের কারও সাথে শেয়ার করা হয় না। যেকোনো শেয়ারিং শুধু প্রয়োজনীয় পরিচালন সেবা বা ব্যবহারকারীর নিজের শুরু করা কাজের মধ্যে সীমিত।';

  @override
  String get settingsAboutAppBody =>
      'কুরআন ও ইবাদতের একটি অ্যাপ, যা আপনাকে নামাজ, জিকির, কুরআন তিলাওয়াত এবং প্রশান্তির সাথে দৈনিক আমল ধরে রাখতে সহজ ও আপন ভঙ্গিতে সাহায্য করে।';

  @override
  String get settingsAboutMissionTitle => 'আমাদের লক্ষ্য';

  @override
  String get settingsAboutMissionBody =>
      'অ্যাপটি যেন একজন হালকা সঙ্গী হয়, যা বিরক্ত না করে ইবাদতে সাহায্য করে এবং মুসহাফ, জিকির, নামাজের সময়, সতর্কবার্তা ও পরিবারের জন্য সহায়ক ফিচারের মতো গুরুত্বপূর্ণ দৈনন্দিন টুলস এক জায়গায় আনে।';

  @override
  String get settingsAboutOfferTitle => 'আমরা যা দিই';

  @override
  String get settingsAboutOfferBody =>
      'মুসহাফ, জিকির, নামাজের সময়, কিবলা, দৈনিক আমল, উইজেট, ফজরের সাথী, ছোট্ট মুসলিম, মুসাফিরের সেবা, এবং ব্যবহারকারীর প্রয়োজন অনুযায়ী সাজানো যায় এমন সতর্কবার্তা।';

  @override
  String get settingsDeveloperHeroBody =>
      '৭ বছরেরও বেশি অভিজ্ঞতাসম্পন্ন Full Stack ও Mobile সফটওয়্যার ইঞ্জিনিয়ার, Flutter, Laravel ও Next.js এবং ওয়েব ও মোবাইলের জন্য প্রোডাকশন-মানের অ্যাপ তৈরিতে বিশেষজ্ঞ।';

  @override
  String get settingsDeveloperBioTitle => 'সংক্ষিপ্ত পরিচিতি';

  @override
  String get settingsDeveloperBioBody =>
      'মুতাসিম আল-হিলালি বাস্তব ব্যবহারকারীদের জন্য অ্যাপ ও ডিজিটাল প্ল্যাটফর্ম তৈরি করেন, বিশেষ করে মোবাইল অ্যাপ, ব্যাকএন্ড সিস্টেম, ইউজার ইন্টারফেস এবং Fintech ও SaaS প্ল্যাটফর্মে।';

  @override
  String get settingsDeveloperFieldsTitle => 'কাজের ক্ষেত্র';

  @override
  String get settingsDeveloperFieldsBody =>
      'Flutter, Laravel, Next.js, React, API Development, মোবাইল অ্যাপ, ওয়েব অ্যাপ, Fintech সমাধান ও SaaS প্ল্যাটফর্ম।';

  @override
  String get settingsDeveloperContactTitle => 'যোগাযোগের মাধ্যম';

  @override
  String get settingsContactWebsite => 'ওয়েবসাইট';

  @override
  String get settingsContactEmail => 'ইমেইল';

  @override
  String get settingsAppLinksTitle => 'অ্যাপের লিংক';

  @override
  String get notifSettingsLabelAppNotifications => 'অ্যাপের নোটিফিকেশন';

  @override
  String get notifSettingsLabelAllAthan => 'সব আজানের নোটিফিকেশন';

  @override
  String notifSettingsAthanOf(String prayer) {
    return '$prayer-এর আজান';
  }

  @override
  String get notifSettingsLabelMiddleNight => 'কিয়ামুল লাইল';

  @override
  String get notifSettingsLabelThikrMorning => 'সকালের জিকির';

  @override
  String get notifSettingsLabelThikrEvening => 'সন্ধ্যার জিকির';

  @override
  String get notifSettingsLabelThikrWakeUp => 'ঘুম থেকে ওঠার জিকির';

  @override
  String get notifSettingsLabelThikrSleep => 'ঘুমের জিকির';

  @override
  String get notifSettingsLabelSalawat => 'মুহাম্মাদ ﷺ-এর প্রতি দরুদ';

  @override
  String get notifSettingsLabelRandomAudioThikr => 'এলোমেলো অডিও জিকির';

  @override
  String get notifSettingsLabelFloatingAdhkar =>
      'ভাসমান জিকির ও বিকল্প সতর্কবার্তা';

  @override
  String get notifSettingsLabelDailyQuranWird => 'কুরআনের দৈনিক আমল';

  @override
  String get notifSettingsLabelReadSurahMulk => 'সূরা মুলক তিলাওয়াত';

  @override
  String get notifSettingsLabelReadSpecificSurah => 'নির্দিষ্ট সূরা তিলাওয়াত';

  @override
  String get notifSettingsLabelReadSurahKahf => 'সূরা কাহফ তিলাওয়াত';

  @override
  String get notifSettingsLabelFasting => 'রোজার রিমাইন্ডার';

  @override
  String get notifSettingsLabelFastingMonday => 'সোমবারের রোজা';

  @override
  String get notifSettingsLabelFastingThursday => 'বৃহস্পতিবারের রোজা';

  @override
  String get notifSettingsLabelBestDua =>
      'আল্লাহ তাআলার কাছে প্রিয় ও মহান প্রভাববিশিষ্ট উত্তম দোয়া';

  @override
  String get notifSettingsLabelWirdMorning => 'সকালের আমল';

  @override
  String get notifSettingsLabelWirdEvening => 'সন্ধ্যার আমল';

  @override
  String get notifSettingsLabelWirdNight => 'ঘুমের আগের আমল';

  @override
  String get notifSettingsLabelWirdSummary => 'দৈনিক আমলের সারসংক্ষেপ';

  @override
  String get notifSettingsLabelYoungMuslim => 'ছোট্ট মুসলিম রিমাইন্ডার';

  @override
  String get notifSettingsLabelQuranPlan => 'কুরআন পরিকল্পনার রিমাইন্ডার';

  @override
  String get notifSettingsLabelGeneral => 'অ্যাপের সাধারণ নোটিফিকেশন';

  @override
  String get notifSettingsTitleRandomThikr => 'এলোমেলো জিকির';

  @override
  String get notifSettingsTitleFloatingAdhkar => 'ভাসমান জিকির';

  @override
  String get notifSettingsTitlePrayerAthan => 'নামাজের আজান';

  @override
  String get notifSettingsBodyThikrMorning => 'সকালের জিকির ভুলবেন না!';

  @override
  String get notifSettingsBodyThikrEvening => 'সন্ধ্যার জিকির ভুলবেন না!';

  @override
  String get notifSettingsBodyMiddleNight =>
      'কিয়ামুল লাইলের সময় হয়েছে, রাতের শেষ তৃতীয়াংশকে কাজে লাগান।';

  @override
  String get notifSettingsBodySalawat =>
      'নবী ﷺ-এর প্রতি দরুদ পড়ুন, আপনার দিন আনন্দময় হবে।';

  @override
  String get notifSettingsBodyRememberAllah =>
      'আল্লাহকে স্মরণ করুন, তিনিও আপনাকে স্মরণ করবেন!';

  @override
  String get notifSettingsBodyReadQuran =>
      'কুরআনের দৈনিক আমলের জন্য কিছু সময় রাখুন।';

  @override
  String get notifSettingsBodyReadSurahMulk =>
      'আজ রাতে সূরা মুলক পড়তে ভুলবেন না।';

  @override
  String get notifSettingsBodyThikrSleep => 'ঘুমানোর আগে ঘুমের জিকির পড়ুন।';

  @override
  String get notifSettingsBodyThikrWakeUp =>
      'ঘুম থেকে উঠে আল্লাহর জিকির দিয়ে দিন শুরু করুন।';

  @override
  String get notifSettingsBodyReadSurah =>
      'আজ আপনার বেছে নেওয়া সূরাটি পড়তে ভুলবেন না।';

  @override
  String get notifSettingsBodyReadSurahKahf =>
      'জুমার দিনে সূরা কাহফ পড়তে ভুলবেন না।';

  @override
  String get notifSettingsBodyFasting => 'নফল রোজার রিমাইন্ডার।';

  @override
  String get notifSettingsBodyFastingMonday => 'সোমবারের রোজার রিমাইন্ডার।';

  @override
  String get notifSettingsBodyFastingThursday =>
      'বৃহস্পতিবারের রোজার রিমাইন্ডার।';

  @override
  String get notifSettingsBodyAthanTime => 'এখন আজানের সময় হয়েছে।';

  @override
  String get notifSettingsBodyWirdMorning =>
      'ইবাদতের পাথেয় দিয়ে আপনার দিন শুরু করুন।';

  @override
  String get notifSettingsBodyWirdEvening =>
      'সন্ধ্যার পাথেয়তে আল্লাহর সাথে সম্পর্ক নবায়ন করুন।';

  @override
  String get notifSettingsBodyWirdNight =>
      'জিকির ও দোয়া দিয়ে দিনটি শেষ করুন।';

  @override
  String get notifSettingsBodyWirdSummary =>
      'আজকের ইবাদতের পাথেয় একবার দেখে নিন।';

  @override
  String get notifSettingsBodyYoungMuslim =>
      'ছোট্ট মুসলিমের কনটেন্টে ফিরে আসার রিমাইন্ডার।';

  @override
  String get notifSettingsBodyQuranPlan =>
      'আপনার কুরআন পরিকল্পনার আজকের সেশন ভুলবেন না।';

  @override
  String get notifSettingsBodyGeneral =>
      'তামানিনা অ্যাপের সাধারণ নোটিফিকেশন ও সতর্কবার্তা।';

  @override
  String get notifSettingsAllPrayers => 'সব নামাজ';

  @override
  String get notifSettingsSalawatShort => 'দরুদ শরীফ';

  @override
  String get notifSettingsQuranWirdShort => 'কুরআনের আমল';

  @override
  String get notifSettingsGroupGeneral => 'সাধারণ';

  @override
  String get notifSettingsGroupAthan => 'আজান';

  @override
  String get notifSettingsGroupDailyWird => 'দৈনিক আমল';

  @override
  String get notifSettingsGroupAdhkar => 'জিকির';

  @override
  String get notifSettingsGroupQuran => 'কুরআন';

  @override
  String get notifSettingsGroupAppSections => 'অ্যাপের বিভাগ';

  @override
  String get notifSettingsGroupNightAndWaking => 'রাত ও জাগরণ';

  @override
  String get notifSettingsGroupFasting => 'রোজা';

  @override
  String get notifSettingsGroupRecurringAdhkar => 'পুনরাবৃত্ত জিকির';

  @override
  String get notifSettingsGroupSystem => 'সিস্টেম';

  @override
  String get notifSettingsMasterTitle => 'অ্যাপের সব নোটিফিকেশন';

  @override
  String get notifSettingsMasterOnSubtitle =>
      'নোটিফিকেশন চালু আছে, নিচে প্রতিটি ধরন ঠিক করতে পারেন';

  @override
  String get notifSettingsMasterOffSubtitle =>
      'এই সুইচ চালু না করা পর্যন্ত সব নোটিফিকেশন বন্ধ থাকবে';

  @override
  String get notifSettingsSystemTitle => 'সিস্টেম নোটিফিকেশন';

  @override
  String get notifSettingsSystemSubtitle =>
      'আপনার ডিভাইসে নির্ধারিত ও চালু নোটিফিকেশনগুলো দেখুন';

  @override
  String get notifSettingsStatusStopped => 'বন্ধ';

  @override
  String get notifSettingsStatusEnabled => 'চালু';

  @override
  String notifSettingsSummaryDaily(String time) {
    return 'প্রতিদিন · $time';
  }

  @override
  String notifSettingsSummaryHourly(int minute) {
    return 'প্রতি ঘণ্টার $minute মিনিটে';
  }

  @override
  String notifSettingsSummaryEveryNMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count মিনিটে',
      one: 'প্রতি $count মিনিটে',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsListSeparator => ', ';

  @override
  String get notifSettingsNoDaysSelected => 'কোনো দিন নির্ধারিত নেই';

  @override
  String notifSettingsSummaryWeekly(String days, String time) {
    return 'সাপ্তাহিক ($days) · $time';
  }

  @override
  String notifSettingsSummaryCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'কাস্টম সময়সূচি · $countটি সময়',
      one: 'কাস্টম সময়সূচি · $countটি সময়',
      zero: 'কাস্টম সময়সূচি · কোনো সময় নেই',
    );
    return '$_temp0';
  }

  @override
  String get notifSettingsScheduleTimesTooltip => 'সতর্কবার্তার সময়';

  @override
  String get notifSettingsEditScheduleTitle => 'সময়সূচি সম্পাদনা';

  @override
  String get notifSettingsEditScheduleSubtitle =>
      'পুনরাবৃত্তির ধরন ও সতর্কবার্তার সময় বদলান';

  @override
  String get notifSettingsExtraSchedulesTitle => 'অতিরিক্ত সময় পরিচালনা';

  @override
  String get notifSettingsExtraSchedulesSubtitle =>
      'এই নোটিফিকেশনের জন্য একাধিক সময় যোগ করুন';

  @override
  String get notifScheduleBodyAllAthan =>
      'সব আজানের সতর্কবার্তা নির্ধারিত সময়ে পুনরাবৃত্ত হবে।';

  @override
  String get notifScheduleBodyAthanFajr =>
      'এখন ফজরের আজানের সময়, দ্রুত নামাজে চলুন।';

  @override
  String get notifScheduleBodyAthanDhuhr => 'এখন যোহরের আজানের সময়।';

  @override
  String get notifScheduleBodyAthanAsr => 'এখন আসরের আজানের সময়।';

  @override
  String get notifScheduleBodyAthanMaghrib => 'এখন মাগরিবের আজানের সময়।';

  @override
  String get notifScheduleBodyAthanIsha => 'এখন ইশার আজানের সময়।';

  @override
  String get notifScheduleBodyMiddleNight =>
      'কিয়ামুল লাইলের সময় হয়েছে! উঠুন, দয়াময় রবের সাথে একান্তে কথা বলুন।';

  @override
  String get notifScheduleBodyThikrMorning => 'সকালের জিকির ভুলবেন না!';

  @override
  String get notifScheduleBodyThikrEvening => 'সন্ধ্যার জিকির ভুলবেন না!';

  @override
  String get notifScheduleBodySalawat =>
      'সম্মানিত নবী ﷺ-এর প্রতি দরুদ পড়ুন, আপনার জন্য দশটি নেকি লেখা হবে।';

  @override
  String get notifScheduleBodyReadQuran => 'আজ কুরআনের আমল ভুলবেন না।';

  @override
  String get notifScheduleBodyReadSurahMulk => 'ঘুমানোর আগে সূরা মুলক পড়ুন।';

  @override
  String get notifScheduleBodyThikrSleep => 'ঘুমানোর আগে ঘুমের জিকির পড়ুন।';

  @override
  String get notifScheduleBodyThikrWakeUp =>
      'ঘুম থেকে ওঠার জিকির দিয়ে দিন শুরু করুন।';

  @override
  String get notifScheduleBodyReadSurah =>
      'আজকের জন্য নির্ধারিত সূরাটি পড়তে ভুলবেন না।';

  @override
  String get notifScheduleBodyReadSurahKahf => 'জুমার দিনে সূরা কাহফ পড়ুন।';

  @override
  String get notifScheduleBodyFasting =>
      'নফল রোজার রয়েছে মহান প্রতিদান, সুযোগ হাতছাড়া করবেন না।';

  @override
  String get notifScheduleTitleRandomThikr => 'এলোমেলো জিকির থেকে কাস্টম';

  @override
  String get notifScheduleValidateTime => 'আগে সতর্কবার্তার সময় নির্ধারণ করুন';

  @override
  String get notifScheduleValidateMinute => 'প্রতি ঘণ্টার মিনিট নির্ধারণ করুন';

  @override
  String get notifScheduleValidateWeekday =>
      'সপ্তাহের অন্তত একটি দিন নির্ধারণ করুন';

  @override
  String get notifScheduleValidateInterval =>
      'মিনিটের সংখ্যা দিন (শূন্যের বেশি)';

  @override
  String get notifScheduleValidateDate => 'অন্তত একটি তারিখ যোগ করুন';

  @override
  String get notifScheduleDetails => 'বিস্তারিত';

  @override
  String get notifScheduleMinuteOfHourTitle => 'প্রতি ঘণ্টার মিনিট';

  @override
  String get notifScheduleMinuteOfHourSubtitle =>
      '0 থেকে 59-এর মধ্যে একটি সংখ্যা';

  @override
  String get notifScheduleMinuteUnit => 'মিনিট';

  @override
  String get notifScheduleRepeatTitle => 'পুনরাবৃত্তি';

  @override
  String get notifScheduleRepeatSubtitle =>
      'একটি সতর্কবার্তা থেকে পরেরটির ব্যবধান';

  @override
  String get notifScheduleCustomTime => 'কাস্টম সময়';

  @override
  String get notifScheduleDeleteTime => 'সময় মুছুন';

  @override
  String get notifScheduleNoTimesYet => 'এখনো কোনো সময় যোগ করেননি';

  @override
  String get notifScheduleAddTime => 'সময় যোগ করুন';

  @override
  String get notifScheduleSaveSchedule => 'সময়সূচি সংরক্ষণ করুন';

  @override
  String get notifScheduleAddNewTitle => 'নতুন সময় যোগ করুন';

  @override
  String get notifScheduleEditTitle => 'সময় সম্পাদনা';

  @override
  String get notifScheduleOptionalLabel => 'ঐচ্ছিক বিবরণ';

  @override
  String get notifScheduleAddConfirm => 'সময় যোগ করুন';

  @override
  String get notifScheduleSaveEdit => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get notifScheduleTypeDaily => 'দৈনিক';

  @override
  String get notifScheduleTypeHourly => 'প্রতি ঘণ্টায়';

  @override
  String get notifScheduleTypeEveryNMinutes => 'কয়েক মিনিট পরপর';

  @override
  String get notifScheduleTypeWeekly => 'সাপ্তাহিক';

  @override
  String get notifScheduleTypeCustomDates => 'কাস্টম তারিখ';

  @override
  String get notifScheduleTypeDailyDesc => 'প্রতিদিন একই সময়ে পুনরাবৃত্ত হয়';

  @override
  String get notifScheduleTypeHourlyDesc =>
      'প্রতি ঘণ্টায় নির্দিষ্ট মিনিটে পুনরাবৃত্ত হয়';

  @override
  String get notifScheduleTypeEveryNMinutesDesc =>
      'আপনার ঠিক করা সময় পরপর পুনরাবৃত্ত হয়';

  @override
  String get notifScheduleTypeWeeklyDesc =>
      'সপ্তাহের নির্দিষ্ট দিনে পুনরাবৃত্ত হয়';

  @override
  String get notifScheduleTypeCustomDatesDesc =>
      'আপনার বেছে নেওয়া তারিখ ও সময়ে দেখায়';

  @override
  String get notifScheduleTypeTitle => 'সময়সূচির ধরন';

  @override
  String get notifScheduleTimeTitle => 'সতর্কবার্তার সময়';

  @override
  String get notifScheduleTimeSubtitle => 'ঘণ্টা ও মিনিট বেছে নিতে চাপ দিন';

  @override
  String get notifScheduleLabelHint => 'এই সময়ের জন্য একটি ছোট বিবরণ যোগ করুন';

  @override
  String notifScheduleRowDaily(String time) {
    return 'প্রতিদিন · $time';
  }

  @override
  String notifScheduleRowWeekly(String days, String time) {
    return '$days · $time';
  }

  @override
  String get notifScheduleNoDays => 'কোনো দিন নেই';

  @override
  String notifScheduleRowCustom(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কাস্টম সময়',
      one: '$countটি কাস্টম সময়',
      zero: 'কোনো কাস্টম সময় নেই',
    );
    return '$_temp0';
  }

  @override
  String get notifScheduleDayShort1 => 'সোম';

  @override
  String get notifScheduleDayShort2 => 'মঙ্গল';

  @override
  String get notifScheduleDayShort3 => 'বুধ';

  @override
  String get notifScheduleDayShort4 => 'বৃহঃ';

  @override
  String get notifScheduleDayShort5 => 'শুক্র';

  @override
  String get notifScheduleDayShort6 => 'শনি';

  @override
  String get notifScheduleDayShort7 => 'রবি';

  @override
  String get notifScheduleAllDays => 'সব দিন';

  @override
  String get notifScheduleWorkDays => 'কর্মদিবস';

  @override
  String get notifScheduleWeekend => 'ছুটির দিন';

  @override
  String get notifScheduleClear => 'মুছুন';

  @override
  String get notifScheduleStatTotal => 'মোট';

  @override
  String get notifScheduleStatEnabled => 'চালু';

  @override
  String get notifScheduleStatStopped => 'বন্ধ';

  @override
  String get notifScheduleUnexpectedError => 'একটি অপ্রত্যাশিত সমস্যা হয়েছে';

  @override
  String get notifScheduleSaved => 'সংরক্ষিত হয়েছে';

  @override
  String get notifScheduleScreenTitle => 'নোটিফিকেশনের সময়';

  @override
  String get notifScheduleListTitle => 'সময়সমূহ';

  @override
  String get notifScheduleEmpty =>
      'এখনো কোনো সময় নেই — «সময় যোগ করুন» বোতাম থেকে একটি যোগ করুন।';

  @override
  String get notifScheduleDeleteTitle => 'সময় মুছুন';

  @override
  String get notifScheduleDeleteMessage =>
      'আপনি কি নিশ্চিতভাবে এই সময়টি মুছতে চান?\nএর সাথে যুক্ত সব নোটিফিকেশন বাতিল হবে।';

  @override
  String get notifScheduleSaving => 'সংরক্ষণ করা হচ্ছে...';

  @override
  String get notifScheduleLoading => 'সময়সমূহ লোড হচ্ছে...';

  @override
  String notifScheduleLoadFailed(String error) {
    return 'সময়সমূহ লোড করা যায়নি: $error';
  }

  @override
  String get notifScheduleAdded => 'সময় সফলভাবে যোগ হয়েছে';

  @override
  String notifScheduleAddFailed(String error) {
    return 'সময় যোগ করা যায়নি: $error';
  }

  @override
  String get notifScheduleUpdated => 'সময় সফলভাবে হালনাগাদ হয়েছে';

  @override
  String notifScheduleUpdateFailed(String error) {
    return 'সময় হালনাগাদ করা যায়নি: $error';
  }

  @override
  String get notifScheduleDeleted => 'সময় সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String notifScheduleDeleteFailed(String error) {
    return 'সময় মোছা যায়নি: $error';
  }

  @override
  String get notifScheduleActivated => 'সময়টি চালু হয়েছে';

  @override
  String get notifScheduleDeactivated => 'সময়টি বন্ধ হয়েছে';

  @override
  String notifScheduleToggleFailed(String error) {
    return 'সময়ের অবস্থা পরিবর্তন করা যায়নি: $error';
  }

  @override
  String get notifSettingsScheduledGroup => 'নির্ধারিত';

  @override
  String get notifSettingsNoScheduled =>
      'এই মুহূর্তে কোনো নির্ধারিত নোটিফিকেশন নেই';

  @override
  String get notifSettingsShownNowGroup => 'এখন দৃশ্যমান';

  @override
  String get notifSettingsNoShown => 'নোটিফিকেশন বারে কোনো নোটিফিকেশন নেই';

  @override
  String get notifSettingsUntitled => 'শিরোনামহীন নোটিফিকেশন';

  @override
  String get notifSettingsDismiss => 'নোটিফিকেশন লুকান';

  @override
  String get notifSettingsCancelNotification => 'নোটিফিকেশন বাতিল করুন';

  @override
  String notifSettingsAthanTicker(String prayer) {
    return 'এখন $prayer-এর আজানের সময় হয়েছে';
  }

  @override
  String get downloadTitle => 'ডাউনলোড';

  @override
  String get downloadEmptyAll =>
      'এখনো কোনো ডাউনলোড নেই, শুরু করতে একটি ডাউনলোড যোগ করুন।';

  @override
  String get downloadEmptyActive => 'কোনো সক্রিয় ডাউনলোড নেই';

  @override
  String get downloadEmptyCompleted => 'কোনো সম্পন্ন ডাউনলোড নেই';

  @override
  String get downloadEmptyPaused => 'কোনো থেমে থাকা ডাউনলোড নেই';

  @override
  String get downloadEmptyFailed => 'কোনো ব্যর্থ ডাউনলোড নেই';

  @override
  String get downloadCancelAll => 'সব বাতিল করুন';

  @override
  String get downloadCancelAllConfirm =>
      'আপনি কি নিশ্চিতভাবে সব সক্রিয় ডাউনলোড বাতিল করতে চান?';

  @override
  String get downloadAdd => 'ডাউনলোড যোগ করুন';

  @override
  String get downloadFilterAll => 'সব';

  @override
  String get downloadStatusActive => 'সক্রিয়';

  @override
  String get downloadStatusCompleted => 'সম্পন্ন';

  @override
  String get downloadStatusPaused => 'থেমে আছে';

  @override
  String get downloadStatusFailed => 'ব্যর্থ';

  @override
  String get downloadStarted => 'ডাউনলোড শুরু হয়েছে';

  @override
  String get downloadAddNewTitle => 'নতুন ডাউনলোড যোগ করুন';

  @override
  String get downloadUrlLabel => 'ফাইলের লিংক';

  @override
  String get downloadUrlRequired => 'অনুগ্রহ করে ডাউনলোড লিংক দিন';

  @override
  String get downloadUrlInvalid => 'অনুগ্রহ করে একটি সঠিক লিংক দিন';

  @override
  String get downloadFileNameLabel => 'ফাইলের নাম';

  @override
  String get downloadOptional => 'ঐচ্ছিক';

  @override
  String get downloadPublicStorageTitle => 'পাবলিক স্টোরেজ';

  @override
  String get downloadPublicStorageSubtitle => 'ডাউনলোড ফোল্ডারে সংরক্ষণ করুন';

  @override
  String get downloadAllowCellularTitle => 'মোবাইল ডেটা ব্যবহারের অনুমতি';

  @override
  String get downloadAllowCellularSubtitle => 'মোবাইল ডেটা দিয়ে ডাউনলোড করুন';

  @override
  String get downloadStart => 'ডাউনলোড শুরু করুন';

  @override
  String get downloadPause => 'বিরতি';

  @override
  String get downloadResume => 'চালিয়ে যান';

  @override
  String get downloadOpenFile => 'ফাইল খুলুন';

  @override
  String get downloadRemoveFromList => 'তালিকা থেকে সরান';

  @override
  String get downloadDeleteFile => 'ফাইল মুছুন';

  @override
  String get downloadTotal => 'মোট';

  @override
  String get downloadInProgressNow => 'এখন ডাউনলোড হচ্ছে';

  @override
  String downloadAndMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এবং আরও $countটি',
      one: 'এবং আরও $countটি',
    );
    return '$_temp0';
  }

  @override
  String get widgetLabelNextPrayer => 'পরবর্তী নামাজ';

  @override
  String get widgetLabelDailyAyah => 'আজকের আয়াত';

  @override
  String get widgetLabelOpenApp => 'তামানিনা খুলুন';

  @override
  String get widgetLabelSetLocation => 'অ্যাপে আপনার লোকেশন দিন';

  @override
  String get widgetLabelRefreshNeeded => 'সময়সূচি হালনাগাদ করতে';

  @override
  String widgetLabelNextIn(String prayer) {
    return '$prayer বাকি';
  }

  @override
  String get dailyWirdTitle => 'দিন-রাতের পাথেয়';

  @override
  String get dailyWirdSettingsTooltip => 'পাথেয় সেটিংস';

  @override
  String get dailyWirdUnexpectedError => 'একটি অপ্রত্যাশিত সমস্যা হয়েছে।';

  @override
  String get dailyWirdRemindersHeader => 'রিমাইন্ডার';

  @override
  String get dailyWirdReminderSleepLabel => 'ঘুমের জিকির';

  @override
  String get dailyWirdProgramHeader => 'প্রোগ্রাম';

  @override
  String get dailyWirdSaveSetup => 'সেটআপ সংরক্ষণ করুন';

  @override
  String get dailyWirdSetupFailed => 'ইবাদতের পাথেয় সেটআপ করা যায়নি।';

  @override
  String get dailyWirdItemNotFound => 'ইবাদতের পাথেয়র আইটেমটি পাওয়া যায়নি।';

  @override
  String get dailyWirdTodayTasksHeader => 'আজকের আমল';

  @override
  String dailyWirdStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ধারাবাহিকতা $count দিন',
      one: 'ধারাবাহিকতা $count দিন',
      zero: 'ধারাবাহিকতা ০ দিন',
    );
    return '$_temp0';
  }

  @override
  String dailyWirdWeeklyAdherence(int percent) {
    return 'সাপ্তাহিক নিয়মিততা $percent%';
  }

  @override
  String get dailyWirdChoosePresetTitle => 'আপনার ইবাদতের পাথেয় বেছে নিন';

  @override
  String get dailyWirdChoosePresetSubtitle =>
      'একটি প্রস্তুত প্রোগ্রাম দিয়ে শুরু করুন, তারপর নিজের মতো সাজিয়ে নিন';

  @override
  String get dailyWirdItemOptions => 'আমলের অপশন';

  @override
  String get dailyWirdEditTargetCount => 'লক্ষ্য সংখ্যা সম্পাদনা';

  @override
  String get dailyWirdStartOver => 'নতুন করে শুরু করুন';

  @override
  String get dailyWirdMoveUp => 'উপরে সরান';

  @override
  String get dailyWirdMoveDown => 'নিচে সরান';

  @override
  String get dailyWirdHideItem => 'পাথেয় থেকে লুকান';

  @override
  String get dailyWirdCountHint => 'উদাহরণ: ৫০ বার';

  @override
  String get dailyWirdTimeMorning => 'সকাল';

  @override
  String get dailyWirdTimeEvening => 'সন্ধ্যা';

  @override
  String get dailyWirdTimeNight => 'রাত';

  @override
  String get dailyWirdTimeAny => 'যেকোনো সময়';

  @override
  String get dailyWirdTimeMorningLong => 'সকালের সময়';

  @override
  String get dailyWirdTimeEveningLong => 'সন্ধ্যার সময়';

  @override
  String get dailyWirdTimeNightLong => 'ঘুমের আগে';

  @override
  String get dailyWirdTimeAnyLong => 'যেকোনো সময়ে';

  @override
  String get dailyWirdTypeDhikrSet => 'জিকির';

  @override
  String get dailyWirdTypeCountedDhikr => 'সংখ্যাসহ জিকির';

  @override
  String get dailyWirdTypeQuran => 'কুরআনের আমল';

  @override
  String get dailyWirdTypeDua => 'দোয়া';

  @override
  String get dailyWirdTypeSurah => 'সূরা';

  @override
  String dailyWirdCountProgress(int done, int total) {
    return '$total-এর মধ্যে $done';
  }

  @override
  String dailyWirdCompletedOf(int done, int total, String unit) {
    return 'সম্পন্ন $done / $total$unit';
  }

  @override
  String get dailyWirdItemDone => 'সম্পন্ন';

  @override
  String get dailyWirdMarkComplete => 'সম্পন্ন করুন';

  @override
  String get dailyWirdCountOnce => 'একবার গুনুন';

  @override
  String get dailyWirdCompleteThis => 'এই আমল সম্পন্ন করুন';

  @override
  String get dailyWirdUncomplete => 'সম্পন্ন বাতিল করুন';

  @override
  String get dailyWirdReminderMorningTitle => 'সকালের পাথেয়';

  @override
  String get dailyWirdReminderMorningBody =>
      'আল্লাহর জিকির, তাঁর কিতাব তিলাওয়াত ও দোয়া দিয়ে দিন শুরু করুন।';

  @override
  String get dailyWirdReminderEveningTitle => 'সন্ধ্যার পাথেয়';

  @override
  String get dailyWirdReminderEveningBody =>
      'আল্লাহর সাথে সম্পর্ক নবায়ন করুন এবং সন্ধ্যার পাথেয় থেকে যা সহজ হয় সম্পন্ন করুন।';

  @override
  String get dailyWirdReminderNightTitle => 'ঘুমের আগের পাথেয়';

  @override
  String get dailyWirdReminderNightBody =>
      'জিকির, দোয়া ও ইবাদতের বাকি পাথেয় দিয়ে দিনটি শেষ করুন।';

  @override
  String get dailyWirdReminderSummaryTitle => 'দিনশেষের আত্মসমালোচনা';

  @override
  String get dailyWirdReminderSummaryBody =>
      'আজকের ইবাদতের পাথেয় দেখে নিন, কতটুকু সম্পন্ন করেছেন তা মিলিয়ে নিন।';

  @override
  String get wirdMorningAdhkar => 'সকালের জিকির';

  @override
  String get wirdEveningAdhkar => 'সন্ধ্যার জিকির';

  @override
  String get wirdMorningTitle => 'সকালের আমল';

  @override
  String get wirdEveningTitle => 'সন্ধ্যার আমল';

  @override
  String get wirdSearchHint => 'জিকির খুঁজুন';

  @override
  String wirdPagerPosition(int current, int total) {
    return 'জিকির $current / $total';
  }

  @override
  String get wirdPrevious => 'আগেরটি';

  @override
  String get wirdNext => 'পরেরটি';

  @override
  String get wirdShowSingle => 'একটি করে জিকির দেখুন';

  @override
  String get wirdShowList => 'জিকির তালিকা আকারে দেখুন';

  @override
  String get wirdTypeMorningOnly => 'শুধু সকাল';

  @override
  String get wirdTypeEveningOnly => 'শুধু সন্ধ্যা';

  @override
  String get wirdTypeBoth => 'সকাল ও সন্ধ্যা';

  @override
  String get wirdNoAudio => 'কোনো অডিও ফাইল নেই';

  @override
  String get wirdPause => 'বিরতি';

  @override
  String get wirdReplay => 'আবার চালান';

  @override
  String get wirdPlayAudio => 'অডিও চালান';

  @override
  String wirdRemaining(int remaining, int total) {
    return '$total-এর মধ্যে $remaining বাকি';
  }

  @override
  String get wirdCompleted => 'সম্পন্ন করেছেন';

  @override
  String get wirdResetCount => 'আবার গুনুন';

  @override
  String get wirdCopyDhikr => 'জিকির কপি করুন';

  @override
  String get wirdSource => 'সূত্র';

  @override
  String get wirdShowDetails => 'বিস্তারিত দেখুন';

  @override
  String get wirdHideDetails => 'বিস্তারিত লুকান';

  @override
  String get wirdVirtue => 'ফজিলত';

  @override
  String get wirdHadithText => 'হাদিসের মূল পাঠ';

  @override
  String get wirdWordExplanations => 'নির্বাচিত শব্দের ব্যাখ্যা';

  @override
  String get wirdReadOnce => 'একবার পড়েছি';

  @override
  String get wirdPlayAll => 'পুরো আমল চালান';

  @override
  String get wirdPreparingAudio => 'অডিও প্রস্তুত হচ্ছে';

  @override
  String get wirdReplayAll => 'পুরো আমল আবার চালান';

  @override
  String get wirdPlayAllFinished => 'সব জিকির চালানো শেষ হয়েছে।';

  @override
  String get wirdNowPlaying => 'এখন পড়া হচ্ছে';

  @override
  String wirdRepeatProgress(int current, int total) {
    return 'পুনরাবৃত্তি $current / $total';
  }

  @override
  String get thikrLibraryTitle => 'জিকির লাইব্রেরি';

  @override
  String get thikrGroupDaily => 'আপনার দিনের জিকির';

  @override
  String get thikrMorningSubtitle => 'ফজরের পর থেকে বেলা ওঠা পর্যন্ত আপনার আমল';

  @override
  String get thikrEveningSubtitle => 'আসরের পর থেকে রাত পর্যন্ত আপনার আমল';

  @override
  String get thikrSleepTitle => 'ঘুম ও স্বপ্নের দোয়া';

  @override
  String get thikrSleepSubtitle => 'ঘুমের আগে ও ঘুমে ভয় পেলে যা পড়বেন';

  @override
  String get thikrPrayerJumuahTitle => 'নামাজ ও জুমার জিকির';

  @override
  String get thikrPrayerJumuahSubtitle =>
      'আজান, নামাজের পর ও জুমার দিনের জিকির';

  @override
  String get thikrGroupDuas => 'মাসনুন দোয়া';

  @override
  String get thikrQuranicDuasTitle => 'কুরআনের দোয়া';

  @override
  String get thikrQuranicDuasSubtitle => 'আল্লাহর কিতাবে বর্ণিত নবীদের দোয়া';

  @override
  String get thikrComprehensiveDuasTitle => 'ব্যাপক অর্থবোধক দোয়া';

  @override
  String get thikrComprehensiveDuasSubtitle =>
      'দুনিয়া ও আখিরাতের কল্যাণ একত্র করা দোয়া';

  @override
  String get thikrHajjTitle => 'হজ ও উমরার দোয়া';

  @override
  String get thikrHajjSubtitle =>
      'ইহরাম, তাওয়াফ, সাঈ ও পবিত্র স্থানসমূহের দোয়া';

  @override
  String get thikrFuneralTitle => 'মৃত ব্যক্তি ও জানাজার দোয়া';

  @override
  String get thikrFuneralSubtitle => 'জানাজার নামাজে ও কবরের কাছে যা পড়া হয়';

  @override
  String get thikrGroupTools => 'আপনার টুলস';

  @override
  String get thikrTasbeehTitle => 'তাসবিহ';

  @override
  String get thikrTasbeehSubtitle =>
      'আপনার তাসবিহ গোনে এবং দিনের হিসাব সংরক্ষণ করে এমন কাউন্টার';

  @override
  String get thikrMyDuasSubtitle => 'আপনার নিজের যোগ করা দোয়াগুলো এক জায়গায়';

  @override
  String get thikrSliderSubtitle => 'এই সময়ের আমল, এখনই খুলুন';

  @override
  String get afterPrayerTitle => 'নামাজের পরের জিকির';

  @override
  String get afterPrayerSubtitle => 'ফরজ নামাজের পরের জিকির';

  @override
  String get afterPrayerSearchHint => 'জিকির খুঁজুন';

  @override
  String afterPrayerFallbackTitle(int number) {
    return 'নামাজের পরের জিকির $number';
  }

  @override
  String afterPrayerRepeatCountLine(int count) {
    return 'পুনরাবৃত্তি: $count';
  }

  @override
  String afterPrayerVirtueLine(String virtue) {
    return 'ফজিলত: $virtue';
  }

  @override
  String get afterPrayerRepeatLabel => 'পুনরাবৃত্তি';

  @override
  String get afterPrayerVirtueLabel => 'ফজিলত';

  @override
  String get afterPrayerMentioned => 'উল্লেখ আছে';

  @override
  String get afterPrayerNotMentioned => 'উল্লেখ নেই';

  @override
  String get afterPrayerTextSection => 'জিকিরের লেখা';

  @override
  String get afterPrayerVirtueSection => 'জিকিরের ফজিলত';

  @override
  String afterPrayerRepeatTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার',
      one: '$count বার',
    );
    return '$_temp0';
  }

  @override
  String get afterPrayerNoResults => 'মিলে যাওয়া কোনো ফলাফল নেই';

  @override
  String get afterPrayerShowAll => 'সব জিকির দেখুন';

  @override
  String get myDuasTitle => 'আমার দোয়া';

  @override
  String get myDuasActionFailed => 'কাজটি সম্পন্ন করা যায়নি।';

  @override
  String get myDuasEmptyCustomTitle => 'কোনো দোয়া যোগ করা হয়নি';

  @override
  String get myDuasEmptyCustomMessage =>
      'এই বিভাগে শুধু আপনার যোগ করা দোয়াগুলো দেখানো হয়।';

  @override
  String get myDuasEmptyTitle => 'এখনো কোনো দোয়া নেই';

  @override
  String get myDuasEmptyMessage =>
      'আপনার প্রথম দোয়া যোগ করুন, তা সঙ্গে সঙ্গে এখানে দেখাবে।';

  @override
  String get myDuasAddNew => 'নতুন দোয়া যোগ করুন';

  @override
  String get myDuasAdd => 'দোয়া যোগ করুন';

  @override
  String get myDuasAddSubtitle =>
      'দোয়াটি লিখুন, তা আপনার নিজস্ব দোয়ার মধ্যে দেখাবে।';

  @override
  String get myDuasEditTitle => 'দোয়া সম্পাদনা';

  @override
  String get myDuasEditSubtitle =>
      'লেখা বা বিবরণ সম্পাদনা করে সরাসরি পরিবর্তন সংরক্ষণ করতে পারেন।';

  @override
  String get myDuasCountLabel => 'দোয়ার সংখ্যা';

  @override
  String get myDuasTodayLabel => 'আজকের পাঠ';

  @override
  String get myDuasOptions => 'দোয়ার অপশন';

  @override
  String get myDuasResetToday => 'আজকের গণনা শূন্য করুন';

  @override
  String get ruqyahTitle => 'শরয়ি রুকইয়া';

  @override
  String get ruqyahSearchHint => 'রুকইয়া খুঁজুন';

  @override
  String get ruqyahDefaultReference => 'আল-কুরআনুল কারিম';

  @override
  String get ruqyahUnspecified => 'অনির্ধারিত';

  @override
  String ruqyahRepeatLine(String count) {
    return 'পুনরাবৃত্তি: $count';
  }

  @override
  String ruqyahReferenceLine(String reference) {
    return 'সূত্র: $reference';
  }

  @override
  String ruqyahDescriptionLine(String description) {
    return 'বিবরণ: $description';
  }

  @override
  String ruqyahNumber(int number) {
    return 'রুকইয়া $number';
  }

  @override
  String get ruqyahTextSection => 'রুকইয়ার লেখা';

  @override
  String get ruqyahDescriptionSection => 'বিবরণ';

  @override
  String get ruqyahNoResultsTitle => 'কোনো ফলাফল নেই';

  @override
  String get ruqyahNoResultsMessage =>
      'আপনার অনুসন্ধানের সাথে মেলে এমন কোনো রুকইয়া পাওয়া যায়নি।';

  @override
  String get ruqyahShowAll => 'সব রুকইয়া দেখুন';

  @override
  String get radioTitle => 'রেডিও';

  @override
  String get radioKindReciters => 'কারি';

  @override
  String get radioKindPrograms => 'অনুষ্ঠান ও তিলাওয়াত';

  @override
  String get radioLoadFailed => 'এই মুহূর্তে রেডিও স্টেশন লোড করা যাচ্ছে না।';

  @override
  String get radioPlayFailed => 'এখন রেডিও চালানো যাচ্ছে না।';

  @override
  String get radioToggleFailed => 'চালানোর অবস্থা পরিবর্তন করা যায়নি।';

  @override
  String get radioStopFailed => 'রেডিও বন্ধ করা যায়নি।';

  @override
  String get radioNoMatch => 'এই নামে কোনো স্টেশন নেই।';

  @override
  String get radioSearchHint => 'কারি বা অনুষ্ঠান খুঁজুন';

  @override
  String get radioFavouritesHint =>
      'যেকোনো স্টেশন প্রিয়তে যোগ করতে কিছুক্ষণ চেপে ধরুন।';

  @override
  String get radioAddFavourite => 'প্রিয়তে যোগ করুন';

  @override
  String get radioRemoveFavourite => 'প্রিয় থেকে সরান';

  @override
  String radioAddedToFavourites(String station) {
    return '$station প্রিয়তে যোগ হয়েছে';
  }

  @override
  String radioRemovedFromFavourites(String station) {
    return '$station প্রিয় থেকে সরানো হয়েছে';
  }

  @override
  String get radioSleepTimer => 'স্লিপ টাইমার';

  @override
  String get radioSleepTimerDescription =>
      'নির্বাচিত সময় পরে সম্প্রচার নিজে থেকেই বন্ধ হবে।';

  @override
  String radioStopsIn(String time) {
    return '$time পরে বন্ধ হবে';
  }

  @override
  String get radioCancelTimer => 'টাইমার বাতিল করুন';

  @override
  String radioMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট',
      one: '$count মিনিট',
    );
    return '$_temp0';
  }

  @override
  String get radioStopBroadcast => 'সম্প্রচার বন্ধ করুন';

  @override
  String get radioTuning => 'সংযোগ করা হচ্ছে…';

  @override
  String get radioLive => 'সরাসরি সম্প্রচার';

  @override
  String get radioPaused => 'বিরতিতে আছে';

  @override
  String get radioTapToPlay => 'চালাতে চাপ দিন';

  @override
  String get radioPause => 'বিরতি';

  @override
  String get radioPlay => 'চালান';
}
