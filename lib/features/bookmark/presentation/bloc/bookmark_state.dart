// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bookmark_bloc.dart';

@immutable
class BookmarkState {
  const BookmarkState({
    this.setState = RequestState.initial,
    this.isPageBookmarked = false,
    this.isPageBookmarkedAyah = false,
    this.pageBookmarksList = const [],
    this.ayahBookmarkList = const [],
    this.error,
  });
  final RequestState setState;
  final String? error;
  final bool isPageBookmarked;
  final bool isPageBookmarkedAyah;
  final List<BookmarkPageModel> pageBookmarksList;
  final List<BookmarkAyahModel> ayahBookmarkList;

  // ─────────────────────── COPY WITH ───────────────────────
  BookmarkState copyWith({
    RequestState? setState,
    String? error,
    bool? isPageBookmarked,
    bool? isPageBookmarkedAyah,
    List<BookmarkPageModel>? pageBookmarksList,
    List<BookmarkAyahModel>? ayahBookmarkList,
  }) {
    return BookmarkState(
      setState: setState ?? this.setState,
      error: error ?? this.error,
      isPageBookmarked: isPageBookmarked ?? this.isPageBookmarked,
      isPageBookmarkedAyah: isPageBookmarkedAyah ?? this.isPageBookmarkedAyah,
      pageBookmarksList: pageBookmarksList ?? this.pageBookmarksList,
      ayahBookmarkList: ayahBookmarkList ?? this.ayahBookmarkList,
    );
  }
}
