import 'package:quran_app/l10n/l10n.dart';

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

  String repeatLabel(L10n l10n) {
    if (isDynamicRepeat) {
      return l10n.travelerRepeatBySituation;
    }
    return repeatCount == null
        ? l10n.travelerRepeatOnce
        : l10n.travelerRepeatTimes(repeatCount!);
  }
}

/// اسم مرحلة الطريق التي يُقال فيها الذكر، أو `null` لمفتاح غير معروف.
String? travelTriggerLabel(L10n l10n, String trigger) {
  switch (trigger) {
    case 'on_start_travel':
      return l10n.travelerStageStart;
    case 'on_elevation_change':
      return l10n.travelerStageOnTheWay;
    case 'on_stop':
      return l10n.travelerStageStop;
    case 'on_return':
      return l10n.travelerStageReturn;
    case 'on_farewell':
      return l10n.travelerStageFarewell;
    case 'on_farewell_reply':
      return l10n.travelerStageFarewellReply;
    default:
      return null;
  }
}
