import 'dart:math';

import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_plan.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

/// ما يحتاجه المنتقي من المصحف.
///
/// واجهة ضيّقة لا `AyahDataSource` مباشرةً: ذاك يقرأ `QuranCtrl.instance`
/// ساكنًا، فلا يُختبر منطق الانتقاء بدونه.
abstract interface class AyahReminderMushafSource {
  /// عدد آيات المصحف — `ayahUQNumber` يسير من 1 إليه.
  Future<int> totalAyahs();

  /// الآية بترقيمها الفريد، أو `null` إن خرج الرقم عن المصحف.
  Future<NewAyahModel?> ayahAt(int ayahNumber);

  /// آيات صفحة، مرتّبةً.
  Future<List<NewAyahModel>> ayahsOnPage(int page);

  /// الصفحة التي وقف عندها القارئ.
  Future<int> lastReadPage();
}

/// يبني طابور آيات الأيام القادمة.
///
/// الطابور يُبنى مقدَّمًا لأن إشعار `flutter_local_notifications` يُجدَّل
/// بنصٍّ ثابت: التكرار اليومي الواحد يرسل الآية نفسها إلى الأبد. فيُجدَّل
/// يومٌ بيوم، ويُعاد بناء الطابور في كل مرّة يُفتح فيها التطبيق.
class AyahReminderPicker {
  const AyahReminderPicker({required AyahReminderMushafSource mushaf})
      : _mushaf = mushaf;

  final AyahReminderMushafSource _mushaf;

  /// ترتيب المحاولة لكل مصدر مطلوب.
  ///
  /// موضع القراءة قد يكون فارغًا (لم تُحمَّل بيانات الصفحة)، فله بديل بعده.
  /// والعشوائي آخر الصفّ لأنه وحده لا يعتمد على بيانات للمستخدم.
  static List<AyahReminderSource> _chainFor(AyahReminderSource requested) {
    switch (requested) {
      case AyahReminderSource.continueReading:
        return const <AyahReminderSource>[
          AyahReminderSource.continueReading,
          AyahReminderSource.random,
        ];
      case AyahReminderSource.random:
        return const <AyahReminderSource>[AyahReminderSource.random];
    }
  }

  Future<AyahReminderPlan> plan({
    required AyahReminderSource requested,
    required int days,
    required DateTime from,
  }) async {
    if (days <= 0) {
      return AyahReminderPlan.empty(requested);
    }

    final total = await _mushaf.totalAyahs();
    if (total <= 0) {
      // المصحف لم يُحمَّل بعد (إقلاع بارد، أو عملية خلفية). لا يُجدَّل شيء،
      // ويُبنى الطابور عند أول فتح للتطبيق.
      return AyahReminderPlan.empty(requested);
    }

    for (final candidate in _chainFor(requested)) {
      final picks = await _picksFor(
        candidate,
        days: days,
        total: total,
        from: from,
      );
      if (picks.isNotEmpty) {
        return AyahReminderPlan(
          requested: requested,
          resolved: candidate,
          picks: picks,
        );
      }
    }

    return AyahReminderPlan.empty(requested);
  }

  Future<List<AyahReminderPick>> _picksFor(
    AyahReminderSource source, {
    required int days,
    required int total,
    required DateTime from,
  }) async {
    switch (source) {
      case AyahReminderSource.continueReading:
        return _fromContinueReading(days: days, total: total);
      case AyahReminderSource.random:
        return _fromRandom(days: days, total: total, from: from);
    }
  }

  /// من موضع القراءة: تبدأ بأول آية في الصفحة الموقوف عندها، ثم تتقدّم آية
  /// كل يوم. تلتف عند آخر المصحف فلا ينقطع الطابور في سورة الناس.
  Future<List<AyahReminderPick>> _fromContinueReading({
    required int days,
    required int total,
  }) async {
    final page = await _mushaf.lastReadPage();
    final pageAyahs = await _mushaf.ayahsOnPage(page);
    if (pageAyahs.isEmpty) return const <AyahReminderPick>[];

    final start = pageAyahs.first.numberGlobal;
    return _picksFromNumbers(
      days: days,
      numberFor: (i) => ((start - 1 + i) % total) + 1,
    );
  }

  /// عشوائية، لكن ثابتة لليوم: البذرة من تاريخ اليوم لا من اللحظة. فإعادة
  /// بناء الطابور بعد الظهر لا تغيّر آية اليوم التي أُعلنت صباحًا.
  Future<List<AyahReminderPick>> _fromRandom({
    required int days,
    required int total,
    required DateTime from,
  }) {
    final daySeed = _dayNumber(from);
    return _picksFromNumbers(
      days: days,
      numberFor: (i) => Random(daySeed + i).nextInt(total) + 1,
    );
  }

  /// رقم اليوم منسوبًا إلى بداية التقويم — بذرةُ العشوائي.
  ///
  /// يُحسب من مكوّنات التاريخ لا من `millisecondsSinceEpoch` للحظة: القسمة
  /// على طول اليوم في منطقة بفارقٍ بالساعات تقع على يومين مختلفين حسب الساعة.
  static int _dayNumber(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  /// يحوّل أرقام الآيات إلى اختيارات، ويتجاوز ما لا يُقرأ بدل أن يُفشل
  /// الطابور كلّه: يومٌ ناقص أهون من أسبوع بلا إشعار.
  Future<List<AyahReminderPick>> _picksFromNumbers({
    required int days,
    required int Function(int dayOffset) numberFor,
  }) async {
    final picks = <AyahReminderPick>[];
    for (var i = 0; i < days; i++) {
      final ayah = await _mushaf.ayahAt(numberFor(i));
      if (ayah == null) continue;
      picks.add(AyahReminderPick(dayOffset: i, ayah: ayah));
    }
    return picks;
  }
}
