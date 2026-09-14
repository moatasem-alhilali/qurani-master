import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';

/// قاعدة معالجة خطوط العرض العالية، مع خيار "تلقائي" الذي يترك القرار
/// للقيمة الافتراضية لطريقة الحساب المختارة.
enum PrayerHighLatitudeOption {
  auto(
    'تلقائي',
    'يترك المعالجة للقيمة الافتراضية لطريقة الحساب.',
  ),
  middleOfTheNight(
    'منتصف الليل',
    'لا يسبق الفجر منتصف الليل ولا يتأخر العشاء عنه.',
  ),
  seventhOfTheNight(
    'سُبع الليل',
    'يعتمد على سُبع الليل الأخير للفجر والأول للعشاء.',
  ),
  twilightAngle(
    'زاوية الشفق',
    'يقسّم الليل حسب زاويتي الفجر والعشاء المختارتين.',
  );

  const PrayerHighLatitudeOption(this.label, this.description);

  final String label;
  final String description;

  HighLatitudeRule? get rule => switch (this) {
        PrayerHighLatitudeOption.auto => null,
        PrayerHighLatitudeOption.middleOfTheNight =>
          HighLatitudeRule.middle_of_the_night,
        PrayerHighLatitudeOption.seventhOfTheNight =>
          HighLatitudeRule.seventh_of_the_night,
        PrayerHighLatitudeOption.twilightAngle =>
          HighLatitudeRule.twilight_angle,
      };
}

/// طريقة تحديد وقت العشاء في الإعداد المخصص.
enum PrayerIshaMode {
  angle('زاوية', 'يُحسب العشاء بزاوية الشمس تحت الأفق.'),
  interval('فاصل زمني', 'يُحسب العشاء بعدد دقائق ثابت بعد المغرب.');

  const PrayerIshaMode(this.label, this.description);

  final String label;
  final String description;
}

/// زوايا الإعداد المخصص، وتُستخدم فقط مع [CalculationMethod.other].
@immutable
class PrayerCustomAngles {
  const PrayerCustomAngles({
    this.fajrAngle = 18,
    this.ishaMode = PrayerIshaMode.angle,
    this.ishaAngle = 17,
    this.ishaInterval = 90,
    this.maghribAngle,
  });

  static const double minAngle = 5;
  static const double maxAngle = 25;
  static const double angleStep = 0.5;
  static const double minMaghribAngle = 0.5;
  static const double maxMaghribAngle = 10;
  static const int minIshaInterval = 30;
  static const int maxIshaInterval = 180;
  static const int ishaIntervalStep = 5;

  static const PrayerCustomAngles defaults = PrayerCustomAngles();

  final double fajrAngle;
  final PrayerIshaMode ishaMode;
  final double ishaAngle;
  final int ishaInterval;

  /// زاوية المغرب، والقيمة الفارغة تعني اعتماد غروب الشمس كما هو المعتاد.
  final double? maghribAngle;

  PrayerCustomAngles copyWith({
    double? fajrAngle,
    PrayerIshaMode? ishaMode,
    double? ishaAngle,
    int? ishaInterval,
    double? maghribAngle,
    bool clearMaghribAngle = false,
  }) {
    return PrayerCustomAngles(
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaMode: ishaMode ?? this.ishaMode,
      ishaAngle: ishaAngle ?? this.ishaAngle,
      ishaInterval: ishaInterval ?? this.ishaInterval,
      maghribAngle:
          clearMaghribAngle ? null : (maghribAngle ?? this.maghribAngle),
    );
  }

  PrayerCustomAngles clamped() {
    return PrayerCustomAngles(
      fajrAngle: fajrAngle.clamp(minAngle, maxAngle),
      ishaMode: ishaMode,
      ishaAngle: ishaAngle.clamp(minAngle, maxAngle),
      ishaInterval: ishaInterval.clamp(minIshaInterval, maxIshaInterval),
      maghribAngle: maghribAngle?.clamp(minMaghribAngle, maxMaghribAngle),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PrayerCustomAngles &&
      other.fajrAngle == fajrAngle &&
      other.ishaMode == ishaMode &&
      other.ishaAngle == ishaAngle &&
      other.ishaInterval == ishaInterval &&
      other.maghribAngle == maghribAngle;

  @override
  int get hashCode =>
      Object.hash(fajrAngle, ishaMode, ishaAngle, ishaInterval, maghribAngle);
}

/// تعديلات يدوية بالدقائق تُضاف إلى كل وقت بعد حسابه أو تُطرح منه.
@immutable
class PrayerManualAdjustments {
  const PrayerManualAdjustments({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });

  /// أقصى تعديل مسموح به بالدقائق في الاتجاهين.
  static const int maxMinutes = 60;

  static const PrayerManualAdjustments zero = PrayerManualAdjustments();

  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  bool get isZero =>
      fajr == 0 &&
      sunrise == 0 &&
      dhuhr == 0 &&
      asr == 0 &&
      maghrib == 0 &&
      isha == 0;

  PrayerManualAdjustments copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return PrayerManualAdjustments(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }

  PrayerManualAdjustments clamped() {
    int limit(int value) => value.clamp(-maxMinutes, maxMinutes);
    return PrayerManualAdjustments(
      fajr: limit(fajr),
      sunrise: limit(sunrise),
      dhuhr: limit(dhuhr),
      asr: limit(asr),
      maghrib: limit(maghrib),
      isha: limit(isha),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PrayerManualAdjustments &&
      other.fajr == fajr &&
      other.sunrise == sunrise &&
      other.dhuhr == dhuhr &&
      other.asr == asr &&
      other.maghrib == maghrib &&
      other.isha == isha;

  @override
  int get hashCode => Object.hash(fajr, sunrise, dhuhr, asr, maghrib, isha);
}

/// إعدادات حساب مواقيت الصلاة التي يتحكم بها المستخدم.
@immutable
class PrayerCalculationSettings {
  const PrayerCalculationSettings({
    this.method = defaultMethod,
    this.madhab = defaultMadhab,
    this.highLatitudeOption = PrayerHighLatitudeOption.auto,
    this.ramadanIshaAdjustmentEnabled = true,
    this.adjustments = PrayerManualAdjustments.zero,
    this.customAngles = PrayerCustomAngles.defaults,
  });

  /// الافتراضي في التطبيق: تقويم أم القرى - جامعة أم القرى بمكة المكرمة.
  static const CalculationMethod defaultMethod = CalculationMethod.umm_al_qura;
  static const Madhab defaultMadhab = Madhab.shafi;

  /// الدقائق التي تُضاف للعشاء في رمضان عند اعتماد طريقة تحسب العشاء
  /// كفاصل زمني بعد المغرب مثل أم القرى وقطر.
  static const int ramadanIshaExtraMinutes = 30;

  static const PrayerCalculationSettings defaults = PrayerCalculationSettings();

  final CalculationMethod method;
  final Madhab madhab;
  final PrayerHighLatitudeOption highLatitudeOption;
  final bool ramadanIshaAdjustmentEnabled;
  final PrayerManualAdjustments adjustments;
  final PrayerCustomAngles customAngles;

  /// طرق الحساب التي تعتمد فاصلًا زمنيًا بعد المغرب للعشاء، وهي وحدها
  /// التي ينطبق عليها تعديل رمضان.
  bool get supportsRamadanIshaAdjustment =>
      method == CalculationMethod.umm_al_qura ||
      method == CalculationMethod.qatar;

  /// الإعداد المخصص الذي يحدد فيه المستخدم الزوايا بنفسه.
  bool get isCustomMethod => method == CalculationMethod.other;

  /// قاعدة "زاوية الشفق" تحتاج زاوية عشاء معرّفة، وطرق مثل أم القرى وقطر
  /// تحسب العشاء كفاصل زمني بلا زاوية، فاعتمادها معها يُسقط الحساب.
  bool get supportsTwilightAngleRule =>
      isCustomMethod || method.getParameters().ishaAngle != null;

  /// القاعدة المطبّقة فعليًا بعد استبعاد ما لا تدعمه طريقة الحساب.
  PrayerHighLatitudeOption get effectiveHighLatitudeOption =>
      highLatitudeOption == PrayerHighLatitudeOption.twilightAngle &&
              !supportsTwilightAngleRule
          ? PrayerHighLatitudeOption.auto
          : highLatitudeOption;

  /// الخيارات المعروضة للمستخدم مع طريقة الحساب الحالية.
  List<PrayerHighLatitudeOption> get availableHighLatitudeOptions =>
      PrayerHighLatitudeOption.values
          .where(
            (option) =>
                option != PrayerHighLatitudeOption.twilightAngle ||
                supportsTwilightAngleRule,
          )
          .toList();

  bool get isDefault => this == defaults;

  PrayerCalculationSettings copyWith({
    CalculationMethod? method,
    Madhab? madhab,
    PrayerHighLatitudeOption? highLatitudeOption,
    bool? ramadanIshaAdjustmentEnabled,
    PrayerManualAdjustments? adjustments,
    PrayerCustomAngles? customAngles,
  }) {
    return PrayerCalculationSettings(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
      highLatitudeOption: highLatitudeOption ?? this.highLatitudeOption,
      ramadanIshaAdjustmentEnabled:
          ramadanIshaAdjustmentEnabled ?? this.ramadanIshaAdjustmentEnabled,
      adjustments: adjustments ?? this.adjustments,
      customAngles: customAngles ?? this.customAngles,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PrayerCalculationSettings &&
      other.method == method &&
      other.madhab == madhab &&
      other.highLatitudeOption == highLatitudeOption &&
      other.ramadanIshaAdjustmentEnabled == ramadanIshaAdjustmentEnabled &&
      other.adjustments == adjustments &&
      other.customAngles == customAngles;

  @override
  int get hashCode => Object.hash(
        method,
        madhab,
        highLatitudeOption,
        ramadanIshaAdjustmentEnabled,
        adjustments,
        customAngles,
      );
}

/// أسماء وأوصاف عربية لطرق الحساب لعرضها في شاشة الإعدادات.
extension PrayerCalculationMethodLabels on CalculationMethod {
  String get arabicLabel => switch (this) {
        CalculationMethod.umm_al_qura => 'أم القرى - مكة المكرمة',
        CalculationMethod.muslim_world_league => 'رابطة العالم الإسلامي',
        CalculationMethod.egyptian => 'الهيئة المصرية العامة للمساحة',
        CalculationMethod.karachi => 'جامعة العلوم الإسلامية - كراتشي',
        CalculationMethod.dubai => 'دبي',
        CalculationMethod.qatar => 'قطر',
        CalculationMethod.kuwait => 'الكويت',
        CalculationMethod.singapore => 'سنغافورة',
        CalculationMethod.turkey => 'ديانت - تركيا',
        CalculationMethod.tehran => 'جامعة طهران للجيوفيزياء',
        CalculationMethod.moon_sighting_committee => 'لجنة رؤية الهلال',
        CalculationMethod.north_america => 'الجمعية الإسلامية لأمريكا الشمالية',
        CalculationMethod.other => 'إعداد مخصص',
      };

  String get arabicDescription => switch (this) {
        CalculationMethod.umm_al_qura =>
          'الفجر 18.5° والعشاء بعد المغرب بـ 90 دقيقة.',
        CalculationMethod.muslim_world_league => 'الفجر 18° والعشاء 17°.',
        CalculationMethod.egyptian => 'الفجر 19.5° والعشاء 17.5°.',
        CalculationMethod.karachi => 'الفجر 18° والعشاء 18°.',
        CalculationMethod.dubai => 'الفجر والعشاء 18.2°.',
        CalculationMethod.qatar => 'الفجر 18° والعشاء بعد المغرب بـ 90 دقيقة.',
        CalculationMethod.kuwait => 'الفجر 18° والعشاء 17.5°.',
        CalculationMethod.singapore => 'الفجر 20° والعشاء 18°.',
        CalculationMethod.turkey => 'الفجر 18° والعشاء 17° مع تعديلات ديانت.',
        CalculationMethod.tehran => 'الفجر 17.7° والعشاء 14° والمغرب 4.5°.',
        CalculationMethod.moon_sighting_committee =>
          'الفجر 18° والعشاء 18° مع تعديلات موسمية.',
        CalculationMethod.north_america => 'الفجر 15° والعشاء 15°.',
        CalculationMethod.other => 'حدّد زوايا الفجر والعشاء والمغرب بنفسك.',
      };

  /// الطرق المعروضة في الإعدادات، مرتّبة بالأقرب للمستخدم العربي.
  static const List<CalculationMethod> selectable = [
    CalculationMethod.umm_al_qura,
    CalculationMethod.muslim_world_league,
    CalculationMethod.egyptian,
    CalculationMethod.qatar,
    CalculationMethod.kuwait,
    CalculationMethod.dubai,
    CalculationMethod.karachi,
    CalculationMethod.turkey,
    CalculationMethod.singapore,
    CalculationMethod.moon_sighting_committee,
    CalculationMethod.north_america,
    CalculationMethod.tehran,
    CalculationMethod.other,
  ];
}

extension PrayerMadhabLabels on Madhab {
  String get arabicLabel => switch (this) {
        Madhab.shafi => 'الشافعي والمالكي والحنبلي',
        Madhab.hanafi => 'الحنفي',
      };

  String get arabicDescription => switch (this) {
        Madhab.shafi =>
          'العصر عندما يصير ظل الشيء مثله، وعليه المالكي والحنبلي أيضًا.',
        Madhab.hanafi => 'العصر عندما يصير ظل الشيء مثليه.',
      };
}
