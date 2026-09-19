import 'package:flutter/widgets.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/l10n/app_localizations.dart';

export 'package:quran_app/l10n/app_localizations.dart' show L10n, lookupL10n;

/// اللغات المدعومة، مرتّبة بعدد المسلمين الناطقين بها.
///
/// البنجابية (نحو 100 مليون مسلم) ليست هنا عمدًا: مسلمو باكستان يقرؤون ويكتبون
/// الأردية، والبنجابية المكتوبة في التطبيقات غالبًا بخط الغورموخي الذي يستعمله
/// السيخ في الهند — فالأردية تبلغ جمهورها فعلًا.
enum AppLanguage {
  arabic('ar', 'العربية', 'Arabic', '🇸🇦', isRtl: true),
  urdu('ur', 'اردو', 'Urdu', '🇵🇰', isRtl: true),
  bengali('bn', 'বাংলা', 'Bengali', '🇧🇩', isRtl: false),
  indonesian('id', 'Bahasa Indonesia', 'Indonesian', '🇮🇩', isRtl: false),
  persian('fa', 'فارسی', 'Persian', '🇮🇷', isRtl: true),
  turkish('tr', 'Türkçe', 'Turkish', '🇹🇷', isRtl: false);

  const AppLanguage(
    this.code,
    this.nativeName,
    this.englishName,
    this.flag, {
    required this.isRtl,
  });

  final String code;

  /// اسم اللغة بلغتها — يتعرّف عليه المستخدم مهما كانت لغة الواجهة الحالية.
  final String nativeName;
  final String englishName;
  final String flag;
  final bool isRtl;

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    for (final language in values) {
      if (language.code == code) return language;
    }
    return null;
  }

  /// أنسب لغة عند أوّل فتح — بلا أيّ صلاحية.
  ///
  /// موقع GPS يحتاج إذنًا لا نملكه بعد (شاشة اللغة تسبق طلب الموقع)، فنستدلّ
  /// على البلد بما يعطيه النظام مجّانًا، بالترتيب:
  /// 1. لغة من لغات الجهاز المفضّلة ندعمها — المستخدم يقرؤها قطعًا.
  /// 2. بلد الجهاز (`en_PK` ← الأردية): هاتف بالإنجليزية في باكستان.
  /// 3. المنطقة الزمنية (`Asia/Dhaka` ← البنغالية): حين لا يحمل الإعداد بلدًا.
  /// 4. العربية.
  static AppLanguage suggestFor(
    List<Locale> deviceLocales, {
    String? timeZoneName,
  }) {
    for (final locale in deviceLocales) {
      final match = fromCode(locale.languageCode);
      if (match != null) return match;
    }
    for (final locale in deviceLocales) {
      final match = _byCountry[locale.countryCode?.toUpperCase()];
      if (match != null) return match;
    }
    final byZone = _byTimeZone[timeZoneName];
    if (byZone != null) return byZone;
    return arabic;
  }

  /// بلدان جمهور كل لغة. الماليزية قريبة من الإندونيسية ومفهومة لقرّائها،
  /// والأذرية قريبة من التركية، ومسلمو الهند يقرؤون الأردية.
  static const Map<String, AppLanguage> _byCountry = {
    'PK': urdu,
    'IN': urdu,
    'BD': bengali,
    'ID': indonesian,
    'MY': indonesian,
    'BN': indonesian,
    'IR': persian,
    'AF': persian,
    'TJ': persian,
    'TR': turkish,
    'AZ': turkish,
    'CY': turkish,
  };

  static const Map<String, AppLanguage> _byTimeZone = {
    'Asia/Karachi': urdu,
    'Asia/Kolkata': urdu,
    'Asia/Calcutta': urdu,
    'Asia/Dhaka': bengali,
    'Asia/Dacca': bengali,
    'Asia/Jakarta': indonesian,
    'Asia/Pontianak': indonesian,
    'Asia/Makassar': indonesian,
    'Asia/Jayapura': indonesian,
    'Asia/Kuala_Lumpur': indonesian,
    'Asia/Kuching': indonesian,
    'Asia/Brunei': indonesian,
    'Asia/Tehran': persian,
    'Asia/Kabul': persian,
    'Asia/Dushanbe': persian,
    'Europe/Istanbul': turkish,
    'Asia/Istanbul': turkish,
    'Asia/Baku': turkish,
  };
}

extension L10nContext on BuildContext {
  /// نصوص الواجهة باللغة الحالية: `context.l10n.commonSave`.
  L10n get l10n => L10n.of(this);

  /// رمز اللغة الحالية (`ar`, `ur`, …) لتمريره إلى `DateFormat`/`NumberFormat`
  /// بدل كتابة 'ar' ثابتة.
  String get localeCode => L10n.of(this).localeName;
}

/// الترجمة خارج شجرة الواجهة: الإشعارات، ودجات الشاشة الرئيسية، مهامّ الخلفية.
///
/// هناك لا يوجد `BuildContext`، ولا حتى `MaterialApp` في عزل الخلفية، فتُقرأ
/// اللغة المحفوظة من التخزين مباشرة.
abstract final class L10nService {
  /// مفتاح اللغة المختارة في التخزين. `LocaleCubit` يكتبه، وكل ما عداه يقرؤه.
  static const String storageKey = 'app_locale_code';

  static AppLanguage get savedLanguage =>
      AppLanguage.fromCode(CacheService().getString(storageKey)) ??
      AppLanguage.arabic;

  /// نصوص اللغة المحفوظة. يتطلّب أن يكون `CacheConfig.loadConfig()` قد نُفّذ.
  static L10n get current => lookupL10n(savedLanguage.locale);

  static L10n forCode(String code) =>
      lookupL10n((AppLanguage.fromCode(code) ?? AppLanguage.arabic).locale);
}

extension HijriL10n on L10n {
  /// اسم الشهر الهجري (1–12) بلغة الواجهة.
  String hijriMonth(int month) {
    switch (month) {
      case 1:
        return hijriMonth1;
      case 2:
        return hijriMonth2;
      case 3:
        return hijriMonth3;
      case 4:
        return hijriMonth4;
      case 5:
        return hijriMonth5;
      case 6:
        return hijriMonth6;
      case 7:
        return hijriMonth7;
      case 8:
        return hijriMonth8;
      case 9:
        return hijriMonth9;
      case 10:
        return hijriMonth10;
      case 11:
        return hijriMonth11;
      default:
        return hijriMonth12;
    }
  }

  /// اسم الصلاة من مفتاحها (`fajr`, `sunrise`, `dhuhr`, `asr`, `maghrib`, `isha`).
  String prayerName(String key) {
    switch (key) {
      case 'fajr':
        return prayerFajr;
      case 'sunrise':
        return prayerSunrise;
      case 'dhuhr':
        return prayerDhuhr;
      case 'asr':
        return prayerAsr;
      case 'maghrib':
        return prayerMaghrib;
      case 'isha':
        return prayerIsha;
      case 'jumuah':
        return prayerJumuah;
      default:
        return key;
    }
  }
}
