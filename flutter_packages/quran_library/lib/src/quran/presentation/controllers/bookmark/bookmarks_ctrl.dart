part of '/quran.dart';

/// Controller that handles the bookmarks of the user.
///
/// This controller is a singleton and can be accessed through
/// [BookmarksCtrl.instance].
///
/// It provides methods to add, remove and get bookmarks.
///
/// The bookmarks are stored in the device's storage and are loaded
/// when the app starts.
///
/// The [BookmarksCtrl] is also responsible for updating the UI when
/// the bookmarks change.
class BookmarksCtrl extends GetxController {
  /// The singleton instance of [BookmarksCtrl].
  ///
  /// This is the instance that is created and used by the app.
  ///
  /// It is a singleton because it is the only instance of the
  /// [BookmarksCtrl] and is used everywhere in the app.
  static BookmarksCtrl get instance =>
      GetInstance().putOrFind(() => BookmarksCtrl());

  /// Constructor for [BookmarksCtrl].
  ///
  /// If a [QuranRepository] is provided, it is used; otherwise, a new instance
  /// of [QuranRepository] is created.
  BookmarksCtrl({QuranRepository? quranRepository})
      : _quranRepository = quranRepository ?? QuranRepository(),
        super();

  final QuranRepository _quranRepository;

  /// A map of color codes to lists of [BookmarkModel]s.
  ///
  /// The keys of the map are the color codes of the bookmarks, and the values
  /// are lists of [BookmarkModel]s that have that color code.
  ///
  /// The [bookmarks] map is used to store the bookmarks of the user.
  final Map<int, List<BookmarkModel>> bookmarks = {};

  /// A list of ayah Ids that have bookmarks.
  ///
  /// This list is created by flattening the [bookmarks] map, which is a map of
  /// color codes to lists of [BookmarkModel]s. The list contains the ayah Ids
  /// of all the bookmarks, and is used to check if an ayah has a bookmark or
  /// not.
  List<int> get bookmarksAyahs => bookmarks.values
      .expand((list) => list)
      .map((bookmark) => bookmark.ayahId)
      .toList();

  // final BookmarkModel _searchBookmark =
  //     BookmarkModel(id: 3, colorCode: 0xFFF7EFE0, name: 'search Bookmark');

  // final List<BookmarkModel> _defaultBookmarks = [
  //   BookmarkModel(id: 0, colorCode: 0xAAFFD354, name: 'العلامة الصفراء'),
  //   BookmarkModel(id: 1, colorCode: 0xAAF36077, name: 'العلامة الحمراء'),
  //   BookmarkModel(id: 2, colorCode: 0xAA00CD00, name: 'العلامة الخضراء'),
  // ];

  /// Initializes the bookmarks of the user.
  ///
  /// If [userBookmarks] is provided, it is used to initialize the bookmarks.
  /// If [overwrite] is true, the bookmarks are cleared and the [userBookmarks]
  /// are added to the map. Otherwise, the bookmarks are loaded from the
  /// storage and if there are no bookmarks, the default bookmarks are added.
  ///
  /// The bookmarks are saved to the storage after initialization.
  ///
  /// This method should be called once when the app starts, and before using
  /// any other methods of [BookmarksCtrl].
  void initBookmarks(
      {Map<int, List<BookmarkModel>>? userBookmarks, bool overwrite = false}) {
    if (overwrite) {
      bookmarks.clear();
      if (userBookmarks != null) {
        bookmarks.addAll(userBookmarks);
      }
    } else {
      final savedBookmarks = _quranRepository.getBookmarks();
      if (savedBookmarks.isEmpty) {
        // إذا لم توجد إشارات محفوظة، يمكن تحميل افتراضية
        bookmarks[0xAAFFD354] = []; // اللون الأصفر
        bookmarks[0xAAF36077] = []; // اللون الأحمر
        bookmarks[0xAA00CD00] = []; // اللون الأخضر
      } else {
        // قم بتجميع الإشارات المرجعية حسب colorCode
        for (var bookmark in savedBookmarks) {
          bookmarks.update(
            bookmark.colorCode,
            (existingList) => [...existingList, bookmark],
            ifAbsent: () => [bookmark],
          );
        }
      }
    }
    _quranRepository.saveBookmarks(_flattenBookmarks());
    update(['bookmarks']);
  }

  /// Saves a new bookmark to the list of bookmarks.
  ///
  /// The bookmark is created with a unique ID, the provided [colorCode],
  /// [surahName], [ayahId], [ayahNumber], and [page].
  ///
  /// The bookmark is added to the list of bookmarks with the same [colorCode],
  /// or a new list is created if there is no existing list.
  ///
  /// The bookmarks are saved to the storage after adding the new bookmark.
  ///
  /// Calls [QuranCtrl.update] after saving the bookmark.
  void saveBookmark({
    required String surahName,
    required int ayahId,
    required int ayahNumber,
    required int page,
    required int colorCode,
  }) {
    final bookmark = BookmarkModel(
      id: DateTime.now().millisecondsSinceEpoch,
      // إنشاء ID فريد
      colorCode: colorCode,
      name: surahName,
      ayahNumber: ayahNumber,
      ayahId: ayahId,
      page: page,
    );

    // إضافة العلامة الجديدة إلى القائمة الموجودة
    bookmarks.update(
      colorCode,
      (existingList) => [...existingList, bookmark],
      ifAbsent: () => [bookmark], // إذا لم تكن هناك قائمة، أنشئ واحدة جديدة
    );

    _quranRepository.saveBookmarks(_flattenBookmarks());
    update(['bookmarks']);
    QuranCtrl.instance.update();
  }

  /// Removes a bookmark from the list of bookmarks.
  ///
  /// The bookmark is searched in all the lists, and if found, it is removed.
  ///
  /// The bookmarks are saved to the storage after removing the bookmark.
  ///
  /// Calls [QuranCtrl.update] after removing the bookmark.
  void removeBookmark(int bookmarkId) {
    // البحث في جميع القوائم لإيجاد الشارة المراد حذفها
    bookmarks.forEach((colorCode, list) {
      bookmarks.update(
        colorCode,
        (existingList) => existingList
            .where((bookmark) => bookmark.id != bookmarkId)
            .toList(),
      );
    });

    _quranRepository.saveBookmarks(_flattenBookmarks());
    update(['bookmarks']);
    QuranCtrl.instance.update();
  }

  // تحويل العلامات إلى قائمة مسطحة لحفظها في التخزين
  List<BookmarkModel> _flattenBookmarks() {
    return bookmarks.values.expand((list) => list).toList();
  }

  /// Checks if the given bookmark list contains a bookmark with the given Surah number and Ayah UQ number.
  ///
  /// Returns:
  ///   `true` if the bookmark exists, `false` otherwise.
  // bool hasBookmark(int surahNum, int ayahUQNum, List? bookmarkList) =>
  //     (bookmarkList!.firstWhereOrNull(((element) =>
  //                 element.surahNumber == surahNum &&
  //                 element.ayahUQNumber == ayahUQNum)) !=
  //             null)
  //         ? true
  //         : false;
}
