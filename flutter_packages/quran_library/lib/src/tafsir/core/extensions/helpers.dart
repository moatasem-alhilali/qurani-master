import '../../tafsir.dart';

extension Helpers on TafsirCtrl {
  bool get isCurrentATranslation =>
      radioValue.value >= translationsStartIndex &&
      radioValue.value < tafsirAndTranslationsItems.length;

  bool get isCurrentNotAsqlTafsir =>
      !isCurrentATranslation &&
      (tafsirAndTranslationsItems[radioValue.value].type !=
          TafsirFileType.json);

  bool get isCurrentAcustomTafsir =>
      !isCurrentATranslation &&
      (tafsirAndTranslationsItems[radioValue.value].isCustom);
}
