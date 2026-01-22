part of '../../tafsir.dart';

class _StorageConstants {
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
