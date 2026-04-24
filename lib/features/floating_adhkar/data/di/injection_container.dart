import 'package:get_it/get_it.dart';
import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_built_in_source.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_overlay_controller.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';

Future<void> registerFloatingAdhkarDependencies(GetIt getIt) async {
  getIt
    ..registerLazySingleton<FloatingAdhkarDatabaseService>(
      FloatingAdhkarDatabaseService.new,
    )
    ..registerLazySingleton<FloatingAdhkarBuiltInSource>(
      FloatingAdhkarBuiltInSource.new,
    )
    ..registerLazySingleton<FloatingAdhkarSelector>(
      FloatingAdhkarSelector.new,
    )
    ..registerLazySingleton<FloatingAdhkarOverlayController>(
      FloatingAdhkarOverlayController.new,
    )
    ..registerLazySingleton<FloatingAdhkarRepository>(
      () => FloatingAdhkarRepository(
        databaseService: getIt<FloatingAdhkarDatabaseService>(),
        builtInSource: getIt<FloatingAdhkarBuiltInSource>(),
        selector: getIt<FloatingAdhkarSelector>(),
      ),
    )
    ..registerFactory<FloatingAdhkarBloc>(
      () => FloatingAdhkarBloc(
        repository: getIt<FloatingAdhkarRepository>(),
        overlayController: getIt<FloatingAdhkarOverlayController>(),
      ),
    );
}
