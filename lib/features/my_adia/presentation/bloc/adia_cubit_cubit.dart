import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/my_adia/data/model/doa_model.dart';
import 'package:quran_app/features/my_adia/data/database/database_doa_service.dart';

part 'adia_cubit_state.dart';

class AdiaCubit extends Cubit<AdiaCubitState> {
  AdiaCubit() : super(AdiaCubitInitial());
  static AdiaCubit get(BuildContext context) => BlocProvider.of(context);

  final _doaService = DatabaseDoaService();

  List<DoaModel> doaList = [];

  Future<void> addDua({String? title, String? content}) async {
    try {
      final doa = DoaModel(title: title, content: content);
      await _doaService.addDoa(doa);
      await getDoa();
      emit(AddDoaState());
    } catch (e) {
      emit(AddDoaErrorState());
    }
  }

  Future<void> getDoa() async {
    try {
      doaList = await _doaService.getAllDoa();
      emit(GetDoaState());
    } catch (e) {
      print(e);
      emit(GetDoaErrorState());
    }
  }

  Future<void> deleteDoa({required DoaModel doaModel}) async {
    try {
      await _doaService.deleteDoa(doaModel.id!);
      await getDoa();
      emit(DeleteDoaState());
    } catch (e) {
      print(e);
      emit(DeleteDoaErrorState());
    }
  }

  Future<void> editDoa({String? title, String? content, int? id}) async {
    try {
      final doa = DoaModel(id: id, title: title, content: content);
      await _doaService.updateDoa(doa);
      await getDoa();
      emit(EditDoaState());
    } catch (e) {
      print(e);
      emit(EditDoaErrorState());
    }
  }
}
