import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/my_adia/data/model/doa_model.dart';

class DatabaseDoaService {
  final _db = DatabaseService();

  Future<int> addDoa(DoaModel doa) async {
    return await _db.insert(DatabaseTables.doua, doa.toMap());
  }

  Future<int> deleteDoa(int id) async {
    return await _db.delete(DatabaseTables.doua, id);
  }

  Future<int> updateDoa(DoaModel doa) async {
    return await _db.updateById(DatabaseTables.doua, doa.toMap(), doa.id!);
  }

  Future<List<DoaModel>> getAllDoa() async {
    final rows = await _db.get(DatabaseTables.doua);
    return rows.map((e) => DoaModel.fromJson(e)).toList();
  }
}
