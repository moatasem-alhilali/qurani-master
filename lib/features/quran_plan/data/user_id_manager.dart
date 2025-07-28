import 'package:flutter/foundation.dart';
import 'package:quran_app/core/services/device_info_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdManager {
  UserIdManager._();
  static const _key = 'unique_user_id';
  static final _storage = SharedPreferences.getInstance();
  static final UserIdManager instance = UserIdManager._();
  // get or generate user id
  Future<String> getUserId() async {
    var userId = await _storage.then((value) => value.getString(_key));
    if (userId == null) {
      // get device id or generate uuid
      userId = await DeviceInfoService().getDeviceId();
      if (userId.isEmpty) {
        userId = UniqueKey().toString();
      }
      await _storage.then((value) => value.setString(_key, userId!));
    }
    return userId;
  }
}
