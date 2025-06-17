import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_event.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_state.dart';

class AllahNamesBloc extends Bloc<AllahNamesEvent, AllahNamesState> {
  AllahNamesBloc() : super(AllahNamesInitial()) {
    on<LoadAllahNamesEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadAllahNamesEvent event,
    Emitter<AllahNamesState> emit,
  ) async {
    emit(AllahNamesLoading());

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.allahNamesPath,
      );

      final names = list.map(AllahNameModel.fromJson).toList();

      emit(AllahNamesLoaded(names));
    } catch (e) {
      emit(AllahNamesError('Failed to load Allah names.'));
    }
  }
}
