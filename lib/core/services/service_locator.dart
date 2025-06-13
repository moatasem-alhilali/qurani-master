import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/notification/tasks_notification.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/offline/data/remote/offline_repository_imp.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/search/data/remote/aya_repository.dart';
import 'package:quran_app/features/search/data/remote/search_repository_imp.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting/data/remote/manage_notification_repo.dart';

final sl = GetIt.instance;

void setupServiceLocator() async {
  ///
  sl.registerSingleton<DatabaseNotificationSettingService>(
      DatabaseNotificationSettingService());
  sl.registerSingleton<CacheService>(CacheService());
  sl.registerSingleton<Connectivity>(Connectivity());

  // 👇 سجل ManageNotificationRepo بعد أن تجهز كل اعتماداته
  sl.registerSingleton<ManageNotificationRepo>(
    ManageNotificationRepo(
      tasksNotification: null, // مؤقتًا null، بنعدل لاحقًا
      settingDb: sl.get(),
    ),
  );

  // 👇 ثم سجل NotificationService
  sl.registerSingleton<NotificationService>(NotificationService());

  // 👇 الآن TasksNotification (لكن لازم نعدل constructor ليقبل الـ repo بعدين)
  final tasksNotification = TasksNotification();
  sl.registerSingleton<TasksNotification>(tasksNotification);

  // 🔁 أربط ManageNotificationRepo بـ tasksNotification الآن بعد الإنشاء
  final repo = sl.get<ManageNotificationRepo>();
  repo.tasksNotification = tasksNotification;

  // باقي التسجيلات كما هي...
  sl.registerSingleton<OfflineRepositoryImpl>(OfflineRepositoryImpl());
  sl.registerSingleton<BookRepositoryImpl>(BookRepositoryImpl());
  sl.registerSingleton<BaseAudioRepositoryImpl>(BaseAudioRepositoryImpl());
  sl.registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl());
  sl.registerSingleton<SearchRepositoryImpl>(SearchRepositoryImpl());
  sl.registerSingleton<AyaRepository>(AyaRepository());
  sl.registerSingleton<PrayerTimeService>(AdhanPrayerTimeService());
  sl.registerFactory<ConnectivityBloc>(() => ConnectivityBloc());
  await _initDatabaseClient();
}

Future<void> _initDatabaseClient() async => sl
    .registerSingleton<DataBaseClient>(DataBaseClient.instance..initDatabase());
