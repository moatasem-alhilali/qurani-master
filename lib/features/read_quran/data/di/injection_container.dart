import 'package:get_it/get_it.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';
import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/data_source/surah_data_source.dart';
import 'package:quran_app/features/read_quran/data/data_source/surah_verse_reader_data_source.dart';
import 'package:quran_app/features/read_quran/data/data_source/verse_reader_data_source.dart';

Future<void> registerQuranDependencies(GetIt getIt) async {
  getIt
    ..registerSingleton<FullQuranDataClient>(
      FullQuranDataClient.instance..initDatabase(),
    )
    ..registerLazySingleton<SurahDataSource>(
      () => SurahDataSource(
        getIt<FullQuranDataClient>(),
      ),
    )
    ..registerLazySingleton<AyahDataSource>(
      () => AyahDataSource(
        getIt<FullQuranDataClient>(),
      ),
    )
    ..registerLazySingleton<VerseReaderDataSource>(
      () => VerseReaderDataSource(
        getIt<FullQuranDataClient>(),
      ),
    )
    ..registerLazySingleton<SurahVerseReaderDataSource>(
      () => SurahVerseReaderDataSource(
        getIt<FullQuranDataClient>(),
      ),
    );
}
