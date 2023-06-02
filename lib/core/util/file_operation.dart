import 'package:flutter/services.dart';

class FileOperations {
  Future<String> getDataFromFile(String path) async {
    return await rootBundle.loadString(path);
  }
}
