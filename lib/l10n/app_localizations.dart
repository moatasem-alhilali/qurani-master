import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('fa'),
    Locale('id'),
    Locale('tr'),
    Locale('ur')
  ];

  /// Name of the "floating adhkar" feature: short remembrances of Allah that pop up over other apps (Android overlay) or as periodic reminders (iPhone).
  ///
  /// In ar, this message translates to:
  /// **'الأذكار العائمة'**
  String get floatingAdhkarTitle;

  /// Source tag for adhkar that ship with the app (built-in), shown next to a dhikr.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get floatingAdhkarSourceBuiltIn;

  /// Source tag for adhkar the user added themselves.
  ///
  /// In ar, this message translates to:
  /// **'مخصص'**
  String get floatingAdhkarSourceCustom;

  /// Label for the user's own adhkar ("my adhkar"): a source name and a settings row title.
  ///
  /// In ar, this message translates to:
  /// **'أذكاري الخاصة'**
  String get floatingAdhkarSourceMyAdhkar;

  /// Fallback source name for a built-in dhikr whose source is unknown ("the app library").
  ///
  /// In ar, this message translates to:
  /// **'مكتبة التطبيق'**
  String get floatingAdhkarSourceAppLibrary;

  /// Fallback title for a built-in dhikr that has no title.
  ///
  /// In ar, this message translates to:
  /// **'ذكر افتراضي'**
  String get floatingAdhkarDefaultDhikrTitle;

  /// Fallback notification title for a random dhikr reminder (iPhone) when the dhikr has no title.
  ///
  /// In ar, this message translates to:
  /// **'ذكر عشوائي'**
  String get floatingAdhkarRandomDhikrTitle;

  /// iOS notification subtitle for random adhkar reminders.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار العشوائية'**
  String get floatingAdhkarIosNotificationSubtitle;

  /// Title of the Android persistent notification while the floating adhkar background service runs.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار العشوائية العائمة'**
  String get floatingAdhkarOverlayServiceTitle;

  /// Body of the Android persistent notification while the floating adhkar service runs.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الأذكار العائمة تعمل في الخلفية'**
  String get floatingAdhkarOverlayServiceContent;

  /// No description provided for @floatingAdhkarErrorUnsupportedPlatform.
  ///
  /// In ar, this message translates to:
  /// **'هذه الميزة غير متاحة على هذه المنصة.'**
  String get floatingAdhkarErrorUnsupportedPlatform;

  /// No description provided for @floatingAdhkarErrorIosNotificationsToEnable.
  ///
  /// In ar, this message translates to:
  /// **'يجب السماح بالإشعارات لتشغيل تذكيرات الأذكار على iPhone.'**
  String get floatingAdhkarErrorIosNotificationsToEnable;

  /// Android permission "display over other apps" is needed first.
  ///
  /// In ar, this message translates to:
  /// **'يجب منح صلاحية الظهور فوق التطبيقات الأخرى أولًا.'**
  String get floatingAdhkarErrorOverlayPermissionFirst;

  /// No description provided for @floatingAdhkarErrorNoSource.
  ///
  /// In ar, this message translates to:
  /// **'فعّل مصدرًا واحدًا على الأقل للأذكار العائمة.'**
  String get floatingAdhkarErrorNoSource;

  /// No description provided for @floatingAdhkarErrorIosNotificationsRequired.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الإشعارات مطلوبة لتشغيل تذكيرات iPhone.'**
  String get floatingAdhkarErrorIosNotificationsRequired;

  /// No description provided for @floatingAdhkarErrorOverlayPermissionRequired.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية مطلوبة لتشغيل النافذة العائمة.'**
  String get floatingAdhkarErrorOverlayPermissionRequired;

  /// No description provided for @floatingAdhkarErrorTitleAndTextRequired.
  ///
  /// In ar, this message translates to:
  /// **'العنوان والنص مطلوبان لتحديث الذكر الافتراضي.'**
  String get floatingAdhkarErrorTitleAndTextRequired;

  /// No description provided for @floatingAdhkarErrorNotificationsDenied.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم منح صلاحية الإشعارات.'**
  String get floatingAdhkarErrorNotificationsDenied;

  /// No description provided for @floatingAdhkarErrorOverlayDenied.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم منح صلاحية الظهور فوق التطبيقات الأخرى.'**
  String get floatingAdhkarErrorOverlayDenied;

  /// No description provided for @floatingAdhkarErrorEnableBeforePreview.
  ///
  /// In ar, this message translates to:
  /// **'فعّل الميزة أولًا ثم استخدم المعاينة المباشرة.'**
  String get floatingAdhkarErrorEnableBeforePreview;

  /// No description provided for @floatingAdhkarErrorPreviewNotificationsRequired.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الإشعارات مطلوبة لعرض ذكر الآن.'**
  String get floatingAdhkarErrorPreviewNotificationsRequired;

  /// No description provided for @floatingAdhkarErrorPreviewOverlayRequired.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية مطلوبة لعرض الذكر العائم.'**
  String get floatingAdhkarErrorPreviewOverlayRequired;

  /// Status of the floating adhkar service (feminine: refers to "the service").
  ///
  /// In ar, this message translates to:
  /// **'غير مدعومة'**
  String get floatingAdhkarStatusUnsupported;

  /// Status of the floating adhkar service: needs a permission.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج صلاحية'**
  String get floatingAdhkarStatusPermissionRequired;

  /// Status of the floating adhkar service: needs setup.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج تهيئة'**
  String get floatingAdhkarStatusMisconfigured;

  /// Status of the floating adhkar service: running now.
  ///
  /// In ar, this message translates to:
  /// **'تعمل الآن'**
  String get floatingAdhkarStatusActive;

  /// Status of the floating adhkar service: stopped.
  ///
  /// In ar, this message translates to:
  /// **'متوقفة'**
  String get floatingAdhkarStatusInactive;

  /// Screen title / button: manage which adhkar appear.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الأذكار'**
  String get floatingAdhkarManageTitle;

  /// No description provided for @floatingAdhkarManageSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر ما يظهر من الافتراضي وأضف أذكارك'**
  String get floatingAdhkarManageSubtitle;

  /// No description provided for @floatingAdhkarAddPrivateTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ذكر خاص'**
  String get floatingAdhkarAddPrivateTooltip;

  /// No description provided for @floatingAdhkarAddCustomTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ذكر مخصص'**
  String get floatingAdhkarAddCustomTitle;

  /// No description provided for @floatingAdhkarAddCustomSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سيصبح متاحًا ضمن الأذكار العائمة عند تفعيله.'**
  String get floatingAdhkarAddCustomSubtitle;

  /// No description provided for @floatingAdhkarEditTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الذكر'**
  String get floatingAdhkarEditTitle;

  /// No description provided for @floatingAdhkarEditSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّث النص ثم احفظ التغييرات مباشرة.'**
  String get floatingAdhkarEditSubtitle;

  /// Count badge: how many adhkar are enabled out of the total, e.g. "3 of 10".
  ///
  /// In ar, this message translates to:
  /// **'{enabled} من {total}'**
  String floatingAdhkarEnabledOfTotal(int enabled, int total);

  /// No description provided for @floatingAdhkarEmptyBuiltInTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أذكار افتراضية متاحة'**
  String get floatingAdhkarEmptyBuiltInTitle;

  /// No description provided for @floatingAdhkarEmptyBuiltInMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على مكتبة الأذكار الافتراضية داخل التطبيق.'**
  String get floatingAdhkarEmptyBuiltInMessage;

  /// No description provided for @floatingAdhkarEmptyCustomTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أذكار خاصة بعد'**
  String get floatingAdhkarEmptyCustomTitle;

  /// No description provided for @floatingAdhkarEmptyCustomMessage.
  ///
  /// In ar, this message translates to:
  /// **'أضف ذكرك أو دعاءك ليدخل ضمن الدوران العشوائي العائم.'**
  String get floatingAdhkarEmptyCustomMessage;

  /// No description provided for @floatingAdhkarAddNewDhikr.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ذكر جديد'**
  String get floatingAdhkarAddNewDhikr;

  /// Tooltip of the "more" menu on a dhikr row.
  ///
  /// In ar, this message translates to:
  /// **'خيارات الذكر'**
  String get floatingAdhkarItemOptions;

  /// Built-in adhkar (tab title and source row title).
  ///
  /// In ar, this message translates to:
  /// **'الأذكار الافتراضية'**
  String get floatingAdhkarTabBuiltIn;

  /// The user's own adhkar (tab title).
  ///
  /// In ar, this message translates to:
  /// **'الأذكار الخاصة'**
  String get floatingAdhkarTabCustom;

  /// Section header above a preview of the next dhikr.
  ///
  /// In ar, this message translates to:
  /// **'معاينة الذكر'**
  String get floatingAdhkarPreviewHeader;

  /// No description provided for @floatingAdhkarAdvancedTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات متقدمة'**
  String get floatingAdhkarAdvancedTitle;

  /// No description provided for @floatingAdhkarAdvancedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'معدل الظهور ومدّة البقاء والمصادر'**
  String get floatingAdhkarAdvancedSubtitle;

  /// How often a floating dhikr appears.
  ///
  /// In ar, this message translates to:
  /// **'معدل الظهور'**
  String get floatingAdhkarFrequencyTitle;

  /// How long a floating dhikr stays on screen.
  ///
  /// In ar, this message translates to:
  /// **'مدة بقاء الذكر'**
  String get floatingAdhkarVisibleDurationTitle;

  /// A duration in seconds.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{ثانية واحدة} =2{ثانيتان} few{{count} ثوانٍ} other{{count} ثانية}}'**
  String floatingAdhkarSecondsCount(int count);

  /// No description provided for @floatingAdhkarSourcesTitle.
  ///
  /// In ar, this message translates to:
  /// **'مصادر الأذكار'**
  String get floatingAdhkarSourcesTitle;

  /// No description provided for @floatingAdhkarAllowNotifications.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالإشعارات'**
  String get floatingAdhkarAllowNotifications;

  /// No description provided for @floatingAdhkarGrantPermission.
  ///
  /// In ar, this message translates to:
  /// **'منح الصلاحية المطلوبة'**
  String get floatingAdhkarGrantPermission;

  /// No description provided for @floatingAdhkarPermissionHint.
  ///
  /// In ar, this message translates to:
  /// **'بدونها لن يظهر الذكر فوق التطبيقات'**
  String get floatingAdhkarPermissionHint;

  /// iPhone: send a dhikr notification now.
  ///
  /// In ar, this message translates to:
  /// **'إرسال ذكر الآن'**
  String get floatingAdhkarSendNow;

  /// Android: show a floating dhikr now.
  ///
  /// In ar, this message translates to:
  /// **'عرض ذكر الآن'**
  String get floatingAdhkarShowNow;

  /// No description provided for @floatingAdhkarPreviewReadyHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب شكل الذكر كما سيظهر لك'**
  String get floatingAdhkarPreviewReadyHint;

  /// No description provided for @floatingAdhkarPreviewDisabledHint.
  ///
  /// In ar, this message translates to:
  /// **'فعّل الخدمة وامنح الصلاحية أولًا'**
  String get floatingAdhkarPreviewDisabledHint;

  /// No description provided for @floatingAdhkarIosReminders.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات iPhone'**
  String get floatingAdhkarIosReminders;

  /// No description provided for @floatingAdhkarFloatingService.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة العائمة'**
  String get floatingAdhkarFloatingService;

  /// No description provided for @floatingAdhkarUnsupportedPlatform.
  ///
  /// In ar, this message translates to:
  /// **'غير مدعوم على هذه المنصة'**
  String get floatingAdhkarUnsupportedPlatform;

  /// Short stat label under a number: built-in adhkar.
  ///
  /// In ar, this message translates to:
  /// **'الافتراضية'**
  String get floatingAdhkarStatBuiltIn;

  /// Short stat label under a number: the user's own adhkar.
  ///
  /// In ar, this message translates to:
  /// **'الخاصة'**
  String get floatingAdhkarStatCustom;

  /// No description provided for @floatingAdhkarSettingsTitleIos.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات تذكيرات الأذكار'**
  String get floatingAdhkarSettingsTitleIos;

  /// No description provided for @floatingAdhkarSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الأذكار العائمة'**
  String get floatingAdhkarSettingsTitle;

  /// No description provided for @floatingAdhkarReminderTiming.
  ///
  /// In ar, this message translates to:
  /// **'توقيت التذكير'**
  String get floatingAdhkarReminderTiming;

  /// No description provided for @floatingAdhkarAppearanceTiming.
  ///
  /// In ar, this message translates to:
  /// **'توقيت الظهور'**
  String get floatingAdhkarAppearanceTiming;

  /// No description provided for @floatingAdhkarReminderFrequency.
  ///
  /// In ar, this message translates to:
  /// **'معدل تكرار التنبيه'**
  String get floatingAdhkarReminderFrequency;

  /// No description provided for @floatingAdhkarAppearanceFrequency.
  ///
  /// In ar, this message translates to:
  /// **'معدل تكرار الظهور'**
  String get floatingAdhkarAppearanceFrequency;

  /// No description provided for @floatingAdhkarBuiltInSourceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المصدر الداخلي الأساسي للتطبيق'**
  String get floatingAdhkarBuiltInSourceSubtitle;

  /// No description provided for @floatingAdhkarCustomSourceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار التي أضفتها بنفسك'**
  String get floatingAdhkarCustomSourceSubtitle;

  /// No description provided for @floatingAdhkarMixSources.
  ///
  /// In ar, this message translates to:
  /// **'الخلط بين المصادر'**
  String get floatingAdhkarMixSources;

  /// No description provided for @floatingAdhkarMixSourcesOn.
  ///
  /// In ar, this message translates to:
  /// **'يتم الاختيار من قائمة موحدة'**
  String get floatingAdhkarMixSourcesOn;

  /// No description provided for @floatingAdhkarMixSourcesOff.
  ///
  /// In ar, this message translates to:
  /// **'يتم التناوب بين الافتراضي والمخصص'**
  String get floatingAdhkarMixSourcesOff;

  /// No description provided for @floatingAdhkarSaveNeedsSource.
  ///
  /// In ar, this message translates to:
  /// **'فعّل مصدرًا واحدًا على الأقل قبل الحفظ.'**
  String get floatingAdhkarSaveNeedsSource;

  /// No description provided for @floatingAdhkarMasterSwitch.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الميزة بالكامل'**
  String get floatingAdhkarMasterSwitch;

  /// No description provided for @floatingAdhkarMasterSwitchIosHint.
  ///
  /// In ar, this message translates to:
  /// **'تُجدول تنبيهات أذكار على iPhone'**
  String get floatingAdhkarMasterSwitchIosHint;

  /// No description provided for @floatingAdhkarMasterSwitchHint.
  ///
  /// In ar, this message translates to:
  /// **'تبدأ الخدمة الخلفية في إظهار الأذكار'**
  String get floatingAdhkarMasterSwitchHint;

  /// No description provided for @floatingAdhkarSaveSettings.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإعدادات'**
  String get floatingAdhkarSaveSettings;

  /// How often a dhikr appears, e.g. "every 5 minutes".
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{كل دقيقة} =2{كل دقيقتين} few{كل {count} دقائق} other{كل {count} دقيقة}}'**
  String floatingAdhkarEveryMinutes(int count);

  /// No description provided for @floatingAdhkarSourcesMixed.
  ///
  /// In ar, this message translates to:
  /// **'دمج بين الافتراضي والمخصص'**
  String get floatingAdhkarSourcesMixed;

  /// No description provided for @floatingAdhkarSourcesAlternating.
  ///
  /// In ar, this message translates to:
  /// **'تناوب بين الافتراضي والمخصص'**
  String get floatingAdhkarSourcesAlternating;

  /// No description provided for @floatingAdhkarSourcesBuiltInOnly.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار الافتراضية فقط'**
  String get floatingAdhkarSourcesBuiltInOnly;

  /// No description provided for @floatingAdhkarSourcesCustomOnly.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المستخدم فقط'**
  String get floatingAdhkarSourcesCustomOnly;

  /// No description provided for @floatingAdhkarSourcesNone.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد مصدر مفعّل'**
  String get floatingAdhkarSourcesNone;

  /// Name of the digital tasbih (prayer beads counter) screen.
  ///
  /// In ar, this message translates to:
  /// **'المسبحة'**
  String get sabihTitle;

  /// Prayer-bead material: walnut wood.
  ///
  /// In ar, this message translates to:
  /// **'جوز'**
  String get sabihBeadWalnut;

  /// Prayer-bead material: oak wood.
  ///
  /// In ar, this message translates to:
  /// **'بلّوط'**
  String get sabihBeadOak;

  /// Prayer-bead material: emerald.
  ///
  /// In ar, this message translates to:
  /// **'زمرّد'**
  String get sabihBeadEmerald;

  /// Prayer-bead material: black onyx.
  ///
  /// In ar, this message translates to:
  /// **'عقيق أسود'**
  String get sabihBeadOnyx;

  /// Prayer-bead material: amber.
  ///
  /// In ar, this message translates to:
  /// **'كهرمان'**
  String get sabihBeadAmber;

  /// Prayer-bead material: mahogany wood.
  ///
  /// In ar, this message translates to:
  /// **'ماهوجني'**
  String get sabihBeadMahogany;

  /// Prayer-bead material colour: olive/sage green.
  ///
  /// In ar, this message translates to:
  /// **'زيتوني'**
  String get sabihBeadSage;

  /// Prayer-bead material: red agate / garnet.
  ///
  /// In ar, this message translates to:
  /// **'عقيق أحمر'**
  String get sabihBeadGarnet;

  /// No description provided for @sabihErrorRefreshList.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث قائمة الأذكار.'**
  String get sabihErrorRefreshList;

  /// No description provided for @sabihErrorLoad.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل الأذكار.'**
  String get sabihErrorLoad;

  /// No description provided for @sabihErrorRecord.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تسجيل الذكر.'**
  String get sabihErrorRecord;

  /// No description provided for @sabihErrorResetToday.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تصفير عداد اليوم.'**
  String get sabihErrorResetToday;

  /// No description provided for @sabihAnalyticsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get sabihAnalyticsTitle;

  /// No description provided for @sabihTabOverview.
  ///
  /// In ar, this message translates to:
  /// **'نظرة عامة'**
  String get sabihTabOverview;

  /// No description provided for @sabihTabDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل الأذكار'**
  String get sabihTabDetails;

  /// No description provided for @sabihDhikrSettingsTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الذكر'**
  String get sabihDhikrSettingsTooltip;

  /// No description provided for @sabihAddCustomDhikr.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ذكر مخصص'**
  String get sabihAddCustomDhikr;

  /// No description provided for @sabihEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على عناصر ذكر'**
  String get sabihEmptyMessage;

  /// No description provided for @sabihAddFirst.
  ///
  /// In ar, this message translates to:
  /// **'أضف ذكرك الأول'**
  String get sabihAddFirst;

  /// No description provided for @sabihSaveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get sabihSaveChanges;

  /// No description provided for @sabihAddDhikr.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الذكر'**
  String get sabihAddDhikr;

  /// No description provided for @sabihSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ الذكر.'**
  String get sabihSaveFailed;

  /// No description provided for @sabihUpdatedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الذكر بنجاح.'**
  String get sabihUpdatedSuccess;

  /// No description provided for @sabihAddedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الذكر بنجاح.'**
  String get sabihAddedSuccess;

  /// No description provided for @sabihEditDhikr.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الذكر'**
  String get sabihEditDhikr;

  /// No description provided for @sabihFieldText.
  ///
  /// In ar, this message translates to:
  /// **'نص الذكر'**
  String get sabihFieldText;

  /// Input hint showing an example value. {example} is an Arabic dhikr or a number and is not translated.
  ///
  /// In ar, this message translates to:
  /// **'مثال: {example}'**
  String sabihExampleHint(String example);

  /// No description provided for @sabihTextRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال نص الذكر'**
  String get sabihTextRequired;

  /// No description provided for @sabihTextTooShort.
  ///
  /// In ar, this message translates to:
  /// **'نص الذكر قصير جدًا'**
  String get sabihTextTooShort;

  /// Optional field: the virtue (reward) of the dhikr or a short description.
  ///
  /// In ar, this message translates to:
  /// **'الفضل أو وصف مختصر (اختياري)'**
  String get sabihFieldVirtue;

  /// No description provided for @sabihPeriodToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get sabihPeriodToday;

  /// No description provided for @sabihPeriodWeek.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع'**
  String get sabihPeriodWeek;

  /// No description provided for @sabihPeriodMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get sabihPeriodMonth;

  /// No description provided for @sabihPeriodYear.
  ///
  /// In ar, this message translates to:
  /// **'السنة'**
  String get sabihPeriodYear;

  /// Period filter: all time.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get sabihPeriodAll;

  /// No description provided for @sabihThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'هذا الأسبوع'**
  String get sabihThisWeek;

  /// No description provided for @sabihThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'هذا الشهر'**
  String get sabihThisMonth;

  /// No description provided for @sabihAllTime.
  ///
  /// In ar, this message translates to:
  /// **'كل الوقت'**
  String get sabihAllTime;

  /// No description provided for @sabihMostUsed.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار الأكثر استخدامًا'**
  String get sabihMostUsed;

  /// No description provided for @sabihTotalCount.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي عدد الأذكار'**
  String get sabihTotalCount;

  /// No description provided for @sabihNoDataYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات بعد'**
  String get sabihNoDataYet;

  /// No description provided for @sabihResetTodayCounter.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين عدّاد اليوم'**
  String get sabihResetTodayCounter;

  /// No description provided for @sabihEditThisDhikr.
  ///
  /// In ar, this message translates to:
  /// **'تعديل هذا الذكر'**
  String get sabihEditThisDhikr;

  /// No description provided for @sabihDeleteThisDhikr.
  ///
  /// In ar, this message translates to:
  /// **'حذف هذا الذكر'**
  String get sabihDeleteThisDhikr;

  /// Small badge on a dhikr the user added.
  ///
  /// In ar, this message translates to:
  /// **'مخصص'**
  String get sabihCustomBadge;

  /// No description provided for @sabihNoCustomDhikr.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد ذكر مخصص'**
  String get sabihNoCustomDhikr;

  /// No description provided for @sabihSummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخّص الذكر'**
  String get sabihSummaryTitle;

  /// No description provided for @sabihTodayNotStarted.
  ///
  /// In ar, this message translates to:
  /// **'لم تبدأ ذكر اليوم بعد'**
  String get sabihTodayNotStarted;

  /// How many times the user did tasbih today.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{ذكرت اليوم مرّة واحدة} =2{ذكرت اليوم مرّتين} few{ذكرت اليوم {count} مرّات} other{ذكرت اليوم {count} مرّة}}'**
  String sabihTodayCount(int count);

  /// Screen-reader label of the tap-to-count ring.
  ///
  /// In ar, this message translates to:
  /// **'تسبيح'**
  String get sabihCounterSemantics;

  /// Shown under the counter when the goal is reached, e.g. "Reached 33".
  ///
  /// In ar, this message translates to:
  /// **'بلغت {target}'**
  String sabihTargetReached(int target);

  /// Shown under the count: "out of 33".
  ///
  /// In ar, this message translates to:
  /// **'من {target}'**
  String sabihTargetOf(int target);

  /// Goal count, e.g. "Goal 33".
  ///
  /// In ar, this message translates to:
  /// **'الهدف {target}'**
  String sabihTargetLabel(int target);

  /// No description provided for @sabihTapAnywhere.
  ///
  /// In ar, this message translates to:
  /// **'المس أي مكان للتسبيح'**
  String get sabihTapAnywhere;

  /// Screen-reader label of the big count number.
  ///
  /// In ar, this message translates to:
  /// **'عدد التسبيح'**
  String get sabihCountSemantics;

  /// No description provided for @sabihInvalidNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقمًا صحيحًا أكبر من صفر'**
  String get sabihInvalidNumber;

  /// No description provided for @sabihSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المسبحة'**
  String get sabihSettingsTitle;

  /// No description provided for @sabihTargetSection.
  ///
  /// In ar, this message translates to:
  /// **'هدف الذكر'**
  String get sabihTargetSection;

  /// If the goal is left unchanged it steps up automatically: 33, then 99, then every 100.
  ///
  /// In ar, this message translates to:
  /// **'اتركه كما هو وسيتدرّج تلقائيًا: ٣٣ ثم ٩٩ ثم كل مئة.'**
  String get sabihTargetAutoHint;

  /// No description provided for @sabihFontSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get sabihFontSize;

  /// A single letter shown small and large on both ends of the font-size slider (like "A"). Use the first letter of your alphabet.
  ///
  /// In ar, this message translates to:
  /// **'أ'**
  String get sabihFontSizeGlyph;

  /// A percentage value.
  ///
  /// In ar, this message translates to:
  /// **'{value}٪'**
  String sabihPercent(int value);

  /// No description provided for @sabihVibration.
  ///
  /// In ar, this message translates to:
  /// **'الاهتزاز'**
  String get sabihVibration;

  /// No description provided for @sabihVibrationTitle.
  ///
  /// In ar, this message translates to:
  /// **'اهتزاز خفيف مع كل تسبيحة'**
  String get sabihVibrationTitle;

  /// No description provided for @sabihVibrationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'واهتزازة أوضح عند بلوغ الهدف'**
  String get sabihVibrationSubtitle;

  /// Section title: choose the prayer-beads style/material.
  ///
  /// In ar, this message translates to:
  /// **'تصميم السبحة'**
  String get sabihBeadDesign;

  /// No description provided for @sabihResetTodayCounterAction.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط عدّاد اليوم'**
  String get sabihResetTodayCounterAction;

  /// Group title in the features hub: your daily devotions.
  ///
  /// In ar, this message translates to:
  /// **'وردك اليومي'**
  String get anotherScreenGroupDaily;

  /// Group title in the features hub: knowledge and recitation.
  ///
  /// In ar, this message translates to:
  /// **'علم وتلاوة'**
  String get anotherScreenGroupKnowledge;

  /// Group title in the features hub: adhkar and tools.
  ///
  /// In ar, this message translates to:
  /// **'أذكار وأدوات'**
  String get anotherScreenGroupTools;

  /// Feature name: a daily/nightly devotional programme (adhkar, Quran, duas).
  ///
  /// In ar, this message translates to:
  /// **'زاد اليوم والليلة'**
  String get anotherScreenDailyWird;

  /// No description provided for @anotherScreenDailyWirdSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ورد تعبدي منظم لأذكارك وتلاوتك اليومية'**
  String get anotherScreenDailyWirdSubtitle;

  /// Feature name: plans for completing a full reading of the Quran (khatm).
  ///
  /// In ar, this message translates to:
  /// **'خطط الختمة'**
  String get anotherScreenKhatmaPlans;

  /// No description provided for @anotherScreenKhatmaPlansSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خطط مرتبة لإتمام الختمة بما يناسبك'**
  String get anotherScreenKhatmaPlansSubtitle;

  /// No description provided for @anotherScreenTasbihSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تسبيح سهل بعداد مريح وواضح'**
  String get anotherScreenTasbihSubtitle;

  /// No description provided for @anotherScreenFloatingAdhkarSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار قصيرة تظهر فوق التطبيقات الأخرى'**
  String get anotherScreenFloatingAdhkarSubtitle;

  /// Feature name: scheduled reminders/calls to wake friends for Fajr prayer.
  ///
  /// In ar, this message translates to:
  /// **'صحبة الفجر'**
  String get anotherScreenFajrCompanion;

  /// No description provided for @anotherScreenFajrCompanionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات دعوية واتصالات مجدولة'**
  String get anotherScreenFajrCompanionSubtitle;

  /// Feature name: an encyclopedia of the Quran's surahs (meaning, virtues, themes).
  ///
  /// In ar, this message translates to:
  /// **'موسوعة السور'**
  String get anotherScreenSurahEncyclopedia;

  /// No description provided for @anotherScreenSurahEncyclopediaSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استعراض السور وفضائلها وموضوعاتها'**
  String get anotherScreenSurahEncyclopediaSubtitle;

  /// Feature name: Imam al-Nawawi's Forty Hadith.
  ///
  /// In ar, this message translates to:
  /// **'الأربعون النووية'**
  String get anotherScreenNawawi40;

  /// No description provided for @anotherScreenNawawi40Subtitle.
  ///
  /// In ar, this message translates to:
  /// **'أحاديث جامعة في أبواب الدين'**
  String get anotherScreenNawawi40Subtitle;

  /// Feature name: the 99 Beautiful Names of Allah.
  ///
  /// In ar, this message translates to:
  /// **'أسماء الله الحسنى'**
  String get anotherScreenNamesOfAllah;

  /// No description provided for @anotherScreenNamesOfAllahSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تأمل الأسماء ومعانيها المباركة'**
  String get anotherScreenNamesOfAllahSubtitle;

  /// Feature name: Quran/Islamic radio stations.
  ///
  /// In ar, this message translates to:
  /// **'الإذاعة'**
  String get anotherScreenRadio;

  /// No description provided for @anotherScreenRadioSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إذاعات قرآنية وإسلامية ببث مباشر متواصل'**
  String get anotherScreenRadioSubtitle;

  /// Title of the well-known dua book "Hisn al-Muslim" (Fortress of the Muslim). Use the name Muslims know it by in your language.
  ///
  /// In ar, this message translates to:
  /// **'حصن المسلم'**
  String get anotherScreenHisnMuslim;

  /// No description provided for @anotherScreenHisnMuslimSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار جامعة مرتبة للأحوال والمناسبات'**
  String get anotherScreenHisnMuslimSubtitle;

  /// Feature name: the user's personal duas.
  ///
  /// In ar, this message translates to:
  /// **'أدعيتي الخاصة'**
  String get anotherScreenMyDuas;

  /// No description provided for @anotherScreenMyDuasSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احتفظ بأدعيتك الشخصية في مكان واحد'**
  String get anotherScreenMyDuasSubtitle;

  /// Feature name: tools for travellers.
  ///
  /// In ar, this message translates to:
  /// **'المسافر'**
  String get anotherScreenTraveler;

  /// No description provided for @anotherScreenTravelerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار السفر ومواقيت الرحلات وأماكن نافعة'**
  String get anotherScreenTravelerSubtitle;

  /// Feature name: home-screen widgets.
  ///
  /// In ar, this message translates to:
  /// **'ودجات الشاشة الرئيسية'**
  String get anotherScreenHomeWidgets;

  /// No description provided for @anotherScreenHomeWidgetsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة ومواقيت اليوم وآية اليوم'**
  String get anotherScreenHomeWidgetsSubtitle;

  /// Footnotes section of a Hisn al-Muslim chapter.
  ///
  /// In ar, this message translates to:
  /// **'الحواشي'**
  String get anotherScreenFootnotes;

  /// Chapter number in Hisn al-Muslim.
  ///
  /// In ar, this message translates to:
  /// **'الباب {number}'**
  String anotherScreenChapterNumber(int number);

  /// Number of texts (adhkar) in a chapter.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{نص واحد} =2{نصّان} few{{count} نصوص} other{{count} نصًّا}}'**
  String anotherScreenTextsCount(int count);

  /// Number of footnotes in a chapter.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{حاشية واحدة} =2{حاشيتان} few{{count} حواشٍ} other{{count} حاشية}}'**
  String anotherScreenFootnotesCount(int count);

  /// Section title: the text of the dhikr.
  ///
  /// In ar, this message translates to:
  /// **'نص الذكر'**
  String get anotherScreenDhikrText;

  /// No description provided for @anotherScreenHisnSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن حصن المسلم'**
  String get anotherScreenHisnSearchHint;

  /// No description provided for @anotherScreenNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get anotherScreenNoResults;

  /// No description provided for @anotherScreenHisnNoResultsMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد بابًا يطابق بحثك في حصن المسلم.'**
  String get anotherScreenHisnNoResultsMessage;

  /// No description provided for @anotherScreenShowAllAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'عرض جميع الأذكار'**
  String get anotherScreenShowAllAdhkar;

  /// No description provided for @anotherScreenSurahSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن سورة'**
  String get anotherScreenSurahSearchHint;

  /// Surah heading; {name} is the Arabic surah name.
  ///
  /// In ar, this message translates to:
  /// **'سورة {name}'**
  String anotherScreenSurahTitle(String name);

  /// A label followed by a colon, used as a heading in shared text. Adjust the colon to your language.
  ///
  /// In ar, this message translates to:
  /// **'{label}:'**
  String anotherScreenLabelHeading(String label);

  /// A "label: value" line in shared text. Adjust the colon/spacing to your language.
  ///
  /// In ar, this message translates to:
  /// **'{label}: {value}'**
  String anotherScreenLabelValue(String label, String value);

  /// Position of the surah in the list.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get anotherScreenSurahOrder;

  /// No description provided for @anotherScreenSurahNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم السورة'**
  String get anotherScreenSurahNumber;

  /// No description provided for @anotherScreenAyahCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الآيات'**
  String get anotherScreenAyahCount;

  /// No description provided for @anotherScreenSurahNameMeaning.
  ///
  /// In ar, this message translates to:
  /// **'معنى اسم السورة'**
  String get anotherScreenSurahNameMeaning;

  /// No description provided for @anotherScreenSurahNamingReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب التسمية'**
  String get anotherScreenSurahNamingReason;

  /// No description provided for @anotherScreenSurahOtherNamesShort.
  ///
  /// In ar, this message translates to:
  /// **'أسماء أخرى'**
  String get anotherScreenSurahOtherNamesShort;

  /// No description provided for @anotherScreenSurahOtherNames.
  ///
  /// In ar, this message translates to:
  /// **'أسماء أخرى للسورة'**
  String get anotherScreenSurahOtherNames;

  /// The overall theme/purpose of the surah.
  ///
  /// In ar, this message translates to:
  /// **'المقصد العام'**
  String get anotherScreenSurahPurpose;

  /// Occasion of revelation (asbab al-nuzul).
  ///
  /// In ar, this message translates to:
  /// **'سبب النزول'**
  String get anotherScreenSurahRevelationReason;

  /// No description provided for @anotherScreenSurahVirtues.
  ///
  /// In ar, this message translates to:
  /// **'فضائل السورة'**
  String get anotherScreenSurahVirtues;

  /// How the surah connects to the surahs around it (munasabat).
  ///
  /// In ar, this message translates to:
  /// **'مناسبات السورة'**
  String get anotherScreenSurahRelations;

  /// {count} is the Arabic verse count from the data (e.g. "سَبْعٌ (7)"), not a number to format.
  ///
  /// In ar, this message translates to:
  /// **'{count} آية'**
  String anotherScreenAyahsLabel(String count);

  /// No description provided for @anotherScreenNoMatchingResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get anotherScreenNoMatchingResults;

  /// No description provided for @anotherScreenShowAllSurahs.
  ///
  /// In ar, this message translates to:
  /// **'عرض جميع السور'**
  String get anotherScreenShowAllSurahs;

  /// No description provided for @quranPlanAnalysisStartFirst.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ أول جلسة لتحليل تقدمك.'**
  String get quranPlanAnalysisStartFirst;

  /// No description provided for @quranPlanAnalysisFinished.
  ///
  /// In ar, this message translates to:
  /// **'مبارك! لقد أنهيت الخطة.'**
  String get quranPlanAnalysisFinished;

  /// No description provided for @quranPlanAnalysisOnTrack.
  ///
  /// In ar, this message translates to:
  /// **'أنت على المسار الصحيح، ومتوقع أن تختم قبل الوقت المحدد!'**
  String get quranPlanAnalysisOnTrack;

  /// No description provided for @quranPlanAnalysisBehind.
  ///
  /// In ar, this message translates to:
  /// **'قد تتأخر قليلاً عن الموعد. حاول تسريع وتيرة القراءة.'**
  String get quranPlanAnalysisBehind;

  /// Daily reminder notification title. {title} is the plan name the user typed.
  ///
  /// In ar, this message translates to:
  /// **'خطة ختم القرآن: {title}'**
  String quranPlanReminderTitle(String title);

  /// Daily reminder notification body. {title} is the plan name.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس جلسة اليوم في خطتك \"{title}\"!'**
  String quranPlanReminderBody(String title);

  /// No description provided for @quranPlanAddTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة خطة ختم جديدة'**
  String get quranPlanAddTitle;

  /// No description provided for @quranPlanDetailsHeader.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الخطة'**
  String get quranPlanDetailsHeader;

  /// No description provided for @quranPlanTitleLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الخطة'**
  String get quranPlanTitleLabel;

  /// No description provided for @quranPlanTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'اسم الخطة'**
  String get quranPlanTitleHint;

  /// No description provided for @quranPlanTitleRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوانًا'**
  String get quranPlanTitleRequired;

  /// Form label: starting juz (one of the 30 parts of the Quran).
  ///
  /// In ar, this message translates to:
  /// **'من الجزء'**
  String get quranPlanFromJuz;

  /// Form label: ending juz.
  ///
  /// In ar, this message translates to:
  /// **'إلى الجزء'**
  String get quranPlanToJuz;

  /// No description provided for @quranPlanChooseStart.
  ///
  /// In ar, this message translates to:
  /// **'اختر البداية'**
  String get quranPlanChooseStart;

  /// No description provided for @quranPlanChooseEnd.
  ///
  /// In ar, this message translates to:
  /// **'اختر النهاية'**
  String get quranPlanChooseEnd;

  /// No description provided for @quranPlanEndBeforeStart.
  ///
  /// In ar, this message translates to:
  /// **'النهاية قبل البداية'**
  String get quranPlanEndBeforeStart;

  /// No description provided for @quranPlanDaysLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأيام'**
  String get quranPlanDaysLabel;

  /// No description provided for @quranPlanDaysHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 30'**
  String get quranPlanDaysHint;

  /// No description provided for @quranPlanDaysInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عدد الأيام بشكل صحيح'**
  String get quranPlanDaysInvalid;

  /// No description provided for @quranPlanSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الخطة'**
  String get quranPlanSave;

  /// Dropdown hint: choose.
  ///
  /// In ar, this message translates to:
  /// **'اختر'**
  String get quranPlanChoose;

  /// A juz (one of the 30 parts of the Quran), e.g. "Juz 5".
  ///
  /// In ar, this message translates to:
  /// **'الجزء {number}'**
  String quranPlanJuz(int number);

  /// No description provided for @quranPlanDailyReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير يومي'**
  String get quranPlanDailyReminder;

  /// No reminder time chosen.
  ///
  /// In ar, this message translates to:
  /// **'غير محدّد'**
  String get quranPlanNotSet;

  /// Title: plans for completing the Quran (khatm).
  ///
  /// In ar, this message translates to:
  /// **'خطط الختم'**
  String get quranPlanListTitle;

  /// No description provided for @quranPlanNewTooltip.
  ///
  /// In ar, this message translates to:
  /// **'خطة جديدة'**
  String get quranPlanNewTooltip;

  /// No description provided for @quranPlanSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن خطة'**
  String get quranPlanSearchHint;

  /// Juz range of a plan, e.g. "Juz 1 to 30".
  ///
  /// In ar, this message translates to:
  /// **'الجزء {start} إلى {end}'**
  String quranPlanJuzRange(int start, int end);

  /// Plan length in days.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{يوم واحد} =2{يومان} few{{count} أيام} other{{count} يومًا}}'**
  String quranPlanDaysCount(int count);

  /// How many reading sessions of the plan are loaded on screen.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{جلسة واحدة محمّلة} =2{جلستان محمّلتان} few{{count} جلسات محمّلة} other{{count} جلسة محمّلة}}'**
  String quranPlanLoadedSessions(int count);

  /// Sessions done out of total, e.g. "3 of 30".
  ///
  /// In ar, this message translates to:
  /// **'{done} من {total}'**
  String quranPlanProgress(int done, int total);

  /// Snackbar asking to confirm deleting a plan.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف الخطة ؟'**
  String get quranPlanDeleteConfirm;

  /// No description provided for @quranPlanConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get quranPlanConfirm;

  /// No description provided for @quranPlanDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف الخطة'**
  String get quranPlanDelete;

  /// Warning shown when the user skipped reading for several days.
  ///
  /// In ar, this message translates to:
  /// **'انتبه: لديك عدة أيام ركود. جلسة قصيرة اليوم تكفي لإعادة الإيقاع.'**
  String get quranPlanStagnationWarning;

  /// No description provided for @quranPlanLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل هذه الخطة حاليًا.'**
  String get quranPlanLoadFailed;

  /// No description provided for @quranPlanTodaySession.
  ///
  /// In ar, this message translates to:
  /// **'جلسة اليوم'**
  String get quranPlanTodaySession;

  /// No description provided for @quranPlanAllSessionsDone.
  ///
  /// In ar, this message translates to:
  /// **'أتممت جلسات هذه الخطة، بارك الله فيك.'**
  String get quranPlanAllSessionsDone;

  /// Section header: statistics about the user's reading pace.
  ///
  /// In ar, this message translates to:
  /// **'إيقاع الخطة'**
  String get quranPlanRhythm;

  /// Section header: the list of all reading sessions of the plan.
  ///
  /// In ar, this message translates to:
  /// **'مسار الختمة'**
  String get quranPlanPath;

  /// No description provided for @quranPlanNoSessions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جلسات ظاهرة بعد.'**
  String get quranPlanNoSessions;

  /// Snackbar asking to confirm marking the session as done.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إنهاء الجلسة ؟'**
  String get quranPlanCompleteConfirm;

  /// Reading session number, e.g. "Session 4".
  ///
  /// In ar, this message translates to:
  /// **'جلسة {number}'**
  String quranPlanSessionNumber(int number);

  /// Status: this session is done.
  ///
  /// In ar, this message translates to:
  /// **'مُنجزة'**
  String get quranPlanSessionDone;

  /// No description provided for @quranPlanCurrentSession.
  ///
  /// In ar, this message translates to:
  /// **'جلستك الحالية'**
  String get quranPlanCurrentSession;

  /// Hint: tap to open the Quran at the start of the session.
  ///
  /// In ar, this message translates to:
  /// **'افتح المصحف عند بداية الجلسة'**
  String get quranPlanOpenMushafHint;

  /// No description provided for @quranPlanSessionCompleted.
  ///
  /// In ar, this message translates to:
  /// **'جلسة مُنجزة'**
  String get quranPlanSessionCompleted;

  /// No description provided for @quranPlanCompleteSession.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الجلسة'**
  String get quranPlanCompleteSession;

  /// Fallback surah label when its name is unknown.
  ///
  /// In ar, this message translates to:
  /// **'سورة {number}'**
  String quranPlanSurahFallback(int number);

  /// Range of a reading session. Surah names stay in Arabic.
  ///
  /// In ar, this message translates to:
  /// **'من {fromSurah} الآية {fromAyah} إلى {toSurah} الآية {toAyah}'**
  String quranPlanSessionRange(
      String fromSurah, int fromAyah, String toSurah, int toAyah);

  /// When a session was completed; {date} is a formatted date and time.
  ///
  /// In ar, this message translates to:
  /// **'تم الإنجاز · {date}'**
  String quranPlanCompletedAt(String date);

  /// Predicted date of finishing the Quran.
  ///
  /// In ar, this message translates to:
  /// **'توقّع يوم الختم'**
  String get quranPlanExpectedFinish;

  /// No description provided for @quranPlanAverageInterval.
  ///
  /// In ar, this message translates to:
  /// **'متوسّط الفاصل بين الجلسات'**
  String get quranPlanAverageInterval;

  /// Average days between sessions; {days} is a decimal like "1.5".
  ///
  /// In ar, this message translates to:
  /// **'{days} يوم'**
  String quranPlanAverageIntervalValue(String days);

  /// Weekday on which the user reads most.
  ///
  /// In ar, this message translates to:
  /// **'اليوم الأكثر نشاطًا'**
  String get quranPlanMostActiveDay;

  /// Weekday on which the user reads least.
  ///
  /// In ar, this message translates to:
  /// **'اليوم الأقلّ نشاطًا'**
  String get quranPlanLeastActiveDay;

  /// No description provided for @quranPlanCompletionProbability.
  ///
  /// In ar, this message translates to:
  /// **'احتمال إتمام الخطة'**
  String get quranPlanCompletionProbability;

  /// A percentage written out, e.g. "70 percent".
  ///
  /// In ar, this message translates to:
  /// **'{percent} بالمئة'**
  String quranPlanPercentValue(int percent);

  /// Days on which the user did not read.
  ///
  /// In ar, this message translates to:
  /// **'أيام الركود'**
  String get quranPlanStagnationDays;

  /// Title and body of the fallback screen shown when the app navigates to a page that does not exist.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة غير موجودة'**
  String get cleanupRouteNotFound;

  /// iOS subtitle line under the title of a push notification sent from the server: 'New notification'.
  ///
  /// In ar, this message translates to:
  /// **'إشعار جديد'**
  String get cleanupNotificationSubtitle;

  /// Button on a push notification (Android): open/view it. One short word.
  ///
  /// In ar, this message translates to:
  /// **'عرض'**
  String get cleanupNotificationActionView;

  /// Button on a push notification (Android): dismiss it. One short word.
  ///
  /// In ar, this message translates to:
  /// **'تجاهل'**
  String get cleanupNotificationActionDismiss;

  /// Error snackbar on the Downloads screen when starting/pausing/resuming/cancelling/opening a download fails.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إتمام عملية التنزيل. حاول مرة أخرى.'**
  String get cleanupDownloadActionFailed;

  /// Download status under a file name: waiting in the queue to start.
  ///
  /// In ar, this message translates to:
  /// **'في الانتظار'**
  String get cleanupDownloadStatusQueued;

  /// Download status under a file name: the download was cancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغي'**
  String get cleanupDownloadStatusCanceled;

  /// Download status under a file name when the state is unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get cleanupDownloadStatusUnknown;

  /// Second line on the lock screen / media notification while a Quran radio station is playing: 'Holy Quran Radio'.
  ///
  /// In ar, this message translates to:
  /// **'إذاعة القرآن الكريم'**
  String get cleanupRadioMediaArtist;

  /// Short meaning shown in small text under the built-in dhikr «سبحان الله» in the Tasbih (the dhikr itself stays Arabic). Arabic source is a short explanation; other languages give the translation of the phrase, e.g. 'Glory be to Allah'.
  ///
  /// In ar, this message translates to:
  /// **'تنزيه الله عن كل نقص'**
  String get cleanupDhikrMeaningSubhanAllah;

  /// Short meaning under the built-in dhikr «الحمد لله» in the Tasbih. Other languages: translation of the phrase, e.g. 'All praise is due to Allah'.
  ///
  /// In ar, this message translates to:
  /// **'الثناء على الله بكل كمال'**
  String get cleanupDhikrMeaningAlhamdulillah;

  /// Short meaning under the built-in dhikr «لا إله إلا الله» in the Tasbih. Other languages: translation, e.g. 'There is no god but Allah'.
  ///
  /// In ar, this message translates to:
  /// **'لا معبود بحقّ إلا الله'**
  String get cleanupDhikrMeaningLaIlaha;

  /// Short meaning under the built-in dhikr «الله أكبر» in the Tasbih. Other languages: translation, e.g. 'Allah is the Greatest'.
  ///
  /// In ar, this message translates to:
  /// **'الله أعظم من كل شيء'**
  String get cleanupDhikrMeaningAllahuAkbar;

  /// Short meaning under the built-in dhikr «لا حول ولا قوة إلا بالله» in the Tasbih. Other languages: translation, e.g. 'There is no might nor power except with Allah'.
  ///
  /// In ar, this message translates to:
  /// **'لا تحوّل ولا قدرة إلا بعون الله'**
  String get cleanupDhikrMeaningLaHawla;

  /// Short meaning under the built-in dhikr «أستغفر الله» in the Tasbih. Other languages: translation, e.g. 'I seek forgiveness from Allah'.
  ///
  /// In ar, this message translates to:
  /// **'أطلب من الله المغفرة'**
  String get cleanupDhikrMeaningAstaghfirullah;

  /// Short meaning under the built-in dhikr «سبحان الله وبحمده سبحان الله العظيم» in the Tasbih. Other languages: translation, e.g. 'Glory be to Allah and praise Him, glory be to Allah the Magnificent'.
  ///
  /// In ar, this message translates to:
  /// **'تنزيه الله مع حمده وتعظيمه'**
  String get cleanupDhikrMeaningSubhanAllahWaBihamdihi;

  /// Brand name of the app. Keep recognizable; Latin-script languages use the transliteration 'Tamaneena'.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة'**
  String get appName;

  /// No description provided for @commonContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get commonContinue;

  /// No description provided for @commonSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In ar, this message translates to:
  /// **'حسنًا'**
  String get commonOk;

  /// No description provided for @commonClose.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get commonClose;

  /// No description provided for @commonDone.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get commonDone;

  /// No description provided for @commonRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get commonSearch;

  /// No description provided for @commonSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get commonSettings;

  /// No description provided for @commonLoading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get commonError;

  /// No description provided for @commonDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get commonAdd;

  /// No description provided for @commonShare.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get commonShare;

  /// No description provided for @commonCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم النسخ'**
  String get commonCopied;

  /// No description provided for @commonBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get commonBack;

  /// No description provided for @commonYes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get commonNo;

  /// No description provided for @commonRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get commonRefresh;

  /// No description provided for @commonSeeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get commonSeeAll;

  /// No description provided for @commonEnable.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل'**
  String get commonEnable;

  /// No description provided for @commonDisable.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get commonDisable;

  /// No description provided for @commonLater.
  ///
  /// In ar, this message translates to:
  /// **'لاحقًا'**
  String get commonLater;

  /// No description provided for @prayerFajr.
  ///
  /// In ar, this message translates to:
  /// **'الفجر'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In ar, this message translates to:
  /// **'الشروق'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In ar, this message translates to:
  /// **'الظهر'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In ar, this message translates to:
  /// **'العصر'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In ar, this message translates to:
  /// **'المغرب'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In ar, this message translates to:
  /// **'العشاء'**
  String get prayerIsha;

  /// No description provided for @prayerJumuah.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get prayerJumuah;

  /// Islamic (Hijri) month names 1-12. Use the standard spelling Muslims use in the target language (e.g. Turkish 'Muharrem', Indonesian 'Muharram').
  ///
  /// In ar, this message translates to:
  /// **'محرم'**
  String get hijriMonth1;

  /// No description provided for @hijriMonth2.
  ///
  /// In ar, this message translates to:
  /// **'صفر'**
  String get hijriMonth2;

  /// No description provided for @hijriMonth3.
  ///
  /// In ar, this message translates to:
  /// **'ربيع الأول'**
  String get hijriMonth3;

  /// No description provided for @hijriMonth4.
  ///
  /// In ar, this message translates to:
  /// **'ربيع الآخر'**
  String get hijriMonth4;

  /// No description provided for @hijriMonth5.
  ///
  /// In ar, this message translates to:
  /// **'جمادى الأولى'**
  String get hijriMonth5;

  /// No description provided for @hijriMonth6.
  ///
  /// In ar, this message translates to:
  /// **'جمادى الآخرة'**
  String get hijriMonth6;

  /// No description provided for @hijriMonth7.
  ///
  /// In ar, this message translates to:
  /// **'رجب'**
  String get hijriMonth7;

  /// No description provided for @hijriMonth8.
  ///
  /// In ar, this message translates to:
  /// **'شعبان'**
  String get hijriMonth8;

  /// No description provided for @hijriMonth9.
  ///
  /// In ar, this message translates to:
  /// **'رمضان'**
  String get hijriMonth9;

  /// No description provided for @hijriMonth10.
  ///
  /// In ar, this message translates to:
  /// **'شوال'**
  String get hijriMonth10;

  /// No description provided for @hijriMonth11.
  ///
  /// In ar, this message translates to:
  /// **'ذو القعدة'**
  String get hijriMonth11;

  /// No description provided for @hijriMonth12.
  ///
  /// In ar, this message translates to:
  /// **'ذو الحجة'**
  String get hijriMonth12;

  /// A Hijri date. {month} is one of hijriMonth1..12. The 'هـ' suffix marks the Hijri era; use the target language's equivalent (e.g. 'H' in Indonesian/Turkish).
  ///
  /// In ar, this message translates to:
  /// **'{day} {month} {year} هـ'**
  String hijriDate(String day, String month, String year);

  /// Name of the kids section (Young Muslim) with Islamic story videos; screen title.
  ///
  /// In ar, this message translates to:
  /// **'المسلم الصغير'**
  String get youngMuslimTitle;

  /// Shown in quiz review when the child left a question unanswered.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم الإجابة'**
  String get youngMuslimQuizUnanswered;

  /// Notification title reminding the child to resume a video.
  ///
  /// In ar, this message translates to:
  /// **'كمل المشاهدة في المسلم الصغير'**
  String get youngMuslimResumeReminderTitle;

  /// Notification body. {topic} is the story title (Arabic content).
  ///
  /// In ar, this message translates to:
  /// **'ارجع إلى \"{topic}\" وأكمل رحلتك بهدوء.'**
  String youngMuslimResumeReminderBody(String topic);

  /// Chip on a kids category cover.
  ///
  /// In ar, this message translates to:
  /// **'واجهة آمنة للأطفال'**
  String get youngMuslimAudienceKidsSafe;

  /// Chip on a general-audience category cover.
  ///
  /// In ar, this message translates to:
  /// **'مشاهدة عامة'**
  String get youngMuslimAudienceGeneral;

  /// Label under a number: count of series.
  ///
  /// In ar, this message translates to:
  /// **'سلسلة'**
  String get youngMuslimStatSeries;

  /// Label under a number: count of episodes.
  ///
  /// In ar, this message translates to:
  /// **'حلقة'**
  String get youngMuslimStatEpisode;

  /// No description provided for @youngMuslimChooseSeries.
  ///
  /// In ar, this message translates to:
  /// **'اختر السلسلة'**
  String get youngMuslimChooseSeries;

  /// Section header: list of episodes.
  ///
  /// In ar, this message translates to:
  /// **'الحلقات'**
  String get youngMuslimEpisodes;

  /// Number of episodes.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} حلقة}}'**
  String youngMuslimEpisodesCount(int count);

  /// No description provided for @youngMuslimNoEpisodesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حلقات الآن'**
  String get youngMuslimNoEpisodesTitle;

  /// No description provided for @youngMuslimNoEpisodesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر السلسلة المختارة أو عد لاحقًا بعد تحديث الفلاتر.'**
  String get youngMuslimNoEpisodesSubtitle;

  /// No description provided for @youngMuslimCategoryLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل القسم'**
  String get youngMuslimCategoryLoadError;

  /// No description provided for @youngMuslimTryAgainShortly.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى بعد قليل.'**
  String get youngMuslimTryAgainShortly;

  /// No description provided for @youngMuslimSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن قصة...'**
  String get youngMuslimSearchHint;

  /// Section header.
  ///
  /// In ar, this message translates to:
  /// **'الإنجازات'**
  String get youngMuslimAchievements;

  /// Section header above quick filter chips.
  ///
  /// In ar, this message translates to:
  /// **'تصفية سريعة'**
  String get youngMuslimQuickFilter;

  /// No description provided for @youngMuslimFilterResults.
  ///
  /// In ar, this message translates to:
  /// **'نتائج الفلترة'**
  String get youngMuslimFilterResults;

  /// Number of search/filter results.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} نتيجة}}'**
  String youngMuslimResultsCount(int count);

  /// No description provided for @youngMuslimNoMatchesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get youngMuslimNoMatchesTitle;

  /// No description provided for @youngMuslimNoMatchesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'جرّب كلمات أبسط أو غيّر الفلاتر لتظهر حلقات أكثر.'**
  String get youngMuslimNoMatchesSubtitle;

  /// Section header: content categories.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام'**
  String get youngMuslimSections;

  /// Section header: videos in progress.
  ///
  /// In ar, this message translates to:
  /// **'أكمل المشاهدة'**
  String get youngMuslimContinueWatching;

  /// No description provided for @youngMuslimRecentlyWatched.
  ///
  /// In ar, this message translates to:
  /// **'شاهدت مؤخرًا'**
  String get youngMuslimRecentlyWatched;

  /// No description provided for @youngMuslimFavorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get youngMuslimFavorites;

  /// Watch-later list / toggle.
  ///
  /// In ar, this message translates to:
  /// **'سأشاهد لاحقًا'**
  String get youngMuslimWatchLater;

  /// No description provided for @youngMuslimSuggestions.
  ///
  /// In ar, this message translates to:
  /// **'اقتراحات مناسبة'**
  String get youngMuslimSuggestions;

  /// No description provided for @youngMuslimGreetingWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بك في عالم القصص والتعلّم'**
  String get youngMuslimGreetingWelcome;

  /// No description provided for @youngMuslimGreetingPickNew.
  ///
  /// In ar, this message translates to:
  /// **'اختر قصة جديدة وابدأ رحلتك اليوم'**
  String get youngMuslimGreetingPickNew;

  /// Greeting when the child has unfinished episodes.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{لديك {count} حلقة بانتظارك لتعود إليها}}'**
  String youngMuslimGreetingWaiting(int count);

  /// My points and achievements.
  ///
  /// In ar, this message translates to:
  /// **'نقاطي وإنجازاتي'**
  String get youngMuslimRewardsTitle;

  /// Gamification: current level and total points (XP).
  ///
  /// In ar, this message translates to:
  /// **'المستوى {level} · {points} نقطة'**
  String youngMuslimLevelAndPoints(int level, int points);

  /// No description provided for @youngMuslimNextLevelProgress.
  ///
  /// In ar, this message translates to:
  /// **'التقدّم للمستوى التالي'**
  String get youngMuslimNextLevelProgress;

  /// Progress fraction, e.g. "40 of 100".
  ///
  /// In ar, this message translates to:
  /// **'{current} من {total}'**
  String youngMuslimProgressOf(int current, int total);

  /// Label under a number.
  ///
  /// In ar, this message translates to:
  /// **'إنجازات'**
  String get youngMuslimStatAchievements;

  /// Label under a number: completed episodes.
  ///
  /// In ar, this message translates to:
  /// **'حلقات'**
  String get youngMuslimStatEpisodes;

  /// Label under a number: correct answers.
  ///
  /// In ar, this message translates to:
  /// **'إجابات'**
  String get youngMuslimStatAnswers;

  /// Filter option: all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get youngMuslimFilterAll;

  /// No description provided for @youngMuslimStatusInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المشاهدة'**
  String get youngMuslimStatusInProgress;

  /// No description provided for @youngMuslimStatusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get youngMuslimStatusCompleted;

  /// Short filter chip: watch later.
  ///
  /// In ar, this message translates to:
  /// **'لاحقًا'**
  String get youngMuslimStatusWatchLater;

  /// No description provided for @youngMuslimFiltersActiveNote.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر مفعّلة الآن، ويمكنك تعديلها من زرّ التصفية أعلى الصفحة.'**
  String get youngMuslimFiltersActiveNote;

  /// Button: clear filters.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get youngMuslimClearFilters;

  /// No description provided for @youngMuslimContentLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل المحتوى'**
  String get youngMuslimContentLoadError;

  /// No description provided for @youngMuslimPullToRetry.
  ///
  /// In ar, this message translates to:
  /// **'اسحب الصفحة للأسفل لإعادة المحاولة.'**
  String get youngMuslimPullToRetry;

  /// No description provided for @youngMuslimFilterSheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'تصفية المحتوى'**
  String get youngMuslimFilterSheetTitle;

  /// Label: the content category (filter group / info row).
  ///
  /// In ar, this message translates to:
  /// **'القسم'**
  String get youngMuslimCategoryLabel;

  /// Filter group: language of the video content.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get youngMuslimFilterLanguage;

  /// Content language filter option.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get youngMuslimLanguageArabic;

  /// Content language filter option.
  ///
  /// In ar, this message translates to:
  /// **'الفرنسية'**
  String get youngMuslimLanguageFrench;

  /// Content language filter option: mixed languages.
  ///
  /// In ar, this message translates to:
  /// **'مختلط'**
  String get youngMuslimLanguageMixed;

  /// No description provided for @youngMuslimFilterContentType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المحتوى'**
  String get youngMuslimFilterContentType;

  /// No description provided for @youngMuslimContentTypeStorySeries.
  ///
  /// In ar, this message translates to:
  /// **'سلاسل قصصية'**
  String get youngMuslimContentTypeStorySeries;

  /// No description provided for @youngMuslimApplyFilters.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الفلاتر'**
  String get youngMuslimApplyFilters;

  /// Title of the kid-safe video player screen.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل آمن للأطفال'**
  String get youngMuslimPlayerTitle;

  /// No description provided for @youngMuslimEpisodeQuizTitle.
  ///
  /// In ar, this message translates to:
  /// **'سؤال الحلقة بعد المشاهدة'**
  String get youngMuslimEpisodeQuizTitle;

  /// Quiz at the end of a whole series.
  ///
  /// In ar, this message translates to:
  /// **'تحدي السلسلة'**
  String get youngMuslimSeriesChallenge;

  /// No description provided for @youngMuslimPlayerLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل المشغّل الآن.'**
  String get youngMuslimPlayerLoadError;

  /// No description provided for @youngMuslimWatchOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات المشاهدة'**
  String get youngMuslimWatchOptions;

  /// No description provided for @youngMuslimPlayNextEpisode.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الحلقة التالية'**
  String get youngMuslimPlayNextEpisode;

  /// {episode} is the episode number.
  ///
  /// In ar, this message translates to:
  /// **'الحلقة {episode} من نفس السلسلة'**
  String youngMuslimNextEpisodeFromSeries(String episode);

  /// No description provided for @youngMuslimSeriesPlaylist.
  ///
  /// In ar, this message translates to:
  /// **'قائمة السلسلة'**
  String get youngMuslimSeriesPlaylist;

  /// No description provided for @youngMuslimAutoPlayNext.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الحلقة التالية تلقائيًا'**
  String get youngMuslimAutoPlayNext;

  /// No description provided for @youngMuslimAutoPlayNextSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ضمن السلسلة نفسها فقط بعد نهاية الحلقة'**
  String get youngMuslimAutoPlayNextSubtitle;

  /// Button: resume watching.
  ///
  /// In ar, this message translates to:
  /// **'متابعة المشاهدة'**
  String get youngMuslimResumeButton;

  /// No description provided for @youngMuslimPlayNow.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الآن'**
  String get youngMuslimPlayNow;

  /// A percentage; use the target language percent format.
  ///
  /// In ar, this message translates to:
  /// **'{percent}٪'**
  String youngMuslimPercent(int percent);

  /// No description provided for @youngMuslimProgress.
  ///
  /// In ar, this message translates to:
  /// **'التقدّم'**
  String get youngMuslimProgress;

  /// No description provided for @youngMuslimWatchCount.
  ///
  /// In ar, this message translates to:
  /// **'مرات المشاهدة'**
  String get youngMuslimWatchCount;

  /// No description provided for @youngMuslimEpisodeDuration.
  ///
  /// In ar, this message translates to:
  /// **'مدّة الحلقة'**
  String get youngMuslimEpisodeDuration;

  /// {when} is a relative time like "5 minutes ago".
  ///
  /// In ar, this message translates to:
  /// **'آخر مشاهدة: {when}'**
  String youngMuslimLastWatched(String when);

  /// No description provided for @youngMuslimEpisodeInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الحلقة'**
  String get youngMuslimEpisodeInfo;

  /// No description provided for @youngMuslimStory.
  ///
  /// In ar, this message translates to:
  /// **'القصة'**
  String get youngMuslimStory;

  /// No description provided for @youngMuslimSeries.
  ///
  /// In ar, this message translates to:
  /// **'السلسلة'**
  String get youngMuslimSeries;

  /// No description provided for @youngMuslimEpisodeNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحلقة'**
  String get youngMuslimEpisodeNumber;

  /// No description provided for @youngMuslimEpisodeTools.
  ///
  /// In ar, this message translates to:
  /// **'أدوات الحلقة'**
  String get youngMuslimEpisodeTools;

  /// No description provided for @youngMuslimEpisodeQuestions.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة الحلقة'**
  String get youngMuslimEpisodeQuestions;

  /// No description provided for @youngMuslimEpisodeQuestionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة قصيرة تثبّت ما شاهده الطفل'**
  String get youngMuslimEpisodeQuestionsSubtitle;

  /// No description provided for @youngMuslimAfterWatchQuestion.
  ///
  /// In ar, this message translates to:
  /// **'سؤال بعد المشاهدة'**
  String get youngMuslimAfterWatchQuestion;

  /// No description provided for @youngMuslimNextEpisode.
  ///
  /// In ar, this message translates to:
  /// **'الحلقة التالية'**
  String get youngMuslimNextEpisode;

  /// No description provided for @youngMuslimSimilarEpisodes.
  ///
  /// In ar, this message translates to:
  /// **'حلقات مشابهة'**
  String get youngMuslimSimilarEpisodes;

  /// No description provided for @youngMuslimDetailsLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل تفاصيل الحلقة'**
  String get youngMuslimDetailsLoadError;

  /// No description provided for @youngMuslimQuizIntro.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة بسيطة تساعد الطفل على تثبيت ما شاهده.'**
  String get youngMuslimQuizIntro;

  /// Number of quiz questions.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} أسئلة}}'**
  String youngMuslimQuestionsCount(int count);

  /// Points awarded for passing a quiz.
  ///
  /// In ar, this message translates to:
  /// **'+{points} نقطة عند النجاح'**
  String youngMuslimXpOnPass(int points);

  /// Minimum correct answers needed to pass.
  ///
  /// In ar, this message translates to:
  /// **'النجاح من {score}'**
  String youngMuslimPassingScore(int score);

  /// No description provided for @youngMuslimGrading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تصحيح الإجابات'**
  String get youngMuslimGrading;

  /// No description provided for @youngMuslimSubmitAnswers.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الإجابات'**
  String get youngMuslimSubmitAnswers;

  /// No description provided for @youngMuslimAnswerHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب إجابتك هنا بوضوح...'**
  String get youngMuslimAnswerHint;

  /// Praise for a child who passed the quiz ("Well done, champ").
  ///
  /// In ar, this message translates to:
  /// **'أحسنت يا بطل'**
  String get youngMuslimQuizPassed;

  /// No description provided for @youngMuslimQuizAlmost.
  ///
  /// In ar, this message translates to:
  /// **'أنت قريب من الإجابة الكاملة'**
  String get youngMuslimQuizAlmost;

  /// Quiz result summary.
  ///
  /// In ar, this message translates to:
  /// **'أجبت {correct} من {total} إجابة صحيحة'**
  String youngMuslimQuizScore(int correct, int total);

  /// Points gained.
  ///
  /// In ar, this message translates to:
  /// **'+{points} نقطة'**
  String youngMuslimXpGained(int points);

  /// No description provided for @youngMuslimLevel.
  ///
  /// In ar, this message translates to:
  /// **'المستوى {level}'**
  String youngMuslimLevel(int level);

  /// Total points.
  ///
  /// In ar, this message translates to:
  /// **'{points, plural, other{{points} نقطة}}'**
  String youngMuslimPoints(int points);

  /// No description provided for @youngMuslimNewAchievements.
  ///
  /// In ar, this message translates to:
  /// **'إنجازات جديدة'**
  String get youngMuslimNewAchievements;

  /// No description provided for @youngMuslimReviewAnswers.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الإجابات'**
  String get youngMuslimReviewAnswers;

  /// Button: finish the quiz.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء'**
  String get youngMuslimFinish;

  /// No description provided for @youngMuslimYourAnswer.
  ///
  /// In ar, this message translates to:
  /// **'إجابتك'**
  String get youngMuslimYourAnswer;

  /// No description provided for @youngMuslimCorrectAnswer.
  ///
  /// In ar, this message translates to:
  /// **'الإجابة الصحيحة'**
  String get youngMuslimCorrectAnswer;

  /// Label under a number: completed series.
  ///
  /// In ar, this message translates to:
  /// **'سلاسل'**
  String get youngMuslimStatSeriesPlural;

  /// Label under a number: quizzes with full marks.
  ///
  /// In ar, this message translates to:
  /// **'نتائج كاملة'**
  String get youngMuslimStatPerfectScores;

  /// No description provided for @youngMuslimUnlockedAchievements.
  ///
  /// In ar, this message translates to:
  /// **'الإنجازات المفتوحة'**
  String get youngMuslimUnlockedAchievements;

  /// No description provided for @youngMuslimAchievementsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} إنجاز}}'**
  String youngMuslimAchievementsCount(int count);

  /// No description provided for @youngMuslimNoAchievementsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إنجازات بعد'**
  String get youngMuslimNoAchievementsTitle;

  /// No description provided for @youngMuslimNoAchievementsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل أول حلقة أو أجب عن أول سؤال لتبدأ الرحلة.'**
  String get youngMuslimNoAchievementsSubtitle;

  /// No description provided for @youngMuslimUpcomingAchievements.
  ///
  /// In ar, this message translates to:
  /// **'إنجازات قادمة'**
  String get youngMuslimUpcomingAchievements;

  /// No description provided for @youngMuslimAchievementUnlocked.
  ///
  /// In ar, this message translates to:
  /// **'تم فتح هذا الإنجاز.'**
  String get youngMuslimAchievementUnlocked;

  /// {when} is a relative time like "5 minutes ago".
  ///
  /// In ar, this message translates to:
  /// **'فُتح {when}'**
  String youngMuslimAchievementUnlockedAt(String when);

  /// No description provided for @youngMuslimCurrentProgress.
  ///
  /// In ar, this message translates to:
  /// **'التقدّم الحالي'**
  String get youngMuslimCurrentProgress;

  /// Compact video duration: hours and minutes (e.g. "1h 20m").
  ///
  /// In ar, this message translates to:
  /// **'{hours}س {minutes}د'**
  String youngMuslimDurationHoursMinutes(int hours, int minutes);

  /// Compact video duration in minutes (e.g. "12m").
  ///
  /// In ar, this message translates to:
  /// **'{minutes}د'**
  String youngMuslimDurationMinutes(int minutes);

  /// No description provided for @youngMuslimNotWatchedYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يُشاهد بعد'**
  String get youngMuslimNotWatchedYet;

  /// Relative time: just now.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get youngMuslimJustNow;

  /// No description provided for @youngMuslimMinutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{منذ {count} دقيقة}}'**
  String youngMuslimMinutesAgo(int count);

  /// No description provided for @youngMuslimHoursAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{منذ {count} ساعة}}'**
  String youngMuslimHoursAgo(int count);

  /// No description provided for @youngMuslimDaysAgo.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{منذ {count} يوم}}'**
  String youngMuslimDaysAgo(int count);

  /// Episode status: watched.
  ///
  /// In ar, this message translates to:
  /// **'تمت المشاهدة'**
  String get youngMuslimWatched;

  /// Episode status: percent watched.
  ///
  /// In ar, this message translates to:
  /// **'تقدّم {percent}٪'**
  String youngMuslimProgressPercent(int percent);

  /// Episode status: not started yet.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة للمشاهدة'**
  String get youngMuslimReadyToWatch;

  /// Number of series in a category.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} سلسلة}}'**
  String youngMuslimCategorySeriesCount(int count);

  /// Number of series in a category aimed at kids.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} سلسلة · للأطفال}}'**
  String youngMuslimCategorySeriesCountKids(int count);

  /// Episode number and its duration.
  ///
  /// In ar, this message translates to:
  /// **'حلقة {episode} · {duration}'**
  String youngMuslimEpisodeMeta(int episode, String duration);

  /// No description provided for @youngMuslimResumeWhereLeft.
  ///
  /// In ar, this message translates to:
  /// **'تابع من حيث توقفت'**
  String get youngMuslimResumeWhereLeft;

  /// No description provided for @youngMuslimTimeRemaining.
  ///
  /// In ar, this message translates to:
  /// **'يتبقّى {duration}'**
  String youngMuslimTimeRemaining(String duration);

  /// The video is almost finished.
  ///
  /// In ar, this message translates to:
  /// **'اقتربت النهاية'**
  String get youngMuslimAlmostDone;

  /// Generic error when loading library content (categories, books, audios) from the server fails.
  ///
  /// In ar, this message translates to:
  /// **'غير قادر على معالجة العملية'**
  String get categoriesRequestFailed;

  /// Title of the Islamic library screen (books, audios, lessons).
  ///
  /// In ar, this message translates to:
  /// **'المكتبة'**
  String get categoriesLibraryTitle;

  /// Section header: the Holy Quran and its sciences.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم وعلومه'**
  String get categoriesQuranSciencesHeader;

  /// Section header: content types (books, stories, audios...).
  ///
  /// In ar, this message translates to:
  /// **'تصنيفات'**
  String get categoriesTypesHeader;

  /// Section header: library topics.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام'**
  String get categoriesSectionsHeader;

  /// Audio collection: famous Quran recitations.
  ///
  /// In ar, this message translates to:
  /// **'تلاوات مشهورة'**
  String get categoriesFamousRecitations;

  /// Audio collection: Quran teaching for children.
  ///
  /// In ar, this message translates to:
  /// **'تعليم أطفال'**
  String get categoriesKidsTeaching;

  /// Audio collection: Quran recitations in different riwayat/qira'at (screen title).
  ///
  /// In ar, this message translates to:
  /// **'تلاوات بروايات وقراءات'**
  String get categoriesRecitationsByNarration;

  /// Short tile label for categoriesRecitationsByNarration.
  ///
  /// In ar, this message translates to:
  /// **'تلاوات بروايات'**
  String get categoriesRecitationsByNarrationShort;

  /// Audio collection: recitations by imams of the Two Holy Mosques (Makkah & Madinah).
  ///
  /// In ar, this message translates to:
  /// **'مصاحف الحرمين'**
  String get categoriesHaramainMushafs;

  /// No description provided for @categoriesTypeVideos.
  ///
  /// In ar, this message translates to:
  /// **'فيديوهات'**
  String get categoriesTypeVideos;

  /// No description provided for @categoriesTypeBooks.
  ///
  /// In ar, this message translates to:
  /// **'كتب'**
  String get categoriesTypeBooks;

  /// No description provided for @categoriesTypeStories.
  ///
  /// In ar, this message translates to:
  /// **'قصص'**
  String get categoriesTypeStories;

  /// Content type: audio lectures.
  ///
  /// In ar, this message translates to:
  /// **'أصوات'**
  String get categoriesTypeAudios;

  /// Content type: fatwas (religious rulings).
  ///
  /// In ar, this message translates to:
  /// **'فتاوى'**
  String get categoriesTypeFatwas;

  /// Content type: Quran-related materials.
  ///
  /// In ar, this message translates to:
  /// **'قرآن'**
  String get categoriesTypeQuran;

  /// No description provided for @categoriesTypePresentations.
  ///
  /// In ar, this message translates to:
  /// **'عروض تقديمية'**
  String get categoriesTypePresentations;

  /// No description provided for @categoriesTypeNews.
  ///
  /// In ar, this message translates to:
  /// **'أخبار'**
  String get categoriesTypeNews;

  /// No description provided for @categoriesTypeArticles.
  ///
  /// In ar, this message translates to:
  /// **'مقالات'**
  String get categoriesTypeArticles;

  /// No description provided for @categoriesTypeApps.
  ///
  /// In ar, this message translates to:
  /// **'تطبيقات'**
  String get categoriesTypeApps;

  /// Content type: Friday sermons (khutbahs).
  ///
  /// In ar, this message translates to:
  /// **'خطب'**
  String get categoriesTypeSermons;

  /// Library topic.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get categoriesTopicQuran;

  /// Library topic: the Prophetic Sunnah.
  ///
  /// In ar, this message translates to:
  /// **'السنة'**
  String get categoriesTopicSunnah;

  /// Library topic: biography of the Prophet ﷺ.
  ///
  /// In ar, this message translates to:
  /// **'السيرة النبوية'**
  String get categoriesTopicSeerah;

  /// Library topic: Islamic creed (aqeedah).
  ///
  /// In ar, this message translates to:
  /// **'العقيدة'**
  String get categoriesTopicAqeedah;

  /// Library topic: Islamic jurisprudence (fiqh).
  ///
  /// In ar, this message translates to:
  /// **'فقه'**
  String get categoriesTopicFiqh;

  /// Library topic: history.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get categoriesTopicHistory;

  /// Library topic: the Arabic language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة العربية'**
  String get categoriesTopicArabic;

  /// Library topic.
  ///
  /// In ar, this message translates to:
  /// **'دراسات إسلامية'**
  String get categoriesTopicIslamicStudies;

  /// Library topic: scholarly lessons.
  ///
  /// In ar, this message translates to:
  /// **'الدروس العلمية'**
  String get categoriesTopicLessons;

  /// Library topic: major sins and prohibitions.
  ///
  /// In ar, this message translates to:
  /// **'الكبائر والمحرمات'**
  String get categoriesTopicMajorSins;

  /// No description provided for @categoriesNoSearchResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج لهذا البحث.'**
  String get categoriesNoSearchResults;

  /// Number of items in a library section.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} عنصرًا}}'**
  String categoriesItemsCount(int count);

  /// Type label of a library item: audio.
  ///
  /// In ar, this message translates to:
  /// **'مادة صوتية'**
  String get categoriesItemAudio;

  /// Type label of a library item: book.
  ///
  /// In ar, this message translates to:
  /// **'كتاب'**
  String get categoriesItemBook;

  /// Type label of a library item: article.
  ///
  /// In ar, this message translates to:
  /// **'مقال'**
  String get categoriesItemArticle;

  /// Type label of a library item: video.
  ///
  /// In ar, this message translates to:
  /// **'مرئي'**
  String get categoriesItemVideo;

  /// Fallback screen title when a category has no name.
  ///
  /// In ar, this message translates to:
  /// **'التصنيف'**
  String get categoriesFallbackTitle;

  /// No description provided for @categoriesNoAttachments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مرفقات لهذه المادة.'**
  String get categoriesNoAttachments;

  /// Section header: files attached to a library item.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get categoriesAttachments;

  /// Button: watch a video attachment.
  ///
  /// In ar, this message translates to:
  /// **'مشاهدة'**
  String get categoriesActionWatch;

  /// Button: read a PDF attachment.
  ///
  /// In ar, this message translates to:
  /// **'قراءة'**
  String get categoriesActionRead;

  /// Button: open a link attachment.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get categoriesActionOpen;

  /// Position of an attachment in its list.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب {order}'**
  String categoriesOrder(String order);

  /// Button: download a file.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get categoriesDownload;

  /// Default name of a downloaded attachment without a description.
  ///
  /// In ar, this message translates to:
  /// **'مرفق'**
  String get categoriesAttachmentFallback;

  /// No description provided for @categoriesNoChapters.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أبواب في هذا القسم.'**
  String get categoriesNoChapters;

  /// Tooltip: clear the search field.
  ///
  /// In ar, this message translates to:
  /// **'مسح البحث'**
  String get categoriesClearSearch;

  /// No description provided for @categoriesAudioLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المواد الصوتية.'**
  String get categoriesAudioLoadError;

  /// Name of an untitled audio clip by its position.
  ///
  /// In ar, this message translates to:
  /// **'مقطع {number}'**
  String categoriesAudioClipNumber(int number);

  /// Default name of a downloaded audio clip.
  ///
  /// In ar, this message translates to:
  /// **'مقطع صوتي'**
  String get categoriesAudioClipFallback;

  /// Title of the books screen.
  ///
  /// In ar, this message translates to:
  /// **'كتب'**
  String get booksTitle;

  /// No description provided for @booksLoadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الكتب حاليًا.'**
  String get booksLoadError;

  /// No description provided for @booksEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد كتب للعرض.'**
  String get booksEmpty;

  /// Section header: downloadable files of a book.
  ///
  /// In ar, this message translates to:
  /// **'ملفّات الكتاب'**
  String get booksFilesHeader;

  /// No description provided for @booksNoFilesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملفّات'**
  String get booksNoFilesTitle;

  /// No description provided for @booksNoFilesBody.
  ///
  /// In ar, this message translates to:
  /// **'لم تُرفق بهذا الكتاب ملفّات للتنزيل.'**
  String get booksNoFilesBody;

  /// Section header: book description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get booksDescriptionHeader;

  /// Section header: bibliographic reference of the book.
  ///
  /// In ar, this message translates to:
  /// **'المرجع'**
  String get booksReferenceHeader;

  /// Name of an untitled book file by its position.
  ///
  /// In ar, this message translates to:
  /// **'الملفّ {number}'**
  String booksFileNumber(int number);

  /// Title bar of the in-app PDF book reader.
  ///
  /// In ar, this message translates to:
  /// **'قراءة الكتاب'**
  String get booksReadTitle;

  /// No description provided for @booksViewerFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر عرض الكتاب داخل التطبيق'**
  String get booksViewerFailed;

  /// No description provided for @booksOpenOutsideHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك فتحه خارج التطبيق'**
  String get booksOpenOutsideHint;

  /// Button: open the book in an external app/browser.
  ///
  /// In ar, this message translates to:
  /// **'فتح خارج التطبيق'**
  String get booksOpenOutside;

  /// Title: Imam al-Nawawi's Forty Hadith collection. Use the name Muslims know in the target language (e.g. 'Arbain Nawawi').
  ///
  /// In ar, this message translates to:
  /// **'الأربعون النووية'**
  String get hadith40Title;

  /// Fallback title of a hadith by its number in the collection.
  ///
  /// In ar, this message translates to:
  /// **'الحديث {number}'**
  String hadith40Number(int number);

  /// No description provided for @hadith40SearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن حديث'**
  String get hadith40SearchHint;

  /// No description provided for @hadith40NoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج لهذا البحث'**
  String get hadith40NoResults;

  /// No description provided for @hadith40ShowAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأحاديث كلها'**
  String get hadith40ShowAll;

  /// Subtitle in the hadith sheet: collection name and hadith number.
  ///
  /// In ar, this message translates to:
  /// **'الأربعون النووية · الحديث {number}'**
  String hadith40SheetSubtitle(int number);

  /// Heading above the explanation (commentary) of the hadith.
  ///
  /// In ar, this message translates to:
  /// **'شرح الحديث'**
  String get hadith40Explanation;

  /// Text shared/copied for a hadith. {title}, {hadith} and {explanation} are Arabic content; translate only the "Explanation of the hadith:" label.
  ///
  /// In ar, this message translates to:
  /// **'{title}\n\n{hadith}\n\nشرح الحديث:\n{explanation}'**
  String hadith40ShareText(String title, String hadith, String explanation);

  /// Title: the 99 Beautiful Names of Allah (Asma ul-Husna).
  ///
  /// In ar, this message translates to:
  /// **'أسماء الله الحسنى'**
  String get allahNamesTitle;

  /// Subtitle in the name details sheet, e.g. "Name 5 of the Beautiful Names of Allah".
  ///
  /// In ar, this message translates to:
  /// **'الاسم {number} من أسماء الله الحسنى'**
  String allahNamesNameOrder(int number);

  /// Section header: meaning of the name.
  ///
  /// In ar, this message translates to:
  /// **'المعنى'**
  String get allahNamesMeaning;

  /// No description provided for @allahNamesSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن أسماء الله الحسنى'**
  String get allahNamesSearchHint;

  /// No description provided for @allahNamesNoResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get allahNamesNoResultsTitle;

  /// No description provided for @allahNamesNoResultsMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد اسمًا يطابق بحثك.'**
  String get allahNamesNoResultsMessage;

  /// No description provided for @allahNamesShowAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأسماء كلها'**
  String get allahNamesShowAll;

  /// Section header in the ayah sheet: listen to the recitation.
  ///
  /// In ar, this message translates to:
  /// **'السماع'**
  String get readQuranListen;

  /// Section header in the ayah sheet: the verse text.
  ///
  /// In ar, this message translates to:
  /// **'الآية'**
  String get readQuranAyah;

  /// Section header in the ayah sheet: exegesis (tafsir) of the verse.
  ///
  /// In ar, this message translates to:
  /// **'تفسير الآية'**
  String get readQuranTafsir;

  /// Accessibility label of the play/pause button.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل أو إيقاف'**
  String get quranAudioPlayPause;

  /// Name of an untitled audio track by its position.
  ///
  /// In ar, this message translates to:
  /// **'المقطع {number}'**
  String audiosTrackNumber(int number);

  /// Section header: audio tracks of a series.
  ///
  /// In ar, this message translates to:
  /// **'المقاطع'**
  String get audiosTracksHeader;

  /// No description provided for @audiosSearchSeriesHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن سلسلة'**
  String get audiosSearchSeriesHint;

  /// Subtitle of a row: an audio lecture series.
  ///
  /// In ar, this message translates to:
  /// **'سلسلة صوتية'**
  String get audiosSeriesSubtitle;

  /// No description provided for @audiosNoSeries.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد سلاسل للعرض'**
  String get audiosNoSeries;

  /// No description provided for @audiosNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا نتائج لبحثك'**
  String get audiosNoResults;

  /// Player button: previous track.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get audiosPrevious;

  /// Player button: next track.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get audiosNext;

  /// Accessibility label: pause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقّت'**
  String get audiosPause;

  /// Accessibility label: play.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل'**
  String get audiosPlay;

  /// Android snackbar shown when an in-app (flexible) update finished downloading.
  ///
  /// In ar, this message translates to:
  /// **'تم تحميل التحديث، يمكنك تثبيته الآن.'**
  String get coreUpdateDownloaded;

  /// Snackbar action that installs the downloaded app update.
  ///
  /// In ar, this message translates to:
  /// **'تثبيت الآن'**
  String get coreUpdateInstallNow;

  /// Title of the iOS 'new version available' dialog.
  ///
  /// In ar, this message translates to:
  /// **'يتوفر تحديث جديد'**
  String get coreUpdateAvailableTitle;

  /// Body of the iOS update dialog. Keep 'App Store' as is.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version} متاح الآن على App Store.'**
  String coreUpdateAvailableMessage(String version);

  /// Heading shown above the store release notes in the update dialog.
  ///
  /// In ar, this message translates to:
  /// **'الجديد في هذا الإصدار:'**
  String get coreUpdateWhatsNew;

  /// Update dialog button that opens the App Store page.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الآن'**
  String get coreUpdateNow;

  /// Title of the 'exit the app?' confirmation dialog (literally 'Notice').
  ///
  /// In ar, this message translates to:
  /// **'تنبيه'**
  String get coreExitDialogTitle;

  /// Body of the exit confirmation dialog shown on back press from the home screen.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من الخروج من التطبيق'**
  String get coreExitDialogMessage;

  /// Short exit confirmation used by the older exit dialog.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من الخروج'**
  String get coreExitConfirmMessage;

  /// Button in the exit dialog that cancels leaving the app (stay).
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get coreExitStay;

  /// Button in the exit dialog that closes the app.
  ///
  /// In ar, this message translates to:
  /// **'الخروج'**
  String get coreExitAction;

  /// Default title of the delete confirmation dialog (deleting a dhikr/remembrance item).
  ///
  /// In ar, this message translates to:
  /// **'حذف الذكر؟'**
  String get coreDeleteDhikrTitle;

  /// Default message of the delete confirmation dialog for a dhikr item.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الذكر؟'**
  String get coreDeleteDhikrMessage;

  /// Form validation error for an empty required text field.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get coreFieldRequired;

  /// Generic empty state when a list or detail has no data.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات.'**
  String get coreNoData;

  /// Generic empty state for lists with nothing to display.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد بيانات للعرض'**
  String get coreNoDataToShow;

  /// Section heading 'Content' in library detail sheets.
  ///
  /// In ar, this message translates to:
  /// **'المحتوى'**
  String get coreContent;

  /// Generic error with a retry button: 'Something went wrong, please try again'.
  ///
  /// In ar, this message translates to:
  /// **'هناك خطأ ما يرجى المحاولة مرة أخرى'**
  String get coreGenericError;

  /// Error shown when loading data failed.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل البيانات'**
  String get coreLoadDataError;

  /// Shows the HTTP/server status code under an error message.
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {code}'**
  String coreErrorStatus(String code);

  /// Tooltip of the back button that closes the search view.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق البحث'**
  String get coreCloseSearch;

  /// Tooltip of the button that clears the search text.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get coreClear;

  /// Fallback header title of a generic bottom sheet ('Add new').
  ///
  /// In ar, this message translates to:
  /// **'إضافة جديد'**
  String get coreSheetDefaultTitle;

  /// Fallback header subtitle of a generic bottom sheet ('Customize the content').
  ///
  /// In ar, this message translates to:
  /// **'قم بتخصيص المحتوى'**
  String get coreSheetDefaultSubtitle;

  /// Toast after copying text to the clipboard.
  ///
  /// In ar, this message translates to:
  /// **'تم النسخ بنجاح'**
  String get coreCopiedSuccessfully;

  /// Toast when a file download starts.
  ///
  /// In ar, this message translates to:
  /// **'التنزيل بدأ'**
  String get coreDownloadStarted;

  /// Toast when a file download has been queued/finished.
  ///
  /// In ar, this message translates to:
  /// **'تم التنزيل'**
  String get coreDownloadCompleted;

  /// Toast asking whether to save the user's current Quran reading position.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حفظ مكان قراءتك؟'**
  String get coreSaveReadingPositionPrompt;

  /// Toast when the device location service (GPS) is turned off.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع غير مفعّلة. فعّلها لتحديد مواقيت الصلاة.'**
  String get coreLocationServiceDisabled;

  /// Toast when the user denied the location permission.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم منح صلاحية الوصول إلى الموقع.'**
  String get coreLocationPermissionDenied;

  /// Toast when the location permission is permanently denied and must be enabled from system settings.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الموقع مرفوضة نهائيًا. فعّلها من إعدادات التطبيق.'**
  String get coreLocationPermissionDeniedForever;

  /// No description provided for @coreNotNow.
  ///
  /// In ar, this message translates to:
  /// **'ليس الآن'**
  String get coreNotNow;

  /// Button that grants a requested permission.
  ///
  /// In ar, this message translates to:
  /// **'السماح'**
  String get coreAllow;

  /// Button that opens the system settings page of the app.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get coreOpenSettings;

  /// Title of the dialog explaining why notification permission is needed.
  ///
  /// In ar, this message translates to:
  /// **'إذن الإشعارات'**
  String get coreNotificationPermissionTitle;

  /// Body of the notification permission rationale dialog. Keep the line break.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج التطبيق إلى إذن الإشعارات لتذكيرك بأوقات الصلاة والأذكار.\nهذا يساعدك على البقاء على اتصال مع تعاليم الإسلام طوال اليوم.'**
  String get coreNotificationPermissionRationale;

  /// No description provided for @coreNotificationSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الإشعارات'**
  String get coreNotificationSettingsTitle;

  /// Dialog body when notification permission is permanently denied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض إذن الإشعارات بشكل دائم.\nيرجى الذهاب إلى الإعدادات وتفعيل الإشعارات يدوياً.'**
  String get coreNotificationPermanentlyDeniedMessage;

  /// corePermissionStatus*: short descriptions of the current notification permission state.
  ///
  /// In ar, this message translates to:
  /// **'تم منح جميع الأذونات'**
  String get corePermissionStatusGranted;

  /// No description provided for @corePermissionStatusDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض أذونات الإشعارات'**
  String get corePermissionStatusDenied;

  /// No description provided for @corePermissionStatusPermanentlyDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الأذونات بشكل دائم'**
  String get corePermissionStatusPermanentlyDenied;

  /// No description provided for @corePermissionStatusPartial.
  ///
  /// In ar, this message translates to:
  /// **'تم منح بعض الأذونات فقط'**
  String get corePermissionStatusPartial;

  /// No description provided for @corePermissionStatusUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حالة الأذونات غير معروفة'**
  String get corePermissionStatusUnknown;

  /// corePermissionResult*: outcome of asking the user for notification permissions.
  ///
  /// In ar, this message translates to:
  /// **'تم منح جميع الأذونات بنجاح'**
  String get corePermissionResultGranted;

  /// No description provided for @corePermissionResultDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض طلب الأذونات'**
  String get corePermissionResultDenied;

  /// No description provided for @corePermissionResultPermanentlyDenied.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الأذونات بشكل دائم - يرجى الذهاب إلى الإعدادات'**
  String get corePermissionResultPermanentlyDenied;

  /// No description provided for @corePermissionResultPartial.
  ///
  /// In ar, this message translates to:
  /// **'تم منح بعض الأذونات - قد تحتاج لأذونات إضافية'**
  String get corePermissionResultPartial;

  /// No description provided for @corePermissionResultError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء طلب الأذونات'**
  String get corePermissionResultError;

  /// iOS notification action button that opens the app.
  ///
  /// In ar, this message translates to:
  /// **'فتح التطبيق'**
  String get coreNotificationActionOpenApp;

  /// iOS notification action button that dismisses the notification.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء'**
  String get coreNotificationActionDismiss;

  /// iOS notification action: mark the reminder (e.g. adhkar) as read/done.
  ///
  /// In ar, this message translates to:
  /// **'تم القراءة'**
  String get coreNotificationActionMarkRead;

  /// iOS notification action: remind me later.
  ///
  /// In ar, this message translates to:
  /// **'تذكير لاحقاً'**
  String get coreNotificationActionRemindLater;

  /// Android notification channel group name shown in system settings.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات الإسلامية'**
  String get coreNotificationGroupName;

  /// Android notification channel group description shown in system settings.
  ///
  /// In ar, this message translates to:
  /// **'مجموعة الإشعارات الخاصة بالتطبيق الإسلامي'**
  String get coreNotificationGroupDescription;

  /// Android notification channel description in system settings. {channel} is one of the coreChannel* names.
  ///
  /// In ar, this message translates to:
  /// **'قناة {channel} للإشعارات الإسلامية'**
  String coreNotificationChannelDescription(String channel);

  /// 'Tamaneena app' — default notification ticker/iOS subtitle. Latin-script languages write 'Tamaneena'.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق طمأنينة'**
  String get coreNotificationAppLabel;

  /// Summary text of an expandable (big text) notification: 'More...'.
  ///
  /// In ar, this message translates to:
  /// **'المزيد...'**
  String get coreNotificationMore;

  /// Summary line of a grouped Android notification: number of notifications.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا إشعارات} =1{إشعار واحد} =2{إشعاران} few{{count} إشعارات} many{{count} إشعارًا} other{{count} إشعار}}'**
  String coreNotificationCount(int count);

  /// Body of a grouped Android notification summary: number of new notifications.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا إشعارات جديدة} =1{إشعار جديد واحد} =2{إشعاران جديدان} few{{count} إشعارات جديدة} many{{count} إشعارًا جديدًا} other{{count} إشعار جديد}}'**
  String coreNotificationNewCount(int count);

  /// Accessibility ticker of the adhan notification: 'It is now time for the adhan of {prayer}'.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن أذان {prayer}'**
  String coreAthanTicker(String prayer);

  /// Short label 'Adhan of {prayer}' (e.g. 'Fajr adhan'). {prayer} is a prayer name.
  ///
  /// In ar, this message translates to:
  /// **'أذان {prayer}'**
  String coreAthanDescription(String prayer);

  /// coreChannel*: Android notification channel names shown in system settings, formatted '<app name> - <channel>'. Latin-script languages write the app name as 'Tamaneena'. Dhikr phrases (e.g. 'Subhan Allah', 'La hawla wa la quwwata illa billah') should use the transliteration Muslims use in the target language.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - الأذان'**
  String get coreChannelAthan;

  /// No description provided for @coreChannelMohammed.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - الصلاة على النبي'**
  String get coreChannelMohammed;

  /// No description provided for @coreChannelMorning.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - أذكار الصباح'**
  String get coreChannelMorning;

  /// No description provided for @coreChannelNight.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - أذكار المساء'**
  String get coreChannelNight;

  /// No description provided for @coreChannelSleep.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - أذكار النوم'**
  String get coreChannelSleep;

  /// No description provided for @coreChannelGetUp.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - أذكار الاستيقاظ'**
  String get coreChannelGetUp;

  /// No description provided for @coreChannelMiddleNight.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - قيام الليل'**
  String get coreChannelMiddleNight;

  /// No description provided for @coreChannelRandomThikr.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - أذكار عشوائية'**
  String get coreChannelRandomThikr;

  /// No description provided for @coreChannelAstgferAllh.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - الاستغفار'**
  String get coreChannelAstgferAllh;

  /// No description provided for @coreChannelHasbnaAllh.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - حسبنا الله'**
  String get coreChannelHasbnaAllh;

  /// No description provided for @coreChannelLaHawla.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - لا حول ولا قوة إلا بالله'**
  String get coreChannelLaHawla;

  /// No description provided for @coreChannelSubhanAllh.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - سبحان الله'**
  String get coreChannelSubhanAllh;

  /// No description provided for @coreChannelDefaultChannel.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - الإشعارات العامة'**
  String get coreChannelDefaultChannel;

  /// Channel for the 'Fajr companion' smart-outreach reminders.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - صحبة الفجر'**
  String get coreChannelSmartOutreach;

  /// coreFcmChannel*: Android channels for push (Firebase) notifications, '<app name> - <channel>'.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - إشعارات مهمة'**
  String get coreFcmChannelHighImportance;

  /// No description provided for @coreFcmChannelChat.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - الرسائل'**
  String get coreFcmChannelChat;

  /// No description provided for @coreFcmChannelUpdates.
  ///
  /// In ar, this message translates to:
  /// **'طمأنينة - التحديثات'**
  String get coreFcmChannelUpdates;

  /// No description provided for @coreFcmChannelHighImportanceDescription.
  ///
  /// In ar, this message translates to:
  /// **'قناة الإشعارات المهمة في تطبيق طمأنينة'**
  String get coreFcmChannelHighImportanceDescription;

  /// No description provided for @coreFcmChannelDefaultDescription.
  ///
  /// In ar, this message translates to:
  /// **'قناة الإشعارات العامة في تطبيق طمأنينة'**
  String get coreFcmChannelDefaultDescription;

  /// No description provided for @coreFcmChannelChatDescription.
  ///
  /// In ar, this message translates to:
  /// **'قناة رسائل وتنبيهات تطبيق طمأنينة'**
  String get coreFcmChannelChatDescription;

  /// No description provided for @coreFcmChannelUpdatesDescription.
  ///
  /// In ar, this message translates to:
  /// **'قناة تحديثات تطبيق طمأنينة'**
  String get coreFcmChannelUpdatesDescription;

  /// Title of the first-launch language picker.
  ///
  /// In ar, this message translates to:
  /// **'اختر لغتك'**
  String get languageTitle;

  /// Subtitle under the picker title.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تغييرها لاحقًا من الإعدادات.'**
  String get languageSubtitle;

  /// Settings row and page title for changing the app language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get languageSettingTitle;

  /// Settings row subtitle. The current language name is shown separately.
  ///
  /// In ar, this message translates to:
  /// **'لغة واجهة التطبيق'**
  String get languageSettingSubtitle;

  /// Tells the user that Quran, adhkar and duas are always shown in their original Arabic text, whatever the interface language.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم والأذكار والأدعية تبقى بنصّها العربي.'**
  String get languageReligiousTextNote;

  /// Name of the 'Dawn companionship' feature: scheduled call lists that phone relatives/friends (e.g. to wake them for Fajr prayer). Screen title.
  ///
  /// In ar, this message translates to:
  /// **'صحبة الفجر'**
  String get outreachTitle;

  /// One-line subtitle under the feature title: calm call lists that start your loved ones' day with good.
  ///
  /// In ar, this message translates to:
  /// **'قوائم اتصال هادئة تبدأ يوم من تحبّ بالخير'**
  String get outreachTagline;

  /// Action type of a contact in a call list: just place a phone call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال فقط'**
  String get outreachActionCallOnly;

  /// Error: the call list (schedule) no longer exists.
  ///
  /// In ar, this message translates to:
  /// **'هذه القائمة غير موجودة.'**
  String get outreachErrorScheduleNotFound;

  /// No description provided for @outreachContactsPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'يجب السماح بالوصول لجهات الاتصال لاختيار رقم تلقائياً.'**
  String get outreachContactsPermissionDenied;

  /// No description provided for @outreachContactNoPhone.
  ///
  /// In ar, this message translates to:
  /// **'جهة الاتصال المختارة لا تحتوي على رقم هاتف.'**
  String get outreachContactNoPhone;

  /// No description provided for @outreachContactPickError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء اختيار جهة الاتصال.'**
  String get outreachContactPickError;

  /// Fallback name for a contact that has no name.
  ///
  /// In ar, this message translates to:
  /// **'بدون اسم'**
  String get outreachUnnamed;

  /// Name of the Phone (make calls) permission, listed among missing permissions.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال'**
  String get outreachPermissionPhone;

  /// Name of the Contacts permission, listed among missing permissions.
  ///
  /// In ar, this message translates to:
  /// **'جهات الاتصال'**
  String get outreachPermissionContacts;

  /// Name of the Notifications permission, listed among missing permissions.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get outreachPermissionNotifications;

  /// Separator placed between items of an inline list (permission names, weekday names). Arabic comma followed by a space; use the target language's comma + space.
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get outreachListSeparator;

  /// No description provided for @outreachValidationTitleRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسمًا للقائمة.'**
  String get outreachValidationTitleRequired;

  /// No description provided for @outreachValidationAddNumber.
  ///
  /// In ar, this message translates to:
  /// **'أضف رقمًا واحدًا على الأقل.'**
  String get outreachValidationAddNumber;

  /// No description provided for @outreachValidationEmptyPhone.
  ///
  /// In ar, this message translates to:
  /// **'كل خانة يجب أن تحتوي على رقم هاتف.'**
  String get outreachValidationEmptyPhone;

  /// No description provided for @outreachValidationIncompleteNumber.
  ///
  /// In ar, this message translates to:
  /// **'يوجد رقم غير مكتمل.'**
  String get outreachValidationIncompleteNumber;

  /// No description provided for @outreachValidationDuplicateNumber.
  ///
  /// In ar, this message translates to:
  /// **'يوجد رقم مكرر في نفس القائمة.'**
  String get outreachValidationDuplicateNumber;

  /// No description provided for @outreachValidationPickDay.
  ///
  /// In ar, this message translates to:
  /// **'اختر يومًا واحدًا على الأقل.'**
  String get outreachValidationPickDay;

  /// No description provided for @outreachValidationEnableWithoutNumbers.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تشغيل قائمة بدون أرقام.'**
  String get outreachValidationEnableWithoutNumbers;

  /// No description provided for @outreachCallLogsTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل المكالمات'**
  String get outreachCallLogsTitle;

  /// No description provided for @outreachClearLog.
  ///
  /// In ar, this message translates to:
  /// **'مسح السجل'**
  String get outreachClearLog;

  /// No description provided for @outreachStatTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get outreachStatTotal;

  /// Stat label: number of people who answered the call.
  ///
  /// In ar, this message translates to:
  /// **'ردّوا'**
  String get outreachStatAnswered;

  /// Stat label: number of people who did not answer.
  ///
  /// In ar, this message translates to:
  /// **'لم يردّوا'**
  String get outreachStatNotAnswered;

  /// Stat label: number of calls that failed.
  ///
  /// In ar, this message translates to:
  /// **'فشل'**
  String get outreachStatFailed;

  /// No description provided for @outreachResultsHeader.
  ///
  /// In ar, this message translates to:
  /// **'النتائج'**
  String get outreachResultsHeader;

  /// No description provided for @outreachNoResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج بعد'**
  String get outreachNoResultsTitle;

  /// No description provided for @outreachNoResultsMessage.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا نتيجة كل مكالمة بعد أول تشغيل.'**
  String get outreachNoResultsMessage;

  /// Compact duration in seconds, e.g. '12s'. 'ث' is the Arabic abbreviation for seconds.
  ///
  /// In ar, this message translates to:
  /// **'{seconds}ث'**
  String outreachSecondsShort(int seconds);

  /// Slider value in seconds, e.g. '30 s'. 'ث' is the Arabic abbreviation for seconds.
  ///
  /// In ar, this message translates to:
  /// **'{seconds} ث'**
  String outreachSecondsValue(int seconds);

  /// No description provided for @outreachCallStatusAnswered.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get outreachCallStatusAnswered;

  /// No description provided for @outreachCallStatusNotAnswered.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم الرد'**
  String get outreachCallStatusNotAnswered;

  /// No description provided for @outreachCallStatusFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل الاتصال'**
  String get outreachCallStatusFailed;

  /// No description provided for @outreachExecutionTitle.
  ///
  /// In ar, this message translates to:
  /// **'بدء المكالمات'**
  String get outreachExecutionTitle;

  /// No description provided for @outreachCallsStartedFromAlert.
  ///
  /// In ar, this message translates to:
  /// **'بدأت المكالمات من التنبيه.'**
  String get outreachCallsStartedFromAlert;

  /// No description provided for @outreachCallsStartedNow.
  ///
  /// In ar, this message translates to:
  /// **'بدأت المكالمات الآن.'**
  String get outreachCallsStartedNow;

  /// No description provided for @outreachCallsStartFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر بدء المكالمات الآن. حاول مرة أخرى.'**
  String get outreachCallsStartFailed;

  /// No description provided for @outreachCallLogsReviewSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع من ردّ ومن لم يردّ بعد انتهاء القائمة'**
  String get outreachCallLogsReviewSubtitle;

  /// No description provided for @outreachPreparingCalls.
  ///
  /// In ar, this message translates to:
  /// **'جارِ تجهيز المكالمات...'**
  String get outreachPreparingCalls;

  /// No description provided for @outreachDontCloseHint.
  ///
  /// In ar, this message translates to:
  /// **'لا تغلق الصفحة حتى تبدأ العملية.'**
  String get outreachDontCloseHint;

  /// No description provided for @outreachCanCloseHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك إغلاق الصفحة الآن ومراجعة النتيجة من السجل.'**
  String get outreachCanCloseHint;

  /// No description provided for @outreachAddList.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قائمة'**
  String get outreachAddList;

  /// No description provided for @outreachStatLists.
  ///
  /// In ar, this message translates to:
  /// **'القوائم'**
  String get outreachStatLists;

  /// Stat label: number of enabled call lists.
  ///
  /// In ar, this message translates to:
  /// **'المفعّلة'**
  String get outreachStatEnabled;

  /// Stat label: total number of phone numbers across all lists.
  ///
  /// In ar, this message translates to:
  /// **'الأرقام'**
  String get outreachStatNumbers;

  /// No description provided for @outreachListsHeader.
  ///
  /// In ar, this message translates to:
  /// **'قوائم الاتصال'**
  String get outreachListsHeader;

  /// No description provided for @outreachToolsHeader.
  ///
  /// In ar, this message translates to:
  /// **'أدوات'**
  String get outreachToolsHeader;

  /// No description provided for @outreachCallLogsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة كل اتصال: من ردّ ومن لم يردّ'**
  String get outreachCallLogsSubtitle;

  /// No description provided for @outreachSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الاتصال'**
  String get outreachSettingsTitle;

  /// No description provided for @outreachSettingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المدد الافتراضية وسلوك القوائم الجديدة'**
  String get outreachSettingsSubtitle;

  /// No description provided for @outreachNoListsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد قوائم بعد'**
  String get outreachNoListsTitle;

  /// No description provided for @outreachNoListsMessage.
  ///
  /// In ar, this message translates to:
  /// **'أضف قائمة وحدّد وقتها والأرقام التي تودّ الاتصال بها.'**
  String get outreachNoListsMessage;

  /// Countdown label on the next call list: it starts now.
  ///
  /// In ar, this message translates to:
  /// **'تبدأ الآن'**
  String get outreachStartsNow;

  /// Countdown until the next call list runs: 'in N minutes'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{بعد {count} دقيقة}}'**
  String outreachStartsInMinutes(int count);

  /// Countdown until the next call list runs: 'in N hours'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{بعد {count} ساعة}}'**
  String outreachStartsInHours(int count);

  /// Countdown until the next call list runs: 'in H hours and M minutes'.
  ///
  /// In ar, this message translates to:
  /// **'بعد {hours} ساعة و{minutes} دقيقة'**
  String outreachStartsInHoursMinutes(int hours, int minutes);

  /// Countdown until the next call list runs: 'in N days'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{بعد يوم} other{بعد {count} أيام}}'**
  String outreachStartsInDays(int count);

  /// Snackbar. {permissions} is a comma-separated list of permission names.
  ///
  /// In ar, this message translates to:
  /// **'لازم تفعيل هذه الصلاحيات أولًا: {permissions}'**
  String outreachPermissionsRequiredSnack(String permissions);

  /// Notice banner. {permissions} is a comma-separated list of permission names.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحيات المطلوبة غير مكتملة. لتعمل القوائم في وقتها فعّل: {permissions}'**
  String outreachPermissionsNotice(String permissions);

  /// No description provided for @outreachGrantPermissions.
  ///
  /// In ar, this message translates to:
  /// **'منح الصلاحيات'**
  String get outreachGrantPermissions;

  /// No description provided for @outreachOpenSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get outreachOpenSettings;

  /// No description provided for @outreachSettingsSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الإعدادات.'**
  String get outreachSettingsSaved;

  /// No description provided for @outreachSettingsIntro.
  ///
  /// In ar, this message translates to:
  /// **'تُطبَّق هذه القيم على كل قائمة جديدة.'**
  String get outreachSettingsIntro;

  /// No description provided for @outreachDefaultDurationsHeader.
  ///
  /// In ar, this message translates to:
  /// **'المدد الافتراضية'**
  String get outreachDefaultDurationsHeader;

  /// Slider: how long to let the phone ring before giving up.
  ///
  /// In ar, this message translates to:
  /// **'مدة انتظار الرد'**
  String get outreachRingTimeout;

  /// Slider: how long to stay on the call after it is answered before hanging up.
  ///
  /// In ar, this message translates to:
  /// **'الانتظار بعد الرد'**
  String get outreachHangupDelay;

  /// No description provided for @outreachDelayBetweenEach.
  ///
  /// In ar, this message translates to:
  /// **'الفاصل بين كل رقم'**
  String get outreachDelayBetweenEach;

  /// No description provided for @outreachBehaviorHeader.
  ///
  /// In ar, this message translates to:
  /// **'سلوك القوائم'**
  String get outreachBehaviorHeader;

  /// No description provided for @outreachStopAfterFirstAnswerList.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف القائمة بعد أول رد'**
  String get outreachStopAfterFirstAnswerList;

  /// No description provided for @outreachRetryIfNoAnswer.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الاتصال إذا لم يتم الرد'**
  String get outreachRetryIfNoAnswer;

  /// No description provided for @outreachRestartAfterFinish.
  ///
  /// In ar, this message translates to:
  /// **'إعادة البدء بعد الانتهاء'**
  String get outreachRestartAfterFinish;

  /// No description provided for @outreachSaveSettings.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإعدادات'**
  String get outreachSaveSettings;

  /// No description provided for @outreachBackgroundHeader.
  ///
  /// In ar, this message translates to:
  /// **'التشغيل في الخلفية'**
  String get outreachBackgroundHeader;

  /// No description provided for @outreachBatteryTitle.
  ///
  /// In ar, this message translates to:
  /// **'استثناء التطبيق من توفير البطارية'**
  String get outreachBatteryTitle;

  /// No description provided for @outreachBatterySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إذا توقفت القوائم وهي في الخلفية، اسمح للتطبيق بالعمل من إعدادات البطارية.'**
  String get outreachBatterySubtitle;

  /// No description provided for @outreachEditList.
  ///
  /// In ar, this message translates to:
  /// **'تعديل القائمة'**
  String get outreachEditList;

  /// No description provided for @outreachNewList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة جديدة'**
  String get outreachNewList;

  /// No description provided for @outreachCallTimeHeader.
  ///
  /// In ar, this message translates to:
  /// **'وقت الاتصال'**
  String get outreachCallTimeHeader;

  /// No description provided for @outreachManualTime.
  ///
  /// In ar, this message translates to:
  /// **'اختيار وقت يدوي'**
  String get outreachManualTime;

  /// No description provided for @outreachManualTimeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد الساعة والدقيقة بنفسك'**
  String get outreachManualTimeSubtitle;

  /// No description provided for @outreachUseFajrTime.
  ///
  /// In ar, this message translates to:
  /// **'استخدام وقت الفجر'**
  String get outreachUseFajrTime;

  /// Option to use today's Fajr (dawn prayer) time. {time} is the formatted time.
  ///
  /// In ar, this message translates to:
  /// **'استخدام وقت الفجر · {time}'**
  String outreachUseFajrTimeWithTime(String time);

  /// No description provided for @outreachPrayerTimesNotReady.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة غير جاهزة الآن'**
  String get outreachPrayerTimesNotReady;

  /// No description provided for @outreachFajrAutoFill.
  ///
  /// In ar, this message translates to:
  /// **'يُعبَّأ الوقت تلقائيًا من مواقيت اليوم'**
  String get outreachFajrAutoFill;

  /// No description provided for @outreachFajrUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'وقت الفجر غير متاح الآن. جرّب بعد قليل.'**
  String get outreachFajrUnavailable;

  /// No description provided for @outreachFajrTimeUsed.
  ///
  /// In ar, this message translates to:
  /// **'تم استخدام وقت الفجر: {time}'**
  String outreachFajrTimeUsed(String time);

  /// No description provided for @outreachContactFetchFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نجيب جهة الاتصال الآن.'**
  String get outreachContactFetchFailed;

  /// No description provided for @outreachExactAlarmHint.
  ///
  /// In ar, this message translates to:
  /// **'لضمان صحبة الفجر في وقتها بدقة، فعّل إذن التنبيهات الدقيقة من إعدادات الجهاز.'**
  String get outreachExactAlarmHint;

  /// No description provided for @outreachListNameHeader.
  ///
  /// In ar, this message translates to:
  /// **'اسم القائمة'**
  String get outreachListNameHeader;

  /// No description provided for @outreachStartTime.
  ///
  /// In ar, this message translates to:
  /// **'موعد البدء'**
  String get outreachStartTime;

  /// No description provided for @outreachStartTimeHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر وقتًا يدويًا أو استعمل وقت الفجر'**
  String get outreachStartTimeHint;

  /// No description provided for @outreachFajrTimeToday.
  ///
  /// In ar, this message translates to:
  /// **'وقت الفجر اليوم {time}'**
  String outreachFajrTimeToday(String time);

  /// Section header with the number of contacts in the list.
  ///
  /// In ar, this message translates to:
  /// **'جهات الاتصال · {count}'**
  String outreachContactsHeader(int count);

  /// No description provided for @outreachPickFromContacts.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من جهات الاتصال'**
  String get outreachPickFromContacts;

  /// No description provided for @outreachPickFromContactsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف رقمًا جديدًا إلى هذه القائمة'**
  String get outreachPickFromContactsSubtitle;

  /// No description provided for @outreachAdvancedSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات متقدمة'**
  String get outreachAdvancedSettings;

  /// No description provided for @outreachAdvancedSettingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأيام، مدد الانتظار، وسلوك التكرار'**
  String get outreachAdvancedSettingsSubtitle;

  /// No description provided for @outreachSaving.
  ///
  /// In ar, this message translates to:
  /// **'جارِ الحفظ...'**
  String get outreachSaving;

  /// No description provided for @outreachSaveList.
  ///
  /// In ar, this message translates to:
  /// **'حفظ القائمة'**
  String get outreachSaveList;

  /// No description provided for @outreachNoNumbersYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تُضف أرقام بعد.'**
  String get outreachNoNumbersYet;

  /// No description provided for @outreachEnableList.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل هذه القائمة'**
  String get outreachEnableList;

  /// No description provided for @outreachDailyRepeat.
  ///
  /// In ar, this message translates to:
  /// **'تكرار يومي'**
  String get outreachDailyRepeat;

  /// No description provided for @outreachEveryDay.
  ///
  /// In ar, this message translates to:
  /// **'كل يوم'**
  String get outreachEveryDay;

  /// No description provided for @outreachSelectedWeekdays.
  ///
  /// In ar, this message translates to:
  /// **'أيام مختارة من الأسبوع'**
  String get outreachSelectedWeekdays;

  /// No description provided for @outreachDelayBetweenNumbers.
  ///
  /// In ar, this message translates to:
  /// **'الفاصل بين الأرقام'**
  String get outreachDelayBetweenNumbers;

  /// No description provided for @outreachStopAfterFirstAnswer.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف بعد أول رد'**
  String get outreachStopAfterFirstAnswer;

  /// No description provided for @outreachRetryOnNoAnswer.
  ///
  /// In ar, this message translates to:
  /// **'إعادة عند عدم الرد'**
  String get outreachRetryOnNoAnswer;

  /// No description provided for @outreachRepeatWholeCycle.
  ///
  /// In ar, this message translates to:
  /// **'تكرار الحلقة بالكامل'**
  String get outreachRepeatWholeCycle;

  /// No description provided for @outreachListNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: تذكير الفجر'**
  String get outreachListNameHint;

  /// No description provided for @outreachTitleFieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسمًا للقائمة'**
  String get outreachTitleFieldRequired;

  /// No description provided for @outreachPickNumber.
  ///
  /// In ar, this message translates to:
  /// **'اختر الرقم'**
  String get outreachPickNumber;

  /// No description provided for @outreachMultipleNumbers.
  ///
  /// In ar, this message translates to:
  /// **'هذا الاسم فيه أكثر من رقم.'**
  String get outreachMultipleNumbers;

  /// No description provided for @outreachNoDays.
  ///
  /// In ar, this message translates to:
  /// **'بلا أيام محددة'**
  String get outreachNoDays;

  /// Number of phone numbers in a call list.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{بلا أرقام} =1{رقم واحد} =2{رقمان} few{{count} أرقام} many{{count} رقمًا} other{{count} رقمًا}}'**
  String outreachContactsCount(int count);

  /// Compact meta: ring timeout in seconds ('ث' = seconds).
  ///
  /// In ar, this message translates to:
  /// **'انتظار {seconds}ث'**
  String outreachMetaRing(int seconds);

  /// Compact meta: wait after answer in seconds ('ث' = seconds).
  ///
  /// In ar, this message translates to:
  /// **'بعد الرد {seconds}ث'**
  String outreachMetaAfterAnswer(int seconds);

  /// Compact meta: delay between numbers in seconds ('ث' = seconds).
  ///
  /// In ar, this message translates to:
  /// **'بين الأرقام {seconds}ث'**
  String outreachMetaBetween(int seconds);

  /// Pill on the call list that runs soonest.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get outreachNearest;

  /// No description provided for @outreachStartNow.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get outreachStartNow;

  /// No description provided for @outreachStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get outreachStatusActive;

  /// No description provided for @outreachStatusStopped.
  ///
  /// In ar, this message translates to:
  /// **'متوقّف'**
  String get outreachStatusStopped;

  /// Screen-reader label. {status} is outreachStatusActive or outreachStatusStopped.
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {status}'**
  String outreachStatusSemantics(String status);

  /// Weekday names, 1 = Monday … 7 = Sunday.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get outreachWeekday1;

  /// No description provided for @outreachWeekday2.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get outreachWeekday2;

  /// No description provided for @outreachWeekday3.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get outreachWeekday3;

  /// No description provided for @outreachWeekday4.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get outreachWeekday4;

  /// No description provided for @outreachWeekday5.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get outreachWeekday5;

  /// No description provided for @outreachWeekday6.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get outreachWeekday6;

  /// No description provided for @outreachWeekday7.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get outreachWeekday7;

  /// Title of the traveler services sheet (mosques nearby, travel adhkar, halal food, prayer on a flight).
  ///
  /// In ar, this message translates to:
  /// **'خدمات المسافر'**
  String get travelerServicesTitle;

  /// No description provided for @travelerNearbyMosques.
  ///
  /// In ar, this message translates to:
  /// **'المساجد القريبة'**
  String get travelerNearbyMosques;

  /// No description provided for @travelerNearbyHalalRestaurants.
  ///
  /// In ar, this message translates to:
  /// **'مطاعم حلال قريبة'**
  String get travelerNearbyHalalRestaurants;

  /// No description provided for @travelerHalalRestaurants.
  ///
  /// In ar, this message translates to:
  /// **'مطاعم حلال'**
  String get travelerHalalRestaurants;

  /// Short hint under the 'Nearby mosques' tile: around you now.
  ///
  /// In ar, this message translates to:
  /// **'حولك الآن'**
  String get travelerHintAroundYou;

  /// Short hint under the 'Travel adhkar' tile: comes with a counter.
  ///
  /// In ar, this message translates to:
  /// **'بعدّاد'**
  String get travelerHintWithCounter;

  /// Short hint under the 'Halal restaurants' tile: depends on your country.
  ///
  /// In ar, this message translates to:
  /// **'حسب بلدك'**
  String get travelerHintByCountry;

  /// No description provided for @travelerFlightPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة أثناء الطيران'**
  String get travelerFlightPrayer;

  /// Short hint under the 'Prayer during flight' tile: by flight number.
  ///
  /// In ar, this message translates to:
  /// **'برقم الرحلة'**
  String get travelerHintByFlightNumber;

  /// No description provided for @travelerSetLocationForMakkah.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك في المواقيت لتظهر المسافة إلى مكّة.'**
  String get travelerSetLocationForMakkah;

  /// Shown when the user is in Makkah. 'تقبّل الله' = 'May Allah accept (your worship)'.
  ///
  /// In ar, this message translates to:
  /// **'أنت في مكّة المكرّمة — تقبّل الله.'**
  String get travelerInMakkah;

  /// No description provided for @travelerYourLocation.
  ///
  /// In ar, this message translates to:
  /// **'موضعك'**
  String get travelerYourLocation;

  /// Makkah al-Mukarramah, the holy city. Use the usual honorific form in the target language.
  ///
  /// In ar, this message translates to:
  /// **'مكّة المكرّمة'**
  String get travelerMakkah;

  /// No description provided for @travelerQibla.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get travelerQibla;

  /// A distance in meters. 'م' is the Arabic abbreviation for meters.
  ///
  /// In ar, this message translates to:
  /// **'{value} م'**
  String travelerDistanceMeters(String value);

  /// A distance in kilometers. 'كم' is the Arabic abbreviation for km.
  ///
  /// In ar, this message translates to:
  /// **'{value} كم'**
  String travelerDistanceKm(String value);

  /// Separator between parts of an address or place label. Arabic comma + space; use the target language's comma + space.
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get travelerListSeparator;

  /// Compass direction toward Makkah (N, NE, E, SE, S, SW, W, NW), shown under the distance.
  ///
  /// In ar, this message translates to:
  /// **'شمالًا'**
  String get travelerDirectionN;

  /// No description provided for @travelerDirectionNE.
  ///
  /// In ar, this message translates to:
  /// **'شمال شرق'**
  String get travelerDirectionNE;

  /// No description provided for @travelerDirectionE.
  ///
  /// In ar, this message translates to:
  /// **'شرقًا'**
  String get travelerDirectionE;

  /// No description provided for @travelerDirectionSE.
  ///
  /// In ar, this message translates to:
  /// **'جنوب شرق'**
  String get travelerDirectionSE;

  /// No description provided for @travelerDirectionS.
  ///
  /// In ar, this message translates to:
  /// **'جنوبًا'**
  String get travelerDirectionS;

  /// No description provided for @travelerDirectionSW.
  ///
  /// In ar, this message translates to:
  /// **'جنوب غرب'**
  String get travelerDirectionSW;

  /// No description provided for @travelerDirectionW.
  ///
  /// In ar, this message translates to:
  /// **'غربًا'**
  String get travelerDirectionW;

  /// No description provided for @travelerDirectionNW.
  ///
  /// In ar, this message translates to:
  /// **'شمال غرب'**
  String get travelerDirectionNW;

  /// No description provided for @travelerPrayerUnknown.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get travelerPrayerUnknown;

  /// Very short prayer names for small map markers (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha).
  ///
  /// In ar, this message translates to:
  /// **'فجر'**
  String get travelerPrayerShortFajr;

  /// No description provided for @travelerPrayerShortSunrise.
  ///
  /// In ar, this message translates to:
  /// **'شروق'**
  String get travelerPrayerShortSunrise;

  /// No description provided for @travelerPrayerShortDhuhr.
  ///
  /// In ar, this message translates to:
  /// **'ظهر'**
  String get travelerPrayerShortDhuhr;

  /// No description provided for @travelerPrayerShortAsr.
  ///
  /// In ar, this message translates to:
  /// **'عصر'**
  String get travelerPrayerShortAsr;

  /// No description provided for @travelerPrayerShortMaghrib.
  ///
  /// In ar, this message translates to:
  /// **'مغرب'**
  String get travelerPrayerShortMaghrib;

  /// No description provided for @travelerPrayerShortIsha.
  ///
  /// In ar, this message translates to:
  /// **'عشاء'**
  String get travelerPrayerShortIsha;

  /// No description provided for @travelerNoMosquesFound.
  ///
  /// In ar, this message translates to:
  /// **'لم نعثر على مساجد في النطاق الحالي.'**
  String get travelerNoMosquesFound;

  /// No description provided for @travelerNoRestaurantsFound.
  ///
  /// In ar, this message translates to:
  /// **'لم نعثر على مطاعم حلال في هذا النطاق.'**
  String get travelerNoRestaurantsFound;

  /// Estimated walking time.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} دقيقة مشيًا}}'**
  String travelerWalkingMinutes(int count);

  /// Fallback name for a mosque with no name on the map.
  ///
  /// In ar, this message translates to:
  /// **'مسجد قريب'**
  String get travelerDefaultMosqueName;

  /// Fallback name for a halal restaurant with no name on the map.
  ///
  /// In ar, this message translates to:
  /// **'مطعم حلال'**
  String get travelerDefaultRestaurantName;

  /// No description provided for @travelerNoDetailedAddress.
  ///
  /// In ar, this message translates to:
  /// **'بدون عنوان تفصيلي'**
  String get travelerNoDetailedAddress;

  /// Repeat count of a dhikr that depends on the situation.
  ///
  /// In ar, this message translates to:
  /// **'بحسب الموقف'**
  String get travelerRepeatBySituation;

  /// No description provided for @travelerRepeatOnce.
  ///
  /// In ar, this message translates to:
  /// **'مرة'**
  String get travelerRepeatOnce;

  /// How many times a dhikr is repeated.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{{count} مرة}}'**
  String travelerRepeatTimes(int count);

  /// Stages of a journey at which a travel dhikr is said (start, on the way, stopping, returning, bidding farewell to a traveler, supplication for a traveler).
  ///
  /// In ar, this message translates to:
  /// **'عند بداية السفر'**
  String get travelerStageStart;

  /// No description provided for @travelerStageOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'أثناء الطريق'**
  String get travelerStageOnTheWay;

  /// No description provided for @travelerStageStop.
  ///
  /// In ar, this message translates to:
  /// **'عند التوقف'**
  String get travelerStageStop;

  /// No description provided for @travelerStageReturn.
  ///
  /// In ar, this message translates to:
  /// **'عند الرجوع'**
  String get travelerStageReturn;

  /// No description provided for @travelerStageFarewell.
  ///
  /// In ar, this message translates to:
  /// **'توديع المسافر'**
  String get travelerStageFarewell;

  /// No description provided for @travelerStageFarewellReply.
  ///
  /// In ar, this message translates to:
  /// **'دعاء للمسافر'**
  String get travelerStageFarewellReply;

  /// Travel adhkar: remembrances/supplications said while travelling.
  ///
  /// In ar, this message translates to:
  /// **'أذكار السفر'**
  String get travelerAthkarTitle;

  /// No description provided for @travelerAthkarLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل أذكار السفر.'**
  String get travelerAthkarLoadFailed;

  /// No description provided for @travelerFarewellTitle.
  ///
  /// In ar, this message translates to:
  /// **'لمن يودّع مسافرًا'**
  String get travelerFarewellTitle;

  /// These adhkar are not for your road, but for those left behind (seeing you off).
  ///
  /// In ar, this message translates to:
  /// **'ليست من طريقك — بل ممّن بقي خلفك'**
  String get travelerFarewellCaption;

  /// No description provided for @travelerRoadComplete.
  ///
  /// In ar, this message translates to:
  /// **'أتممت أذكار طريقك'**
  String get travelerRoadComplete;

  /// No description provided for @travelerRoadStations.
  ///
  /// In ar, this message translates to:
  /// **'محطّات الطريق'**
  String get travelerRoadStations;

  /// Blessing: 'May safety accompany you.'
  ///
  /// In ar, this message translates to:
  /// **'صحبتك السلامة.'**
  String get travelerRoadCompleteCaption;

  /// No description provided for @travelerRoadCaption.
  ///
  /// In ar, this message translates to:
  /// **'كل ذكر في موضعه من الرحلة — افتح المحطّة التي أنت فيها.'**
  String get travelerRoadCaption;

  /// In shared dhikr text. {virtue} is Arabic religious text and stays untranslated.
  ///
  /// In ar, this message translates to:
  /// **'الفضل: {virtue}'**
  String travelerShareVirtue(String virtue);

  /// In shared dhikr text. {source} is the hadith collection, {hadith} the reference; both stay as-is.
  ///
  /// In ar, this message translates to:
  /// **'المصدر: {source} ({hadith})'**
  String travelerShareSource(String source, String hadith);

  /// No description provided for @travelerResetCounter.
  ///
  /// In ar, this message translates to:
  /// **'تصفير العدّاد'**
  String get travelerResetCounter;

  /// No description provided for @travelerCounterDone.
  ///
  /// In ar, this message translates to:
  /// **'تمّ'**
  String get travelerCounterDone;

  /// Button label: count (tap once per dhikr).
  ///
  /// In ar, this message translates to:
  /// **'عدّ'**
  String get travelerCounterCount;

  /// No description provided for @travelerCountDhikr.
  ///
  /// In ar, this message translates to:
  /// **'عدّ الذكر'**
  String get travelerCountDhikr;

  /// No description provided for @travelerFlightPrayerTitle.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة أثناء الطيران'**
  String get travelerFlightPrayerTitle;

  /// No description provided for @travelerShowTimes.
  ///
  /// In ar, this message translates to:
  /// **'عرض المواقيت'**
  String get travelerShowTimes;

  /// No description provided for @travelerShowMap.
  ///
  /// In ar, this message translates to:
  /// **'عرض الخريطة'**
  String get travelerShowMap;

  /// No description provided for @travelerShowList.
  ///
  /// In ar, this message translates to:
  /// **'عرض القائمة'**
  String get travelerShowList;

  /// No description provided for @travelerSearchByFlightNumber.
  ///
  /// In ar, this message translates to:
  /// **'بحث برقم الرحلة'**
  String get travelerSearchByFlightNumber;

  /// No description provided for @travelerRunSearchNow.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل البحث الآن'**
  String get travelerRunSearchNow;

  /// No description provided for @travelerFlightAttemptsExhausted.
  ///
  /// In ar, this message translates to:
  /// **'انتهت المحاولات. أعد فتح الصفحة للمحاولة مجددًا.'**
  String get travelerFlightAttemptsExhausted;

  /// No description provided for @travelerFlightNumberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الرحلة غير صحيح. مثال: EK202 أو MS985'**
  String get travelerFlightNumberInvalid;

  /// No description provided for @travelerFlightFetchFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر جلب بيانات الرحلة حاليًا.'**
  String get travelerFlightFetchFailed;

  /// Data source label: simulated locally, no real flight API.
  ///
  /// In ar, this message translates to:
  /// **'محاكاة محلية (بدون API)'**
  String get travelerSourceMock;

  /// Airport city names used by the simulated flight route.
  ///
  /// In ar, this message translates to:
  /// **'الرياض'**
  String get travelerCityRiyadh;

  /// No description provided for @travelerCityJeddah.
  ///
  /// In ar, this message translates to:
  /// **'جدة'**
  String get travelerCityJeddah;

  /// No description provided for @travelerCityDubai.
  ///
  /// In ar, this message translates to:
  /// **'دبي'**
  String get travelerCityDubai;

  /// No description provided for @travelerCityDoha.
  ///
  /// In ar, this message translates to:
  /// **'الدوحة'**
  String get travelerCityDoha;

  /// No description provided for @travelerCityIstanbul.
  ///
  /// In ar, this message translates to:
  /// **'إسطنبول'**
  String get travelerCityIstanbul;

  /// No description provided for @travelerCityCairo.
  ///
  /// In ar, this message translates to:
  /// **'القاهرة'**
  String get travelerCityCairo;

  /// No description provided for @travelerCityKualaLumpur.
  ///
  /// In ar, this message translates to:
  /// **'كوالالمبور'**
  String get travelerCityKualaLumpur;

  /// No description provided for @travelerCityLondon.
  ///
  /// In ar, this message translates to:
  /// **'لندن'**
  String get travelerCityLondon;

  /// No description provided for @travelerCityParis.
  ///
  /// In ar, this message translates to:
  /// **'باريس'**
  String get travelerCityParis;

  /// No description provided for @travelerCityNewYork.
  ///
  /// In ar, this message translates to:
  /// **'نيويورك'**
  String get travelerCityNewYork;

  /// Label followed by the number of remaining flight searches.
  ///
  /// In ar, this message translates to:
  /// **'محاولات متبقّية'**
  String get travelerAttemptsRemaining;

  /// No description provided for @travelerLiveTrack.
  ///
  /// In ar, this message translates to:
  /// **'مسار مباشر'**
  String get travelerLiveTrack;

  /// No description provided for @travelerTakeoff.
  ///
  /// In ar, this message translates to:
  /// **'الإقلاع'**
  String get travelerTakeoff;

  /// No description provided for @travelerLanding.
  ///
  /// In ar, this message translates to:
  /// **'الهبوط'**
  String get travelerLanding;

  /// No description provided for @travelerFlightEnded.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الرحلة — لم تبقَ مواقيت على متنها.'**
  String get travelerFlightEnded;

  /// No description provided for @travelerNoPrayerDuringFlight.
  ///
  /// In ar, this message translates to:
  /// **'لم تقع أي صلاة ضمن مدّة هذه الرحلة.'**
  String get travelerNoPrayerDuringFlight;

  /// No description provided for @travelerAllFlightPrayersPassed.
  ///
  /// In ar, this message translates to:
  /// **'مضت كل مواقيت هذه الرحلة.'**
  String get travelerAllFlightPrayersPassed;

  /// Compact countdown: 'in H h M min'. 'س' = hours, 'د' = minutes (abbreviations).
  ///
  /// In ar, this message translates to:
  /// **'بعد {hours} س و{minutes} د'**
  String travelerCountdownHoursMinutes(int hours, int minutes);

  /// Countdown: 'in N minutes'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{بعد {count} دقيقة}}'**
  String travelerCountdownMinutes(int count);

  /// {prayer} is a prayer name, {countdown} e.g. 'in 2 h 10 min'.
  ///
  /// In ar, this message translates to:
  /// **'{prayer} على متن الرحلة — {countdown}'**
  String travelerNextPrayerAboard(String prayer, String countdown);

  /// No description provided for @travelerFirstPrayerAboard.
  ///
  /// In ar, this message translates to:
  /// **'أوّل صلاة على متن الرحلة: {prayer}'**
  String travelerFirstPrayerAboard(String prayer);

  /// {time} is HH:mm, {offset} the UTC offset like '+3' or '+5:30', in local time below the plane.
  ///
  /// In ar, this message translates to:
  /// **'{time} بتوقيت موضع الطائرة ({offset})'**
  String travelerAtPlaneLocalTime(String time, String offset);

  /// No description provided for @travelerLocalTimeAbovePlane.
  ///
  /// In ar, this message translates to:
  /// **'بالتوقيت المحلي فوق موضع الطائرة'**
  String get travelerLocalTimeAbovePlane;

  /// No description provided for @travelerTapStopHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على أي محطّة لترى موضعها على الخريطة'**
  String get travelerTapStopHint;

  /// No description provided for @travelerUpcoming.
  ///
  /// In ar, this message translates to:
  /// **'قادم'**
  String get travelerUpcoming;

  /// Badge on the next prayer stop of a flight timeline.
  ///
  /// In ar, this message translates to:
  /// **'التالية'**
  String get travelerNext;

  /// {place} is a place/description, {time} is the GMT (UTC) time HH:mm.
  ///
  /// In ar, this message translates to:
  /// **'{place} · جرينتش {time}'**
  String travelerStopGmt(String place, String time);

  /// No description provided for @travelerSearchByFlightNumberHeader.
  ///
  /// In ar, this message translates to:
  /// **'ابحث برقم الرحلة'**
  String get travelerSearchByFlightNumberHeader;

  /// Button that runs the flight search.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل'**
  String get travelerRun;

  /// No description provided for @travelerFlightSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رقم الرحلة لنحسب مواقيت الصلاة على طول المسار.'**
  String get travelerFlightSearchHint;

  /// No description provided for @travelerFlightDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الرحلة'**
  String get travelerFlightDetails;

  /// No description provided for @travelerFlightNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الرحلة'**
  String get travelerFlightNumber;

  /// No description provided for @travelerFrom.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get travelerFrom;

  /// No description provided for @travelerTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get travelerTo;

  /// No description provided for @travelerDataSource.
  ///
  /// In ar, this message translates to:
  /// **'مصدر البيانات'**
  String get travelerDataSource;

  /// No description provided for @travelerFlightTimeline.
  ///
  /// In ar, this message translates to:
  /// **'خطّ زمن الرحلة'**
  String get travelerFlightTimeline;

  /// No description provided for @travelerNoTimesDuringFlight.
  ///
  /// In ar, this message translates to:
  /// **'لم تظهر مواقيت ضمن مدة هذه الرحلة.'**
  String get travelerNoTimesDuringFlight;

  /// No description provided for @travelerFlightNumberExample.
  ///
  /// In ar, this message translates to:
  /// **'مثال: EK202'**
  String get travelerFlightNumberExample;

  /// No description provided for @travelerShowFullRoute.
  ///
  /// In ar, this message translates to:
  /// **'عرض المسار كاملًا'**
  String get travelerShowFullRoute;

  /// No description provided for @travelerZoomIn.
  ///
  /// In ar, this message translates to:
  /// **'تكبير'**
  String get travelerZoomIn;

  /// No description provided for @travelerZoomOut.
  ///
  /// In ar, this message translates to:
  /// **'تصغير'**
  String get travelerZoomOut;

  /// No description provided for @travelerLocationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديد موقعك الحالي. حاول مرة أخرى.'**
  String get travelerLocationFailed;

  /// No description provided for @travelerLocationServiceDisabled.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع غير مفعلة. فعّلها لإظهار النتائج القريبة.'**
  String get travelerLocationServiceDisabled;

  /// No description provided for @travelerLocationPermissionRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب منح صلاحية الموقع حتى تعمل هذه الميزة.'**
  String get travelerLocationPermissionRequired;

  /// No description provided for @travelerLocationPermissionDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض صلاحية الموقع نهائيًا. افتح إعدادات التطبيق.'**
  String get travelerLocationPermissionDeniedForever;

  /// No description provided for @travelerPlacesFetchFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر جلب النتائج القريبة الآن. حاول مجددًا.'**
  String get travelerPlacesFetchFailed;

  /// No description provided for @travelerExpandRadius.
  ///
  /// In ar, this message translates to:
  /// **'وسّع النطاق'**
  String get travelerExpandRadius;

  /// {radius} is a distance like '3 km'. The arrow next to each place points toward it.
  ///
  /// In ar, this message translates to:
  /// **'كلّها ضمن {radius} — والسهم يشير إلى جهة كلٍّ منها.'**
  String travelerAllWithinRadius(String radius);

  /// Label before the search radius chips.
  ///
  /// In ar, this message translates to:
  /// **'النطاق'**
  String get travelerRadius;

  /// No description provided for @travelerNearestPlaces.
  ///
  /// In ar, this message translates to:
  /// **'أقرب الأماكن'**
  String get travelerNearestPlaces;

  /// No description provided for @travelerFoundResults.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{وجدنا {count} نتيجة قربك}}'**
  String travelerFoundResults(int count);

  /// No description provided for @travelerUnexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get travelerUnexpectedError;

  /// No description provided for @travelerHalalRestricted.
  ///
  /// In ar, this message translates to:
  /// **'لا يظهر بحث المطاعم الحلال في الدول الإسلامية،\nلأن مطاعمها حلال أصلًا.'**
  String get travelerHalalRestricted;

  /// No description provided for @travelerOpenMapsFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر فتح تطبيق الخرائط.'**
  String get travelerOpenMapsFailed;

  /// No description provided for @travelerNearestMosque.
  ///
  /// In ar, this message translates to:
  /// **'أقرب مسجد إليك'**
  String get travelerNearestMosque;

  /// No description provided for @travelerNearestRestaurant.
  ///
  /// In ar, this message translates to:
  /// **'أقرب مطعم حلال'**
  String get travelerNearestRestaurant;

  /// No description provided for @travelerTakeMeThere.
  ///
  /// In ar, this message translates to:
  /// **'خذني إليه'**
  String get travelerTakeMeThere;

  /// You will reach the mosque before {prayer}; {count} minutes remain until it.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{تلحق {prayer} — تبقّى {count} دقيقة}}'**
  String travelerWillMakeIt(int count, String prayer);

  /// Walking, you might miss {prayer}; {count} minutes remain until it.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, other{قد لا تلحق {prayer} مشيًا — تبقّى {count} دقيقة}}'**
  String travelerMightMiss(int count, String prayer);

  /// No description provided for @travelerOpenInGoogleMaps.
  ///
  /// In ar, this message translates to:
  /// **'فتح في خرائط جوجل'**
  String get travelerOpenInGoogleMaps;

  /// No description provided for @travelerTapMarkerHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على العلامة لعرض التفاصيل'**
  String get travelerTapMarkerHint;

  /// No description provided for @travelerOpenPhoneFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح تطبيق الاتصال.'**
  String get travelerOpenPhoneFailed;

  /// No description provided for @travelerOpenLinkFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح الرابط.'**
  String get travelerOpenLinkFailed;

  /// Button: get directions to the place.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاه'**
  String get travelerDirections;

  /// No description provided for @travelerGoogleMaps.
  ///
  /// In ar, this message translates to:
  /// **'خرائط جوجل'**
  String get travelerGoogleMaps;

  /// Button: phone the place.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get travelerCall;

  /// No description provided for @travelerUpdating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحديث…'**
  String get travelerUpdating;

  /// No description provided for @travelerResultsCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد النتائج {count}'**
  String travelerResultsCount(int count);

  /// No description provided for @travelerMyCurrentLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي الحالي'**
  String get travelerMyCurrentLocation;

  /// No description provided for @travelerMaps.
  ///
  /// In ar, this message translates to:
  /// **'الخرائط'**
  String get travelerMaps;

  /// No description provided for @travelerMyLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي'**
  String get travelerMyLocation;

  /// Title of the Qibla compass screen.
  ///
  /// In ar, this message translates to:
  /// **'القبلة'**
  String get qiblahTitle;

  /// Tooltip of the refresh button that restarts the Qibla direction detection.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الاتجاه'**
  String get qiblahRefreshTooltip;

  /// Error: the device has no compass/orientation sensor.
  ///
  /// In ar, this message translates to:
  /// **'جهازك لا يدعم استشعار الاتجاه'**
  String get qiblahErrorNoSensor;

  /// No description provided for @qiblahErrorPermissionRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب السماح بالوصول للموقع لتحديد اتجاه القبلة'**
  String get qiblahErrorPermissionRequired;

  /// Generic error on the Qibla screen. {error} is a technical error message.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في تحديد اتجاه القبلة: {error}'**
  String qiblahErrorGeneric(String error);

  /// No description provided for @qiblahErrorLocationServiceOff.
  ///
  /// In ar, this message translates to:
  /// **'خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات'**
  String get qiblahErrorLocationServiceOff;

  /// No description provided for @qiblahErrorPermissionDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض أذونات الموقع نهائياً. يرجى تفعيلها من إعدادات التطبيق'**
  String get qiblahErrorPermissionDeniedForever;

  /// No description provided for @qiblahErrorLocationFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في الحصول على الموقع الحالي'**
  String get qiblahErrorLocationFailed;

  /// Shown instead of a city name when reverse geocoding fails.
  ///
  /// In ar, this message translates to:
  /// **'موقع غير معروف'**
  String get qiblahUnknownLocation;

  /// Compass stream error. {error} is a technical error message.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحديد الاتجاه: {error}'**
  String qiblahErrorDirection(String error);

  /// No description provided for @qiblahErrorStreamFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في بدء تتبع الاتجاه'**
  String get qiblahErrorStreamFailed;

  /// No description provided for @qiblahLocating.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحديد الموقع...'**
  String get qiblahLocating;

  /// Shown when the phone points at the Qibla.
  ///
  /// In ar, this message translates to:
  /// **'أنت متوجّه إلى القبلة'**
  String get qiblahAligned;

  /// Instruction to rotate the phone to the left by {degrees} degrees.
  ///
  /// In ar, this message translates to:
  /// **'استدر يسارًا {degrees}°'**
  String qiblahTurnLeft(int degrees);

  /// Instruction to rotate the phone to the right by {degrees} degrees.
  ///
  /// In ar, this message translates to:
  /// **'استدر يمينًا {degrees}°'**
  String qiblahTurnRight(int degrees);

  /// No description provided for @qiblahLoadingTitle.
  ///
  /// In ar, this message translates to:
  /// **'جارِ تحديد اتجاه القبلة'**
  String get qiblahLoadingTitle;

  /// No description provided for @qiblahLoadingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من تفعيل الموقع والسماح بالأذونات'**
  String get qiblahLoadingSubtitle;

  /// Hint under the direction line when aligned: hold the device still, the arrow is on the Qibla mark.
  ///
  /// In ar, this message translates to:
  /// **'ثبّت الجهاز، السهم على علامة القبلة'**
  String get qiblahHintAligned;

  /// No description provided for @qiblahHintMove.
  ///
  /// In ar, this message translates to:
  /// **'حرّك الجهاز ببطء حتى يصل السهم إلى العلامة'**
  String get qiblahHintMove;

  /// Section header above the compass readings (heading, Qibla angle, location, distance).
  ///
  /// In ar, this message translates to:
  /// **'قراءة البوصلة'**
  String get qiblahReadingsHeader;

  /// No description provided for @qiblahCurrentHeading.
  ///
  /// In ar, this message translates to:
  /// **'اتجاهك الحالي'**
  String get qiblahCurrentHeading;

  /// No description provided for @qiblahAngle.
  ///
  /// In ar, this message translates to:
  /// **'زاوية القبلة'**
  String get qiblahAngle;

  /// No description provided for @qiblahCurrentLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعك الحالي'**
  String get qiblahCurrentLocation;

  /// No description provided for @qiblahDistanceToMecca.
  ///
  /// In ar, this message translates to:
  /// **'المسافة إلى مكة'**
  String get qiblahDistanceToMecca;

  /// Distance in kilometres.
  ///
  /// In ar, this message translates to:
  /// **'{km} كم'**
  String qiblahDistanceKm(int km);

  /// No description provided for @qiblahInstructionsHeader.
  ///
  /// In ar, this message translates to:
  /// **'تعليمات الاستخدام'**
  String get qiblahInstructionsHeader;

  /// Bulleted usage instructions for the Qibla compass, one bullet per line (keep the \n line breaks and bullets).
  ///
  /// In ar, this message translates to:
  /// **'• امسك الهاتف مستويًا أمامك.\n• تحرّك ببطء حتى يلتقي السهم الذهبي بالعلامة العلوية.\n• عند المحاذاة تضيء الحلقة وتشعر باهتزازة خفيفة.\n• أبعد الأجسام المعدنية عن الهاتف.\n• إذا اضطرب المؤشر، حرّك الهاتف على شكل رقم ٨.'**
  String get qiblahInstructions;

  /// Cardinal direction labels painted on the compass dial (N/E/S/W). Keep short.
  ///
  /// In ar, this message translates to:
  /// **'شمال'**
  String get qiblahCompassNorth;

  /// No description provided for @qiblahCompassEast.
  ///
  /// In ar, this message translates to:
  /// **'شرق'**
  String get qiblahCompassEast;

  /// No description provided for @qiblahCompassSouth.
  ///
  /// In ar, this message translates to:
  /// **'جنوب'**
  String get qiblahCompassSouth;

  /// No description provided for @qiblahCompassWest.
  ///
  /// In ar, this message translates to:
  /// **'غرب'**
  String get qiblahCompassWest;

  /// Home section header above the daily prayer tracker and continue-reading row.
  ///
  /// In ar, this message translates to:
  /// **'يومك'**
  String get homeSectionYourDay;

  /// Home section header above a random Quran verse.
  ///
  /// In ar, this message translates to:
  /// **'آية من القرآن'**
  String get homeSectionAyah;

  /// Home section header above the grid of app features.
  ///
  /// In ar, this message translates to:
  /// **'المميزات'**
  String get homeSectionFeatures;

  /// Home section header for the children's section.
  ///
  /// In ar, this message translates to:
  /// **'قسم الأطفال'**
  String get homeSectionKids;

  /// Name of the children's section ('The Young Muslim').
  ///
  /// In ar, this message translates to:
  /// **'المسلم الصغير'**
  String get homeYoungMuslimTitle;

  /// Subtitle of the children's section: stories, manners and adhkar for kids.
  ///
  /// In ar, this message translates to:
  /// **'قصص وآداب وأذكار للطفل'**
  String get homeYoungMuslimSubtitle;

  /// Home banner telling the user an app update is available.
  ///
  /// In ar, this message translates to:
  /// **'يوجد تحديث جديد · الإصدار {version}'**
  String homeUpdateAvailable(String version);

  /// Small button on the update banner.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get homeUpdateAction;

  /// Home row to resume Quran reading where the user stopped.
  ///
  /// In ar, this message translates to:
  /// **'تكملة القراءة'**
  String get homeContinueReading;

  /// Home row to start reading the Quran (no progress yet).
  ///
  /// In ar, this message translates to:
  /// **'ابدأ القراءة'**
  String get homeStartReading;

  /// Last reading position. {surah} is the Arabic surah name (e.g. 'سورة البقرة'), {page} the Mushaf page number.
  ///
  /// In ar, this message translates to:
  /// **'{surah} · صفحة {page}'**
  String homeContinueReadingPosition(String surah, int page);

  /// Subtitle when nothing was read yet: start from Surah Al-Fatiha, page 1.
  ///
  /// In ar, this message translates to:
  /// **'من سورة الفاتحة · صفحة ١'**
  String get homeStartReadingPosition;

  /// Reference under a Quran verse. {surah} is the Arabic surah name, {number} the verse number.
  ///
  /// In ar, this message translates to:
  /// **'{surah} · الآية {number}'**
  String homeAyahReference(String surah, int number);

  /// Verse number when the surah name is unavailable.
  ///
  /// In ar, this message translates to:
  /// **'الآية {number}'**
  String homeAyahNumber(int number);

  /// Button that shows another random verse.
  ///
  /// In ar, this message translates to:
  /// **'آية أخرى'**
  String get homeAnotherAyah;

  /// Button that opens the verse in the Quran reader.
  ///
  /// In ar, this message translates to:
  /// **'اقرأها في المصحف'**
  String get homeReadInMushaf;

  /// Prayer tracker message when all five prayers are marked done ('May Allah accept it').
  ///
  /// In ar, this message translates to:
  /// **'أتممت صلوات اليوم، تقبّل الله'**
  String get homeTrackerComplete;

  /// Prayer tracker hint: mark the prayers you have performed today.
  ///
  /// In ar, this message translates to:
  /// **'علّم ما أدّيته اليوم'**
  String get homeTrackerPrompt;

  /// Prayer tracker counter, e.g. '3 of 5'.
  ///
  /// In ar, this message translates to:
  /// **'{count} من {total}'**
  String homeTrackerProgress(int count, int total);

  /// Streak chip: number of consecutive days all five prayers were marked done. For =1 a bare 'day' is enough.
  ///
  /// In ar, this message translates to:
  /// **'{days, plural, =1{يوم} =2{يومان متتاليان} few{{days} أيام متتالية} many{{days} يومًا متتاليًا} other{{days} يوم متتالٍ}}'**
  String homeTrackerStreak(int days);

  /// Bottom navigation tab: Home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeNavHome;

  /// Bottom navigation tab: Sections/categories.
  ///
  /// In ar, this message translates to:
  /// **'الاقسام'**
  String get homeNavSections;

  /// Two lines: next prayer name and time, then the remaining time (h:mm:ss).
  ///
  /// In ar, this message translates to:
  /// **'  {prayer} : {time}  \n الوقت المتبقي : {remaining} '**
  String homeNextPrayerRemaining(String prayer, String time, String remaining);

  /// High-latitude rule option: automatic (use the calculation method's default).
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get prayerTimeHighLatAuto;

  /// No description provided for @prayerTimeHighLatAutoDesc.
  ///
  /// In ar, this message translates to:
  /// **'يترك المعالجة للقيمة الافتراضية لطريقة الحساب.'**
  String get prayerTimeHighLatAutoDesc;

  /// High-latitude rule: 'Middle of the night' (standard astronomical rule name).
  ///
  /// In ar, this message translates to:
  /// **'منتصف الليل'**
  String get prayerTimeHighLatMiddleOfNight;

  /// No description provided for @prayerTimeHighLatMiddleOfNightDesc.
  ///
  /// In ar, this message translates to:
  /// **'لا يسبق الفجر منتصف الليل ولا يتأخر العشاء عنه.'**
  String get prayerTimeHighLatMiddleOfNightDesc;

  /// High-latitude rule: 'Seventh of the night'.
  ///
  /// In ar, this message translates to:
  /// **'سُبع الليل'**
  String get prayerTimeHighLatSeventhOfNight;

  /// No description provided for @prayerTimeHighLatSeventhOfNightDesc.
  ///
  /// In ar, this message translates to:
  /// **'يعتمد على سُبع الليل الأخير للفجر والأول للعشاء.'**
  String get prayerTimeHighLatSeventhOfNightDesc;

  /// High-latitude rule: 'Twilight angle'.
  ///
  /// In ar, this message translates to:
  /// **'زاوية الشفق'**
  String get prayerTimeHighLatTwilightAngle;

  /// No description provided for @prayerTimeHighLatTwilightAngleDesc.
  ///
  /// In ar, this message translates to:
  /// **'يقسّم الليل حسب زاويتي الفجر والعشاء المختارتين.'**
  String get prayerTimeHighLatTwilightAngleDesc;

  /// Segmented option in the custom method: Isha computed by sun angle.
  ///
  /// In ar, this message translates to:
  /// **'العشاء بزاوية'**
  String get prayerTimeIshaModeAngle;

  /// No description provided for @prayerTimeIshaModeAngleDesc.
  ///
  /// In ar, this message translates to:
  /// **'يُحسب العشاء بزاوية الشمس تحت الأفق.'**
  String get prayerTimeIshaModeAngleDesc;

  /// Segmented option in the custom method: Isha computed as fixed minutes after Maghrib.
  ///
  /// In ar, this message translates to:
  /// **'العشاء بفاصل زمني'**
  String get prayerTimeIshaModeInterval;

  /// No description provided for @prayerTimeIshaModeIntervalDesc.
  ///
  /// In ar, this message translates to:
  /// **'يُحسب العشاء بعدد دقائق ثابت بعد المغرب.'**
  String get prayerTimeIshaModeIntervalDesc;

  /// Prayer calculation method names. Use the name commonly used for these institutions in the target language.
  ///
  /// In ar, this message translates to:
  /// **'أم القرى - مكة المكرمة'**
  String get prayerTimeMethodUmmAlQura;

  /// No description provided for @prayerTimeMethodMuslimWorldLeague.
  ///
  /// In ar, this message translates to:
  /// **'رابطة العالم الإسلامي'**
  String get prayerTimeMethodMuslimWorldLeague;

  /// No description provided for @prayerTimeMethodEgyptian.
  ///
  /// In ar, this message translates to:
  /// **'الهيئة المصرية العامة للمساحة'**
  String get prayerTimeMethodEgyptian;

  /// No description provided for @prayerTimeMethodKarachi.
  ///
  /// In ar, this message translates to:
  /// **'جامعة العلوم الإسلامية - كراتشي'**
  String get prayerTimeMethodKarachi;

  /// No description provided for @prayerTimeMethodDubai.
  ///
  /// In ar, this message translates to:
  /// **'دبي'**
  String get prayerTimeMethodDubai;

  /// No description provided for @prayerTimeMethodQatar.
  ///
  /// In ar, this message translates to:
  /// **'قطر'**
  String get prayerTimeMethodQatar;

  /// No description provided for @prayerTimeMethodKuwait.
  ///
  /// In ar, this message translates to:
  /// **'الكويت'**
  String get prayerTimeMethodKuwait;

  /// No description provided for @prayerTimeMethodSingapore.
  ///
  /// In ar, this message translates to:
  /// **'سنغافورة'**
  String get prayerTimeMethodSingapore;

  /// Turkish Presidency of Religious Affairs (Diyanet).
  ///
  /// In ar, this message translates to:
  /// **'ديانت - تركيا'**
  String get prayerTimeMethodTurkey;

  /// No description provided for @prayerTimeMethodTehran.
  ///
  /// In ar, this message translates to:
  /// **'جامعة طهران للجيوفيزياء'**
  String get prayerTimeMethodTehran;

  /// Moonsighting Committee Worldwide.
  ///
  /// In ar, this message translates to:
  /// **'لجنة رؤية الهلال'**
  String get prayerTimeMethodMoonSighting;

  /// ISNA.
  ///
  /// In ar, this message translates to:
  /// **'الجمعية الإسلامية لأمريكا الشمالية'**
  String get prayerTimeMethodNorthAmerica;

  /// Custom calculation method where the user sets the angles.
  ///
  /// In ar, this message translates to:
  /// **'إعداد مخصص'**
  String get prayerTimeMethodCustom;

  /// Short technical description of a calculation method (sun angles / minutes).
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18.5° والعشاء بعد المغرب بـ 90 دقيقة.'**
  String get prayerTimeMethodUmmAlQuraDesc;

  /// No description provided for @prayerTimeMethodMuslimWorldLeagueDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء 17°.'**
  String get prayerTimeMethodMuslimWorldLeagueDesc;

  /// No description provided for @prayerTimeMethodEgyptianDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 19.5° والعشاء 17.5°.'**
  String get prayerTimeMethodEgyptianDesc;

  /// No description provided for @prayerTimeMethodKarachiDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء 18°.'**
  String get prayerTimeMethodKarachiDesc;

  /// No description provided for @prayerTimeMethodDubaiDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر والعشاء 18.2°.'**
  String get prayerTimeMethodDubaiDesc;

  /// No description provided for @prayerTimeMethodQatarDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء بعد المغرب بـ 90 دقيقة.'**
  String get prayerTimeMethodQatarDesc;

  /// No description provided for @prayerTimeMethodKuwaitDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء 17.5°.'**
  String get prayerTimeMethodKuwaitDesc;

  /// No description provided for @prayerTimeMethodSingaporeDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 20° والعشاء 18°.'**
  String get prayerTimeMethodSingaporeDesc;

  /// No description provided for @prayerTimeMethodTurkeyDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء 17° مع تعديلات ديانت.'**
  String get prayerTimeMethodTurkeyDesc;

  /// No description provided for @prayerTimeMethodTehranDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 17.7° والعشاء 14° والمغرب 4.5°.'**
  String get prayerTimeMethodTehranDesc;

  /// No description provided for @prayerTimeMethodMoonSightingDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 18° والعشاء 18° مع تعديلات موسمية.'**
  String get prayerTimeMethodMoonSightingDesc;

  /// No description provided for @prayerTimeMethodNorthAmericaDesc.
  ///
  /// In ar, this message translates to:
  /// **'الفجر 15° والعشاء 15°.'**
  String get prayerTimeMethodNorthAmericaDesc;

  /// No description provided for @prayerTimeMethodCustomDesc.
  ///
  /// In ar, this message translates to:
  /// **'حدّد زوايا الفجر والعشاء والمغرب بنفسك.'**
  String get prayerTimeMethodCustomDesc;

  /// Asr juristic method: Shafi'i, Maliki and Hanbali (the 'standard' Asr).
  ///
  /// In ar, this message translates to:
  /// **'الشافعي والمالكي والحنبلي'**
  String get prayerTimeMadhabShafi;

  /// Asr juristic method: Hanafi.
  ///
  /// In ar, this message translates to:
  /// **'الحنفي'**
  String get prayerTimeMadhabHanafi;

  /// Asr begins when an object's shadow equals its length.
  ///
  /// In ar, this message translates to:
  /// **'العصر عندما يصير ظل الشيء مثله، وعليه المالكي والحنبلي أيضًا.'**
  String get prayerTimeMadhabShafiDesc;

  /// Asr begins when an object's shadow is twice its length.
  ///
  /// In ar, this message translates to:
  /// **'العصر عندما يصير ظل الشيء مثليه.'**
  String get prayerTimeMadhabHanafiDesc;

  /// Intro text above the prayer calculation settings.
  ///
  /// In ar, this message translates to:
  /// **'اختر التقويم الذي تعتمده جهتك المحلية، وعدّل المواقيت يدويًا إن احتجت مطابقتها مع مسجد الحي.'**
  String get prayerTimeCalcIntro;

  /// Setting label and sheet title: prayer-time calculation method.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الحساب'**
  String get prayerTimeCalcMethod;

  /// Setting label: juristic school used to compute Asr.
  ///
  /// In ar, this message translates to:
  /// **'مذهب حساب العصر'**
  String get prayerTimeCalcAsrMadhab;

  /// Short segmented-button label for the Shafi'i (standard) Asr method.
  ///
  /// In ar, this message translates to:
  /// **'الشافعي'**
  String get prayerTimeMadhabShafiShort;

  /// Setting label and sheet title: high-latitude adjustment rule.
  ///
  /// In ar, this message translates to:
  /// **'خطوط العرض العالية'**
  String get prayerTimeCalcHighLatitude;

  /// Toggle: delay Isha during Ramadan.
  ///
  /// In ar, this message translates to:
  /// **'تأخير العشاء في رمضان'**
  String get prayerTimeCalcRamadanIsha;

  /// Hint of the Ramadan Isha toggle: adds 30 minutes to Isha for the whole month, as the Umm al-Qura calendar does.
  ///
  /// In ar, this message translates to:
  /// **'يضيف ٣٠ دقيقة على العشاء طوال الشهر كما في تقويم أم القرى.'**
  String get prayerTimeCalcRamadanIshaHint;

  /// Link that resets calculation settings to the Umm al-Qura defaults.
  ///
  /// In ar, this message translates to:
  /// **'استعادة إعدادات أم القرى'**
  String get prayerTimeCalcRestoreDefaults;

  /// Group title for the custom-method angles.
  ///
  /// In ar, this message translates to:
  /// **'زوايا الحساب المخصصة'**
  String get prayerTimeCalcCustomAngles;

  /// Stepper label: Fajr sun angle (degrees).
  ///
  /// In ar, this message translates to:
  /// **'زاوية الفجر'**
  String get prayerTimeCalcFajrAngle;

  /// Setting label: how Isha is computed (angle or interval).
  ///
  /// In ar, this message translates to:
  /// **'حساب العشاء'**
  String get prayerTimeCalcIshaMode;

  /// No description provided for @prayerTimeCalcIshaModeHint.
  ///
  /// In ar, this message translates to:
  /// **'إمّا بزاوية الشفق، وإمّا بفاصل ثابت بعد المغرب.'**
  String get prayerTimeCalcIshaModeHint;

  /// Stepper label: Isha sun angle (degrees).
  ///
  /// In ar, this message translates to:
  /// **'زاوية العشاء'**
  String get prayerTimeCalcIshaAngle;

  /// Stepper label: minutes between Maghrib and Isha.
  ///
  /// In ar, this message translates to:
  /// **'العشاء بعد المغرب'**
  String get prayerTimeCalcIshaAfterMaghrib;

  /// Toggle: compute Maghrib by a twilight angle instead of sunset.
  ///
  /// In ar, this message translates to:
  /// **'زاوية المغرب بدل الغروب'**
  String get prayerTimeCalcMaghribAngleToggle;

  /// No description provided for @prayerTimeCalcMaghribAngleToggleHint.
  ///
  /// In ar, this message translates to:
  /// **'لِمن يعتمد زاوية شفق للمغرب بدل لحظة الغروب.'**
  String get prayerTimeCalcMaghribAngleToggleHint;

  /// Stepper label: Maghrib sun angle (degrees).
  ///
  /// In ar, this message translates to:
  /// **'زاوية المغرب'**
  String get prayerTimeCalcMaghribAngle;

  /// Compact minutes value in a stepper, e.g. '+5 min' or '90 min'. {value} may carry a +/- sign. Use the language's short minute abbreviation.
  ///
  /// In ar, this message translates to:
  /// **'{value} د'**
  String prayerTimeMinutesShort(String value);

  /// Zero-minutes value in the manual adjustment stepper (same abbreviation as prayerTimeMinutesShort).
  ///
  /// In ar, this message translates to:
  /// **'٠ د'**
  String get prayerTimeMinutesZero;

  /// Expandable row: manual per-prayer minute adjustments.
  ///
  /// In ar, this message translates to:
  /// **'تعديل يدوي لكل وقت'**
  String get prayerTimeCalcManualAdjust;

  /// Hint: match the times with your local mosque minute by minute.
  ///
  /// In ar, this message translates to:
  /// **'طابق المواقيت مع مسجد الحي دقيقة بدقيقة'**
  String get prayerTimeCalcManualAdjustHint;

  /// How many prayer times have a manual adjustment.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{وقت واحد معدّل يدويًا} =2{وقتان معدّلان يدويًا} few{{count} مواقيت معدّلة يدويًا} other{{count} من المواقيت معدّلة يدويًا}}'**
  String prayerTimeCalcManualAdjustCount(int count);

  /// Generic word 'the prayer', used when the specific prayer is unknown (e.g. in an athan notification title).
  ///
  /// In ar, this message translates to:
  /// **'الصلاة'**
  String get prayerTimeGenericPrayer;

  /// Athan notification title without a time. {prayer} is a prayer name (e.g. 'Dhuhr').
  ///
  /// In ar, this message translates to:
  /// **'أذان {prayer}'**
  String prayerTimeAthanTitle(String prayer);

  /// Athan notification title: prayer name and its time, e.g. 'Dhuhr Athan • 11:48'. Keep the • separator.
  ///
  /// In ar, this message translates to:
  /// **'أذان {prayer} • {time}'**
  String prayerTimeAthanTitleWithTime(String prayer, String time);

  /// One-line athan notification body for Fajr: 'Come to prayer — start your day with the light of dawn.'
  ///
  /// In ar, this message translates to:
  /// **'حيّ على الصلاة — ابدأ يومك بنور الفجر.'**
  String get prayerTimeAthanBodyFajr;

  /// Athan notification body for Dhuhr: 'Make it a rest for the heart.'
  ///
  /// In ar, this message translates to:
  /// **'اجعلها استراحة قلب.'**
  String get prayerTimeAthanBodyDhuhr;

  /// Athan notification body for Asr: 'Renew your presence with Allah.'
  ///
  /// In ar, this message translates to:
  /// **'جدّد حضورك مع الله.'**
  String get prayerTimeAthanBodyAsr;

  /// Athan notification body for Maghrib: 'Close your day with obedience and serenity.'
  ///
  /// In ar, this message translates to:
  /// **'اختم يومك بطاعة وسكينة.'**
  String get prayerTimeAthanBodyMaghrib;

  /// Athan notification body for Isha: 'Don't miss the last prayer of the day.'
  ///
  /// In ar, this message translates to:
  /// **'لا تفوّت ختام الصلوات.'**
  String get prayerTimeAthanBodyIsha;

  /// Athan notification body fallback: 'May Allah accept your worship.'
  ///
  /// In ar, this message translates to:
  /// **'تقبّل الله طاعتك.'**
  String get prayerTimeAthanBodyDefault;

  /// Second line of the expanded athan notification: tap to open the prayer alert and details.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لفتح تنبيه الصلاة والتفاصيل.'**
  String get prayerTimeAthanExpandedHint;

  /// Accessibility/status-bar ticker of the athan notification: 'It is now time for the {prayer} athan'.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن أذان {prayer}'**
  String prayerTimeAthanTicker(String prayer);

  /// Athan alert screen: 'It is now time for prayer', shown above the prayer name.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت الصلاة'**
  String get prayerTimeAlertNow;

  /// Athan alert screen encouragement: 'Pray with humility; it is light for the heart and calm for the soul.'
  ///
  /// In ar, this message translates to:
  /// **'أقم صلاتك بخشوع، فهي نور القلب وسكينة الروح.'**
  String get prayerTimeAlertMessage;

  /// Main button on the athan alert screen: 'I'm ready for prayer' (dismisses the screen).
  ///
  /// In ar, this message translates to:
  /// **'تم الاستعداد للصلاة'**
  String get prayerTimeAlertReady;

  /// Link on the athan alert screen that opens the prayer times page.
  ///
  /// In ar, this message translates to:
  /// **'فتح صفحة أوقات الصلاة'**
  String get prayerTimeAlertOpenTimes;

  /// Title of the prayer times screen.
  ///
  /// In ar, this message translates to:
  /// **'أوقات الصلاة'**
  String get prayerTimeTitle;

  /// Title of the prayer times settings screen (also the settings button tooltip).
  ///
  /// In ar, this message translates to:
  /// **'إعدادات أوقات الصلاة'**
  String get prayerTimeSettingsTitle;

  /// Details sheet row: time of the athan.
  ///
  /// In ar, this message translates to:
  /// **'وقت الأذان'**
  String get prayerTimeSheetAthanTime;

  /// Details sheet row label for Sunrise: time from sunrise until Dhuhr.
  ///
  /// In ar, this message translates to:
  /// **'حتى الظهر'**
  String get prayerTimeSheetUntilDhuhr;

  /// Details sheet row: duration of the prayer's time window (until the next prayer).
  ///
  /// In ar, this message translates to:
  /// **'مدّة النافذة'**
  String get prayerTimeSheetWindow;

  /// Details sheet row: difference compared with the same prayer today.
  ///
  /// In ar, this message translates to:
  /// **'الفارق عن اليوم'**
  String get prayerTimeSheetShift;

  /// Very short weekday names (about 3 letters) for the weekly prayer table header.
  ///
  /// In ar, this message translates to:
  /// **'سبت'**
  String get prayerTimeWeekdaySat;

  /// No description provided for @prayerTimeWeekdaySun.
  ///
  /// In ar, this message translates to:
  /// **'أحد'**
  String get prayerTimeWeekdaySun;

  /// No description provided for @prayerTimeWeekdayMon.
  ///
  /// In ar, this message translates to:
  /// **'إثن'**
  String get prayerTimeWeekdayMon;

  /// No description provided for @prayerTimeWeekdayTue.
  ///
  /// In ar, this message translates to:
  /// **'ثلا'**
  String get prayerTimeWeekdayTue;

  /// No description provided for @prayerTimeWeekdayWed.
  ///
  /// In ar, this message translates to:
  /// **'أرب'**
  String get prayerTimeWeekdayWed;

  /// No description provided for @prayerTimeWeekdayThu.
  ///
  /// In ar, this message translates to:
  /// **'خمي'**
  String get prayerTimeWeekdayThu;

  /// No description provided for @prayerTimeWeekdayFri.
  ///
  /// In ar, this message translates to:
  /// **'جمع'**
  String get prayerTimeWeekdayFri;

  /// Duration shorter than one minute.
  ///
  /// In ar, this message translates to:
  /// **'أقل من دقيقة'**
  String get prayerTimeLessThanMinute;

  /// Compact duration in hours, e.g. '2 h'.
  ///
  /// In ar, this message translates to:
  /// **'{hours} س'**
  String prayerTimeHoursShort(int hours);

  /// Compact duration, e.g. '2 h 15 min'.
  ///
  /// In ar, this message translates to:
  /// **'{hours} س {minutes} د'**
  String prayerTimeHoursMinutesShort(int hours, int minutes);

  /// Shift value when the selected day is today itself.
  ///
  /// In ar, this message translates to:
  /// **'اليوم نفسه'**
  String get prayerTimeShiftSameDay;

  /// Shift value: no difference from today.
  ///
  /// In ar, this message translates to:
  /// **'بلا فارق'**
  String get prayerTimeShiftNone;

  /// The prayer is {minutes} minutes later than today.
  ///
  /// In ar, this message translates to:
  /// **'متأخّر {minutes} د'**
  String prayerTimeShiftLater(int minutes);

  /// The prayer is {minutes} minutes earlier than today.
  ///
  /// In ar, this message translates to:
  /// **'مبكّر {minutes} د'**
  String prayerTimeShiftEarlier(int minutes);

  /// Short AM marker shown after a 12-hour time.
  ///
  /// In ar, this message translates to:
  /// **'ص'**
  String get prayerTimeAm;

  /// Short PM marker shown after a 12-hour time.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get prayerTimePm;

  /// Location source: chosen manually by the user.
  ///
  /// In ar, this message translates to:
  /// **'اختيار يدوي'**
  String get prayerTimeLocationSourceManual;

  /// Location source: the device's GPS location.
  ///
  /// In ar, this message translates to:
  /// **'موقع الجهاز'**
  String get prayerTimeLocationSourceDevice;

  /// Hint when no location is set: choose a city or use the device location.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدينة أو استخدم موقع الجهاز'**
  String get prayerTimeLocationPickHint;

  /// Location subtitle: region/country details followed by the location source.
  ///
  /// In ar, this message translates to:
  /// **'{details} · {source}'**
  String prayerTimeLocationDetails(String details, String source);

  /// No location has been set yet.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تحديد موقع بعد'**
  String get prayerTimeLocationNotSet;

  /// Tooltip of the button that uses the device's current location.
  ///
  /// In ar, this message translates to:
  /// **'موقعي الحالي'**
  String get prayerTimeMyLocation;

  /// Link/button that requests a system permission.
  ///
  /// In ar, this message translates to:
  /// **'منح الصلاحية'**
  String get prayerTimeGrantPermission;

  /// Empty state: set your location to show the weekly table.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك ليظهر جدول الأسبوع'**
  String get prayerTimeEmptyWeekTitle;

  /// No description provided for @prayerTimeEmptyWeekSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مدينتك أو استخدم موقع الجهاز'**
  String get prayerTimeEmptyWeekSubtitle;

  /// Link that opens the location picker.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الموقع'**
  String get prayerTimeSetLocation;

  /// Shown when only one day is available: set a city to see the whole week.
  ///
  /// In ar, this message translates to:
  /// **'حدّد مدينتك لعرض مواقيت الأسبوع كاملًا'**
  String get prayerTimeWeekNeedsCity;

  /// Hint under the weekly table: swipe horizontally for more days; tap a time for details.
  ///
  /// In ar, this message translates to:
  /// **'اسحب الجدول أفقيًا لبقية الأيام · المس أي وقت لتفاصيله'**
  String get prayerTimeWeekHint;

  /// Section header for night-prayer (Qiyam al-Layl) times. {day} is 'Today', 'Tomorrow' or a weekday name.
  ///
  /// In ar, this message translates to:
  /// **'قيام الليل · {day}'**
  String prayerTimeNightPrayerHeader(String day);

  /// Islamic midnight (halfway between Maghrib and Fajr).
  ///
  /// In ar, this message translates to:
  /// **'منتصف الليل'**
  String get prayerTimeMidnight;

  /// No description provided for @prayerTimeMidnightHint.
  ///
  /// In ar, this message translates to:
  /// **'منتصف ما بين المغرب والفجر'**
  String get prayerTimeMidnightHint;

  /// The last third of the night.
  ///
  /// In ar, this message translates to:
  /// **'الثلث الأخير'**
  String get prayerTimeLastThird;

  /// The best time for night prayer and supplication.
  ///
  /// In ar, this message translates to:
  /// **'أفضل أوقات القيام والدعاء'**
  String get prayerTimeLastThirdHint;

  /// Section header: location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get prayerTimeLocationHeader;

  /// Fallback notice when the current location could not be updated.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الموقع الحالي.'**
  String get prayerTimeLocationUpdateFailed;

  /// Today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get prayerTimeToday;

  /// Tomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غدًا'**
  String get prayerTimeTomorrow;

  /// Header of the prayer-name column in the weekly table.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة'**
  String get prayerTimeTablePrayerColumn;

  /// Settings section header: how prayer times are calculated.
  ///
  /// In ar, this message translates to:
  /// **'طريقة حساب المواقيت'**
  String get prayerTimeSettingsCalcHeader;

  /// Settings section header: silent mode during prayer.
  ///
  /// In ar, this message translates to:
  /// **'الصامت وقت الصلاة'**
  String get prayerTimeSettingsSilentHeader;

  /// Snackbar: grant the Do Not Disturb permission first.
  ///
  /// In ar, this message translates to:
  /// **'امنح صلاحية عدم الإزعاج أولًا حتى تعمل الميزة.'**
  String get prayerTimeSilentNeedsPermission;

  /// Snackbar after saving prayer time settings.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ إعدادات أوقات الصلاة.'**
  String get prayerTimeSettingsSaved;

  /// Explains the auto-silent feature: phone goes silent at prayer time, then sound is restored automatically.
  ///
  /// In ar, this message translates to:
  /// **'يحوّل الجهاز إلى صامت مع وقت الصلاة ثم يعيد الصوت تلقائيًا.'**
  String get prayerTimeSilentHint;

  /// Toggle: enable automatic silent mode.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الصامت تلقائيًا'**
  String get prayerTimeSilentEnable;

  /// Note: the feature needs the system 'Do Not Disturb' access permission.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج الميزة صلاحية «عدم الإزعاج» من النظام.'**
  String get prayerTimeSilentPermissionNote;

  /// Label: how long the phone stays silent after the prayer time.
  ///
  /// In ar, this message translates to:
  /// **'مدة الصامت بعد الصلاة'**
  String get prayerTimeSilentDuration;

  /// Short 'min' suffix after a minutes input field.
  ///
  /// In ar, this message translates to:
  /// **'د'**
  String get prayerTimeMinutesSuffix;

  /// Save button while saving.
  ///
  /// In ar, this message translates to:
  /// **'جارِ الحفظ'**
  String get prayerTimeSaving;

  /// Save settings button.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإعدادات'**
  String get prayerTimeSaveSettings;

  /// Fallback name of the user's saved location when no place name was stored.
  ///
  /// In ar, this message translates to:
  /// **'الموقع المحفوظ'**
  String get prayerTimeSavedLocation;

  /// Fallback name for a point picked on the map when no place name is found.
  ///
  /// In ar, this message translates to:
  /// **'موقع محدد على الخريطة'**
  String get prayerTimePickerMapPointLabel;

  /// Map picker: looking up the name of the tapped point.
  ///
  /// In ar, this message translates to:
  /// **'جارِ قراءة اسم الموقع المحدد...'**
  String get prayerTimePickerResolving;

  /// Map picker hint: tap the map to set the area.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على الخريطة لتحديد المنطقة'**
  String get prayerTimePickerTapMap;

  /// Title of the location picker sheet.
  ///
  /// In ar, this message translates to:
  /// **'اختيار المنطقة'**
  String get prayerTimePickerTitle;

  /// Subtitle of the location picker: search, or pick a point on the map.
  ///
  /// In ar, this message translates to:
  /// **'ابحث أو حدّد نقطة من الخريطة'**
  String get prayerTimePickerSubtitle;

  /// Button while the device location is being fetched.
  ///
  /// In ar, this message translates to:
  /// **'جارِ استخدام موقع الجهاز...'**
  String get prayerTimePickerUsingDevice;

  /// Button: use the device's current location.
  ///
  /// In ar, this message translates to:
  /// **'استخدام موقع الجهاز الحالي'**
  String get prayerTimePickerUseDevice;

  /// Tab label: map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get prayerTimePickerMapTab;

  /// Search field hint: city or country name.
  ///
  /// In ar, this message translates to:
  /// **'اسم المدينة أو الدولة'**
  String get prayerTimePickerSearchHint;

  /// No matching search results.
  ///
  /// In ar, this message translates to:
  /// **'لم نعثر على نتائج مطابقة'**
  String get prayerTimePickerNoResults;

  /// Empty search state: start typing a city name.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بكتابة اسم المدينة'**
  String get prayerTimePickerStartTyping;

  /// Map picker footer hint when nothing is selected yet.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على الخريطة لاختيار المنطقة'**
  String get prayerTimePickerTapMapToChoose;

  /// Apply button while applying the chosen location.
  ///
  /// In ar, this message translates to:
  /// **'جارِ الاعتماد'**
  String get prayerTimePickerApplying;

  /// Button that confirms the chosen location.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد'**
  String get prayerTimePickerApply;

  /// Shows the current prayer, e.g. 'Current: Asr'.
  ///
  /// In ar, this message translates to:
  /// **'الحالية {prayer}'**
  String prayerTimeCurrentLabel(String prayer);

  /// Shows the next prayer, e.g. 'Next: Maghrib'.
  ///
  /// In ar, this message translates to:
  /// **'القادمة {prayer}'**
  String prayerTimeNextLabel(String prayer);

  /// Button that turns on the device location service.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الموقع'**
  String get prayerTimeEnableLocation;

  /// Empty state: prayer times cannot be shown before an area is set.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن عرض مواقيت الصلاة قبل تحديد المنطقة'**
  String get prayerTimeTimelineEmptyTitle;

  /// No description provided for @prayerTimeTimelineEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر مدينة يدويًا أو استخدم موقع الجهاز الحالي'**
  String get prayerTimeTimelineEmptySubtitle;

  /// Link that opens the area picker.
  ///
  /// In ar, this message translates to:
  /// **'اختيار منطقة'**
  String get prayerTimeTimelineChooseArea;

  /// Badge on the prayer whose time is now (current prayer).
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get prayerTimeNow;

  /// Badge on the next prayer ('Next'). Feminine in Arabic because 'prayer' is feminine.
  ///
  /// In ar, this message translates to:
  /// **'التالية'**
  String get prayerTimeNextBadge;

  /// Row subtitle: the upcoming prayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get prayerTimeRowNext;

  /// Row subtitle: this prayer's time has passed.
  ///
  /// In ar, this message translates to:
  /// **'انتهى وقتها'**
  String get prayerTimeRowCompleted;

  /// Row subtitle: local time.
  ///
  /// In ar, this message translates to:
  /// **'الوقت المحلي'**
  String get prayerTimeRowLocalTime;

  /// Placeholder while prayer times load.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المواقيت'**
  String get prayerTimeLoadingTimes;

  /// Placeholder while the location is being determined.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحديد الموقع'**
  String get prayerTimeLocatingShort;

  /// Notice when prayer times are unavailable: enable location or grant permission.
  ///
  /// In ar, this message translates to:
  /// **'فعّل الموقع أو امنح الصلاحية لعرض مواقيت الصلاة بدقة.'**
  String get prayerTimeNoticeUnavailable;

  /// Location service is off; times use the last saved location.
  ///
  /// In ar, this message translates to:
  /// **'الأوقات الحالية تستخدم آخر موقع محفوظ. فعّل الموقع لتحديثها تلقائيًا.'**
  String get prayerTimeNoticeServiceOffSaved;

  /// No description provided for @prayerTimeNoticeServiceOff.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع غير مفعلة. فعّلها لعرض مواقيت الصلاة حسب موقعك الحالي.'**
  String get prayerTimeNoticeServiceOff;

  /// Location permission denied; times use the last saved location.
  ///
  /// In ar, this message translates to:
  /// **'الأوقات الحالية تستخدم آخر موقع محفوظ. اسمح بالوصول للموقع لتحديثها الآن.'**
  String get prayerTimeNoticePermissionDeniedSaved;

  /// No description provided for @prayerTimeNoticePermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الموقع غير ممنوحة. اسمح بها لعرض المواقيت حسب موقعك الحالي.'**
  String get prayerTimeNoticePermissionDenied;

  /// Location permission permanently denied; times use the last saved location.
  ///
  /// In ar, this message translates to:
  /// **'الأوقات الحالية تستخدم آخر موقع محفوظ. افتح الإعدادات لإعادة تفعيل صلاحية الموقع.'**
  String get prayerTimeNoticeDeniedForeverSaved;

  /// No description provided for @prayerTimeNoticeDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات وفعّلها لعرض المواقيت بدقة.'**
  String get prayerTimeNoticeDeniedForever;

  /// Location update failed; the last saved location is used.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الموقع الآن، لذلك يتم استخدام آخر موقع محفوظ للمستخدم.'**
  String get prayerTimeNoticeErrorSaved;

  /// No description provided for @prayerTimeNoticeError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديد الموقع حاليًا. فعّل الموقع أو اسمح بالصلاحية لإظهار المواقيت.'**
  String get prayerTimeNoticeError;

  /// Button that opens the system app settings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get prayerTimeOpenSettings;

  /// Countdown line when the prayer time has arrived.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت {prayer}'**
  String prayerTimeCountdownNow(String prayer);

  /// Countdown: prayer in less than a minute.
  ///
  /// In ar, this message translates to:
  /// **'{prayer} بعد أقل من دقيقة'**
  String prayerTimeCountdownUnderMinute(String prayer);

  /// Countdown: prayer in N minutes (1-59).
  ///
  /// In ar, this message translates to:
  /// **'{prayer} بعد {minutes, plural, =1{دقيقة واحدة} =2{دقيقتين} few{{minutes} دقائق} other{{minutes} دقيقة}}'**
  String prayerTimeCountdownMinutes(String prayer, int minutes);

  /// Countdown: prayer in N whole hours.
  ///
  /// In ar, this message translates to:
  /// **'{prayer} بعد {hours, plural, =1{ساعة} =2{ساعتين} few{{hours} ساعات} other{{hours} ساعة}}'**
  String prayerTimeCountdownHours(String prayer, int hours);

  /// Countdown: prayer in H hours M minutes, compact ('h'/'min' abbreviations).
  ///
  /// In ar, this message translates to:
  /// **'{prayer} بعد {hours} س {minutes} د'**
  String prayerTimeCountdownHoursMinutes(String prayer, int hours, int minutes);

  /// Short remaining-time label when the time has come.
  ///
  /// In ar, this message translates to:
  /// **'حان الوقت'**
  String get prayerTimeRemainingNow;

  /// Short remaining time, e.g. '45 min left'.
  ///
  /// In ar, this message translates to:
  /// **'بقي {minutes} د'**
  String prayerTimeRemainingMinutes(int minutes);

  /// Short remaining time, e.g. '2 h left'.
  ///
  /// In ar, this message translates to:
  /// **'بقي {hours} س'**
  String prayerTimeRemainingHours(int hours);

  /// Short remaining time, e.g. '2 h 5 min left'.
  ///
  /// In ar, this message translates to:
  /// **'بقي {hours} س {minutes} د'**
  String prayerTimeRemainingHoursMinutes(int hours, int minutes);

  /// Fallback location label: 'Current location'.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الحالي'**
  String get prayerTimeCurrentLocationFallback;

  /// Label above the current prayer name on the home sky panel: 'You are now in the time of'. Followed by the prayer name on the next line.
  ///
  /// In ar, this message translates to:
  /// **'أنت الآن في وقت'**
  String get prayerTimeYouAreInTime;

  /// Hijri date followed by the note that the calendar is Umm al-Qura.
  ///
  /// In ar, this message translates to:
  /// **'{hijri} · توقيت أم القرى'**
  String prayerTimeBoardHijriLine(String hijri);

  /// Link that opens all prayer times.
  ///
  /// In ar, this message translates to:
  /// **'كل المواقيت'**
  String get prayerTimeAllTimes;

  /// Tooltip: mute the athan for this prayer.
  ///
  /// In ar, this message translates to:
  /// **'كتم أذان هذه الصلاة'**
  String get prayerTimeMuteAthan;

  /// Tooltip: turn on the athan for this prayer.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل أذان هذه الصلاة'**
  String get prayerTimeUnmuteAthan;

  /// Quick action: the Quran (Mushaf).
  ///
  /// In ar, this message translates to:
  /// **'المصحف'**
  String get prayerTimeQuickMushaf;

  /// Quick action: prayer times.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت الصلاة'**
  String get prayerTimeQuickPrayerTimes;

  /// Quick action: the adhkar library.
  ///
  /// In ar, this message translates to:
  /// **'مكتبة الأذكار'**
  String get prayerTimeQuickAdhkar;

  /// Location/status notice: prayer times could not be loaded.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل مواقيت الصلاة حاليًا'**
  String get prayerTimeErrorLoad;

  /// Notice: the selected area could not be applied.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث المنطقة المختارة'**
  String get prayerTimeErrorUpdateArea;

  /// Notice: prayer times could not be recalculated with the new settings.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث المواقيت بالإعدادات الجديدة'**
  String get prayerTimeErrorApplySettings;

  /// Notice: location service is off; enable it or pick a city manually.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع غير مفعلة. فعّلها أو اختر مدينة يدويًا.'**
  String get prayerTimeErrorServiceOff;

  /// Notice: location permission is needed, or pick a city manually.
  ///
  /// In ar, this message translates to:
  /// **'يلزم منح صلاحية الموقع أو اختيار مدينة يدويًا.'**
  String get prayerTimeErrorPermission;

  /// Notice: location permission permanently denied; open settings or pick a city.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الموقع مرفوضة نهائيًا. افتح الإعدادات أو اختر مدينة.'**
  String get prayerTimeErrorDeniedForever;

  /// Notice: the device location could not be determined.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديد موقع الجهاز حاليًا'**
  String get prayerTimeErrorDeviceLocation;

  /// Toast: the system 'add widget' dialog could not be opened; add it manually from the home screen.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر فتح نافذة الإضافة. أضفها يدويًا من الشاشة الرئيسية.'**
  String get homeWidgetsPinFailed;

  /// Toast after refreshing the home-screen widgets.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الودجات'**
  String get homeWidgetsSyncSuccess;

  /// Toast: widget refresh failed; make sure a location is set.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحديث. تأكّد من تحديد موقعك.'**
  String get homeWidgetsSyncFailed;

  /// Tooltip of the button that pins a widget to the home screen.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى الشاشة الرئيسية'**
  String get homeWidgetsAddTooltip;

  /// Title of the home-screen widgets page. Use the platform's usual word for 'widgets'.
  ///
  /// In ar, this message translates to:
  /// **'ودجات الشاشة الرئيسية'**
  String get homeWidgetsTitle;

  /// Group title: how to add a widget.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الإضافة'**
  String get homeWidgetsHowToHeader;

  /// Android instructions for adding a widget. «التطبيقات المصغّرة» is Android's 'Widgets' menu — use the name Android shows in the target language. {appName} is the app name.
  ///
  /// In ar, this message translates to:
  /// **'اضغط زر الإضافة بجانب الودجت، أو اضغط مطوّلًا على مساحة فارغة في الشاشة الرئيسية ثم «التطبيقات المصغّرة» وابحث عن «{appName}».'**
  String homeWidgetsHowToAndroid(String appName);

  /// iOS instructions for adding a widget. {appName} is the app name.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مطوّلًا على مساحة فارغة في الشاشة الرئيسية، ثم زر «+» أعلى الشاشة، وابحث عن «{appName}». ودجت الصلاة القادمة متاحة أيضًا لشاشة القفل.'**
  String homeWidgetsHowToIos(String appName);

  /// Group title listing the available widgets.
  ///
  /// In ar, this message translates to:
  /// **'الودجات'**
  String get homeWidgetsListHeader;

  /// Widget name: Next prayer.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get homeWidgetsNextPrayerTitle;

  /// Android: prayer name and time with a live countdown.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصلاة ووقتها مع عدّ تنازلي حيّ'**
  String get homeWidgetsNextPrayerSubtitleAndroid;

  /// iOS: small size, plus the lock screen in three styles.
  ///
  /// In ar, this message translates to:
  /// **'صغيرة · وشاشة القفل بثلاثة أشكال'**
  String get homeWidgetsNextPrayerSubtitleIos;

  /// Widget name: Today's prayer times.
  ///
  /// In ar, this message translates to:
  /// **'مواقيت اليوم'**
  String get homeWidgetsTodayTimesTitle;

  /// The six prayer times with the Hijri date and city.
  ///
  /// In ar, this message translates to:
  /// **'الصلوات الستّ مع التاريخ الهجري والمدينة'**
  String get homeWidgetsTodayTimesSubtitle;

  /// Widget name: Verse of the day.
  ///
  /// In ar, this message translates to:
  /// **'آية اليوم'**
  String get homeWidgetsDailyAyahTitle;

  /// A short Quran verse that changes every day.
  ///
  /// In ar, this message translates to:
  /// **'آية قصيرة تتجدّد كل يوم'**
  String get homeWidgetsDailyAyahSubtitle;

  /// Group title: sync.
  ///
  /// In ar, this message translates to:
  /// **'المزامنة'**
  String get homeWidgetsSyncHeader;

  /// Row: refresh the widgets now.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الودجات الآن'**
  String get homeWidgetsSyncNow;

  /// Refresh row subtitle: computes prayer times for {days} days with your current location and settings.
  ///
  /// In ar, this message translates to:
  /// **'يحسب مواقيت {days, plural, =1{يومًا واحدًا} =2{يومين} few{{days} أيام} many{{days} يومًا} other{{days} يوم}} بموقعك وإعداداتك الحالية'**
  String homeWidgetsSyncSubtitle(int days);

  /// Hint: widgets keep working for {days} days without opening the app and refresh automatically in the background; they update when location or calculation method changes.
  ///
  /// In ar, this message translates to:
  /// **'الودجات تعمل {days, plural, =1{يومًا واحدًا} =2{يومين} few{{days} أيام} many{{days} يومًا} other{{days} يوم}} دون فتح التطبيق، وتتجدّد تلقائيًا في الخلفية. تتحدّث وحدها عند تغيير موقعك أو طريقة الحساب.'**
  String homeWidgetsSyncHint(int days);

  /// The developer's personal name (Moatasem Alhilali). Transliterate for Latin-script languages.
  ///
  /// In ar, this message translates to:
  /// **'معتصم الهلالي'**
  String get settingsDeveloperName;

  /// No description provided for @settingsUpdateStarting.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ بدء تحديث التطبيق...'**
  String get settingsUpdateStarting;

  /// No description provided for @settingsUpdateUpToDate.
  ///
  /// In ar, this message translates to:
  /// **'أنت تستخدم أحدث إصدار من التطبيق.'**
  String get settingsUpdateUpToDate;

  /// No description provided for @settingsUpdateCheckFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحقق من التحديثات، حاول لاحقاً.'**
  String get settingsUpdateCheckFailed;

  /// No description provided for @settingsGroupPreferences.
  ///
  /// In ar, this message translates to:
  /// **'التفضيلات'**
  String get settingsGroupPreferences;

  /// No description provided for @settingsDarkModeTitle.
  ///
  /// In ar, this message translates to:
  /// **'النمط الداكن'**
  String get settingsDarkModeTitle;

  /// Subtitle under a switch row when the option is enabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعل'**
  String get settingsStatusOn;

  /// Subtitle under a switch row when the option is disabled.
  ///
  /// In ar, this message translates to:
  /// **'معطل'**
  String get settingsStatusOff;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الإشعارات'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحكّم بكل تنبيه يصلك من التطبيق'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsDownloadsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التنزيل'**
  String get settingsDownloadsTitle;

  /// No description provided for @settingsDownloadsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الملفات المحمّلة والمساحة'**
  String get settingsDownloadsSubtitle;

  /// No description provided for @settingsGroupApp.
  ///
  /// In ar, this message translates to:
  /// **'التطبيق'**
  String get settingsGroupApp;

  /// No description provided for @settingsCheckUpdatesTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من التحديثات'**
  String get settingsCheckUpdatesTitle;

  /// No description provided for @settingsCheckUpdatesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من أنك تستخدم أحدث إصدار'**
  String get settingsCheckUpdatesSubtitle;

  /// No description provided for @settingsAboutUsTitle.
  ///
  /// In ar, this message translates to:
  /// **'من نحن'**
  String get settingsAboutUsTitle;

  /// No description provided for @settingsAboutUsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تعرف على تطبيق طمأنينة ورسالته'**
  String get settingsAboutUsSubtitle;

  /// No description provided for @settingsRateAppTitle.
  ///
  /// In ar, this message translates to:
  /// **'قيّم التطبيق'**
  String get settingsRateAppTitle;

  /// No description provided for @settingsRateAppSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ساهم في نشر الخير بتقييمك على المتجر'**
  String get settingsRateAppSubtitle;

  /// No description provided for @settingsGroupPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والأمان'**
  String get settingsGroupPrivacy;

  /// No description provided for @settingsPrivacyPolicyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get settingsPrivacyPolicyTitle;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف يتعامل التطبيق مع بياناتك وصلاحياتك'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsDataSafetyTitle.
  ///
  /// In ar, this message translates to:
  /// **'أمان البيانات'**
  String get settingsDataSafetyTitle;

  /// No description provided for @settingsDataSafetySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص البيانات والصلاحيات وطريقة استخدامها'**
  String get settingsDataSafetySubtitle;

  /// No description provided for @settingsGroupDeveloper.
  ///
  /// In ar, this message translates to:
  /// **'المطوّر'**
  String get settingsGroupDeveloper;

  /// No description provided for @settingsAboutDeveloperTitle.
  ///
  /// In ar, this message translates to:
  /// **'حول المطور'**
  String get settingsAboutDeveloperTitle;

  /// No description provided for @settingsAboutDeveloperSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات وروابط التواصل الخاصة بالمطور'**
  String get settingsAboutDeveloperSubtitle;

  /// No description provided for @settingsDeveloperContactSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مباشر عبر الموقع أو واتس اب'**
  String get settingsDeveloperContactSubtitle;

  /// No description provided for @settingsPersonalWebsite.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الشخصي'**
  String get settingsPersonalWebsite;

  /// No description provided for @settingsGroupFollowNews.
  ///
  /// In ar, this message translates to:
  /// **'تابع آخر الأخبار'**
  String get settingsGroupFollowNews;

  /// Social network names shown under icon tiles (Telegram, WhatsApp, Facebook, Instagram, Twitter/X). Use the usual local spelling.
  ///
  /// In ar, this message translates to:
  /// **'تليجرام'**
  String get settingsSocialTelegram;

  /// No description provided for @settingsSocialWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتس اب'**
  String get settingsSocialWhatsapp;

  /// No description provided for @settingsSocialFacebook.
  ///
  /// In ar, this message translates to:
  /// **'فيسبوك'**
  String get settingsSocialFacebook;

  /// No description provided for @settingsSocialInstagram.
  ///
  /// In ar, this message translates to:
  /// **'انستجرام'**
  String get settingsSocialInstagram;

  /// No description provided for @settingsSocialTwitter.
  ///
  /// In ar, this message translates to:
  /// **'تويتر'**
  String get settingsSocialTwitter;

  /// No description provided for @settingsPrivacyIntro.
  ///
  /// In ar, this message translates to:
  /// **'معلومات واضحة ومختصرة حول طريقة تعامل التطبيق مع بياناتك.'**
  String get settingsPrivacyIntro;

  /// No description provided for @settingsPrivacyMattersTitle.
  ///
  /// In ar, this message translates to:
  /// **'خصوصيتك تهمنا'**
  String get settingsPrivacyMattersTitle;

  /// No description provided for @settingsPrivacyMattersBody.
  ///
  /// In ar, this message translates to:
  /// **'نحرص في طمأنينة على أن تكون تجربة استخدام التطبيق واضحة وآمنة. نستخدم البيانات الضرورية فقط لتشغيل مزايا التطبيق وتحسينها، ولا نبيع بيانات المستخدمين أو نشاركها لأغراض إعلانية.'**
  String get settingsPrivacyMattersBody;

  /// No description provided for @settingsPrivacyDataUsedTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات التي قد يستخدمها التطبيق'**
  String get settingsPrivacyDataUsedTitle;

  /// No description provided for @settingsPrivacyDataUsedBody.
  ///
  /// In ar, this message translates to:
  /// **'قد يستخدم التطبيق الموقع لحساب أوقات الصلاة والقبلة، والإشعارات لتنبيهات الأذان والأذكار، وبيانات التخزين لحفظ المحتوى المحمل والإعدادات المحلية، وجهات الاتصال فقط في الميزات التي يفعّلها المستخدم مثل صحبة الفجر.'**
  String get settingsPrivacyDataUsedBody;

  /// No description provided for @settingsPrivacyControlTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحكم ببياناتك'**
  String get settingsPrivacyControlTitle;

  /// No description provided for @settingsPrivacyControlBody.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تعطيل الإشعارات أو تعديلها من إعدادات الإشعارات داخل التطبيق، ويمكنك إدارة صلاحيات النظام من إعدادات جهازك في أي وقت.'**
  String get settingsPrivacyControlBody;

  /// No description provided for @settingsPrivacyThirdPartyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات الخارجية'**
  String get settingsPrivacyThirdPartyTitle;

  /// Keep product names 'Firebase Remote Config' and 'Firebase Messaging' in Latin script.
  ///
  /// In ar, this message translates to:
  /// **'قد يستخدم التطبيق خدمات مثل Firebase Remote Config وFirebase Messaging لتحديث الإعدادات وإرسال التنبيهات العامة. يتم استخدام هذه الخدمات لتشغيل التطبيق وتحسين التجربة فقط.'**
  String get settingsPrivacyThirdPartyBody;

  /// No description provided for @settingsDataSafetyIntro.
  ///
  /// In ar, this message translates to:
  /// **'ملخص للبيانات التي يستخدمها التطبيق وكيف تُحفظ وتُشارك.'**
  String get settingsDataSafetyIntro;

  /// No description provided for @settingsDataSafetySensitiveTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الحساسة'**
  String get settingsDataSafetySensitiveTitle;

  /// No description provided for @settingsDataSafetySensitiveBody.
  ///
  /// In ar, this message translates to:
  /// **'لا يطلب التطبيق بيانات حساسة إلا عند الحاجة لميزة واضحة يختارها المستخدم. بعض البيانات مثل أوقات التنبيه، التفضيلات، وخطط القراءة تُحفظ محليًا على الجهاز.'**
  String get settingsDataSafetySensitiveBody;

  /// No description provided for @settingsDataSafetyLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get settingsDataSafetyLocationTitle;

  /// No description provided for @settingsDataSafetyLocationBody.
  ///
  /// In ar, this message translates to:
  /// **'يُستخدم الموقع لحساب مواقيت الصلاة، اتجاه القبلة، والخدمات المعتمدة على المكان. يمكن للمستخدم إيقاف صلاحية الموقع من إعدادات النظام.'**
  String get settingsDataSafetyLocationBody;

  /// No description provided for @settingsDataSafetyNotificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get settingsDataSafetyNotificationsTitle;

  /// No description provided for @settingsDataSafetyNotificationsBody.
  ///
  /// In ar, this message translates to:
  /// **'يستخدم التطبيق الإشعارات للأذان، الأذكار، التذكيرات، وبعض رسائل التطبيق العامة. يمكن التحكم بكل نوع إشعار من صفحة إعدادات الإشعارات.'**
  String get settingsDataSafetyNotificationsBody;

  /// No description provided for @settingsDataSafetyStorageTitle.
  ///
  /// In ar, this message translates to:
  /// **'التخزين والتحميل'**
  String get settingsDataSafetyStorageTitle;

  /// No description provided for @settingsDataSafetyStorageBody.
  ///
  /// In ar, this message translates to:
  /// **'قد يستخدم التطبيق التخزين لحفظ الملفات والمحتوى الذي يختار المستخدم تحميله، مثل الصوتيات أو المواد المتاحة داخل التطبيق.'**
  String get settingsDataSafetyStorageBody;

  /// No description provided for @settingsDataSafetySharingTitle.
  ///
  /// In ar, this message translates to:
  /// **'المشاركة'**
  String get settingsDataSafetySharingTitle;

  /// No description provided for @settingsDataSafetySharingBody.
  ///
  /// In ar, this message translates to:
  /// **'لا تتم مشاركة بياناتك الشخصية مع أطراف خارجية للبيع أو التسويق. أي مشاركة تتم تكون ضمن خدمات تشغيل ضرورية أو إجراء يبدأه المستخدم.'**
  String get settingsDataSafetySharingBody;

  /// No description provided for @settingsAboutAppBody.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق قرآني وعبادي يساعدك على الصلاة، الذكر، تلاوة القرآن، والاستمرار على ورد يومي بهدوء وبأسلوب قريب من المستخدم.'**
  String get settingsAboutAppBody;

  /// No description provided for @settingsAboutMissionTitle.
  ///
  /// In ar, this message translates to:
  /// **'رسالتنا'**
  String get settingsAboutMissionTitle;

  /// No description provided for @settingsAboutMissionBody.
  ///
  /// In ar, this message translates to:
  /// **'أن يكون التطبيق رفيقًا خفيفًا يعين المستخدم على الطاعة دون إزعاج، ويجمع الأدوات اليومية المهمة مثل المصحف، الأذكار، مواقيت الصلاة، التنبيهات، والميزات المساعدة للأسرة.'**
  String get settingsAboutMissionBody;

  /// No description provided for @settingsAboutOfferTitle.
  ///
  /// In ar, this message translates to:
  /// **'ما نقدمه'**
  String get settingsAboutOfferTitle;

  /// No description provided for @settingsAboutOfferBody.
  ///
  /// In ar, this message translates to:
  /// **'مصحف، أذكار، مواقيت صلاة، قبلة، ورد يومي، تطبيقات مصغرة، صحبة الفجر، المسلم الصغير، خدمات للمسافر، وتنبيهات قابلة للتخصيص حسب حاجة المستخدم.'**
  String get settingsAboutOfferBody;

  /// No description provided for @settingsDeveloperHeroBody.
  ///
  /// In ar, this message translates to:
  /// **'مهندس برمجيات Full Stack وMobile بخبرة تتجاوز 7 سنوات، متخصص في Flutter وLaravel وNext.js وبناء تطبيقات إنتاجية للويب والجوال.'**
  String get settingsDeveloperHeroBody;

  /// No description provided for @settingsDeveloperBioTitle.
  ///
  /// In ar, this message translates to:
  /// **'نبذة مختصرة'**
  String get settingsDeveloperBioTitle;

  /// No description provided for @settingsDeveloperBioBody.
  ///
  /// In ar, this message translates to:
  /// **'يعمل معتصم الهلالي على بناء تطبيقات ومنصات رقمية تخدم مستخدمين حقيقيين، مع اهتمام خاص بتطبيقات الجوال، الأنظمة الخلفية، واجهات الاستخدام، ومنصات Fintech وSaaS.'**
  String get settingsDeveloperBioBody;

  /// No description provided for @settingsDeveloperFieldsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مجالات العمل'**
  String get settingsDeveloperFieldsTitle;

  /// Comma-separated list of technologies; keep technology names (Flutter, Laravel, Next.js, React, API, Fintech, SaaS) in Latin script.
  ///
  /// In ar, this message translates to:
  /// **'Flutter، Laravel، Next.js، React، API Development، تطبيقات الجوال، تطبيقات الويب، حلول Fintech، ومنصات SaaS.'**
  String get settingsDeveloperFieldsBody;

  /// No description provided for @settingsDeveloperContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'طرق التواصل'**
  String get settingsDeveloperContactTitle;

  /// Short tile label for the developer's website link.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get settingsContactWebsite;

  /// No description provided for @settingsContactEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد'**
  String get settingsContactEmail;

  /// No description provided for @settingsAppLinksTitle.
  ///
  /// In ar, this message translates to:
  /// **'روابط التطبيق'**
  String get settingsAppLinksTitle;

  /// No description provided for @notifSettingsLabelAppNotifications.
  ///
  /// In ar, this message translates to:
  /// **'اشعارات التطبيق'**
  String get notifSettingsLabelAppNotifications;

  /// No description provided for @notifSettingsLabelAllAthan.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات جميع الأذان'**
  String get notifSettingsLabelAllAthan;

  /// Name of the call-to-prayer (adhan) notification for one prayer, e.g. 'Fajr adhan'. Used as a notification title.
  ///
  /// In ar, this message translates to:
  /// **'أذان {prayer}'**
  String notifSettingsAthanOf(String prayer);

  /// No description provided for @notifSettingsLabelMiddleNight.
  ///
  /// In ar, this message translates to:
  /// **'قيام الليل'**
  String get notifSettingsLabelMiddleNight;

  /// No description provided for @notifSettingsLabelThikrMorning.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصباح'**
  String get notifSettingsLabelThikrMorning;

  /// No description provided for @notifSettingsLabelThikrEvening.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المساء'**
  String get notifSettingsLabelThikrEvening;

  /// No description provided for @notifSettingsLabelThikrWakeUp.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الاستيقاظ'**
  String get notifSettingsLabelThikrWakeUp;

  /// No description provided for @notifSettingsLabelThikrSleep.
  ///
  /// In ar, this message translates to:
  /// **'أذكار النوم'**
  String get notifSettingsLabelThikrSleep;

  /// Reminder to send blessings upon the Prophet Muhammad ﷺ. Keep the ﷺ ligature.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة على محمد ﷺ'**
  String get notifSettingsLabelSalawat;

  /// No description provided for @notifSettingsLabelRandomAudioThikr.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار الصوتية العشوائية'**
  String get notifSettingsLabelRandomAudioThikr;

  /// No description provided for @notifSettingsLabelFloatingAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار العائمة والتنبيهات البديلة'**
  String get notifSettingsLabelFloatingAdhkar;

  /// No description provided for @notifSettingsLabelDailyQuranWird.
  ///
  /// In ar, this message translates to:
  /// **'الورد القرآني اليومي'**
  String get notifSettingsLabelDailyQuranWird;

  /// No description provided for @notifSettingsLabelReadSurahMulk.
  ///
  /// In ar, this message translates to:
  /// **'قراءة سورة الملك'**
  String get notifSettingsLabelReadSurahMulk;

  /// No description provided for @notifSettingsLabelReadSpecificSurah.
  ///
  /// In ar, this message translates to:
  /// **'قراءة سورة محددة'**
  String get notifSettingsLabelReadSpecificSurah;

  /// No description provided for @notifSettingsLabelReadSurahKahf.
  ///
  /// In ar, this message translates to:
  /// **'قراءة سورة الكهف'**
  String get notifSettingsLabelReadSurahKahf;

  /// No description provided for @notifSettingsLabelFasting.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بالصيام'**
  String get notifSettingsLabelFasting;

  /// No description provided for @notifSettingsLabelFastingMonday.
  ///
  /// In ar, this message translates to:
  /// **'صيام الاثنين'**
  String get notifSettingsLabelFastingMonday;

  /// No description provided for @notifSettingsLabelFastingThursday.
  ///
  /// In ar, this message translates to:
  /// **'صيام الخميس'**
  String get notifSettingsLabelFastingThursday;

  /// Title/body of the recurring 'Hasbuna Allah wa ni'ma al-wakil' dhikr reminder: 'The best supplication beloved to Allah, with great effect'.
  ///
  /// In ar, this message translates to:
  /// **'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم'**
  String get notifSettingsLabelBestDua;

  /// 'Wird' = a daily devotional portion (worship routine).
  ///
  /// In ar, this message translates to:
  /// **'ورد الصباح'**
  String get notifSettingsLabelWirdMorning;

  /// No description provided for @notifSettingsLabelWirdEvening.
  ///
  /// In ar, this message translates to:
  /// **'ورد المساء'**
  String get notifSettingsLabelWirdEvening;

  /// No description provided for @notifSettingsLabelWirdNight.
  ///
  /// In ar, this message translates to:
  /// **'ورد ما قبل النوم'**
  String get notifSettingsLabelWirdNight;

  /// No description provided for @notifSettingsLabelWirdSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الورد اليومي'**
  String get notifSettingsLabelWirdSummary;

  /// Reminder for the 'Young Muslim' (kids) section of the app.
  ///
  /// In ar, this message translates to:
  /// **'تذكير المسلم الصغير'**
  String get notifSettingsLabelYoungMuslim;

  /// No description provided for @notifSettingsLabelQuranPlan.
  ///
  /// In ar, this message translates to:
  /// **'تذكير خطط القرآن'**
  String get notifSettingsLabelQuranPlan;

  /// No description provided for @notifSettingsLabelGeneral.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات التطبيق العامة'**
  String get notifSettingsLabelGeneral;

  /// No description provided for @notifSettingsTitleRandomThikr.
  ///
  /// In ar, this message translates to:
  /// **'ذكر عشوائي'**
  String get notifSettingsTitleRandomThikr;

  /// No description provided for @notifSettingsTitleFloatingAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار العائمة'**
  String get notifSettingsTitleFloatingAdhkar;

  /// No description provided for @notifSettingsTitlePrayerAthan.
  ///
  /// In ar, this message translates to:
  /// **'أذان الصلاة'**
  String get notifSettingsTitlePrayerAthan;

  /// Body text of a scheduled reminder notification.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس أذكار الصباح!'**
  String get notifSettingsBodyThikrMorning;

  /// No description provided for @notifSettingsBodyThikrEvening.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس أذكار المساء!'**
  String get notifSettingsBodyThikrEvening;

  /// No description provided for @notifSettingsBodyMiddleNight.
  ///
  /// In ar, this message translates to:
  /// **'حان وقت قيام الليل، استغل الثلث الأخير من الليل.'**
  String get notifSettingsBodyMiddleNight;

  /// No description provided for @notifSettingsBodySalawat.
  ///
  /// In ar, this message translates to:
  /// **'صلِّ على النبي ﷺ تسعد في يومك.'**
  String get notifSettingsBodySalawat;

  /// No description provided for @notifSettingsBodyRememberAllah.
  ///
  /// In ar, this message translates to:
  /// **'اذكر الله يذكرك!'**
  String get notifSettingsBodyRememberAllah;

  /// No description provided for @notifSettingsBodyReadQuran.
  ///
  /// In ar, this message translates to:
  /// **'خصص وقتًا لوردك القرآني اليومي.'**
  String get notifSettingsBodyReadQuran;

  /// No description provided for @notifSettingsBodyReadSurahMulk.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس قراءة سورة الملك الليلة.'**
  String get notifSettingsBodyReadSurahMulk;

  /// No description provided for @notifSettingsBodyThikrSleep.
  ///
  /// In ar, this message translates to:
  /// **'اذكار النوم قبل أن تغفو.'**
  String get notifSettingsBodyThikrSleep;

  /// No description provided for @notifSettingsBodyThikrWakeUp.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ يومك بذكر الله بعد الاستيقاظ.'**
  String get notifSettingsBodyThikrWakeUp;

  /// No description provided for @notifSettingsBodyReadSurah.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس قراءة السورة التي اخترتها اليوم.'**
  String get notifSettingsBodyReadSurah;

  /// No description provided for @notifSettingsBodyReadSurahKahf.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس قراءة سورة الكهف في يوم الجمعة.'**
  String get notifSettingsBodyReadSurahKahf;

  /// No description provided for @notifSettingsBodyFasting.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بصيام التطوع.'**
  String get notifSettingsBodyFasting;

  /// No description provided for @notifSettingsBodyFastingMonday.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بصيام يوم الاثنين.'**
  String get notifSettingsBodyFastingMonday;

  /// No description provided for @notifSettingsBodyFastingThursday.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بصيام يوم الخميس.'**
  String get notifSettingsBodyFastingThursday;

  /// No description provided for @notifSettingsBodyAthanTime.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن موعد الأذان.'**
  String get notifSettingsBodyAthanTime;

  /// No description provided for @notifSettingsBodyWirdMorning.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ نهارك بزادك التعبدي.'**
  String get notifSettingsBodyWirdMorning;

  /// No description provided for @notifSettingsBodyWirdEvening.
  ///
  /// In ar, this message translates to:
  /// **'جدد صلتك بالله في زاد المساء.'**
  String get notifSettingsBodyWirdEvening;

  /// No description provided for @notifSettingsBodyWirdNight.
  ///
  /// In ar, this message translates to:
  /// **'اختم يومك بالذكر والدعاء.'**
  String get notifSettingsBodyWirdNight;

  /// No description provided for @notifSettingsBodyWirdSummary.
  ///
  /// In ar, this message translates to:
  /// **'راجع زادك التعبدي اليوم.'**
  String get notifSettingsBodyWirdSummary;

  /// No description provided for @notifSettingsBodyYoungMuslim.
  ///
  /// In ar, this message translates to:
  /// **'تذكير للعودة إلى محتوى المسلم الصغير.'**
  String get notifSettingsBodyYoungMuslim;

  /// No description provided for @notifSettingsBodyQuranPlan.
  ///
  /// In ar, this message translates to:
  /// **'لا تنس جلسة اليوم من خطتك القرآنية.'**
  String get notifSettingsBodyQuranPlan;

  /// No description provided for @notifSettingsBodyGeneral.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات وتنبيهات عامة من تطبيق طمأنينة.'**
  String get notifSettingsBodyGeneral;

  /// Row title: adhan notifications for all prayers.
  ///
  /// In ar, this message translates to:
  /// **'كل الصلوات'**
  String get notifSettingsAllPrayers;

  /// Short row title: reminder to send blessings upon the Prophet Muhammad.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة على محمد'**
  String get notifSettingsSalawatShort;

  /// Short row title: daily Quran reading portion reminder.
  ///
  /// In ar, this message translates to:
  /// **'الورد القرآني'**
  String get notifSettingsQuranWirdShort;

  /// Section headers on the notification settings screen.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get notifSettingsGroupGeneral;

  /// No description provided for @notifSettingsGroupAthan.
  ///
  /// In ar, this message translates to:
  /// **'الأذان'**
  String get notifSettingsGroupAthan;

  /// No description provided for @notifSettingsGroupDailyWird.
  ///
  /// In ar, this message translates to:
  /// **'الورد اليومي'**
  String get notifSettingsGroupDailyWird;

  /// No description provided for @notifSettingsGroupAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'الأذكار'**
  String get notifSettingsGroupAdhkar;

  /// No description provided for @notifSettingsGroupQuran.
  ///
  /// In ar, this message translates to:
  /// **'القرآن'**
  String get notifSettingsGroupQuran;

  /// No description provided for @notifSettingsGroupAppSections.
  ///
  /// In ar, this message translates to:
  /// **'أقسام التطبيق'**
  String get notifSettingsGroupAppSections;

  /// No description provided for @notifSettingsGroupNightAndWaking.
  ///
  /// In ar, this message translates to:
  /// **'الليل واليقظة'**
  String get notifSettingsGroupNightAndWaking;

  /// No description provided for @notifSettingsGroupFasting.
  ///
  /// In ar, this message translates to:
  /// **'الصيام'**
  String get notifSettingsGroupFasting;

  /// No description provided for @notifSettingsGroupRecurringAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'أذكار متكررة'**
  String get notifSettingsGroupRecurringAdhkar;

  /// No description provided for @notifSettingsGroupSystem.
  ///
  /// In ar, this message translates to:
  /// **'النظام'**
  String get notifSettingsGroupSystem;

  /// No description provided for @notifSettingsMasterTitle.
  ///
  /// In ar, this message translates to:
  /// **'كل إشعارات التطبيق'**
  String get notifSettingsMasterTitle;

  /// No description provided for @notifSettingsMasterOnSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات مفعّلة، وتستطيع ضبط كل نوع أدناه'**
  String get notifSettingsMasterOnSubtitle;

  /// No description provided for @notifSettingsMasterOffSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل الإشعارات موقوفة حتى تفعّل هذا المفتاح'**
  String get notifSettingsMasterOffSubtitle;

  /// No description provided for @notifSettingsSystemTitle.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات النظام'**
  String get notifSettingsSystemTitle;

  /// No description provided for @notifSettingsSystemSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استعرض الإشعارات المجدولة والمفعّلة على جهازك'**
  String get notifSettingsSystemSubtitle;

  /// Short status under a notification row.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get notifSettingsStatusStopped;

  /// No description provided for @notifSettingsStatusEnabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعّل'**
  String get notifSettingsStatusEnabled;

  /// Schedule summary: every day at {time} (HH:mm).
  ///
  /// In ar, this message translates to:
  /// **'يومياً · {time}'**
  String notifSettingsSummaryDaily(String time);

  /// Schedule summary: every hour at minute {minute} past the hour.
  ///
  /// In ar, this message translates to:
  /// **'كل ساعة عند الدقيقة {minute}'**
  String notifSettingsSummaryHourly(int minute);

  /// Schedule summary: repeats every {count} minutes.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{كل دقيقة} =2{كل دقيقتين} few{كل {count} دقائق} many{كل {count} دقيقة} other{كل {count} دقيقة}}'**
  String notifSettingsSummaryEveryNMinutes(int count);

  /// Separator between items in a short list (e.g. weekday names). Arabic comma plus space; use ', ' for Latin-script languages.
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get notifSettingsListSeparator;

  /// No description provided for @notifSettingsNoDaysSelected.
  ///
  /// In ar, this message translates to:
  /// **'بدون أيام محددة'**
  String get notifSettingsNoDaysSelected;

  /// Schedule summary: weekly on {days} at {time}.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعياً ({days}) · {time}'**
  String notifSettingsSummaryWeekly(String days, String time);

  /// Schedule summary: custom schedule with {count} specific dates/times.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{جدولة مخصصة · بدون توقيت} =1{جدولة مخصصة · توقيت واحد} =2{جدولة مخصصة · توقيتان} few{جدولة مخصصة · {count} توقيتات} many{جدولة مخصصة · {count} توقيتًا} other{جدولة مخصصة · {count} توقيت}}'**
  String notifSettingsSummaryCustom(int count);

  /// No description provided for @notifSettingsScheduleTimesTooltip.
  ///
  /// In ar, this message translates to:
  /// **'مواعيد التنبيه'**
  String get notifSettingsScheduleTimesTooltip;

  /// No description provided for @notifSettingsEditScheduleTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الجدولة'**
  String get notifSettingsEditScheduleTitle;

  /// No description provided for @notifSettingsEditScheduleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر نوع التكرار ووقت التنبيه'**
  String get notifSettingsEditScheduleSubtitle;

  /// No description provided for @notifSettingsExtraSchedulesTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة مواعيد إضافية'**
  String get notifSettingsExtraSchedulesTitle;

  /// No description provided for @notifSettingsExtraSchedulesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف أكثر من موعد لهذا الإشعار'**
  String get notifSettingsExtraSchedulesSubtitle;

  /// Bodies of notifications scheduled from the per-notification schedules screen.
  ///
  /// In ar, this message translates to:
  /// **'سيتكرر تنبيه جميع الأذان في أوقاتها المحددة.'**
  String get notifScheduleBodyAllAthan;

  /// No description provided for @notifScheduleBodyAthanFajr.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت أذان الفجر، بادر بالصلاة.'**
  String get notifScheduleBodyAthanFajr;

  /// No description provided for @notifScheduleBodyAthanDhuhr.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت أذان الظهر.'**
  String get notifScheduleBodyAthanDhuhr;

  /// No description provided for @notifScheduleBodyAthanAsr.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت أذان العصر.'**
  String get notifScheduleBodyAthanAsr;

  /// No description provided for @notifScheduleBodyAthanMaghrib.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت أذان المغرب.'**
  String get notifScheduleBodyAthanMaghrib;

  /// No description provided for @notifScheduleBodyAthanIsha.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن وقت أذان العشاء.'**
  String get notifScheduleBodyAthanIsha;

  /// No description provided for @notifScheduleBodyMiddleNight.
  ///
  /// In ar, this message translates to:
  /// **'حان وقت قيام الليل! قم وناجِ الرحمن.'**
  String get notifScheduleBodyMiddleNight;

  /// No description provided for @notifScheduleBodyThikrMorning.
  ///
  /// In ar, this message translates to:
  /// **'لا تنسَ أذكار الصباح!'**
  String get notifScheduleBodyThikrMorning;

  /// No description provided for @notifScheduleBodyThikrEvening.
  ///
  /// In ar, this message translates to:
  /// **'لا تنسَ أذكار المساء!'**
  String get notifScheduleBodyThikrEvening;

  /// No description provided for @notifScheduleBodySalawat.
  ///
  /// In ar, this message translates to:
  /// **'صَلِّ على النبي الكريم ﷺ، تُكتب لك عشرُ حسنات.'**
  String get notifScheduleBodySalawat;

  /// No description provided for @notifScheduleBodyReadQuran.
  ///
  /// In ar, this message translates to:
  /// **'لا تنسَ وردك من القرآن اليوم.'**
  String get notifScheduleBodyReadQuran;

  /// No description provided for @notifScheduleBodyReadSurahMulk.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سورة الملك قبل النوم.'**
  String get notifScheduleBodyReadSurahMulk;

  /// No description provided for @notifScheduleBodyThikrSleep.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ أذكار النوم قبل أن تنام.'**
  String get notifScheduleBodyThikrSleep;

  /// No description provided for @notifScheduleBodyThikrWakeUp.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ يومك بأذكار الاستيقاظ.'**
  String get notifScheduleBodyThikrWakeUp;

  /// No description provided for @notifScheduleBodyReadSurah.
  ///
  /// In ar, this message translates to:
  /// **'لا تنسَ قراءة السورة المحددة لهذا اليوم.'**
  String get notifScheduleBodyReadSurah;

  /// No description provided for @notifScheduleBodyReadSurahKahf.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سورة الكهف يوم الجمعة.'**
  String get notifScheduleBodyReadSurahKahf;

  /// No description provided for @notifScheduleBodyFasting.
  ///
  /// In ar, this message translates to:
  /// **'صيام النوافل له أجر عظيم، لا تفوت الفرصة.'**
  String get notifScheduleBodyFasting;

  /// Notification title for custom-scheduled random dhikr reminders.
  ///
  /// In ar, this message translates to:
  /// **'مخصصة من أذكار عشوائية'**
  String get notifScheduleTitleRandomThikr;

  /// No description provided for @notifScheduleValidateTime.
  ///
  /// In ar, this message translates to:
  /// **'حدد وقت التنبيه أولاً'**
  String get notifScheduleValidateTime;

  /// No description provided for @notifScheduleValidateMinute.
  ///
  /// In ar, this message translates to:
  /// **'حدد الدقيقة من كل ساعة'**
  String get notifScheduleValidateMinute;

  /// No description provided for @notifScheduleValidateWeekday.
  ///
  /// In ar, this message translates to:
  /// **'حدد يوماً واحداً على الأقل من الأسبوع'**
  String get notifScheduleValidateWeekday;

  /// No description provided for @notifScheduleValidateInterval.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عدد الدقائق (أكبر من صفر)'**
  String get notifScheduleValidateInterval;

  /// No description provided for @notifScheduleValidateDate.
  ///
  /// In ar, this message translates to:
  /// **'أضف تاريخاً واحداً على الأقل'**
  String get notifScheduleValidateDate;

  /// No description provided for @notifScheduleDetails.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get notifScheduleDetails;

  /// No description provided for @notifScheduleMinuteOfHourTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدقيقة من كل ساعة'**
  String get notifScheduleMinuteOfHourTitle;

  /// No description provided for @notifScheduleMinuteOfHourSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'رقم بين 0 و 59'**
  String get notifScheduleMinuteOfHourSubtitle;

  /// Unit suffix shown after a number input field (minutes).
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get notifScheduleMinuteUnit;

  /// No description provided for @notifScheduleRepeatTitle.
  ///
  /// In ar, this message translates to:
  /// **'التكرار'**
  String get notifScheduleRepeatTitle;

  /// No description provided for @notifScheduleRepeatSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المدة بين كل تنبيه والذي يليه'**
  String get notifScheduleRepeatSubtitle;

  /// No description provided for @notifScheduleCustomTime.
  ///
  /// In ar, this message translates to:
  /// **'موعد مخصص'**
  String get notifScheduleCustomTime;

  /// No description provided for @notifScheduleDeleteTime.
  ///
  /// In ar, this message translates to:
  /// **'حذف الموعد'**
  String get notifScheduleDeleteTime;

  /// No description provided for @notifScheduleNoTimesYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تضف أي موعد بعد'**
  String get notifScheduleNoTimesYet;

  /// No description provided for @notifScheduleAddTime.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد'**
  String get notifScheduleAddTime;

  /// No description provided for @notifScheduleSaveSchedule.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الجدولة'**
  String get notifScheduleSaveSchedule;

  /// No description provided for @notifScheduleAddNewTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة موعد جديد'**
  String get notifScheduleAddNewTitle;

  /// No description provided for @notifScheduleEditTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الموعد'**
  String get notifScheduleEditTitle;

  /// No description provided for @notifScheduleOptionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'وصف اختياري'**
  String get notifScheduleOptionalLabel;

  /// No description provided for @notifScheduleAddConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الموعد'**
  String get notifScheduleAddConfirm;

  /// No description provided for @notifScheduleSaveEdit.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديل'**
  String get notifScheduleSaveEdit;

  /// No description provided for @notifScheduleTypeDaily.
  ///
  /// In ar, this message translates to:
  /// **'يومي'**
  String get notifScheduleTypeDaily;

  /// No description provided for @notifScheduleTypeHourly.
  ///
  /// In ar, this message translates to:
  /// **'كل ساعة'**
  String get notifScheduleTypeHourly;

  /// No description provided for @notifScheduleTypeEveryNMinutes.
  ///
  /// In ar, this message translates to:
  /// **'كل عدة دقائق'**
  String get notifScheduleTypeEveryNMinutes;

  /// No description provided for @notifScheduleTypeWeekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعي'**
  String get notifScheduleTypeWeekly;

  /// No description provided for @notifScheduleTypeCustomDates.
  ///
  /// In ar, this message translates to:
  /// **'تواريخ مخصصة'**
  String get notifScheduleTypeCustomDates;

  /// No description provided for @notifScheduleTypeDailyDesc.
  ///
  /// In ar, this message translates to:
  /// **'يتكرر كل يوم في الوقت نفسه'**
  String get notifScheduleTypeDailyDesc;

  /// No description provided for @notifScheduleTypeHourlyDesc.
  ///
  /// In ar, this message translates to:
  /// **'يتكرر كل ساعة عند دقيقة محددة'**
  String get notifScheduleTypeHourlyDesc;

  /// No description provided for @notifScheduleTypeEveryNMinutesDesc.
  ///
  /// In ar, this message translates to:
  /// **'يتكرر كل فترة زمنية تحددها'**
  String get notifScheduleTypeEveryNMinutesDesc;

  /// No description provided for @notifScheduleTypeWeeklyDesc.
  ///
  /// In ar, this message translates to:
  /// **'يتكرر في أيام محددة من الأسبوع'**
  String get notifScheduleTypeWeeklyDesc;

  /// No description provided for @notifScheduleTypeCustomDatesDesc.
  ///
  /// In ar, this message translates to:
  /// **'يظهر في تواريخ وأوقات تختارها'**
  String get notifScheduleTypeCustomDatesDesc;

  /// No description provided for @notifScheduleTypeTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الجدولة'**
  String get notifScheduleTypeTitle;

  /// No description provided for @notifScheduleTimeTitle.
  ///
  /// In ar, this message translates to:
  /// **'وقت التنبيه'**
  String get notifScheduleTimeTitle;

  /// No description provided for @notifScheduleTimeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لاختيار الساعة والدقيقة'**
  String get notifScheduleTimeSubtitle;

  /// No description provided for @notifScheduleLabelHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف وصفاً قصيراً لهذا الموعد'**
  String get notifScheduleLabelHint;

  /// No description provided for @notifScheduleRowDaily.
  ///
  /// In ar, this message translates to:
  /// **'كل يوم · {time}'**
  String notifScheduleRowDaily(String time);

  /// Weekly schedule row: short day names then time.
  ///
  /// In ar, this message translates to:
  /// **'{days} · {time}'**
  String notifScheduleRowWeekly(String days, String time);

  /// No description provided for @notifScheduleNoDays.
  ///
  /// In ar, this message translates to:
  /// **'بدون أيام'**
  String get notifScheduleNoDays;

  /// Number of custom date/time entries in a schedule.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا مواعيد مخصصة} =1{موعد مخصص واحد} =2{موعدان مخصصان} few{{count} مواعيد مخصصة} many{{count} موعدًا مخصصًا} other{{count} موعد مخصص}}'**
  String notifScheduleRowCustom(int count);

  /// Short weekday names for small chips: 1=Monday … 7=Sunday.
  ///
  /// In ar, this message translates to:
  /// **'اثنين'**
  String get notifScheduleDayShort1;

  /// No description provided for @notifScheduleDayShort2.
  ///
  /// In ar, this message translates to:
  /// **'ثلاثاء'**
  String get notifScheduleDayShort2;

  /// No description provided for @notifScheduleDayShort3.
  ///
  /// In ar, this message translates to:
  /// **'أربعاء'**
  String get notifScheduleDayShort3;

  /// No description provided for @notifScheduleDayShort4.
  ///
  /// In ar, this message translates to:
  /// **'خميس'**
  String get notifScheduleDayShort4;

  /// No description provided for @notifScheduleDayShort5.
  ///
  /// In ar, this message translates to:
  /// **'جمعة'**
  String get notifScheduleDayShort5;

  /// No description provided for @notifScheduleDayShort6.
  ///
  /// In ar, this message translates to:
  /// **'سبت'**
  String get notifScheduleDayShort6;

  /// No description provided for @notifScheduleDayShort7.
  ///
  /// In ar, this message translates to:
  /// **'أحد'**
  String get notifScheduleDayShort7;

  /// No description provided for @notifScheduleAllDays.
  ///
  /// In ar, this message translates to:
  /// **'كل الأيام'**
  String get notifScheduleAllDays;

  /// Quick-select button: working days (currently Sunday–Thursday).
  ///
  /// In ar, this message translates to:
  /// **'أيام العمل'**
  String get notifScheduleWorkDays;

  /// Quick-select button: weekend days (currently Friday–Saturday).
  ///
  /// In ar, this message translates to:
  /// **'العطلة'**
  String get notifScheduleWeekend;

  /// No description provided for @notifScheduleClear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get notifScheduleClear;

  /// No description provided for @notifScheduleStatTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get notifScheduleStatTotal;

  /// No description provided for @notifScheduleStatEnabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعّل'**
  String get notifScheduleStatEnabled;

  /// No description provided for @notifScheduleStatStopped.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get notifScheduleStatStopped;

  /// No description provided for @notifScheduleUnexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get notifScheduleUnexpectedError;

  /// No description provided for @notifScheduleSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ'**
  String get notifScheduleSaved;

  /// No description provided for @notifScheduleScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'مواعيد الإشعار'**
  String get notifScheduleScreenTitle;

  /// No description provided for @notifScheduleListTitle.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد'**
  String get notifScheduleListTitle;

  /// No description provided for @notifScheduleEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد بعد — أضف موعداً من زر «إضافة موعد».'**
  String get notifScheduleEmpty;

  /// No description provided for @notifScheduleDeleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف موعد'**
  String get notifScheduleDeleteTitle;

  /// No description provided for @notifScheduleDeleteMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا الموعد؟\nسيتم إلغاء جميع الإشعارات المرتبطة به.'**
  String get notifScheduleDeleteMessage;

  /// No description provided for @notifScheduleSaving.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الحفظ...'**
  String get notifScheduleSaving;

  /// No description provided for @notifScheduleLoading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحميل المواعيد...'**
  String get notifScheduleLoading;

  /// No description provided for @notifScheduleLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في تحميل المواعيد: {error}'**
  String notifScheduleLoadFailed(String error);

  /// No description provided for @notifScheduleAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة الموعد بنجاح'**
  String get notifScheduleAdded;

  /// No description provided for @notifScheduleAddFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في إضافة الموعد: {error}'**
  String notifScheduleAddFailed(String error);

  /// No description provided for @notifScheduleUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الموعد بنجاح'**
  String get notifScheduleUpdated;

  /// No description provided for @notifScheduleUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في تحديث الموعد: {error}'**
  String notifScheduleUpdateFailed(String error);

  /// No description provided for @notifScheduleDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الموعد بنجاح'**
  String get notifScheduleDeleted;

  /// No description provided for @notifScheduleDeleteFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في حذف الموعد: {error}'**
  String notifScheduleDeleteFailed(String error);

  /// No description provided for @notifScheduleActivated.
  ///
  /// In ar, this message translates to:
  /// **'تم تفعيل الموعد'**
  String get notifScheduleActivated;

  /// No description provided for @notifScheduleDeactivated.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء تفعيل الموعد'**
  String get notifScheduleDeactivated;

  /// No description provided for @notifScheduleToggleFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل في تغيير حالة الموعد: {error}'**
  String notifScheduleToggleFailed(String error);

  /// No description provided for @notifSettingsScheduledGroup.
  ///
  /// In ar, this message translates to:
  /// **'مجدولة'**
  String get notifSettingsScheduledGroup;

  /// No description provided for @notifSettingsNoScheduled.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات مجدولة حالياً'**
  String get notifSettingsNoScheduled;

  /// No description provided for @notifSettingsShownNowGroup.
  ///
  /// In ar, this message translates to:
  /// **'ظاهرة الآن'**
  String get notifSettingsShownNowGroup;

  /// No description provided for @notifSettingsNoShown.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات ظاهرة في شريط الإشعارات'**
  String get notifSettingsNoShown;

  /// No description provided for @notifSettingsUntitled.
  ///
  /// In ar, this message translates to:
  /// **'إشعار بلا عنوان'**
  String get notifSettingsUntitled;

  /// No description provided for @notifSettingsDismiss.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء الإشعار'**
  String get notifSettingsDismiss;

  /// No description provided for @notifSettingsCancelNotification.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الإشعار'**
  String get notifSettingsCancelNotification;

  /// Accessibility ticker text of an adhan notification.
  ///
  /// In ar, this message translates to:
  /// **'حان الآن أذان {prayer}'**
  String notifSettingsAthanTicker(String prayer);

  /// No description provided for @downloadTitle.
  ///
  /// In ar, this message translates to:
  /// **'التنزيلات'**
  String get downloadTitle;

  /// No description provided for @downloadEmptyAll.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنزيلات بعد، أضف تنزيلاً للبدء.'**
  String get downloadEmptyAll;

  /// No description provided for @downloadEmptyActive.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنزيلات نشطة'**
  String get downloadEmptyActive;

  /// No description provided for @downloadEmptyCompleted.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنزيلات مكتملة'**
  String get downloadEmptyCompleted;

  /// No description provided for @downloadEmptyPaused.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنزيلات متوقّفة'**
  String get downloadEmptyPaused;

  /// No description provided for @downloadEmptyFailed.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنزيلات فاشلة'**
  String get downloadEmptyFailed;

  /// No description provided for @downloadCancelAll.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الكل'**
  String get downloadCancelAll;

  /// No description provided for @downloadCancelAllConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إلغاء جميع التنزيلات النشطة؟'**
  String get downloadCancelAllConfirm;

  /// No description provided for @downloadAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تنزيل'**
  String get downloadAdd;

  /// No description provided for @downloadFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get downloadFilterAll;

  /// Download status names, used as filter tab labels and summary row labels.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get downloadStatusActive;

  /// No description provided for @downloadStatusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get downloadStatusCompleted;

  /// No description provided for @downloadStatusPaused.
  ///
  /// In ar, this message translates to:
  /// **'متوقّف'**
  String get downloadStatusPaused;

  /// No description provided for @downloadStatusFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل'**
  String get downloadStatusFailed;

  /// No description provided for @downloadStarted.
  ///
  /// In ar, this message translates to:
  /// **'بدأ التحميل'**
  String get downloadStarted;

  /// No description provided for @downloadAddNewTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تنزيل جديد'**
  String get downloadAddNewTitle;

  /// No description provided for @downloadUrlLabel.
  ///
  /// In ar, this message translates to:
  /// **'رابط الملفّ'**
  String get downloadUrlLabel;

  /// No description provided for @downloadUrlRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رابط التحميل'**
  String get downloadUrlRequired;

  /// No description provided for @downloadUrlInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رابط صحيح'**
  String get downloadUrlInvalid;

  /// No description provided for @downloadFileNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملفّ'**
  String get downloadFileNameLabel;

  /// No description provided for @downloadOptional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get downloadOptional;

  /// No description provided for @downloadPublicStorageTitle.
  ///
  /// In ar, this message translates to:
  /// **'التخزين العام'**
  String get downloadPublicStorageTitle;

  /// No description provided for @downloadPublicStorageSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حفظ في مجلّد التنزيلات'**
  String get downloadPublicStorageSubtitle;

  /// No description provided for @downloadAllowCellularTitle.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالبيانات الخلوية'**
  String get downloadAllowCellularTitle;

  /// No description provided for @downloadAllowCellularSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التحميل عبر بيانات الجوّال'**
  String get downloadAllowCellularSubtitle;

  /// No description provided for @downloadStart.
  ///
  /// In ar, this message translates to:
  /// **'بدء التحميل'**
  String get downloadStart;

  /// No description provided for @downloadPause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقّت'**
  String get downloadPause;

  /// Action: resume a paused download.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get downloadResume;

  /// No description provided for @downloadOpenFile.
  ///
  /// In ar, this message translates to:
  /// **'فتح الملفّ'**
  String get downloadOpenFile;

  /// No description provided for @downloadRemoveFromList.
  ///
  /// In ar, this message translates to:
  /// **'حذف من القائمة'**
  String get downloadRemoveFromList;

  /// No description provided for @downloadDeleteFile.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملفّ'**
  String get downloadDeleteFile;

  /// No description provided for @downloadTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get downloadTotal;

  /// No description provided for @downloadInProgressNow.
  ///
  /// In ar, this message translates to:
  /// **'يجري تنزيله الآن'**
  String get downloadInProgressNow;

  /// Shown after the first 3 running downloads: 'and {count} more'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{وتنزيل آخر} =2{وتنزيلان آخران} few{و{count} غيرها} many{و{count} غيرها} other{و{count} غيرها}}'**
  String downloadAndMore(int count);

  /// Home-screen widget header above the next prayer's name. Very little space: keep it short.
  ///
  /// In ar, this message translates to:
  /// **'الصلاة القادمة'**
  String get widgetLabelNextPrayer;

  /// Home-screen widget header: 'Verse of the day'. Keep it short.
  ///
  /// In ar, this message translates to:
  /// **'آية اليوم'**
  String get widgetLabelDailyAyah;

  /// Home-screen widget placeholder when it has no data yet: 'Open Tamaneena' (the app name).
  ///
  /// In ar, this message translates to:
  /// **'افتح طمأنينة'**
  String get widgetLabelOpenApp;

  /// Home-screen widget hint: the user has not chosen a location in the app yet, so prayer times can't be shown.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك في التطبيق'**
  String get widgetLabelSetLocation;

  /// Second line under 'Open Tamaneena' on the home-screen widget: '…to refresh the prayer times' (the stored times ran out).
  ///
  /// In ar, this message translates to:
  /// **'لتحديث المواقيت'**
  String get widgetLabelRefreshNeeded;

  /// Home-screen widget footer shown right before a live countdown timer (e.g. '01:23:45'). Reads as 'Asr in' + timer. Keep the timer at the position that is natural in your language: the widget always places the countdown AFTER this text.
  ///
  /// In ar, this message translates to:
  /// **'{prayer} بعد'**
  String widgetLabelNextIn(String prayer);

  /// Title of the Daily Wird screen: the user's daily program of worship acts (adhkar, Quran reading, duas). 'Zad' = provision for the day and night.
  ///
  /// In ar, this message translates to:
  /// **'زاد اليوم والليلة'**
  String get dailyWirdTitle;

  /// No description provided for @dailyWirdSettingsTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الزاد'**
  String get dailyWirdSettingsTooltip;

  /// No description provided for @dailyWirdUnexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع.'**
  String get dailyWirdUnexpectedError;

  /// No description provided for @dailyWirdRemindersHeader.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات'**
  String get dailyWirdRemindersHeader;

  /// Label of the bedtime adhkar reminder switch in Daily Wird settings.
  ///
  /// In ar, this message translates to:
  /// **'أذكار النوم'**
  String get dailyWirdReminderSleepLabel;

  /// Section header in Daily Wird settings above the list of ready-made programs (presets).
  ///
  /// In ar, this message translates to:
  /// **'البرنامج'**
  String get dailyWirdProgramHeader;

  /// Button that saves the Daily Wird settings (reminders + chosen program).
  ///
  /// In ar, this message translates to:
  /// **'حفظ التهيئة'**
  String get dailyWirdSaveSetup;

  /// No description provided for @dailyWirdSetupFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إعداد الزاد التعبدي.'**
  String get dailyWirdSetupFailed;

  /// No description provided for @dailyWirdItemNotFound.
  ///
  /// In ar, this message translates to:
  /// **'تعذر العثور على عنصر الزاد التعبدي.'**
  String get dailyWirdItemNotFound;

  /// Section header above today's list of worship acts in Daily Wird.
  ///
  /// In ar, this message translates to:
  /// **'أعمال اليوم'**
  String get dailyWirdTodayTasksHeader;

  /// Streak: number of consecutive days the user kept up the daily program.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{المداومة 0 يوم} =1{المداومة يوم واحد} =2{المداومة يومان} few{المداومة {count} أيام} many{المداومة {count} يومًا} other{المداومة {count} يوم}}'**
  String dailyWirdStreakDays(int count);

  /// Percentage of the daily program completed over the last week.
  ///
  /// In ar, this message translates to:
  /// **'مواظبة الأسبوع {percent}%'**
  String dailyWirdWeeklyAdherence(int percent);

  /// No description provided for @dailyWirdChoosePresetTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر زادك التعبدي'**
  String get dailyWirdChoosePresetTitle;

  /// No description provided for @dailyWirdChoosePresetSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ ببرنامج جاهز ثم خصّصه كما يناسبك'**
  String get dailyWirdChoosePresetSubtitle;

  /// Tooltip of the overflow menu on one worship act in the Daily Wird list.
  ///
  /// In ar, this message translates to:
  /// **'خيارات العمل'**
  String get dailyWirdItemOptions;

  /// Menu item / sheet title: change how many times a counted dhikr should be repeated.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العدد المقصود'**
  String get dailyWirdEditTargetCount;

  /// Reset the progress of one worship act to zero.
  ///
  /// In ar, this message translates to:
  /// **'البدء من جديد'**
  String get dailyWirdStartOver;

  /// No description provided for @dailyWirdMoveUp.
  ///
  /// In ar, this message translates to:
  /// **'تقديم في الترتيب'**
  String get dailyWirdMoveUp;

  /// No description provided for @dailyWirdMoveDown.
  ///
  /// In ar, this message translates to:
  /// **'تأخير في الترتيب'**
  String get dailyWirdMoveDown;

  /// No description provided for @dailyWirdHideItem.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء من الزاد'**
  String get dailyWirdHideItem;

  /// Hint in the number field for the target repeat count. Use the target language's digits/wording, e.g. 'e.g. 50 times'.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ٥٠ مرة'**
  String get dailyWirdCountHint;

  /// Short time-of-day tags shown next to a worship act (morning / evening / night / any time).
  ///
  /// In ar, this message translates to:
  /// **'صباح'**
  String get dailyWirdTimeMorning;

  /// No description provided for @dailyWirdTimeEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء'**
  String get dailyWirdTimeEvening;

  /// No description provided for @dailyWirdTimeNight.
  ///
  /// In ar, this message translates to:
  /// **'ليل'**
  String get dailyWirdTimeNight;

  /// No description provided for @dailyWirdTimeAny.
  ///
  /// In ar, this message translates to:
  /// **'أي وقت'**
  String get dailyWirdTimeAny;

  /// Longer time-of-day labels on the single worship act screen (morning time / evening time / before sleep / any time).
  ///
  /// In ar, this message translates to:
  /// **'وقت الصباح'**
  String get dailyWirdTimeMorningLong;

  /// No description provided for @dailyWirdTimeEveningLong.
  ///
  /// In ar, this message translates to:
  /// **'وقت المساء'**
  String get dailyWirdTimeEveningLong;

  /// No description provided for @dailyWirdTimeNightLong.
  ///
  /// In ar, this message translates to:
  /// **'قبل النوم'**
  String get dailyWirdTimeNightLong;

  /// No description provided for @dailyWirdTimeAnyLong.
  ///
  /// In ar, this message translates to:
  /// **'في أي وقت'**
  String get dailyWirdTimeAnyLong;

  /// Type tags of a worship act: set of adhkar / counted dhikr / Quran portion / dua (supplication) / surah.
  ///
  /// In ar, this message translates to:
  /// **'أذكار'**
  String get dailyWirdTypeDhikrSet;

  /// No description provided for @dailyWirdTypeCountedDhikr.
  ///
  /// In ar, this message translates to:
  /// **'ذكر بعدد'**
  String get dailyWirdTypeCountedDhikr;

  /// No description provided for @dailyWirdTypeQuran.
  ///
  /// In ar, this message translates to:
  /// **'ورد قرآن'**
  String get dailyWirdTypeQuran;

  /// No description provided for @dailyWirdTypeDua.
  ///
  /// In ar, this message translates to:
  /// **'دعاء'**
  String get dailyWirdTypeDua;

  /// No description provided for @dailyWirdTypeSurah.
  ///
  /// In ar, this message translates to:
  /// **'سورة'**
  String get dailyWirdTypeSurah;

  /// Progress on a counted dhikr button, e.g. '12 of 33'.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {total}'**
  String dailyWirdCountProgress(int done, int total);

  /// Counter on the single worship act screen, e.g. 'You completed 12 of 33 times'. {unit} is an optional unit from the content data (Arabic), already prefixed with a space, or empty.
  ///
  /// In ar, this message translates to:
  /// **'أتممت {done} من {total}{unit}'**
  String dailyWirdCompletedOf(int done, int total, String unit);

  /// State label of a worship act that has been completed today.
  ///
  /// In ar, this message translates to:
  /// **'أُنجز'**
  String get dailyWirdItemDone;

  /// Short button: mark a worship act as done.
  ///
  /// In ar, this message translates to:
  /// **'إتمام'**
  String get dailyWirdMarkComplete;

  /// Button that adds one repetition to a counted dhikr.
  ///
  /// In ar, this message translates to:
  /// **'احتساب مرّة'**
  String get dailyWirdCountOnce;

  /// No description provided for @dailyWirdCompleteThis.
  ///
  /// In ar, this message translates to:
  /// **'إتمام هذا العمل'**
  String get dailyWirdCompleteThis;

  /// No description provided for @dailyWirdUncomplete.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الإتمام'**
  String get dailyWirdUncomplete;

  /// Daily Wird notification titles/bodies (morning, evening, before sleep, end-of-day self-review). The summary title is also the label of its reminder switch.
  ///
  /// In ar, this message translates to:
  /// **'زاد الصباح'**
  String get dailyWirdReminderMorningTitle;

  /// No description provided for @dailyWirdReminderMorningBody.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ نهارك بذكر الله وتلاوة كتابه والدعاء.'**
  String get dailyWirdReminderMorningBody;

  /// No description provided for @dailyWirdReminderEveningTitle.
  ///
  /// In ar, this message translates to:
  /// **'زاد المساء'**
  String get dailyWirdReminderEveningTitle;

  /// No description provided for @dailyWirdReminderEveningBody.
  ///
  /// In ar, this message translates to:
  /// **'جدد صلتك بالله، وأتم ما تيسر من زاد المساء.'**
  String get dailyWirdReminderEveningBody;

  /// No description provided for @dailyWirdReminderNightTitle.
  ///
  /// In ar, this message translates to:
  /// **'زاد ما قبل النوم'**
  String get dailyWirdReminderNightTitle;

  /// No description provided for @dailyWirdReminderNightBody.
  ///
  /// In ar, this message translates to:
  /// **'اختم يومك بالذكر والدعاء وما بقي من زادك التعبدي.'**
  String get dailyWirdReminderNightBody;

  /// No description provided for @dailyWirdReminderSummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'محاسبة آخر اليوم'**
  String get dailyWirdReminderSummaryTitle;

  /// No description provided for @dailyWirdReminderSummaryBody.
  ///
  /// In ar, this message translates to:
  /// **'راجع زادك التعبدي اليوم، وانظر ما أتممت منه.'**
  String get dailyWirdReminderSummaryBody;

  /// Names of the morning / evening adhkar collections (remembrances of Allah said after Fajr and after Asr).
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصباح'**
  String get wirdMorningAdhkar;

  /// No description provided for @wirdEveningAdhkar.
  ///
  /// In ar, this message translates to:
  /// **'أذكار المساء'**
  String get wirdEveningAdhkar;

  /// No description provided for @wirdMorningTitle.
  ///
  /// In ar, this message translates to:
  /// **'الورد الصباحي'**
  String get wirdMorningTitle;

  /// No description provided for @wirdEveningTitle.
  ///
  /// In ar, this message translates to:
  /// **'الورد المسائي'**
  String get wirdEveningTitle;

  /// No description provided for @wirdSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن ذكر'**
  String get wirdSearchHint;

  /// Position in single-dhikr view, e.g. 'Dhikr 3 of 24'.
  ///
  /// In ar, this message translates to:
  /// **'الذكر {current} من {total}'**
  String wirdPagerPosition(int current, int total);

  /// No description provided for @wirdPrevious.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get wirdPrevious;

  /// No description provided for @wirdNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get wirdNext;

  /// Tooltips of the view-mode toggle: show one dhikr at a time / show all as a list.
  ///
  /// In ar, this message translates to:
  /// **'عرض ذكرًا واحدًا'**
  String get wirdShowSingle;

  /// No description provided for @wirdShowList.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأذكار قائمةً'**
  String get wirdShowList;

  /// No description provided for @wirdTypeMorningOnly.
  ///
  /// In ar, this message translates to:
  /// **'صباح فقط'**
  String get wirdTypeMorningOnly;

  /// No description provided for @wirdTypeEveningOnly.
  ///
  /// In ar, this message translates to:
  /// **'مساء فقط'**
  String get wirdTypeEveningOnly;

  /// No description provided for @wirdTypeBoth.
  ///
  /// In ar, this message translates to:
  /// **'صباح ومساء'**
  String get wirdTypeBoth;

  /// No description provided for @wirdNoAudio.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد ملف صوتي'**
  String get wirdNoAudio;

  /// No description provided for @wirdPause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقت'**
  String get wirdPause;

  /// No description provided for @wirdReplay.
  ///
  /// In ar, this message translates to:
  /// **'إعادة التشغيل'**
  String get wirdReplay;

  /// No description provided for @wirdPlayAudio.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الصوت'**
  String get wirdPlayAudio;

  /// Repetitions left for a dhikr, e.g. '2 left of 3'.
  ///
  /// In ar, this message translates to:
  /// **'بقي {remaining} من {total}'**
  String wirdRemaining(int remaining, int total);

  /// Shown when the user finished all repetitions of a dhikr.
  ///
  /// In ar, this message translates to:
  /// **'أتممتها'**
  String get wirdCompleted;

  /// No description provided for @wirdResetCount.
  ///
  /// In ar, this message translates to:
  /// **'إعادة العدّ'**
  String get wirdResetCount;

  /// No description provided for @wirdCopyDhikr.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الذكر'**
  String get wirdCopyDhikr;

  /// No description provided for @wirdSource.
  ///
  /// In ar, this message translates to:
  /// **'المصدر'**
  String get wirdSource;

  /// No description provided for @wirdShowDetails.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get wirdShowDetails;

  /// No description provided for @wirdHideDetails.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء التفاصيل'**
  String get wirdHideDetails;

  /// Heading: the virtue/reward of saying this dhikr (fadl).
  ///
  /// In ar, this message translates to:
  /// **'الفضل'**
  String get wirdVirtue;

  /// No description provided for @wirdHadithText.
  ///
  /// In ar, this message translates to:
  /// **'نص الحديث'**
  String get wirdHadithText;

  /// No description provided for @wirdWordExplanations.
  ///
  /// In ar, this message translates to:
  /// **'شرح مفردات مختارة'**
  String get wirdWordExplanations;

  /// Counter button: 'I read it once' — decreases the remaining repetitions by one.
  ///
  /// In ar, this message translates to:
  /// **'قرأت مرة'**
  String get wirdReadOnce;

  /// No description provided for @wirdPlayAll.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الورد كاملًا'**
  String get wirdPlayAll;

  /// No description provided for @wirdPreparingAudio.
  ///
  /// In ar, this message translates to:
  /// **'تهيئة الصوت'**
  String get wirdPreparingAudio;

  /// No description provided for @wirdReplayAll.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تشغيل الورد'**
  String get wirdReplayAll;

  /// No description provided for @wirdPlayAllFinished.
  ///
  /// In ar, this message translates to:
  /// **'تم الانتهاء من تشغيل جميع الأذكار.'**
  String get wirdPlayAllFinished;

  /// Label above the dhikr currently being recited in audio playback.
  ///
  /// In ar, this message translates to:
  /// **'يُتلى الآن'**
  String get wirdNowPlaying;

  /// Audio playback: which repetition of the current dhikr is playing, e.g. 'Repeat 2 of 3'.
  ///
  /// In ar, this message translates to:
  /// **'التكرار {current} من {total}'**
  String wirdRepeatProgress(int current, int total);

  /// No description provided for @thikrLibraryTitle.
  ///
  /// In ar, this message translates to:
  /// **'مكتبة الأذكار'**
  String get thikrLibraryTitle;

  /// No description provided for @thikrGroupDaily.
  ///
  /// In ar, this message translates to:
  /// **'أذكار يومك'**
  String get thikrGroupDaily;

  /// No description provided for @thikrMorningSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'وردك بعد الفجر إلى ارتفاع النهار'**
  String get thikrMorningSubtitle;

  /// No description provided for @thikrEveningSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'وردك بعد العصر إلى الليل'**
  String get thikrEveningSubtitle;

  /// No description provided for @thikrSleepTitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار النوم والأحلام'**
  String get thikrSleepTitle;

  /// No description provided for @thikrSleepSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ما تقوله قبل النوم وعند الفزع منه'**
  String get thikrSleepSubtitle;

  /// No description provided for @thikrPrayerJumuahTitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الصلاة والجمعة'**
  String get thikrPrayerJumuahTitle;

  /// No description provided for @thikrPrayerJumuahSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار الأذان ودبر الصلاة ويوم الجمعة'**
  String get thikrPrayerJumuahSubtitle;

  /// Group header: supplications transmitted from the Quran and Sunnah.
  ///
  /// In ar, this message translates to:
  /// **'أدعية مأثورة'**
  String get thikrGroupDuas;

  /// No description provided for @thikrQuranicDuasTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأدعية القرآنية'**
  String get thikrQuranicDuasTitle;

  /// No description provided for @thikrQuranicDuasSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دعاء الأنبياء كما جاء في كتاب الله'**
  String get thikrQuranicDuasSubtitle;

  /// No description provided for @thikrComprehensiveDuasTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدعية جامعة'**
  String get thikrComprehensiveDuasTitle;

  /// No description provided for @thikrComprehensiveDuasSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دعوات تجمع خير الدنيا والآخرة'**
  String get thikrComprehensiveDuasSubtitle;

  /// No description provided for @thikrHajjTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدعية الحج والعمرة'**
  String get thikrHajjTitle;

  /// No description provided for @thikrHajjSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دعاء الإحرام والطواف والسعي والمشاعر'**
  String get thikrHajjSubtitle;

  /// No description provided for @thikrFuneralTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدعية للميت والجنازة'**
  String get thikrFuneralTitle;

  /// No description provided for @thikrFuneralSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ما يُقال في الصلاة على الميت وعند القبر'**
  String get thikrFuneralSubtitle;

  /// No description provided for @thikrGroupTools.
  ///
  /// In ar, this message translates to:
  /// **'أدواتك'**
  String get thikrGroupTools;

  /// No description provided for @thikrTasbeehTitle.
  ///
  /// In ar, this message translates to:
  /// **'التسبيح'**
  String get thikrTasbeehTitle;

  /// No description provided for @thikrTasbeehSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عدّاد يحصي تسبيحك ويحفظ حصيلة يومك'**
  String get thikrTasbeehSubtitle;

  /// No description provided for @thikrMyDuasSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدعيتك التي أضفتها بنفسك في مكان واحد'**
  String get thikrMyDuasSubtitle;

  /// Subtitle on the highlighted card that opens the morning or evening adhkar depending on the current time.
  ///
  /// In ar, this message translates to:
  /// **'وردُ هذا الوقت، افتحه الآن'**
  String get thikrSliderSubtitle;

  /// No description provided for @afterPrayerTitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار بعد الصلاة'**
  String get afterPrayerTitle;

  /// No description provided for @afterPrayerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أذكار ما بعد الصلاة'**
  String get afterPrayerSubtitle;

  /// No description provided for @afterPrayerSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن أذكار'**
  String get afterPrayerSearchHint;

  /// Fallback title of an after-prayer dhikr whose text is empty.
  ///
  /// In ar, this message translates to:
  /// **'ذكر بعد الصلاة {number}'**
  String afterPrayerFallbackTitle(int number);

  /// Line in the shared/copied text of a dhikr.
  ///
  /// In ar, this message translates to:
  /// **'عدد التكرار: {count}'**
  String afterPrayerRepeatCountLine(int count);

  /// Line in the shared/copied text. {virtue} is Arabic religious text from the content data.
  ///
  /// In ar, this message translates to:
  /// **'الفضل: {virtue}'**
  String afterPrayerVirtueLine(String virtue);

  /// No description provided for @afterPrayerRepeatLabel.
  ///
  /// In ar, this message translates to:
  /// **'التكرار'**
  String get afterPrayerRepeatLabel;

  /// No description provided for @afterPrayerVirtueLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفضل'**
  String get afterPrayerVirtueLabel;

  /// Value of the 'Virtue' badge: whether a virtue is stated for this dhikr (stated / not stated).
  ///
  /// In ar, this message translates to:
  /// **'مذكور'**
  String get afterPrayerMentioned;

  /// No description provided for @afterPrayerNotMentioned.
  ///
  /// In ar, this message translates to:
  /// **'غير مذكور'**
  String get afterPrayerNotMentioned;

  /// No description provided for @afterPrayerTextSection.
  ///
  /// In ar, this message translates to:
  /// **'نص الذكر'**
  String get afterPrayerTextSection;

  /// No description provided for @afterPrayerVirtueSection.
  ///
  /// In ar, this message translates to:
  /// **'فضل الذكر'**
  String get afterPrayerVirtueSection;

  /// How many times to repeat a dhikr, e.g. 'once', '3 times'.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{مرة} =2{مرتان} few{{count} مرات} many{{count} مرة} other{{count} مرة}}'**
  String afterPrayerRepeatTimes(int count);

  /// No description provided for @afterPrayerNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get afterPrayerNoResults;

  /// No description provided for @afterPrayerShowAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الأذكار كلها'**
  String get afterPrayerShowAll;

  /// 'My duas': supplications the user wrote and added themselves.
  ///
  /// In ar, this message translates to:
  /// **'أدعيتي'**
  String get myDuasTitle;

  /// No description provided for @myDuasActionFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تنفيذ العملية.'**
  String get myDuasActionFailed;

  /// No description provided for @myDuasEmptyCustomTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدعية مضافة'**
  String get myDuasEmptyCustomTitle;

  /// No description provided for @myDuasEmptyCustomMessage.
  ///
  /// In ar, this message translates to:
  /// **'هذا القسم يعرض الأدعية التي أضفتها أنت فقط.'**
  String get myDuasEmptyCustomMessage;

  /// No description provided for @myDuasEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدعية بعد'**
  String get myDuasEmptyTitle;

  /// No description provided for @myDuasEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'أضف دعاءك الأول وسيظهر هنا مباشرة.'**
  String get myDuasEmptyMessage;

  /// No description provided for @myDuasAddNew.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دعاء جديد'**
  String get myDuasAddNew;

  /// No description provided for @myDuasAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دعاء'**
  String get myDuasAdd;

  /// No description provided for @myDuasAddSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتب الدعاء ليظهر ضمن أدعيتك الخاصة.'**
  String get myDuasAddSubtitle;

  /// No description provided for @myDuasEditTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الدعاء'**
  String get myDuasEditTitle;

  /// No description provided for @myDuasEditSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تعديل النص أو الوصف وحفظ التغييرات مباشرة.'**
  String get myDuasEditSubtitle;

  /// No description provided for @myDuasCountLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأدعية'**
  String get myDuasCountLabel;

  /// Total number of times the user repeated their duas today.
  ///
  /// In ar, this message translates to:
  /// **'ترديد اليوم'**
  String get myDuasTodayLabel;

  /// No description provided for @myDuasOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات الدعاء'**
  String get myDuasOptions;

  /// No description provided for @myDuasResetToday.
  ///
  /// In ar, this message translates to:
  /// **'تصفير عداد اليوم'**
  String get myDuasResetToday;

  /// Ruqyah: Quranic verses and prophetic supplications recited for healing and protection.
  ///
  /// In ar, this message translates to:
  /// **'الرقية الشرعية'**
  String get ruqyahTitle;

  /// No description provided for @ruqyahSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن رقية'**
  String get ruqyahSearchHint;

  /// Source shown when a ruqyah item has no reference: 'The Holy Quran'.
  ///
  /// In ar, this message translates to:
  /// **'القرآن الكريم'**
  String get ruqyahDefaultReference;

  /// No description provided for @ruqyahUnspecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get ruqyahUnspecified;

  /// Repeat count of a ruqyah item. {count} comes from the content data (may be a word or a number).
  ///
  /// In ar, this message translates to:
  /// **'التكرار: {count}'**
  String ruqyahRepeatLine(String count);

  /// Line in the shared text. {reference} is the source (Arabic content).
  ///
  /// In ar, this message translates to:
  /// **'المرجع: {reference}'**
  String ruqyahReferenceLine(String reference);

  /// Line in the shared text. {description} is Arabic content.
  ///
  /// In ar, this message translates to:
  /// **'الوصف: {description}'**
  String ruqyahDescriptionLine(String description);

  /// Ordinal label of a ruqyah item, e.g. 'Ruqyah 3'.
  ///
  /// In ar, this message translates to:
  /// **'الرقية {number}'**
  String ruqyahNumber(int number);

  /// No description provided for @ruqyahTextSection.
  ///
  /// In ar, this message translates to:
  /// **'نص الرقية'**
  String get ruqyahTextSection;

  /// No description provided for @ruqyahDescriptionSection.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get ruqyahDescriptionSection;

  /// No description provided for @ruqyahNoResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get ruqyahNoResultsTitle;

  /// No description provided for @ruqyahNoResultsMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد رقية تطابق بحثك.'**
  String get ruqyahNoResultsMessage;

  /// No description provided for @ruqyahShowAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الرقى كلها'**
  String get ruqyahShowAll;

  /// Title of the Islamic radio screen (live Quran recitation stations).
  ///
  /// In ar, this message translates to:
  /// **'الإذاعة'**
  String get radioTitle;

  /// Station groups: Quran reciters / programs and recitations.
  ///
  /// In ar, this message translates to:
  /// **'قرّاء'**
  String get radioKindReciters;

  /// No description provided for @radioKindPrograms.
  ///
  /// In ar, this message translates to:
  /// **'برامج وتلاوات'**
  String get radioKindPrograms;

  /// No description provided for @radioLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الإذاعات حاليًا.'**
  String get radioLoadFailed;

  /// No description provided for @radioPlayFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تشغيل الإذاعة الآن.'**
  String get radioPlayFailed;

  /// No description provided for @radioToggleFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تغيير حالة التشغيل.'**
  String get radioToggleFailed;

  /// No description provided for @radioStopFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إيقاف الإذاعة.'**
  String get radioStopFailed;

  /// No description provided for @radioNoMatch.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محطة بهذا الاسم.'**
  String get radioNoMatch;

  /// No description provided for @radioSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن قارئ أو برنامج'**
  String get radioSearchHint;

  /// No description provided for @radioFavouritesHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مطوّلًا على أي محطة لإضافتها إلى المفضّلة.'**
  String get radioFavouritesHint;

  /// No description provided for @radioAddFavourite.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى المفضّلة'**
  String get radioAddFavourite;

  /// No description provided for @radioRemoveFavourite.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من المفضّلة'**
  String get radioRemoveFavourite;

  /// Snackbar after long-press. {station} is the station name (from the server, usually Arabic).
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت {station} إلى المفضّلة'**
  String radioAddedToFavourites(String station);

  /// No description provided for @radioRemovedFromFavourites.
  ///
  /// In ar, this message translates to:
  /// **'أُزيلت {station} من المفضّلة'**
  String radioRemovedFromFavourites(String station);

  /// No description provided for @radioSleepTimer.
  ///
  /// In ar, this message translates to:
  /// **'مؤقّت النوم'**
  String get radioSleepTimer;

  /// No description provided for @radioSleepTimerDescription.
  ///
  /// In ar, this message translates to:
  /// **'يتوقّف البثّ وحده بعد المدّة المختارة.'**
  String get radioSleepTimerDescription;

  /// Sleep timer countdown. {time} is mm:ss.
  ///
  /// In ar, this message translates to:
  /// **'يتوقّف بعد {time}'**
  String radioStopsIn(String time);

  /// No description provided for @radioCancelTimer.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء المؤقّت'**
  String get radioCancelTimer;

  /// Sleep timer duration option in minutes.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{دقيقة واحدة} =2{دقيقتان} few{{count} دقائق} many{{count} دقيقة} other{{count} دقيقة}}'**
  String radioMinutes(int count);

  /// Stops the stream completely (different from pause).
  ///
  /// In ar, this message translates to:
  /// **'إيقاف البثّ'**
  String get radioStopBroadcast;

  /// Status while the station stream is connecting/buffering ('tuning in…').
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الالتقاط…'**
  String get radioTuning;

  /// No description provided for @radioLive.
  ///
  /// In ar, this message translates to:
  /// **'بثّ مباشر'**
  String get radioLive;

  /// No description provided for @radioPaused.
  ///
  /// In ar, this message translates to:
  /// **'متوقّف مؤقّتًا'**
  String get radioPaused;

  /// No description provided for @radioTapToPlay.
  ///
  /// In ar, this message translates to:
  /// **'اضغط للتشغيل'**
  String get radioTapToPlay;

  /// No description provided for @radioPause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقّت'**
  String get radioPause;

  /// No description provided for @radioPlay.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل'**
  String get radioPlay;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'fa',
        'id',
        'tr',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'bn':
      return L10nBn();
    case 'fa':
      return L10nFa();
    case 'id':
      return L10nId();
    case 'tr':
      return L10nTr();
    case 'ur':
      return L10nUr();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
