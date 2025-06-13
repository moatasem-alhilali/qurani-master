import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'allah_names_event.dart';
import 'allah_names_state.dart';

class AllahNamesBloc extends Bloc<AllahNamesEvent, AllahNamesState> {
  AllahNamesBloc() : super(AllahNamesInitial()) {
    on<LoadAllahNamesEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadAllahNamesEvent event, Emitter<AllahNamesState> emit) async {
    emit(AllahNamesLoading());

    try {
      final String jsonStr =
          await rootBundle.loadString('assets/json/allah_names.json');

      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;

      final names = list
          .map((e) => AllahNameModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(AllahNamesLoaded(names));
    } catch (e) {
      emit(AllahNamesError("Failed to load Allah names."));
    }
  }
}
