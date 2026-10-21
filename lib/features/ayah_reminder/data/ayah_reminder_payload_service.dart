import 'dart:convert';

class AyahReminderPayloadData {
  const AyahReminderPayloadData({
    required this.surah,
    required this.ayah,
    this.page,
  });

  final int surah;
  final int ayah;

  /// صفحة المصحف التي تقع فيها الآية — وهي ما يُفتح عند اللمس.
  final int? page;
}

/// حمولة إشعار آية اليوم: تحمل موضع الآية لا نصّها.
///
/// النصّ قد يطول، وحمولة الإشعار تُخزَّن في النظام إلى موعدها — فيكفي الموضع
/// ليُفتح المصحف عليه.
class AyahReminderPayloadService {
  static const String payloadType = 'ayah_reminder';

  String buildPayload({
    required int surah,
    required int ayah,
    int? page,
  }) {
    return jsonEncode(<String, dynamic>{
      'type': payloadType,
      'surah': surah,
      'ayah': ayah,
      'page': page,
    });
  }

  AyahReminderPayloadData? parsePayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      if ((decoded['type'] as String?)?.trim() != payloadType) {
        return null;
      }

      final surah = decoded['surah'] as int?;
      final ayah = decoded['ayah'] as int?;
      if (surah == null || ayah == null) {
        return null;
      }

      return AyahReminderPayloadData(
        surah: surah,
        ayah: ayah,
        page: decoded['page'] as int?,
      );
    } catch (_) {
      return null;
    }
  }
}
