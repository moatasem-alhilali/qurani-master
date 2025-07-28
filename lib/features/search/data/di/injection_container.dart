import 'package:get_it/get_it.dart';
import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/search/data/database/quran_search_datasource.dart';

Future<void> registerSearchDependencies(GetIt getIt) async {
  getIt

      // Remote Data Source
      .registerLazySingleton<QuranSearchDataSource>(
    () => QuranSearchDataSource(
      getIt<FullQuranDataClient>(),
    ),
  );
}
