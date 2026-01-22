part of '../tafsir.dart';

extension TafsirUi on TafsirCtrl {
  /// -------- [onTap] --------

  /// شرح: نسخ نص التفسير مع الآية
  /// Explanation: Copy tafsir text with ayah
  // Future<void> copyOnTap(int ayahUQNumber) async {
  //   await Clipboard.setData(ClipboardData(
  //           text:
  //               '﴿${ayahTextNormal.value}﴾\n\n${tafseerList[ayahUQNumber].tafsirText.customTextSpans()}'))
  //       .then(
  //           (value) => ToastUtils().showToast(Get.context!, 'copyTafseer'.tr));
  // }

  /// شرح: تغيير التفسير أو الترجمة عند تغيير الاختيار
  /// Explanation: Change tafsir/translation when selection changes
  Future<void> handleRadioValueChanged(int val, {int? pageNumber}) async {
    if (radioValue.value == val) {
      return;
    }
    radioValue.value = val;
    log('start changing Tafsir', name: 'TafsirUi');
    box.write(_StorageConstants().radioValue, val);
    if (!tafsirAndTranslationsItems[val].isTranslation) {
      box.write(_StorageConstants().isTafsir, true);
      try {
        await fetchData(
            pageNumber ?? QuranCtrl.instance.state.currentPageNumber.value);
      } catch (e) {
        log('Error changing tafsir: $e', name: 'TafsirUi');
        // التأكد من أن radioValue تم تحديثه للقيمة الصحيحة
        box.write(_StorageConstants().radioValue, radioValue.value);
      }
    } else {
      String langCode = tafsirAndTranslationsItems[val].fileName;
      translationLangCode = langCode;
      await fetchTranslate();
      box.write(_StorageConstants().translationLangCode, langCode);
      box.write(_StorageConstants().isTafsir, false);
      tafseerList.clear(); // شرح: مسح قائمة التفسير عند اختيار الترجمة
    }
    update(['tafsirs_menu_list', 'change_font_size', 'actualTafsirContent']);
    // update(['ActualTafsirWidget']);
  }
}
