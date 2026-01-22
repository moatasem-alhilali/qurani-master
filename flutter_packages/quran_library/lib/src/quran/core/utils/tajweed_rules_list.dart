part of '../../../../quran.dart';

final List<Map<String, dynamic>> tajweedRules = [
  {
    'defaultLanguage': 'ar',
    'languages': ['ar', 'en', 'bn', 'id', 'ur', 'tr', 'ku', 'ms', 'es'],
    'rules': [
      {
        'index': 0,
        'color': 0xff999999,
        'darkColor': 0xff999999,
        'text': {
          'ar': 'إدغام ، وما لا يُلفَظ',
          'en': 'Silent letter',
          'bn': 'ইদগাম',
          'id': 'Idgham',
          'ur': 'ادغام',
          'tr': 'İdğam',
          'ku': 'Îdgam û tîpa bêdeng',
          'ms': 'Idgham (huruf senyap)',
          'es': 'Idgham (letra muda)',
        },
      },
      {
        'index': 1,
        'color': 0xffD0A421,
        'darkColor': 0xff4A76FB,
        'text': {
          'ar': 'مدّ حركتان',
          'en': 'Normal madd (2)',
          'bn': 'মাদ 2 সেকেন্ড',
          'id': 'Maad 2 detik',
          'ur': 'مد طبعی (2 حرکات)',
          'tr': '2 saniye bekle',
          'ku': 'Meddê asayî (2)',
          'ms': 'Mad biasa (2)',
          'es': 'Madd normal (2)',
        },
      },
      {
        'index': 2,
        'color': 0xffFE7D03,
        'darkColor': 0xffFE7D03,
        'text': {
          'ar': 'مدّ ٢ أو ٤ أو ٦ جوازا',
          'en': 'Separated madd (2/4/6)',
          'bn': 'অনুমোদিত মাদ 2 বা 4 বা 6 সেকেন্ড',
          'id': 'Diperbolehkan Maad 2 atau 4 atau 6 detik',
          'ur': 'مد جائز منفصل (2 یا 4 یا 6 حرکات)',
          'tr': 'İzin verilen Maad 2 veya 4 veya 6 saniye',
          'ku': 'Meddê veqetandî (2/4/6)',
          'ms': 'Mad terpisah (2/4/6)',
          'es': 'Madd separado (2/4/6)',
        },
      },
      {
        'index': 3,
        'color': 0xffFF4D8E,
        'darkColor': 0xff29FFFF,
        'text': {
          'ar': 'مدّ واجب ٤ أو ٥ حركات',
          'en': 'Connected madd (4/5)',
          'bn': 'প্রয়োজনীয় মাদ ৪ বা ৫ সেকেন্ড',
          'id': 'Diperlukan Maad 4 atau 5 detik',
          'ur': 'مد واجب متصل (4 یا 5 حرکات)',
          'tr': 'Gerekli Maad 4 veya 5 saniye',
          'ku': 'Meddê girêdayî (4/5)',
          'ms': 'Mad bersambung (4/5)',
          'es': 'Madd conectado (4/5)',
        },
      },
      {
        'index': 4,
        'color': 0xffE30000,
        'darkColor': 0xff1EA0FF,
        'text': {
          'ar': 'مدّ ٦ حركات لزوما',
          'en': 'Necessary madd (6)',
          'bn': 'প্রয়োজনীয় মাদ ৬ সেকেন্ড',
          'id': 'Perlu Maad 6 detik',
          'ur': 'مد لازم (6 حرکات)',
          'tr': 'Gerekli Maad 6 saniye',
          'ku': 'Meddê pêwîst (6)',
          'ms': 'Mad lazim (6)',
          'es': 'Madd necesario (6)',
        },
      },
      {
        'index': 5,
        'color': 0xff26B55D,
        'darkColor': 0xffFF6DFF,
        'text': {
          'ar': 'إخفاء ، ومواقع الغُنًّة (حركتان)',
          'en': 'Ghunna/ikhfa’',
          'bn': 'ইখফা ও ঘুন্না',
          'id': 'Ikhfa dan Ghunna',
          'ur': 'اخفاء اور غنہ',
          'tr': 'İhfa ve Ghunna',
          'ku': 'Ğunne / Îxfâ',
          'ms': 'Ghunna/Ikhfa’',
          'es': 'Ghunna/Ikhfa’',
        },
      },
      {
        'index': 6,
        'color': 0xff00DEFF,
        'darkColor': 0xffEE701E,
        'text': {
          'ar': 'قلقلة',
          'en': 'Qalqala (echo)',
          'bn': 'কলকালা',
          'id': 'Qalqala',
          'ur': 'قلقلہ',
          'tr': 'Kalkala',
          'ku': 'Qelqele (dengdan)',
          'ms': 'Qalqalah (gema)',
          'es': 'Qalqala (eco)',
        },
      },
      {
        'index': 7,
        'color': 0xff3C84D5,
        'darkColor': 0xffDED537,
        'text': {
          'ar': 'تفخيم',
          'en': 'Tafkhim (heavy)',
          'bn': 'তাফখিম',
          'id': 'Tafkhim',
          'ur': 'تفخیم',
          'tr': 'Tefhim',
          'ku': 'Tefxîm (girân)',
          'ms': 'Tafkhim (tebal)',
          'es': 'Tafkhim (pesado)',
        },
      },
    ],
  },
];

// للتوافق الخلفي: نفس القوائم القديمة لكن مولّدة من الهيكلة الجديدة.
// final List<TajweedRuleModel> tajweedRulesListAr =
//     getTajweedRulesListForLanguage(languageCode: 'ar');
// final List<TajweedRuleModel> tajweedRulesListEn =
//     getTajweedRulesListForLanguage(languageCode: 'en');
// final List<TajweedRuleModel> tajweedRulesListBn =
//     getTajweedRulesListForLanguage(languageCode: 'bn');
// final List<TajweedRuleModel> tajweedRulesListId =
//     getTajweedRulesListForLanguage(languageCode: 'id');
// final List<TajweedRuleModel> tajweedRulesListTr =
//     getTajweedRulesListForLanguage(languageCode: 'tr');
// final List<TajweedRuleModel> tajweedRulesListUr =
//     getTajweedRulesListForLanguage(languageCode: 'ur');

class TajweedRuleModel {
  final int color;
  final int darkColor;

  /// قد يكون النص متعدد اللغات وفق الهيكلة الجديدة.
  /// في حال التحويل لقائمة لغة واحدة عبر [forLanguage] يصبح هذا الحقل مفردًا.
  final Map<String, String> text;

  /// النص المختار (بعد [forLanguage]) لسهولة الاستهلاك في الواجهات.
  final String? resolvedText;

  final int? index;

  TajweedRuleModel({
    required this.color,
    required this.darkColor,
    required this.text,
    this.resolvedText,
    this.index,
  });

  String get displayText =>
      resolvedText ?? text['ar'] ?? text.values.firstOrNull ?? '';

  TajweedRuleModel forLanguage(
    String languageCode, {
    String fallbackLanguageCode = 'ar',
  }) {
    final String resolved =
        text[languageCode] ?? text[fallbackLanguageCode] ?? '';

    return TajweedRuleModel(
      color: color,
      darkColor: darkColor,
      text: text,
      resolvedText: resolved,
      index: index,
    );
  }

  factory TajweedRuleModel.fromJson(Map<String, dynamic> json) {
    final dynamic textValue = json['text'];

    return TajweedRuleModel(
      index: json['index'] as int?,
      color: json['color'] as int,
      darkColor: json['darkColor'] as int,
      text: textValue is String
          ? <String, String>{
              'ar': textValue,
            }
          : Map<String, String>.from((textValue as Map?) ?? const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'color': color,
      'darkColor': darkColor,
      'text': text,
    };
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final Iterator<T> it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
