part of '../../../../quran.dart';

final List<Map<String, dynamic>> tajweedRules = [
  {
    'defaultLanguage': 'ar',
    'languages': ['ar', 'en', 'bn', 'id', 'ur', 'tr', 'ku', 'ms', 'es'],
    'rules': [
      {
        'index': 0,
        'color': 0xff999999,
        'text': {
          'ar': 'الحرف الساكن',
          'en': 'Sakin letter (non-vowelled)',
          'bn': 'সাকিন হরফ',
          'id': 'Huruf Sakin',
          'ur': 'حرفِ ساکن',
          'tr': 'Sâkin harf',
          'ku': 'Tîpa sakîn',
          'ms': 'Huruf Sakin',
          'es': 'Letra sâkin (sin vocal)',
        },
      },
      {
        'index': 1,
        'color': 0xfffec1e2,
        'text': {
          'ar': 'مدّ حركتان',
          'en': 'Madd: 2 counts',
          'bn': 'মদ্দ: ২ হারাকাত',
          'id': 'Mad: 2 harakat',
          'ur': 'مد: ۲ حرکات',
          'tr': 'Med: 2 hareke',
          'ku': 'Med: 2 hereket',
          'ms': 'Mad: 2 harakat',
          'es': 'Madd: 2 tiempos',
        },
      },
      {
        'index': 2,
        'color': 0xffFE7D03,
        'text': {
          'ar': 'المد المنفصل ٢ أو ٤ أو ٦ حركات',
          'en': 'Madd Munfasil: 2, 4, or 6 counts',
          'bn': 'মদ্দে মুনফাসিল: ২, ৪ বা ৬ হারাকাত',
          'id': 'Mad Munfasil: 2, 4, atau 6 harakat',
          'ur': 'مدِ منفصل: ۲، ۴ یا ۶ حرکات',
          'tr': 'Med-i Munfasıl: 2, 4 veya 6 hareke',
          'ku': 'Medê Munfesil: 2, 4 an 6 hereket',
          'ms': 'Mad Munfasil: 2, 4 atau 6 harakat',
          'es': 'Madd Munfasil: 2, 4 o 6 tiempos',
        },
      },
      {
        'index': 3,
        'color': 0xffFF4D8E,
        'text': {
          'ar': 'المد المتصل ٤ أو ٥ حركات',
          'en': 'Madd Muttasil: 4 or 5 counts',
          'bn': 'মদ্দে মুত্তাসিল: ৪ বা ৫ হারাকাত',
          'id': 'Mad Muttasil: 4 atau 5 harakat',
          'ur': 'مدِ متصل: ۴ یا ۵ حرکات',
          'tr': 'Med-i Muttasıl: 4 veya 5 hareke',
          'ku': 'Medê Muttasil: 4 an 5 hereket',
          'ms': 'Mad Muttasil: 4 atau 5 harakat',
          'es': 'Madd Muttasil: 4 o 5 tiempos',
        },
      },
      {
        'index': 4,
        'color': 0xffE30000,
        'text': {
          'ar': 'المد اللازم ٦ حركات',
          'en': 'Madd Lazim: 6 counts',
          'bn': 'মদ্দে লাজিম: ৬ হারাকাত',
          'id': 'Mad Lazim: 6 harakat',
          'ur': 'مدِ لازم: ۶ حرکات',
          'tr': 'Med-i Lâzım: 6 hareke',
          'ku': 'Medê Lazim: 6 hereket',
          'ms': 'Mad Lazim: 6 harakat',
          'es': 'Madd Lazim: 6 tiempos',
        },
      },
      {
        'index': 5,
        'color': 0xff26B55D,
        'text': {
          'ar': 'غنة/إخفاء',
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
          'ar': 'تفخيم الصوت',
          'en': 'Tafkhim (heavy/emphatic pronunciation)',
          'bn': 'তাফখীম (ভারী উচ্চারণ)',
          'id': 'Tafkhim (bacaan tebal)',
          'ur': 'تفخیم (بھاری ادائیگی)',
          'tr': 'Tefhîm (kalın okuma)',
          'ku': 'Tefxîm (xwendina stûr)',
          'ms': 'Tafkhim (bacaan tebal)',
          'es': 'Tafkhim (pronunciación enfática)',
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

  /// قد يكون النص متعدد اللغات وفق الهيكلة الجديدة.
  /// في حال التحويل لقائمة لغة واحدة عبر [forLanguage] يصبح هذا الحقل مفردًا.
  final Map<String, String> text;

  /// النص المختار (بعد [forLanguage]) لسهولة الاستهلاك في الواجهات.
  final String? resolvedText;

  final int? index;

  TajweedRuleModel({
    required this.color,
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
