import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _prefs!.setString(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    if (value is int) return await _prefs!.setInt(key, value);
    return await _prefs!.setDouble(key, value);
  }

  static int? getInt({required String key}) {
    return _prefs!.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _prefs!.getDouble(key);
  }

  static String? getString({required String key}) {
    return _prefs!.getString(key);
  }

  static bool? getBool({required String key}) {
    return _prefs!.getBool(key);
  }

  static Future<bool> clear() {
    return _prefs!.clear();
  }

  static Future<bool> removeKey(String key) {
    return _prefs!.remove(key);
  }
}

class GetHelperCash {
 

  static Future<void> init() async {
   
  }

  static Future<void> resetData() async {
 
    CashHelper.clear();
  }
}
