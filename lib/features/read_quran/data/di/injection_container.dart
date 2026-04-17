import 'package:get_it/get_it.dart';

Future<void> registerQuranDependencies(GetIt getIt) async {
  // getIt
  //   ..registerSingleton<FullQuranDataClient>(
  //     FullQuranDataClient.instance..initDatabase(),
  //   )
  //   ..registerLazySingleton<SurahDataSource>(
  //     () => SurahDataSource(
  //       getIt<FullQuranDataClient>(),
  //     ),
  //   )
  //   ..registerLazySingleton<AyahDataSource>(
  //     () => AyahDataSource(
  //       getIt<FullQuranDataClient>(),
  //     ),
  //   )
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
