part of 'read_quran_bloc.dart';

@immutable
abstract class ReadQuranEvent {}

class LoadQuranEvent extends ReadQuranEvent {}
class ToggleEvent extends ReadQuranEvent {}

class SetStateRBlocEvent extends ReadQuranEvent {}

