import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

/// آية يوم واحد في الطابور.
class AyahReminderPick {
  const AyahReminderPick({required this.dayOffset, required this.ayah});

  /// كم يومًا من اليوم الأول في الطابور — 0 لليوم، 1 للغد…
  final int dayOffset;

  final NewAyahModel ayah;
}

/// الطابور المحسوب: آية لكل يوم، ومعه المصدر الذي تحقّق فعلًا.
class AyahReminderPlan {
  const AyahReminderPlan({
    required this.requested,
    required this.resolved,
    required this.picks,
  });

  const AyahReminderPlan.empty(this.requested)
      : resolved = requested,
        picks = const <AyahReminderPick>[];

  /// ما اختاره المستخدم في الإعدادات.
  final AyahReminderSource requested;

  /// ما تحقّق فعلًا.
  ///
  /// قد يختلف عن [requested]: من اختار «من موضع قراءتك» قبل أن تُحمَّل بيانات
  /// الصفحة لا موضع له، فيعود الطابور إلى العشوائي. الفارق مُعلَن هنا لا
  /// مخفيّ، لأن إشعارًا يخالف ما اختاره المستخدم بلا إخبارٍ أسوأ من ألّا يعمل.
  final AyahReminderSource resolved;

  final List<AyahReminderPick> picks;

  bool get isEmpty => picks.isEmpty;

  /// هل نزل الطابور عن المصدر المطلوب.
  bool get didFallBack => resolved != requested;
}
