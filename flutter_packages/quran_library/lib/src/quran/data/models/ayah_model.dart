part of '/quran.dart';
// ayah_model.dart
// دمج خصائص موديلات الآية من ملفات json المختلفة في موديل واحد موحد
// Unified model for Ayah from both original and downloaded fonts JSON files

/// موديل موحد للآية في القرآن يدعم كل من بيانات الخطوط الأصلية والمنزلة
/// Unified Ayah model for both original and downloaded fonts data
class AyahModel {
  // رقم الآية الموحد (قد يكون مختلف التسمية حسب المصدر)
  // Unified Ayah number (may differ in naming by source)
  final int ayahUQNumber;
  final int ayahNumber;
  String text;
  final String ayaTextEmlaey;
  final int juz;
  final int page;
  final int? surahNumber;
  final int? lineStart;
  final int? lineEnd;
  final int? quarter;
  final int? hizb;
  final String? englishName;
  final String? arabicName;
  final bool? sajdaBool;
  final dynamic sajda;
  final Color? singleAyahTextColor;
  final bool? centered;

  // متغير يحدد إذا كانت البيانات من ملف الخطوط المنزلة
  // Variable to determine if data is from downloaded fonts JSON
  final bool isDownloadedFonts;

  AyahModel({
    required this.ayahUQNumber,
    required this.ayahNumber,
    required this.text,
    required this.ayaTextEmlaey,
    required this.juz,
    required this.page,
    this.surahNumber,
    this.lineStart,
    this.lineEnd,
    this.quarter,
    this.hizb,
    this.englishName,
    this.arabicName,
    this.sajdaBool,
    this.sajda,
    this.singleAyahTextColor,
    this.centered,
    required this.isDownloadedFonts,
  });

  /// Factory لإنشاء الموديل من json الخاص بالخطوط المنزلة
  /// Factory to create model from downloaded fonts JSON
  factory AyahModel.fromDownloadedFontsJson(Map<String, dynamic> json) {
    return AyahModel(
      ayahUQNumber: json['number'],
      ayahNumber: json['numberInSurah'],
      text: json['text'] ?? '',
      ayaTextEmlaey: json['aya_text_emlaey'] ?? '',
      juz: json['juz'],
      page: json['page'],
      hizb: json['hizbQuarter'],
      sajda: json['sajda'],
      singleAyahTextColor: json['singleAyahTextColor'],
      isDownloadedFonts: true,
      surahNumber: null,
      lineStart: null,
      lineEnd: null,
      quarter: null,
      englishName: null,
      arabicName: null,
      sajdaBool: null,
      centered: null,
    );
  }

  /// Factory لإنشاء الموديل من json الأصلي
  /// Factory to create model from original JSON
  factory AyahModel.fromOriginalJson(Map<String, dynamic> json) {
    // معالجة نص الآية كما في الموديل القديم
    String ayahText = json['aya_text'];
    if (ayahText[ayahText.length - 1] == '\n') {
      ayahText = ayahText.insert(' ', ayahText.length - 1);
    } else {
      ayahText = '$ayahText ';
    }
    return AyahModel(
      ayahUQNumber: json['id'],
      ayahNumber: json['aya_no'],
      text: ayahText,
      ayaTextEmlaey: json['aya_text_emlaey'] ?? '',
      juz: json['jozz'],
      page: json['page'],
      surahNumber: json['sura_no'] ?? json['sora'] ?? 0,
      lineStart: json['line_start'],
      lineEnd: json['line_end'],
      quarter: json['quarter'] ?? -1,
      hizb: json['hizb'] ?? -1,
      englishName: json['sura_name_en'] ?? json['sora_name_en'],
      arabicName: json['sura_name_ar'] ?? json['sora_name_ar'],
      sajdaBool: false,
      sajda: null,
      singleAyahTextColor: null,
      centered: json['centered'] ?? false,
      isDownloadedFonts: false,
    );
  }

  factory AyahModel.empty() {
    return AyahModel(
      ayahUQNumber: 0,
      ayahNumber: 0,
      text: '',
      ayaTextEmlaey: '',
      juz: 0,
      page: 0,
      surahNumber: 0,
      lineStart: 0,
      lineEnd: 0,
      quarter: 0,
      hizb: 0,
      englishName: '',
      arabicName: '',
      sajdaBool: false,
      sajda: null,
      singleAyahTextColor: null,
      centered: false,
      isDownloadedFonts: false,
    );
  }

  /// دالة مصنع لإنشاء نسخة جديدة من الآية مع نص أو خصائص معدلة
  /// Factory to create a new instance from an existing ayah with custom text, ayaTextEmlaey, and centered
  factory AyahModel.fromAya({
    required AyahModel ayah,
    required String aya,
    required String ayaText,
    bool? centered,
  }) {
    return AyahModel(
      ayahUQNumber: ayah.ayahUQNumber,
      ayahNumber: ayah.ayahNumber,
      text: aya,
      ayaTextEmlaey: ayaText,
      juz: ayah.juz,
      page: ayah.page,
      surahNumber: ayah.surahNumber,
      lineStart: ayah.lineStart,
      lineEnd: ayah.lineEnd,
      quarter: ayah.quarter,
      hizb: ayah.hizb,
      englishName: ayah.englishName,
      arabicName: ayah.arabicName,
      sajdaBool: ayah.sajdaBool,
      sajda: ayah.sajda,
      singleAyahTextColor: ayah.singleAyahTextColor,
      centered: centered ?? ayah.centered,
      isDownloadedFonts: ayah.isDownloadedFonts,
    );
  }

  /// مثال آمن لاستخدام centered في الكود:
  /// Safe example for using centered in code:
  ///
  /// if ((aya.centered ?? false) && i == lines.length - 2) {
  ///   centered = true;
  /// }
  ///
  /// هذا يضمن عدم حدوث خطأ إذا كانت centered غير موجودة في json
  /// This ensures no error if centered is missing in json
}

/// موديل موحد للسورة يربط مع AyahModel
/// Unified Surah model linked with AyahModel
class SurahModel {
  final int surahNumber;
  final String arabicName;
  final String englishName;
  final String? revelationType;
  List<AyahModel> ayahs;
  final bool isDownloadedFonts;
  final int? startPage;
  int? endPage;

  SurahModel({
    required this.surahNumber,
    required this.arabicName,
    required this.englishName,
    this.revelationType,
    required this.ayahs,
    required this.isDownloadedFonts,
    this.startPage,
    this.endPage,
  });

  /// Factory لإنشاء السورة من json الخطوط المنزلة
  /// Factory to create surah from downloaded fonts JSON
  factory SurahModel.fromDownloadedFontsJson(Map<String, dynamic> json) {
    var ayahsFromJson = json['ayahs'] as List;
    List<AyahModel> ayahsList =
        ayahsFromJson.map((i) => AyahModel.fromDownloadedFontsJson(i)).toList();
    return SurahModel(
      surahNumber: json['number'],
      arabicName: json['name'],
      englishName: json['englishName'],
      revelationType: json['revelationType'],
      ayahs: ayahsList,
      isDownloadedFonts: true,
      startPage: json['start_page'],
      endPage: json['end_page'],
    );
  }

  /// Factory لإنشاء السورة من json الأصلي
  /// Factory to create surah from original JSON
  factory SurahModel.fromOriginalJson(Map<String, dynamic> json) {
    var ayahsFromJson = json['ayahs'] as List;
    List<AyahModel> ayahsList =
        ayahsFromJson.map((i) => AyahModel.fromOriginalJson(i)).toList();
    return SurahModel(
      surahNumber: json['index'],
      arabicName: json['name_ar'],
      englishName: json['name_en'],
      revelationType: null,
      ayahs: ayahsList,
      isDownloadedFonts: false,
      startPage: json['start_page'],
      endPage: json['end_page'],
    );
  }
}
