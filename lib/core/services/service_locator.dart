import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/device_sync/data/device_sync_local_store.dart';
import 'package:quran_app/core/device_sync/data/device_sync_repository.dart';
import 'package:quran_app/core/notification/notification_orchestrator_service.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_adapters.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_payload_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_router_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_scheduler.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_picker.dart';
import 'package:quran_app/core/services/device_info_service.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/bookmark/data/database/bookmark_service.dart';
import 'package:quran_app/features/bookmark/data/remote/book_mark_repository_imp.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/daily_wird/data/di/injection_container.dart';
import 'package:quran_app/features/floating_adhkar/data/di/injection_container.dart';
import 'package:quran_app/features/home/data/di/injection_container.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_notification_router_service.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_payload_service.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/quran_audio/data/di/injection_container.dart';
import 'package:quran_app/features/quran_audio/data/remote/quran_audio_player_repo.dart';
import 'package:quran_app/features/quran_plan/data/di/injection_container.dart';
import 'package:quran_app/features/radio/data/di/injection_container.dart';
import 'package:quran_app/features/read_quran/data/di/injection_container.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';
import 'package:quran_app/features/smart_outreach/data/database/smart_outreach_database_service.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_native_scheduler_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_validation_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/young_muslim/data/di/injection_container.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─────────────────────── DATABASE ───────────────────────
  // await _initDatabaseClient();
  await registerQuranDependencies(sl);
  await registerSurahVerseReaderDependencies(sl);
  await registerHomeDependencies(sl);
  await registerDailyWirdDependencies(sl);
  await registerFloatingAdhkarDependencies(sl);
  await registerRadioDependencies(sl);

  ///
  /// getIt

  sl
    ..registerSingleton<DatabaseNotificationSettingService>(
      DatabaseNotificationSettingService(),
    )
    ..registerSingleton<SmartOutreachDatabaseService>(
      SmartOutreachDatabaseService(),
    )
    ..registerSingleton<CacheService>(CacheService())
    ..registerSingleton<Connectivity>(Connectivity())
    ..registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance)
    ..registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance)
    ..registerSingleton<DeviceInfoService>(DeviceInfoService())
    ..registerSingleton<DeviceSyncLocalStore>(
      DeviceSyncLocalStore(
        cacheService: sl.get<CacheService>(),
      ),
    )
    ..registerSingleton<DeviceSyncRepository>(
      DeviceSyncRepository(
        firestore: sl.get<FirebaseFirestore>(),
        firebaseMessaging: sl(),
        deviceInfoService: sl.get<DeviceInfoService>(),
        localStore: sl.get<DeviceSyncLocalStore>(),
      ),
    )
    // ─────────────────────── NOTIFICATION ───────────────────────
    ..registerSingleton<NotificationService>(NotificationService())
    ..registerSingleton<NotificationPermissionsService>(
      NotificationPermissionsService(sl.get<NotificationService>().plugin),
    )
    ..registerSingleton<NotificationSchedulesRepo>(
      NotificationSchedulesRepo(
        notifyService: sl.get(),
      ),
    )
    ..registerSingleton<AthanAlarmPayloadService>(
      AthanAlarmPayloadService(),
    )
    ..registerSingleton<AdhanPrayerTimeService>(AdhanPrayerTimeService())
    ..registerSingleton<SettingNotificationRepo>(
      SettingNotificationRepo(
        notificationService: sl.get(),
      ),
    )
    ..registerSingleton<AyahReminderPayloadService>(
      AyahReminderPayloadService(),
    )
    ..registerSingleton<AyahReminderScheduler>(
      AyahReminderScheduler(
        notificationService: sl.get(),
        payloadService: sl.get(),
        picker: AyahReminderPicker(
          mushaf: QuranAyahReminderMushafSource(),
        ),
      ),
    )
    ..registerSingleton<NotificationOrchestratorService>(
      NotificationOrchestratorService(
        notificationService: sl.get(),
        settingRepo: sl.get(),
        notificationSchedulesRepo: sl.get(),
        adhanPrayerTimeService: sl.get(),
        athanPayloadService: sl.get(),
        ayahReminderScheduler: sl.get(),
      ),
    )
    ..registerSingleton<AyahReminderRouterService>(
      AyahReminderRouterService(
        notificationService: sl.get(),
        payloadService: sl.get(),
      ),
    )
    ..registerSingleton<AthanAlarmNotificationRouterService>(
      AthanAlarmNotificationRouterService(
        notificationService: sl.get(),
        payloadService: sl.get(),
      ),
    )
    ..registerSingleton<SmartOutreachValidationService>(
      SmartOutreachValidationService(),
    )
    ..registerSingleton<SmartOutreachContactsPickerService>(
      SmartOutreachContactsPickerService(),
    )
    ..registerSingleton<SmartOutreachNativeSchedulerService>(
      SmartOutreachNativeSchedulerService(),
    )
    ..registerSingleton<SmartOutreachSettingsStore>(
      SmartOutreachSettingsStore(),
    )
    ..registerSingleton<SmartOutreachScheduleRepository>(
      SmartOutreachScheduleRepository(
        databaseService: sl.get(),
        validationService: sl.get(),
        nativeSchedulerService: sl.get(),
      ),
    )

    // ─────────────────────── MANAGE NOTIFICATION REPO ───────────────────────
    // sl.get<ManageNotificationRepo>().tasksNotification = tasksNotification;

    // ─────────────────────── REPOSITORIES ───────────────────────

    ..registerSingleton<BookRepositoryImpl>(BookRepositoryImpl())
    ..registerSingleton<BaseAudioRepositoryImpl>(BaseAudioRepositoryImpl())
    ..registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl())
    ..registerSingleton<PrayerTimeService>(AdhanPrayerTimeService())
    ..registerFactory<ConnectivityBloc>(ConnectivityBloc.new)

    // bookmark
    ..registerSingleton<DatabaseBookmarkAyahService>(
      DatabaseBookmarkAyahService(),
    )
    ..registerSingleton<DatabaseBookmarkPageService>(
      DatabaseBookmarkPageService(),
    )
    ..registerSingleton<BookmarkRepositoryImpl>(
      BookmarkRepositoryImpl(
        bookmarkAyahService: sl(),
        bookmarkService: sl(),
      ),
    )
    ..registerSingleton<DatabaseSabihService>(
      DatabaseSabihService(),
    )
    ..registerLazySingleton<SabihRepository>(
      () => SabihRepositoryImpl(
        sabihService: sl(),
      ),
    )

    // ─────────────────────── QURAN AUDIO ───────────────────────
    ..registerSingleton<QuranAudioPlayerRepo>(QuranAudioPlayerRepoImpl())

    // ─────────────────────── BLOC ───────────────────────
    // ..registerFactory<BookmarkBloc>(() => BookmarkBloc(repository: sl()))
    // singleton لا factory: الشاشات المرتبطة تتشارك الحالة نفسها. كانت
    // تُمرَّر بينها عبر `BlocProvider.value`، وبعد الترحيل صار كل مسار يطلبها
    // من `get_it`. لو بقيت factory لفتحت كل شاشة نسخةً فارغة ولما عاد أي
    // تعديل إلى الشاشة التي استدعتها — عطلٌ صامت لا يظهر كخطأ.
    ..registerLazySingleton<SabihBloc>(() => SabihBloc(repository: sl()))
    ..registerLazySingleton<SmartOutreachSchedulesBloc>(
      () => SmartOutreachSchedulesBloc(sl.get()),
    )
    // كان يُنشأ في `MultiBlocProvider` فوق `MaterialApp`، وهو موضع لا يصله
    // مسارٌ يُفتح من رابط عميق. وهو singleton لأن شاشة الإعدادات ترسل
    // `PrayerTimeCalculationSettingsChanged` وتتوقّع النسخة التي تقرأها شاشة
    // الأوقات؛ نسخةٌ ثانية تعني إعدادًا يُحفظ ولا يسري.
    ..registerLazySingleton<PrayerTimeBloc>(
      () => PrayerTimeBloc(
        prayerTimeService: sl<AdhanPrayerTimeService>(),
        coordinatesService: DatabaseCoordinatesService(),
      ),
    );
  // ..registerFactory<QuranAudioBloc>(
  //   () => QuranAudioBloc(quranAudioPlayerRepo: sl()),
  // );

  // ─────────────────────── QURAN PLAN ───────────────────────
  await registerQuranPlanDependencies(sl);

  // ─────────────────────── YOUNG MUSLIM ───────────────────────
  await registerYoungMuslimDependencies(sl);
}

// Future<void> _initDatabaseClient() async =>
//     sl.registerSingleton<OldDataBaseClient>(
//         OldDataBaseClient.instance..initDatabase());
