part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent {}

class ToggleBookmarkEvent extends BookmarkEvent {}

class SetStateBookmarkEvent extends BookmarkEvent {}

class AddBookmarkEvent extends BookmarkEvent {
  BookmarksAyahs bookmarksAyahs;
  AddBookmarkEvent(this.bookmarksAyahs);
}
class DeleteBookmarkEvent extends BookmarkEvent {
  int ayahUQNum;
  int surahNumber;
  DeleteBookmarkEvent(this.ayahUQNum,this.surahNumber);
}
