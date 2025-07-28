import 'package:get_it/get_it.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';

Future<void> registerHomeDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<RandomAyahBloc>(
    () => RandomAyahBloc(
      ayahDataSource: getIt<AyahDataSource>(),
    ),
  );
}
