part of 'old_read_quran_bloc.dart';

@immutable
abstract class OldReadQuranEvent {}

class OldLoadQuranEvent extends OldReadQuranEvent {}

class OldToggleEvent extends OldReadQuranEvent {}

class OldSetStateRBlocEvent extends OldReadQuranEvent {}

class OldToggleHighBoxEvent extends OldReadQuranEvent {
  OldToggleHighBoxEvent({this.minusHeight = 300});
  final double minusHeight;
}

//set page
class OldSetLastPageReadEvent extends OldReadQuranEvent {
  OldSetLastPageReadEvent({required this.page});
  final int page;
}

// Jump to page
class OldJumpToPageEvent extends OldReadQuranEvent {
  OldJumpToPageEvent({this.page});
  final int? page;
}

// toggle box
class OldToggleBoxEvent extends OldReadQuranEvent {}
