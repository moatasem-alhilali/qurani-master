import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';

abstract class AllahNamesState {}

class AllahNamesInitial extends AllahNamesState {}

class AllahNamesLoading extends AllahNamesState {}

class AllahNamesLoaded extends AllahNamesState {
  final List<AllahNameModel> data;
  AllahNamesLoaded(this.data);
}

class AllahNamesError extends AllahNamesState {
  final String message;
  AllahNamesError(this.message);
}
