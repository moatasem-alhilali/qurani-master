import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/my_adia/core/db/db_helper_note.dart';

part 'adia_cubit_state.dart';

class AdiaCubit extends Cubit<AdiaCubitState> {
  AdiaCubit() : super(AdiaCubitInitial());
  static AdiaCubit get(context) => BlocProvider.of(context);

  List<DoaModel> doaList = [];
  void addDua({String? title, String? content}) {
    DoaModel doaModel = DoaModel(content: content, title: title);

    DBHelperDou.addNote(doaModel).then((value) {
      getDoa();
      emit(AddDoaState());
    }).catchError((onError) {
      emit(AddDoaErrorState());
    });
  }

  void getDoa() {
    doaList = [];
    DBHelperDou.getAllData().then((value) {
      value.forEach((element) {
        doaList.add(DoaModel.fromJson(element));
      });
      emit(GetDoaState());
    }).catchError((onError) {
      print(onError);
      emit(GetDoaErrorState());
    });
  }

  void deleteDoa({DoaModel? doaModel}) {
    DBHelperDou.deleteDoa(doaModel!).then((value) {
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
    DBHelperDou.updateNote(doaModel).then((value) {
      emit(EditDoaState());
      getDoa();
    }).catchError((onError) {
      print(onError);
      emit(EditDoaErrorState());
    });
  }
}
