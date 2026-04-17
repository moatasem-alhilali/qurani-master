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
import 'package:quran_app/core/services/device_info_service.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/bookmark/data/database/bookmark_service.dart';
import 'package:quran_app/features/bookmark/data/remote/book_mark_repository_imp.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/daily_wird/data/di/injection_container.dart';
import 'package:quran_app/features/home/data/di/injection_container.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_notification_router_service.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_payload_service.dart';
import 'package:quran_app/features/quran_audio/data/di/injection_container.dart';
import 'package:quran_app/features/quran_audio/data/remote/quran_audio_player_repo.dart';
import 'package:quran_app/features/quran_plan/data/di/injection_container.dart';
import 'package:quran_app/features/radio/data/di/injection_container.dart';
import 'package:quran_app/features/read_quran/data/di/injection_container.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';
import 'package:quran_app/features/smart_outreach/data/database/smart_outreach_database_service.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_session_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_communication_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_router_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_validation_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_execution_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─────────────────────── DATABASE ───────────────────────
  // await _initDatabaseClient();
  await registerQuranDependencies(sl);
  await registerSurahVerseReaderDependencies(sl);
  await registerHomeDependencies(sl);
  await registerDailyWirdDependencies(sl);
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
    ..registerSingleton<NotificationOrchestratorService>(
      NotificationOrchestratorService(
        notificationService: sl.get(),
        settingRepo: sl.get(),
        notificationSchedulesRepo: sl.get(),
        adhanPrayerTimeService: sl.get(),
        athanPayloadService: sl.get(),
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
    ..registerSingleton<SmartOutreachNotificationService>(
      SmartOutreachNotificationService(notificationService: sl.get()),
    )
    ..registerSingleton<SmartOutreachCommunicationService>(
      SmartOutreachCommunicationService(),
    )
    ..registerSingleton<SmartOutreachScheduleRepository>(
      SmartOutreachScheduleRepository(
        databaseService: sl.get(),
        validationService: sl.get(),
        notificationService: sl.get(),
      ),
    )
    ..registerSingleton<SmartOutreachSessionRepository>(
      SmartOutreachSessionRepository(
        databaseService: sl.get(),
        scheduleRepository: sl.get(),
      ),
    )
    ..registerSingleton<SmartOutreachNotificationRouterService>(
      SmartOutreachNotificationRouterService(
        smartOutreachNotificationService: sl.get(),
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

    // ─────────────────────── QURAN AUDIO ───────────────────────
    ..registerSingleton<QuranAudioPlayerRepo>(QuranAudioPlayerRepoImpl())

    // ─────────────────────── BLOC ───────────────────────
    // ..registerFactory<BookmarkBloc>(() => BookmarkBloc(repository: sl()))
    ..registerFactory<SabihBloc>(() => SabihBloc(repository: sl()))
    ..registerFactory<SmartOutreachSchedulesBloc>(
      () => SmartOutreachSchedulesBloc(sl.get()),
    )
    ..registerFactory<SmartOutreachExecutionBloc>(
      () => SmartOutreachExecutionBloc(
        sessionRepository: sl.get(),
        communicationService: sl.get(),
      ),
    );
  // ..registerFactory<QuranAudioBloc>(
  //   () => QuranAudioBloc(quranAudioPlayerRepo: sl()),
  // );

  // ─────────────────────── QURAN PLAN ───────────────────────
  await registerQuranPlanDependencies(sl);
}

// Future<void> _initDatabaseClient() async =>
//     sl.registerSingleton<OldDataBaseClient>(
//         OldDataBaseClient.instance..initDatabase());
