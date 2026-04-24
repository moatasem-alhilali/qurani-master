import 'package:get_it/get_it.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';

Future<void> registerQuranDependencies(GetIt getIt) async {
  getIt
      //   ..registerSingleton<FullQuranDataClient>(
      //     FullQuranDataClient.instance..initDatabase(),
      //   )
      //   ..registerLazySingleton<SurahDataSource>(
      //     () => SurahDataSource(
      //       getIt<FullQuranDataClient>(),
      //     ),
      //   )
      .registerLazySingleton<AyahDataSource>(
    AyahDataSource.new,
  );
  //   ..registerLazySingleton<VerseReaderDataSource>(
  //     () => VerseReaderDataSource(
  //       getIt<FullQuranDataClient>(),
  //     ),
  //   )
  //   ..registerLazySingleton<SurahVerseReaderDataSource>(
  //     () => SurahVerseReaderDataSource(
  //       getIt<FullQuranDataClient>(),
  //     ),
  //   );
}
