part of 'subih_cubit.dart';

@immutable
abstract class SubihState {}

class SubihInitial extends SubihState {}

//add data state
class AddSubihSuccessState extends SubihState {}

class AddSubihLoadingState extends SubihState {}

class AddSubihErrorState extends SubihState {}

//get data state

class GetSubihSuccessState extends SubihState {}

class GetSubihLoadingState extends SubihState {}

class GetSubihErrorState extends SubihState {}
