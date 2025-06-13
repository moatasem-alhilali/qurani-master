import 'package:quran_app/core/local_database/database_service.dart';

class DatabaseCoordinatesService {
  final _db = DatabaseService();

  Future<void> setCoordinates(double latitude, double longitude) async {
    await _db.delete(DatabaseTables.coordinates, 1); // remove old if exists
    await _db.insert(DatabaseTables.coordinates, {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<Map<String, dynamic>?> getCoordinates() async {
    final rows = await _db.get(DatabaseTables.coordinates);
    if (rows.isNotEmpty) {
      return rows.first;
    }
    return null;
  }

  Future<void> clearCoordinates() async {
    await _db.delete(DatabaseTables.coordinates, 1);
  }
}
