part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent {}

class ToggleBookmarkPageEvent extends BookmarkEvent {}

class SetStateBookmarkEvent extends BookmarkEvent {}

// ─────────────────────── AYAH BOOKMARKS ───────────────────────

class GetBookmarksAyahEvent extends BookmarkEvent {}

class AddBookmarkAyahEvent extends BookmarkEvent {
  AddBookmarkAyahEvent(this.bookmarksAyah);
  final BookmarkAyahRequest bookmarksAyah;
}

class DeleteBookmarkAyahEvent extends BookmarkEvent {
  DeleteBookmarkAyahEvent(this.bookmarksAyah);
  final BookmarkAyahRequest bookmarksAyah;
}

// ─────────────────────── PAGE BOOKMARKS ───────────────────────

class AddBookmarkPageEvent extends BookmarkEvent {
  AddBookmarkPageEvent(this.bookmarksPage);
  final BookmarkPageRequest bookmarksPage;
}

class DeleteBookmarkPageEvent extends BookmarkEvent {
  DeleteBookmarkPageEvent(this.bookmarksPage);
  final BookmarkPageRequest bookmarksPage;
}

class GetBookmarksPageEvent extends BookmarkEvent {}
