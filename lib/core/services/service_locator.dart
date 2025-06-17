import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/notification/tasks_notification.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/bookmark/data/database/bookmark_service.dart';
import 'package:quran_app/features/bookmark/data/remote/book_mark_repository_imp.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/offline/data/remote/offline_repository_imp.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/search/data/remote/aya_repository.dart';
import 'package:quran_app/features/search/data/remote/search_repository_imp.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting/data/remote/manage_notification_repo.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  ///
  sl
    ..registerSingleton<DatabaseNotificationSettingService>(
      DatabaseNotificationSettingService(),
    )
    ..registerSingleton<CacheService>(CacheService())
    ..registerSingleton<Connectivity>(Connectivity())

    // ─────────────────────── MANAGE NOTIFICATION REPO ───────────────────────
    ..registerSingleton<ManageNotificationRepo>(
      ManageNotificationRepo(
        settingDb: sl.get(),
      ),
    )

    // ─────────────────────── NOTIFICATION ───────────────────────
    ..registerSingleton<NotificationService>(NotificationService());

  // ─────────────────────── TASKS NOTIFICATION ───────────────────────
  final tasksNotification = TasksNotification();
  sl.registerSingleton<TasksNotification>(tasksNotification);

  // ─────────────────────── MANAGE NOTIFICATION REPO ───────────────────────
  sl.get<ManageNotificationRepo>().tasksNotification = tasksNotification;

  // ─────────────────────── REPOSITORIES ───────────────────────
  sl
    ..registerSingleton<OfflineRepositoryImpl>(OfflineRepositoryImpl())
    ..registerSingleton<BookRepositoryImpl>(BookRepositoryImpl())
    ..registerSingleton<BaseAudioRepositoryImpl>(BaseAudioRepositoryImpl())
    ..registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl())
    ..registerSingleton<SearchRepositoryImpl>(SearchRepositoryImpl())
    ..registerSingleton<AyaRepository>(AyaRepository())
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

    // ─────────────────────── BLOC ───────────────────────
    ..registerFactory<BookmarkBloc>(() => BookmarkBloc(repository: sl()))
    ..registerFactory<SabihBloc>(() => SabihBloc(repository: sl()));

  // ─────────────────────── DATABASE ───────────────────────
  await _initDatabaseClient();
}

Future<void> _initDatabaseClient() async => sl
    .registerSingleton<DataBaseClient>(DataBaseClient.instance..initDatabase());
