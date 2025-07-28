import 'package:get_it/get_it.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/quran_plan/data/data_source/quran_plan_data_source.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';

Future<void> registerQuranPlanDependencies(GetIt getIt) async {
  getIt
    ..registerLazySingleton<QuranPlanDataSource>(
      () => QuranPlanDataSource(
        ayahDataSource: getIt<AyahDataSource>(),
        notificationService: getIt<NotificationService>(),
      ),
    )
    ..registerFactory<QuranPlanBloc>(
      () => QuranPlanBloc(
        getIt<QuranPlanDataSource>(),
      ),
    );
}
