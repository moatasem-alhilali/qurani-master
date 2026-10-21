import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_picker.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

/// مصحف مُصغَّر: آياته مرقّمة 1..[total] تسير على الصفحات بـ[perPage] آيات.
class _FakeMushaf implements AyahReminderMushafSource {
  _FakeMushaf({this.total = 20, this.perPage = 5, this.page = 1});

  final int total;
  final int perPage;
  int page;

  /// صفحةٌ لا تُقرأ آياتها — تحاكي مصحفًا لم تُحمَّل بياناته.
  bool pageIsEmpty = false;

  @override
  Future<int> totalAyahs() async => total;

  @override
  Future<int> lastReadPage() async => page;

  @override
  Future<List<NewAyahModel>> ayahsOnPage(int page) async {
    if (pageIsEmpty) return <NewAyahModel>[];
    final first = (page - 1) * perPage + 1;
    return <NewAyahModel>[
      for (var n = first; n < first + perPage && n <= total; n++) _ayah(n),
    ];
  }

  @override
  Future<NewAyahModel?> ayahAt(int ayahNumber) async {
    if (ayahNumber < 1 || ayahNumber > total) return null;
    return _ayah(ayahNumber);
  }

  NewAyahModel _ayah(int n) => NewAyahModel(
        id: n,
        surahId: 1,
        numberGlobal: n,
        ayahNumber: n,
        text: 'ayah $n',
        page: ((n - 1) ~/ perPage) + 1,
      );
}

void main() {
  final now = DateTime(2026, 10, 21, 9);

  List<int> numbersOf(dynamic plan) =>
      (plan.picks as List).map<int>((p) => p.ayah.numberGlobal as int).toList();

  group('من موضع القراءة', () {
    test('تبدأ بأول آية في الصفحة الموقوف عندها وتتقدّم آية كل يوم', () async {
      // الصفحة الثالثة: آياتها 11..15.
      final picker = AyahReminderPicker(mushaf: _FakeMushaf(page: 3));

      final plan = await picker.plan(
        requested: AyahReminderSource.continueReading,
        days: 4,
        from: now,
      );

      expect(plan.resolved, AyahReminderSource.continueReading);
      expect(plan.didFallBack, isFalse);
      expect(numbersOf(plan), <int>[11, 12, 13, 14]);
    });

    test('تلتف عند آخر المصحف فلا ينقطع الطابور', () async {
      // المصحف 20 آية، والصفحة الرابعة آياتها 16..20.
      final picker = AyahReminderPicker(mushaf: _FakeMushaf(page: 4));

      final plan = await picker.plan(
        requested: AyahReminderSource.continueReading,
        days: 7,
        from: now,
      );

      expect(numbersOf(plan), <int>[16, 17, 18, 19, 20, 1, 2]);
    });

    test('بصفحة لا تُقرأ ينزل إلى العشوائي ويُعلن النزول', () async {
      final mushaf = _FakeMushaf()..pageIsEmpty = true;
      final picker = AyahReminderPicker(mushaf: mushaf);

      final plan = await picker.plan(
        requested: AyahReminderSource.continueReading,
        days: 3,
        from: now,
      );

      expect(plan.resolved, AyahReminderSource.random);
      expect(plan.didFallBack, isTrue);
      expect(plan.picks, hasLength(3));
    });
  });

  group('العشوائي', () {
    test('ثابت لليوم نفسه فلا تتغيّر آية اليوم بإعادة الجدولة', () async {
      AyahReminderPicker build() =>
          AyahReminderPicker(mushaf: _FakeMushaf(total: 6236));

      final morning = await build().plan(
        requested: AyahReminderSource.random,
        days: 7,
        from: DateTime(2026, 10, 21, 7, 30),
      );
      final evening = await build().plan(
        requested: AyahReminderSource.random,
        days: 7,
        from: DateTime(2026, 10, 21, 22, 15),
      );

      expect(numbersOf(morning), numbersOf(evening));
    });

    test('يتغيّر من يوم إلى يوم', () async {
      AyahReminderPicker build() =>
          AyahReminderPicker(mushaf: _FakeMushaf(total: 6236));

      final today = await build().plan(
        requested: AyahReminderSource.random,
        days: 7,
        from: DateTime(2026, 10, 21, 9),
      );
      final tomorrow = await build().plan(
        requested: AyahReminderSource.random,
        days: 7,
        from: DateTime(2026, 10, 22, 9),
      );

      expect(numbersOf(today), isNot(numbersOf(tomorrow)));
    });

    test('يبقى داخل المصحف', () async {
      final picker = AyahReminderPicker(mushaf: _FakeMushaf(total: 6236));

      final plan = await picker.plan(
        requested: AyahReminderSource.random,
        days: 7,
        from: now,
      );

      expect(plan.picks, hasLength(7));
      for (final number in numbersOf(plan)) {
        expect(number, inInclusiveRange(1, 6236));
      }
    });
  });

  group('الحدود', () {
    test('مصحف غير محمَّل لا يُجدَّل له شيء', () async {
      final picker = AyahReminderPicker(mushaf: _FakeMushaf(total: 0));

      final plan = await picker.plan(
        requested: AyahReminderSource.continueReading,
        days: 7,
        from: now,
      );

      expect(plan.isEmpty, isTrue);
      expect(plan.didFallBack, isFalse);
    });

    test('بلا أيام لا طابور', () async {
      final picker = AyahReminderPicker(mushaf: _FakeMushaf());

      final plan = await picker.plan(
        requested: AyahReminderSource.random,
        days: 0,
        from: now,
      );

      expect(plan.isEmpty, isTrue);
    });
  });

  group('قراءة المصدر المخزَّن', () {
    test('قيمة غير معروفة تعود إلى موضع القراءة لا إلى العشوائي', () {
      // قد تأتي القيمة من إصدار فيه مصدر لا وجود له هنا — «ما تعثّرت فيه»
      // يحتاج ذاكرة تسميع، ولا تسميع في هذا الريبو.
      expect(
        AyahReminderSource.parse('tasmeeWeakness'),
        AyahReminderSource.continueReading,
      );
      expect(
        AyahReminderSource.parse('whatever-an-old-build-wrote'),
        AyahReminderSource.continueReading,
      );
      expect(AyahReminderSource.parse(null), AyahReminderSource.continueReading);
      expect(
        AyahReminderSource.parse('random'),
        AyahReminderSource.random,
      );
    });
  });
}
