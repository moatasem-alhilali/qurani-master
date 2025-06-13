import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/offline/data/models/offline_file_model.dart';

class LocalOfflineService {
  final _db = DatabaseService();

  /// Get all offline files as List<OfflineFileModel>
  Future<List<OfflineFileModel>> getAll() async {
    final data = await _db.get(DatabaseTables.offlines);
    return data.map((e) => OfflineFileModel.fromJson(e)).toList();
  }

  /// Insert a new offline file
  Future<int> insert(OfflineFileModel file) async {
    return await _db.insert(DatabaseTables.offlines, file.toJson());
  }

  /// Delete a file by id
  Future<int> delete(int id) async {
    return await _db.delete(DatabaseTables.offlines, id);
  }

  /// Update a file by id
  Future<int> update(int id, OfflineFileModel file) async {
    return await _db.update(DatabaseTables.offlines, file.toJson(), id);
  }

  /// Get all files filtered by type (e.g. mp3, pdf)
  Future<List<OfflineFileModel>> getByType(String type) async {
    final all = await getAll();
    return all.where((e) => e.type == type).toList();
  }
}
