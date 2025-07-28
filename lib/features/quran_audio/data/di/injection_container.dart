import 'package:get_it/get_it.dart';
import 'package:quran_app/core/bloc/generic/query/query_bloc.dart';
import 'package:quran_app/features/read_quran/data/data_source/surah_verse_reader_data_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/data/repo/surah_verse_reader_data_repo.dart';

typedef SurahVerseReaderBloc = QueryBloc<List<SurahVerseReaderModel>, void>;

Future<void> registerSurahVerseReaderDependencies(GetIt getIt) async {
  getIt
    ..registerLazySingleton<SurahVerseReaderDataRepo>(
      () => SurahVerseReaderDataRepo(
        getIt<SurahVerseReaderDataSource>(),
      ),
    )
    // Stage bloc for handling stage
    ..registerFactory<SurahVerseReaderBloc>(
      () => QueryBloc(
        fetch: (_) async => getIt<SurahVerseReaderDataRepo>().getAll(),
      ),
    );
}
