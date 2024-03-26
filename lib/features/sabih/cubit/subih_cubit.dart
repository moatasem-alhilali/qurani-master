import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/sabih/model/subih_model.dart';

part 'subih_state.dart';

class SubihCubit extends Cubit<SubihState> {
  SubihCubit() : super(AddSubihSuccessState());
  static SubihCubit get(context) => BlocProvider.of(context);
//add
  void addSubih({
    required String count,
    required String date,
    required String text,
  }) async {
    emit(AddSubihLoadingState());
    SubihModel subihModel = SubihModel(
      count: "count",
      date: "date",
      text: "text",
    );
    try {
      // final res = await DBHelperAudio.addTasbih(subihModel);
      // print(res);
      // getAllSubih();
      emit(AddSubihSuccessState());
    } catch (e) {
      print(e);
      emit(AddSubihErrorState());
    }
  }
  //get

  void getAllSubih() async {
    emit(GetSubihLoadingState());
    try {
      // await DBHelperAudio.getAllTusbih();
      emit(GetSubihSuccessState());
    } catch (e) {
      emit(GetSubihErrorState());
    }
  }
}
