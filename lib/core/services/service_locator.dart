import 'package:get_it/get_it.dart';
import 'package:quran_app/features/audios/data/base_audio_repository_imp.dart';
import 'package:quran_app/features/books/data/book_repository_imp.dart';
import 'package:quran_app/features/categories/data/category_repository_imp.dart';
import 'package:quran_app/features/offline/data/offline_repository_imp.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/search/data/aya_repository.dart';
import 'package:quran_app/features/search/data/search_repository_imp.dart';

final sl = GetIt.instance;

void setupServiceLocator() async {
  sl.registerSingleton<OfflineRepositoryImpl>(OfflineRepositoryImpl());
  sl.registerSingleton<BookRepositoryImpl>(BookRepositoryImpl());
  sl.registerSingleton<BaseAudioRepositoryImpl>(BaseAudioRepositoryImpl());
  sl.registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl());
  sl.registerSingleton<SearchRepositoryImpl>(SearchRepositoryImpl());
  sl.registerSingleton<AyaRepository>(AyaRepository());
  //
  await _initDatabaseClient();
  // sl.registerSingleton<DataBaseClient>(DataBaseClient());
}

Future<void> _initDatabaseClient() async => sl
    .registerSingleton<DataBaseClient>(DataBaseClient.instance..initDatabase());
