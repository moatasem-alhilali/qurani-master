part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class SetStateEvent extends BookEvent {}

class GetBookEvent extends BookEvent {}
