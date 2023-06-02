part of 'adia_cubit_cubit.dart';

@immutable
abstract class AdiaCubitState {}

class AdiaCubitInitial extends AdiaCubitState {}
class AddDoaState extends AdiaCubitState {}
class AddDoaErrorState extends AdiaCubitState {}
class GetDoaState extends AdiaCubitState {}
class GetDoaErrorState extends AdiaCubitState {}
class DeleteDoaState extends AdiaCubitState {}

class DeleteDoaErrorState extends AdiaCubitState {}
class EditDoaState extends AdiaCubitState {}

class EditDoaErrorState extends AdiaCubitState {}
