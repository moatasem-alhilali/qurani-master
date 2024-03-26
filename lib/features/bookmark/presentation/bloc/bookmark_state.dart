part of 'bookmark_bloc.dart';

@immutable
class BookmarkState {
  RequestState setState;
  BookmarkState({this.setState = RequestState.defaults});
}
