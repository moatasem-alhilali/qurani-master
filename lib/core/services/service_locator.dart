import 'package:get_it/get_it.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/offline/data/remote/offline_repository_imp.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/search/data/remote/aya_repository.dart';
import 'package:quran_app/features/search/data/remote/search_repository_imp.dart';

final sl = GetIt.instance;

void setupServiceLocator() async {
  sl.registerSingleton<OfflineRepositoryImpl>(OfflineRepositoryImpl());
  sl.registerSingleton<BookRepositoryImpl>(BookRepositoryImpl());
  sl.registerSingleton<BaseAudioRepositoryImpl>(BaseAudioRepositoryImpl());
  sl.registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl());
  sl.registerSingleton<SearchRepositoryImpl>(SearchRepositoryImpl());
  sl.registerSingleton<AyaRepository>(AyaRepository());
  sl.registerSingleton<PrayerTimesRepo>(PrayerTimesRepo());
  //
  await _initDatabaseClient();
  // sl.registerSingleton<DataBaseClient>(DataBaseClient());
}

Future<void> _initDatabaseClient() async => sl
    .registerSingleton<DataBaseClient>(DataBaseClient.instance..initDatabase());
