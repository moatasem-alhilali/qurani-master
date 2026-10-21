import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_payload_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_settings_store.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_picker.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_plan.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_slots.dart';
import 'package:quran_app/features/home/data/surah_label.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/main.dart';
import 'package:quran_library/quran.dart';

/// يجدول إشعار «آية اليوم» طابورًا من الأيام، آيةً لكل يوم.
///
/// لا يمرّ هذا الإشعار على جدولة التذكيرات الثابتة في
/// `NotificationOrchestratorService`: تلك تجدول عنوانًا ونصًّا واحدين مع
/// `DateTimeComponents.time`، فيتكرّر النصّ نفسه كل يوم إلى الأبد. وآيةٌ
/// واحدة تتكرّر سنةً كاملة ليست «آية اليوم».
class AyahReminderScheduler {
  AyahReminderScheduler({
    required NotificationService notificationService,
    required AyahReminderPicker picker,
    required AyahReminderPayloadService payloadService,
    AyahReminderSettingsStore? settingsStore,
    DatabaseNotificationSettingService? settingsTable,
  })  : _notifications = notificationService,
        _picker = picker,
        _payloads = payloadService,
        _store = settingsStore ?? AyahReminderSettingsStore(),
        _table = settingsTable ?? DatabaseNotificationSettingService();

  /// كم يومًا يُجدَّل مقدَّمًا.
  ///
  /// سبعة لا ثلاثون: iOS لا يحتفظ بأكثر من 64 إشعارًا محليًّا مجدولًا للتطبيق
  /// كلّه، والأذان والأوراد والأذكار تأخذ نصيبها من هذا السقف. والطابور يُعاد
  /// بناؤه في كل فتحة للتطبيق، فأسبوعٌ يكفي لمن يفتحه مرّة في الأسبوع.
  static const int horizonDays = 7;

  final NotificationService _notifications;
  final AyahReminderPicker _picker;
  final AyahReminderPayloadService _payloads;
  final AyahReminderSettingsStore _store;

  /// صفّ الإعداد يُقرأ من الجدول مباشرةً لا من `SettingNotificationRepo`:
  /// ذاك الريبو هو من يستدعي هذا المجدول عند التبديل، فاعتمادُه عليه يصنع
  /// حلقةً في الإنشاء.
  final DatabaseNotificationSettingService _table;

  int get _baseId => NotificationIdManager.generateNotificationId(
        NotificationKeys.isNotificationAyahReminder,
      );

  /// يُلغي الطابور القديم ويبني طابورًا جديدًا من إعدادات اليوم.
  ///
  /// آمِن للتكرار: الإلغاء يسبق البناء دائمًا، فلا يتراكم يومان على معرّف واحد.
  Future<AyahReminderPlan?> reschedule({DateTime? now}) async {
    try {
      await cancel();

      final setting = await _table.getByKey(
        NotificationKeys.isNotificationAyahReminder,
      );
      if (setting == null || !setting.enabled) {
        return null;
      }

      final at = now ?? DateTime.now();
      final slots = _slots(setting, at);
      if (slots.isEmpty) {
        return null;
      }

      final plan = await _picker.plan(
        requested: _store.readSource(),
        days: slots.length,
        from: at,
      );
      if (plan.isEmpty) {
        logger.w('Ayah reminder: no ayah could be resolved, nothing scheduled');
        return plan;
      }

      final count = slots.length < plan.picks.length
          ? slots.length
          : plan.picks.length;
      for (var i = 0; i < count; i++) {
        await _scheduleOne(
          id: _baseId + i,
          at: slots[i],
          ayah: plan.picks[i].ayah,
        );
      }

      logger.d('Ayah reminder: scheduled $count day(s), ${plan.resolved.name}');
      return plan;
    } catch (e, trace) {
      logger
        ..e('Error rescheduling the ayah reminder: $e')
        ..e(trace);
      return null;
    }
  }

  /// يُلغي كل أيام الطابور.
  Future<void> cancel() async {
    final base = _baseId;
    for (var i = 0; i < horizonDays; i++) {
      await _notifications.cancelNotificationById(id: base + i);
    }
  }

  Future<void> _scheduleOne({
    required int id,
    required DateTime at,
    required NewAyahModel ayah,
  }) async {
    final l10n = L10nService.current;
    final text = _ayahText(ayah);
    if (text.isEmpty) {
      return;
    }

    final title = l10n.ayahReminderNotificationTitle(
      _surahLabel(ayah.surahId) ?? '',
      ayah.ayahNumber,
    );

    await _notifications.scheduleNotificationCompatType(
      id: id,
      title: title.trim(),
      body: text,
      channel: NotificationChannel.defaultChannel,
      // تاريخ واحد لكل إشعار: النصّ يخصّ يومه، فلا يُكرَّر.
      schedule: NotificationScheduleModel.customDates(<DateTime>[at]),
      settingKey: NotificationKeys.isNotificationAyahReminder,
      payload: _payloads.buildPayload(
        surah: ayah.surahId,
        ayah: ayah.ayahNumber,
        page: ayah.page,
      ),
      subText: l10n.ayahReminderLabel,
      // الآية قد تطول عن سطر الإشعار، فتُعرض كاملةً عند التوسيع.
      bigText: text,
      iosThreadIdentifier: 'ayah_reminder',
    );
  }

  /// مواعيد الأيام القادمة بحسب جدولة الصفّ.
  ///
  /// `NotificationKeys.allowedScheduleTypes` لا تعرض لهذا المفتاح إلا
  /// «يوميّ» و«أسبوعيّ» و«مواعيد محدّدة». وبقيّة الأنواع تبقى مُعالَجة هنا
  /// لأن النوع قد يكون محفوظًا من قبل ذلك التقييد: تُقرأ «يوميًّا في الساعة
  /// المحفوظة» بدل أن تسقط بلا جدولة.
  List<DateTime> _slots(NotificationSettingModel setting, DateTime now) {
    final hour = setting.hour ?? _defaultHour;
    final minute = setting.minute ?? 0;

    switch (setting.scheduleType) {
      case ScheduleType.weekly:
        return AyahReminderSlots.weekly(
          weekdays: setting.weekdays ?? const <int>[],
          hour: hour,
          minute: minute,
          now: now,
          count: horizonDays,
        );
      case ScheduleType.customDates:
        return AyahReminderSlots.custom(
          dates: setting.customDates ?? const <DateTime>[],
          now: now,
          count: horizonDays,
        );
      case ScheduleType.daily:
      case ScheduleType.hourly:
      case ScheduleType.everyNMinutes:
        return AyahReminderSlots.daily(
          hour: hour,
          minute: minute,
          now: now,
          count: horizonDays,
        );
    }
  }

  /// ساعة الإشعار حين لا يحمل الصفّ ساعةً — الأنواع الدوريّة لا تحفظ ساعة.
  static const int _defaultHour = 8;

  /// نصّ الآية كما يُقرأ في شريط الإشعارات.
  ///
  /// العثماني أولًا: نصّه في بيانات المكتبة يونيكود حقيقي لا رموز خطّ، فيرسمه
  /// خطّ النظام بتشكيله. والإملائي احتياطٌ إن غاب، لا خيارٌ أول: حذف التشكيل
  /// من آية يُلبس قراءتها.
  String _ayahText(NewAyahModel ayah) {
    final uthmani = ayah.text.trim();
    if (uthmani.isNotEmpty) return uthmani;
    return ayah.textEmlaey?.trim() ?? '';
  }

  String? _surahLabel(int surahId) {
    try {
      final surahs = QuranLibrary.getAllSurahs();
      if (surahId < 1 || surahId > surahs.length) return null;
      return surahLabel(surahs[surahId - 1]);
    } catch (_) {
      return null;
    }
  }
}
