part of '/quran.dart';

/// هذا الموديل يمثل صفحة من صفحات القرآن ويحتوي على قائمة من الآيات (AyahModel) والأسطر (LineModel)
/// This model represents a Quran page and contains a list of ayahs (AyahModel) and lines (LineModel)
class QuranPageModel {
  final int pageNumber;
  int numberOfNewSurahs;
  List<AyahModel> ayahs; // قائمة الآيات الموحدة
  List<LineModel> lines; // قائمة الأسطر، كل سطر يحتوي على آيات موحدة
  int? hizb;
  bool hasSajda, lastLine;

  QuranPageModel({
    required this.pageNumber,
    required this.ayahs, // يجب أن تكون من نوع AyahModel
    required this.lines, // يجب أن تحتوي كل LineModel على AyahModel
    this.hizb,
    this.hasSajda = false,
    this.lastLine = false,
    this.numberOfNewSurahs = 0,
  });
}

/// هذا الموديل يمثل سطر في صفحة القرآن ويحتوي على قائمة من الآيات الموحدة
/// This model represents a line in a Quran page and contains a list of unified ayahs
class LineModel {
  List<AyahModel> ayahs; // قائمة الآيات الموحدة في السطر
  bool centered;

  LineModel(this.ayahs, {this.centered = false});
}
