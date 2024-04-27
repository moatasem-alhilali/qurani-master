import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/features/my_adia/doa_model.dart';

part 'adia_cubit_state.dart';

class AdiaCubit extends Cubit<AdiaCubitState> {
  AdiaCubit() : super(AdiaCubitInitial());
  static AdiaCubit get(context) => BlocProvider.of(context);

  List<DoaModel> doaList = [];
  void addDua({String? title, String? content}) {
    DoaModel doaModel = DoaModel(content: content, title: title);

    DBHelper.insert(
      'doua',
      doaModel.toMap(),
    ).then((value) {
      getDoa();
      emit(AddDoaState());
    }).catchError((onError) {
      emit(AddDoaErrorState());
    });
  }

  void getDoa() {
    doaList = [];
    DBHelper.get('doua').then((value) {
      for (var element in value) {
        doaList.add(DoaModel.fromJson(element));
      }
      emit(GetDoaState());
    }).catchError((onError) {
      print(onError);
      emit(GetDoaErrorState());
    });
  }

  void deleteDoa({DoaModel? doaModel}) {
    DBHelper.delete(
      'doua',
      where: 'id',
      whereArgs: [doaModel!.id!],
    ).then((value) {
      emit(DeleteDoaState());
      getDoa();
      print(value);
    }).catchError((onError) {
      print(onError);
      emit(DeleteDoaErrorState());
    });
  }

  void editDoa({String? title, String? content, int? id}) {
    DoaModel doaModel = DoaModel(content: content, title: title, id: id);
    DBHelper.update(
      'doua',
      doaModel.toMap(),
      doaModel.id!,
    ).then((value) {
      emit(EditDoaState());
      getDoa();
    }).catchError((onError) {
      print(onError);
      emit(EditDoaErrorState());
    });
  }
}
