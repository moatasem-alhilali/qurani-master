// // // This is a basic Flutter widget test.
// // //
// // // To perform an interaction with a widget in your test, use the WidgetTester
// // // utility in the flutter_test package. For example, you can send tap and scroll
// // // gestures. You can also use WidgetTester to find child widgets in the widget
// // // tree, read text, and verify that the values of widget properties are correct.

// // import 'package:flutter/material.dart';
// // import 'package:flutter_test/flutter_test.dart';

// // import 'package:quran_app/main.dart';
// // import 'package:quran_app/main_view.dart';

// // void main() {
// //   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
// //     // Build our app and trigger a frame.
// //     await tester.pumpWidget(const MyApp());

// //     // Verify that our counter starts at 0.
// //     expect(find.text('0'), findsOneWidget);
// //     expect(find.text('1'), findsNothing);

// //     // Tap the '+' icon and trigger a frame.
// //     await tester.tap(find.byIcon(Icons.add));
// //     await tester.pump();

// //     // Verify that our counter has incremented.
// //     expect(find.text('0'), findsNothing);
// //     expect(find.text('1'), findsOneWidget);
// //   });
// // }

// import 'dart:io';

// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';

// Future<String> downloadAudio(String url) async {
//   final externalDir = await getExternalStorageDirectory();
//   final taskId = await FlutterDownloader.enqueue(
//     url: url,
//     savedDir: externalDir.path,
//     showNotification: true,
//     openFileFromNotification: true,
//   );
//   final downloadTask = await FlutterDownloader.loadTasksWithRawQuery(
//     query: 'SELECT * FROM task WHERE task_id = ?',
//     arguments: [taskId],
//   );
//   if (downloadTask.isNotEmpty) {
//     final savedFilePath = downloadTask[0].savedDir + "/" + downloadTask[0].filename;
//     return savedFilePath;
//   } else {
//     return null;
//   }
// }

// import 'package:sqflite/sqflite.dart';

// final String audioTable = 'audio';

// class Audio {
//   int id;
//   String title;
//   String audioPath;

//   Audio({this.id, this.title, this.audioPath});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'audio_path': audioPath,
//     };
//   }
// }

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database _database;

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database;
//     }
//     _database = await initDatabase();
//     return _database;
//   }

//   Future<Database> initDatabase() async {
//     final documentsDir = await getApplicationDocumentsDirectory();
//     final path = join(documentsDir.path, 'my_app_db.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE IF NOT EXISTS $audioTable (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             title TEXT,
//             audio_path TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertAudio(Audio audio) async {
//     final db = await database;
//     return await db.insert(audioTable, audio.toMap());
//   }

//   Future<List<Audio>> getAllAudios() async {
//     final db = await database;
//     final result = await db.query(audioTable);
//     return result.map((map) => Audio.fromMap(map)).toList();
//   }
// }



// final audioPath = await downloadAudio(url);
// final audio = Audio(title: 'My Audio', audioPath: audioPath);
// await DatabaseHelper().insertAudio(audio);


