/// كل معرّفات ودجات الشاشة الرئيسية — المصدر الوحيد لها في Dart.
///
/// **كل قيمة هنا لها نظير حرفي في الكود الأصلي**، وأيّ اختلاف بحرف واحد يكسر
/// الربط بصمت (لا خطأ ولا تحذير — الودجت ببساطة لا تتحدّث):
///
/// | هنا | أندرويد | iOS |
/// |---|---|---|
/// | [payloadKey] | `WidgetPayload.KEY` | `WidgetPayloadStore.key` |
/// | [appGroupId] | — | `WidgetPayloadStore.appGroup` + ملفّا entitlements |
/// | [iosKinds] | — | `kind` في كل `Widget` |
/// | [androidProviders] | أسماء أصناف `homewidgets/*Provider` + المانيفست | — |
/// | [backgroundTask] | — | `AppDelegate.swift` + `Info.plist` |
/// | [linkScheme] | `WidgetRenderer.launchUri` | `widgetURL` |
abstract final class HomeWidgetIds {
  /// مفتاح البيانات الوحيد: JSON مُرقَّم الإصدار بدل عشرات المفاتيح المتفرّقة.
  ///
  /// كتابة واحدة ذرّية تمنع أن تقرأ الودجت نصف بيانات قديمة ونصفًا جديدًا.
  static const String payloadKey = 'tamaneena_widgets_v2_payload';

  /// إصدار بنية البيانات. يُرفع عند أيّ تغيير غير متوافق، فتتجاهل الودجات
  /// الأصلية البيانات التي لا تفهمها بدل أن تنهار.
  static const int payloadVersion = 2;

  /// مجموعة التطبيقات المشتركة بين التطبيق وامتداد iOS.
  static const String appGroupId = 'group.com.tamaanina.app.widgets';

  static const String iosNextPrayer = 'tamaneena.widget.nextPrayer';
  static const String iosPrayerTimes = 'tamaneena.widget.prayerTimes';
  static const String iosDailyAyah = 'tamaneena.widget.dailyAyah';

  static const List<String> iosKinds = [
    iosNextPrayer,
    iosPrayerTimes,
    iosDailyAyah,
  ];

  static const String _androidPackage =
      'com.tamaneena.tamaneena_app.homewidgets';

  static const String androidNextPrayer =
      '$_androidPackage.NextPrayerWidgetProvider';
  static const String androidPrayerTimes =
      '$_androidPackage.PrayerTimesWidgetProvider';
  static const String androidDailyAyah =
      '$_androidPackage.DailyAyahWidgetProvider';

  static const List<String> androidProviders = [
    androidNextPrayer,
    androidPrayerTimes,
    androidDailyAyah,
  ];

  /// مهمّة المزامنة في الخلفية. على iOS يجب أن يطابق `uniqueName` المعرّفَ
  /// المسجّل في AppDelegate وقائمة `BGTaskSchedulerPermittedIdentifiers`.
  static const String backgroundTask = 'tamaneena.widgets.sync';

  /// رابط الضغط على الودجت. `homeWidget` في الاستعلام شرط home_widget على iOS
  /// ليمرّر الرابط إلى Flutter؛ بدونه يُفتح التطبيق ولا يُعرف مصدر الضغط.
  static const String linkScheme = 'tamaneena';
  static const String linkHost = 'widget';

  /// عدد الأيام المحسوبة مسبقًا. الودجات تعمل صحيحة طوال هذه المدّة ولو لم
  /// يُفتح التطبيق ولم تعمل المزامنة في الخلفية مرّة واحدة.
  static const int daysAhead = 30;
}
