part of 'book_bloc.dart';

@immutable
class BookState {
  //
  List<dynamic> books;
  RequestState getState;
  RequestState loadMoreState;

  BookState({
    //
    this.getState = RequestState.defaults,
    this.books = const [],
    this.loadMoreState = RequestState.defaults,
  });

  BookState copyWith({
    RequestState? getState,
    RequestState? loadMoreState,
    List<dynamic>? books,
  }) {
    return BookState(
      books: books ?? this.books,
      getState: getState ?? this.getState,
      loadMoreState: loadMoreState ?? this.loadMoreState,
    );
  }
}
