extension StringExtensions on String {
  /// translation.. not implemented yet.
  // String get tr => this;

  String get convertArabicToEnglishNumbers {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String text = this;
    for (int i = 0; i < english.length; i++) {
      text = text.replaceAll(arabic[i], english[i]);
    }
    return text;
  }
}
