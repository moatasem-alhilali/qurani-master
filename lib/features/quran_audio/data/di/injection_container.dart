import 'package:get_it/get_it.dart';
import 'package:quran_app/core/bloc/generic/query/query_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

typedef SurahVerseReaderBloc = QueryBloc<List<SurahVerseReaderModel>, void>;

Future<void> registerSurahVerseReaderDependencies(GetIt getIt) async {}
