/// من أين تأتي آية الإشعار اليومي.
///
/// الآية العشوائية ليست الافتراضي عن قصد: تذكير بآية لا علاقة لها بما يقرأه
/// المستخدم هو إشعار يُقرأ مرّة ثم يُسكَت. الافتراضي [continueReading] لأنه
/// يصل الإشعار بعملٍ قائم للمستخدم.
enum AyahReminderSource {
  /// من الصفحة التي وقف عندها القارئ، وتتقدّم آية كل يوم.
  continueReading,

  /// من المصحف كلّه.
  random;

  static const AyahReminderSource fallback = AyahReminderSource.continueReading;

  /// القراءة من نصّ مخزَّن. أي قيمة غير معروفة تعود إلى [fallback] بدل أن
  /// ترمي: الإعداد مُخزَّن في التفضيلات وقد يسبق إصدارًا يحذف خيارًا، أو
  /// يأتي من إصدار فيه خيار لا وجود له هنا.
  static AyahReminderSource parse(String? stored) {
    for (final source in AyahReminderSource.values) {
      if (source.name == stored) return source;
    }
    return fallback;
  }
}
