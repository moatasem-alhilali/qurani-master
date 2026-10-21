/// مواعيد أيام الطابور — حسابٌ خالص على التواريخ.
///
/// مفصول عن المجدول لأنه موضع الخطأ الصامت: موعدٌ مضى اليوم يُجدَّل في الماضي
/// فلا يصل أبدًا، وجدولةٌ أسبوعية بيوم واحد تحتاج أسابيع لتملأ سبعة مواعيد.
abstract final class AyahReminderSlots {
  /// موعد في كل يوم، بدءًا من أقرب موعد لم يمضِ.
  static List<DateTime> daily({
    required int hour,
    required int minute,
    required DateTime now,
    required int count,
  }) {
    final slots = <DateTime>[];
    // ‏`count` يومًا إضافيًّا في المدى: موعد اليوم قد يكون مضى، فيبدأ الطابور
    // بالغد ويبقى بطوله الكامل.
    for (var i = 0; i <= count && slots.length < count; i++) {
      final at = DateTime(now.year, now.month, now.day + i, hour, minute);
      if (at.isAfter(now)) slots.add(at);
    }
    return slots;
  }

  /// موعد في أيام الأسبوع المختارة فقط ([DateTime.monday]…[DateTime.sunday]).
  ///
  /// بأيامٍ فارغة يعود إلى [daily]: جدولةٌ أسبوعية بلا أيام تعني «لا شيء»،
  /// وإشعارٌ شغّله المستخدم ولا يصل أسوأ من إشعارٍ يوميّ لم يضبطه.
  static List<DateTime> weekly({
    required List<int> weekdays,
    required int hour,
    required int minute,
    required DateTime now,
    required int count,
  }) {
    if (weekdays.isEmpty) {
      return daily(hour: hour, minute: minute, now: now, count: count);
    }

    final slots = <DateTime>[];
    // أبعد حالة: يوم واحد في الأسبوع، فـ`count` موعدًا تحتاج `count` أسابيع.
    final horizon = count * 7 + 7;
    for (var i = 0; i <= horizon && slots.length < count; i++) {
      final at = DateTime(now.year, now.month, now.day + i, hour, minute);
      if (!at.isAfter(now)) continue;
      if (!weekdays.contains(at.weekday)) continue;
      slots.add(at);
    }
    return slots;
  }

  /// المواعيد المحدّدة التي لم تمضِ، مرتّبةً.
  static List<DateTime> custom({
    required List<DateTime> dates,
    required DateTime now,
    required int count,
  }) {
    final upcoming = dates.where((date) => date.isAfter(now)).toList()..sort();
    return upcoming.take(count).toList();
  }
}
