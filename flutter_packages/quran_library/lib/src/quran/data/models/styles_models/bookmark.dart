part of '/quran.dart';

/// A model class that represents a single bookmark in the Quran.
///
/// This class contains properties that identify the bookmarked Ayah
/// in the Quran, such as the Surah number and Ayah number in the
/// Quran.
///
/// The [BookmarkModel] class is used to store and retrieve bookmarks
/// in the Quran.
class BookmarkModel {
  /// The unique identifier of the bookmark in the Quran.
  ///
  /// This identifier is used to distinguish each bookmark from others.
  final int id;

  /// The color code of the bookmark.
  ///
  /// This color code is used to display the bookmark in the correct color.
  ///
  /// Example:
  /// ```dart
  /// final bookmarkColorCode = 0xFF123456;
  /// ```
  ///
  final int colorCode;

  /// The identifier of the Ayah in the Quran that is bookmarked.
  ///
  /// This identifier is used to retrieve the correct Ayah when the
  /// bookmark is opened.
  int ayahId;

  /// The number of the Ayah in the Surah.
  ///
  /// This number identifies the Ayah within its Surah and is used to
  /// locate the specific verse in the Quran.
  int ayahNumber;

  /// The page number in the Quran that the bookmarked Ayah is located.
  ///
  /// This page number is used to display the correct page when the
  /// bookmark is opened.
  int page;

  /// The name of the bookmark.
  ///
  /// This name is used to identify the bookmark when it is displayed
  /// in the application.
  final String name;

  /// Creates a new instance of [BookmarkModel].
  ///
  /// The [id] must be provided.
  ///
  /// The [colorCode] is the color code of the bookmark.
  ///
  /// The [name] is the name of the bookmark.
  ///
  /// The [ayahId] is the identifier of the Ayah in the Quran that is bookmarked.
  /// The [ayahNumber] is the number of the Ayah in the Surah.
  /// The [page] is the page number in the Quran that the bookmarked Ayah is located.
  ///
  /// If [ayahId], [ayahNumber], or [page] are not provided, they will be set to -1.
  BookmarkModel({
    required this.id,
    required this.colorCode,
    required this.name,
    this.ayahId = -1,
    this.ayahNumber = -1,
    this.page = -1,
  });

  Map<String, dynamic> _toJson() => {
        'id': id,
        'ayahId': ayahId,
        'ayahNumber': ayahNumber,
        'page': page,
        'color': colorCode,
        'name': name,
      };

  factory BookmarkModel._fromJson(Map<String, dynamic> json) => BookmarkModel(
        id: json['id'],
        colorCode: json['color'],
        name: json['name'] ?? 'Unnamed Bookmark',
        ayahId: json['ayahId'] ?? -1,
        ayahNumber: json['ayahNumber'] ?? -1,
        page: json['page'] ?? -1,
      );
}

/// A model class that represents a single bookmark in the Quran.
///
/// This class contains properties that identify the bookmarked Ayah
/// in the Quran, such as the Surah number and Ayah number in the
/// Quran.
///
/// The [BookmarksAyahs] class is used to store and retrieve bookmarks
/// in the Quran.
class BookmarksAyahs {
  /// The unique identifier for the bookmark in the Quran.
  ///
  /// This identifier is used to differentiate between different bookmarks
  /// in the Quran.
  final int? id;

  /// The unique identifier for the Ayah in the Quran.
  final int ayahUQNumber;

  /// The number of the Surah in the Quran.
  final int surahNumber;

  /// The name of the Surah in the Quran.
  ///
  /// This property is useful for displaying the name of the Surah that
  /// the bookmarked Ayah belongs to.
  final String? surahName;

  /// The page number in the Quran that the bookmarked Ayah is located.
  ///
  /// This property is useful for displaying the correct page when the
  /// bookmark is opened.
  final int? pageNumber;

  /// The number of the Ayah in the Surah.
  ///
  /// This property is useful for displaying the correct Ayah number when the
  /// bookmark is opened.
  final int? ayahNumber;

  /// The last read timestamp for the bookmarked Ayah.
  ///
  /// This property is used to keep track of when the Ayah was last read,
  /// which can be useful for reading history and tracking progress.
  final String? lastRead;
  // final int? bookMarkColorCode;

  /// Creates a new instance of [BookmarksAyahs].
  ///
  /// The [id], [ayahUQNumber], [surahNumber], [surahName], [pageNumber],
  /// [ayahNumber], and [lastRead] must be provided.
  ///
  /// The [id] is the unique identifier for the bookmark in the Quran.
  ///
  /// The [ayahUQNumber] is the unique identifier for the Ayah in the Quran.
  ///
  /// The [surahNumber] is the number of the Surah in the Quran.
  ///
  /// The [surahName] is the name of the Surah in the Quran.
  ///
  /// The [pageNumber] is the page number in the Quran that the bookmarked Ayah is located.
  ///
  /// The [ayahNumber] is the number of the Ayah in the Surah.
  ///
  /// The [lastRead] is the last read timestamp for the bookmarked Ayah.
  BookmarksAyahs({
    this.id,
    required this.ayahUQNumber,
    required this.surahNumber,
    this.surahName,
    this.pageNumber,
    this.ayahNumber,
    this.lastRead,
    // this.bookMarkColorCode,
  });
}
