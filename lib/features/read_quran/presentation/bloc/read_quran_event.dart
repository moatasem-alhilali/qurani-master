part of 'read_quran_bloc.dart';

@immutable
abstract class ReadQuranEvent {}

class LoadQuranEvent extends ReadQuranEvent {}

class ToggleEvent extends ReadQuranEvent {}

class SetStateRBlocEvent extends ReadQuranEvent {}

//set page
class SetLastPageReadEvent extends ReadQuranEvent {
  SetLastPageReadEvent({required this.page});
  final int page;
}
