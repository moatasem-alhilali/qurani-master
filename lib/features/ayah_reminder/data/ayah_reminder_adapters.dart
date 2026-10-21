import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_picker.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/main.dart';
import 'package:quran_library/quran.dart';

/// وصلة المنتقي بالمصحف الفعلي.
class QuranAyahReminderMushafSource implements AyahReminderMushafSource {
  QuranAyahReminderMushafSource({AyahDataSource? ayahDataSource})
      : _ayahs = ayahDataSource ?? AyahDataSource();

  final AyahDataSource _ayahs;

  @override
  Future<int> totalAyahs() => _ayahs.getTotalAyahCount();

  @override
  Future<NewAyahModel?> ayahAt(int ayahNumber) =>
      _ayahs.getAyahById(ayahNumber);

  @override
  Future<List<NewAyahModel>> ayahsOnPage(int page) =>
      _ayahs.getAyahsByPage(page);

  /// الصفحة الجارية في المصحف هي موضع القراءة الذي تحفظه المكتبة بنفسها.
  ///
  /// `CacheConfig.lastPageReadKey` معرَّف في التطبيق لكن لا يكتبه أحد، فقراءته
  /// تعطي موضعًا لا وجود له. الموضع الحقيقي في تخزين `quran_library`.
  @override
  Future<int> lastReadPage() async {
    try {
      final page = QuranCtrl.instance.state.currentPageNumber.value;
      return page >= 1 ? page : 1;
    } catch (e) {
      logger.w('Could not read the last mushaf page for the ayah reminder: $e');
      return 1;
    }
  }
}
