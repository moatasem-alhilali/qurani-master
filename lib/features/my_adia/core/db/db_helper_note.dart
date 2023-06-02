import 'package:sqflite/sqflite.dart';

class DBHelperDou {
  static Database? _db;
  static const int _version = 1;
  static const String _tablename = 'doua';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'dua';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("data opend");
        return db.execute('''
      CREATE TABLE $_tablename(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL);
      ''');
      });
      print('sucssess');
    } catch (e) {
      print(e);
    }
  }

  static Future<int> addNote(DoaModel doaModel) async {
    print("insert");
    return await _db!.insert(_tablename, doaModel.toMap());
  }

  static Future<int> deleteDoa(DoaModel doaModel) async {
    return await _db!.delete(
      _tablename,
      where: 'id = ?',
      whereArgs: [doaModel.id],
    );
  }

  static Future<int> deleteAllNotes() async {
    // Database db = await instance.database;
    return await _db!.delete(_tablename);
  }

  static Future<int> updateNote(DoaModel doaModel) async {
    // Database db = await instance.database;
    return await _db!.update(
      _tablename,
      doaModel.toMap(),
      where: 'id = ?',
      whereArgs: [doaModel.id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    print("query function called");
    return _db!.query(_tablename);
  }
}

class DoaModel {
  int? id;
  String? title;
  String? content;
  DoaModel({this.content, this.id, this.title});
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
      };
  DoaModel.fromJson(dynamic data) {
    id = data['id'];
    title = data['title'];
    content = data['content'];
  }
}
