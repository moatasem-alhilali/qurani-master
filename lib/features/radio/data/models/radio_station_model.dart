import 'dart:convert';
import 'package:quran_app/l10n/l10n.dart';

/// نوع المحطة.
///
/// القائمة تخلط ١٨ محطة قارئ بستّة برامج (السنّة النبوية، الرقية، تكبيرات
/// العيد، التفسير…) وكانت تعرضها كلّها بشكل واحد، فيبحث المستخدم بعينه في
/// أربعة وعشرين صفًّا متطابقًا. النوع يأتي من ملفّ البيانات نفسه لا من الكود.
enum RadioStationKind {
  reciter,
  program;

  const RadioStationKind();

  factory RadioStationKind.fromRaw(String? raw) =>
      raw == 'program' ? RadioStationKind.program : RadioStationKind.reciter;

  /// اسم المجموعة بلغة الواجهة.
  String label(L10n l10n) => this == RadioStationKind.program
      ? l10n.radioKindPrograms
      : l10n.radioKindReciters;

  String get raw => this == RadioStationKind.program ? 'program' : 'reciter';
}

class RadioStationModel {
  const RadioStationModel({
    required this.id,
    required this.name,
    required this.streamUrl,
    required this.imageUrl,
    this.kind = RadioStationKind.reciter,
  });

  factory RadioStationModel.fromMap(Map<String, dynamic> map) {
    return RadioStationModel(
      id: (map['id'] as num).toInt(),
      name: (map['name'] as String?)?.trim() ?? '',
      streamUrl: (map['url'] as String?)?.trim() ?? '',
      imageUrl: (map['img'] as String?)?.trim() ?? '',
      kind: RadioStationKind.fromRaw(map['kind'] as String?),
    );
  }

  factory RadioStationModel.fromJson(String source) =>
      RadioStationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int id;
  final String name;
  final String streamUrl;
  final String imageUrl;
  final RadioStationKind kind;

  /// الاسم بلا بادئة «إذاعة».
  ///
  /// ثماني عشرة محطة من أربع وعشرين تبدأ بالكلمة نفسها، فتضيع بها ثلث عرض
  /// الصفّ وتتشابه أوائل الأسماء فيصعب مسحها بالعين. البادئة معلومة من عنوان
  /// الصفحة أصلًا.
  String get shortName {
    const prefix = 'إذاعة ';
    final trimmed = name.trim();
    if (!trimmed.startsWith(prefix)) return trimmed;
    final rest = trimmed.substring(prefix.length).trim();
    return rest.isEmpty ? trimmed : rest;
  }

  /// أوّل حرفين من الاسم المختصر — بديل الصورة حين تتعذّر.
  String get initials {
    final parts = shortName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return "؟";
    final first = parts.first;
    return first.length <= 2 ? first : first.substring(0, 2);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kind': kind.raw,
      'name': name,
      'url': streamUrl,
      'img': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());
}
