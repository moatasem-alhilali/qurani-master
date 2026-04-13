class TravelDhikrReference {
  const TravelDhikrReference({
    required this.source,
    required this.hadith,
  });

  factory TravelDhikrReference.fromJson(Map<String, dynamic> json) {
    return TravelDhikrReference(
      source: (json['source'] as String? ?? '').trim(),
      hadith: (json['hadith'] as String? ?? '').trim(),
    );
  }

  final String source;
  final String hadith;
}

class TravelDhikrModel {
  const TravelDhikrModel({
    required this.key,
    required this.title,
    required this.text,
    required this.trigger,
    required this.virtue,
    required this.reference,
    this.repeatCount,
    this.isDynamicRepeat = false,
  });

  factory TravelDhikrModel.fromJson(Map<String, dynamic> json) {
    final repeat = json['repeat'];
    var dynamicRepeat = false;
    int? parsedRepeat;

    if (repeat is int) {
      parsedRepeat = repeat;
    } else if (repeat is String) {
      final normalized = repeat.trim().toLowerCase();
      if (normalized == 'dynamic') {
        dynamicRepeat = true;
      } else {
        parsedRepeat = int.tryParse(normalized);
      }
    }

    return TravelDhikrModel(
      key: (json['key'] as String? ?? '').trim(),
      title: (json['title'] as String? ?? '').trim(),
      text: (json['text'] as String? ?? '').trim(),
      trigger: (json['trigger'] as String? ?? '').trim(),
      virtue: (json['virtue'] as String? ?? '').trim(),
      repeatCount: parsedRepeat,
      isDynamicRepeat: dynamicRepeat,
      reference: TravelDhikrReference.fromJson(
        json['reference'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final String key;
  final String title;
  final String text;
  final String trigger;
  final String virtue;
  final int? repeatCount;
  final bool isDynamicRepeat;
  final TravelDhikrReference reference;

  String get repeatLabel {
    if (isDynamicRepeat) {
      return 'بحسب الموقف';
    }
    return repeatCount == null ? 'مرة' : '$repeatCount مرة';
  }
}

const travelTriggerLabels = <String, String>{
  'on_start_travel': 'عند بداية السفر',
  'on_elevation_change': 'أثناء الطريق',
  'on_stop': 'عند التوقف',
  'on_return': 'عند الرجوع',
  'on_farewell': 'توديع المسافر',
  'on_farewell_reply': 'دعاء للمسافر',
};
