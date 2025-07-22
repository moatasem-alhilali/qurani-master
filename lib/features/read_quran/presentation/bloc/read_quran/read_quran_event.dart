part of 'read_quran_bloc.dart';

@immutable
abstract class ReadQuranEvent {}

class LoadQuranEvent extends ReadQuranEvent {}

class ToggleEvent extends ReadQuranEvent {}

class SetStateRBlocEvent extends ReadQuranEvent {}

class ToggleHighBoxEvent extends ReadQuranEvent {
  ToggleHighBoxEvent({this.minusHeight = 300});
  final double minusHeight;
}

//set page
class SetLastPageReadEvent extends ReadQuranEvent {
  SetLastPageReadEvent({required this.page});
  final int page;
}

// Jump to page
class JumpToPageEvent extends ReadQuranEvent {
  JumpToPageEvent({this.page});
  final int? page;
}

// toggle box
class ToggleBoxEvent extends ReadQuranEvent {}
