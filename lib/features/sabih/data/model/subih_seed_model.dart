import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/main.dart';

/// Provides initial dhikr items for the app
class SubihSeeder {
  factory SubihSeeder() => _instance;

  SubihSeeder._internal();
  static final SubihSeeder _instance = SubihSeeder._internal();

  /// Returns a list of common dhikr items
  static List<SubihModel> getDefaultDhikrItems() {
    return [
      SubihModel(
        title: 'سبحان الله',
        content: 'Glory be to Allah',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'الحمد لله',
        content: 'All praise is due to Allah',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'لا إله إلا الله',
        content: 'There is no god but Allah',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'الله أكبر',
        content: 'Allah is the Greatest',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'لا حول ولا قوة إلا بالله',
        content: 'There is no might nor power except with Allah',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'أستغفر الله',
        content: 'I seek forgiveness from Allah',
        createdAt: DateTime.now(),
      ),
      SubihModel(
        title: 'سبحان الله وبحمده سبحان الله العظيم',
        content:
            'Glory be to Allah and praise Him, Glory be to Allah the Magnificent',
        createdAt: DateTime.now(),
      ),
    ];
  }

  /// Seeds the database with initial dhikr items if empty
  static Future<void> runIfNeeded() async {
    try {
      // Check if there are any existing dhikr items
      final existingItemsCount = await DatabaseSabihService.getQueryCount();

      logger.d('existingItemsCount: $existingItemsCount');

      // If no items exist, add the default ones
      if (existingItemsCount == 0) {
        final defaultItems = getDefaultDhikrItems();

        for (final item in defaultItems) {
          final request = SubihRequest(
            title: item.title,
            content: item.content,
            isCustom: false, // These are default items, not custom
            createdAt: item.createdAt,
          );

          await DatabaseSabihService.addSubihItem(request);
        }

        print('Seeded ${defaultItems.length} default dhikr items');
      }
    } catch (e, stackTrace) {
      logger.e(e);
      logger.e(stackTrace);
      print('Error seeding dhikr items: $e');
    }
  }
}
