import 'package:get_it/get_it.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/radio/data/data_source/radio_local_data_source.dart';
import 'package:quran_app/features/radio/data/repo/radio_repository.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';

Future<void> registerRadioDependencies(GetIt getIt) async {
  getIt
    ..registerLazySingleton<RadioLocalDataSource>(
      () => RadioLocalDataSource(getIt<CacheService>()),
    )
    ..registerLazySingleton<RadioAudioService>(RadioAudioService.new)
    ..registerLazySingleton<RadioRepository>(
      () => RadioRepository(
        localDataSource: getIt<RadioLocalDataSource>(),
        audioService: getIt<RadioAudioService>(),
      ),
    )
    ..registerLazySingleton<RadioBloc>(
      () => RadioBloc(repository: getIt<RadioRepository>()),
    );
}
