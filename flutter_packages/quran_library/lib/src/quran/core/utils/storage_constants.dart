part of '/quran.dart';

class _StorageConstants {
  final String bookmarks = 'bookmarks';
  final String lastPage = 'last_page';
  final String isDownloadedCodeV4Fonts = 'isDownloadedCodeV4Fonts';
  // final String isDownloadedCodeV2Fonts = 'isDownloadedCodeV2Fonts';
  final String fontsSelected = 'fontsSelected2';
  final String isTajweed = 'isTajweed';
  final String fontsDownloadedList = 'fontsDownloadedList';
  final String loadedFontPages = 'loadedFontPages';
  final String isBold = 'IS_BOLD_BOOL';

  /// Tafsir & Translation Constants
  final String radioValue = 'TAFSEER_VAL';
  final String tafsirTableValue = 'TAFSEER_TABLE_VAL';
  final String translationLangCode = 'TRANS';
  final String translationValue = 'TRANSLATE_VALUE';
  final String isTafsir = 'IS_TAFSEER';
  final String fontSize = 'FONT_SIZE';

  ///Singleton factory
  static final _StorageConstants _instance = _StorageConstants._internal();

  factory _StorageConstants() {
    return _instance;
  }

  _StorageConstants._internal();
}
