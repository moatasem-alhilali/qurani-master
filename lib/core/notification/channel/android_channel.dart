import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//قيام اليل
var soundMiddleNightAndroidChannel = const AndroidNotificationChannel(
  'sound_middle_night_android_channel',
  'طمأنينة - قيام الليل',
  description: 'قناة إشعارات قيام الليل في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("middlenight"),
);

//الاذكار الصباحيه
var soundMorningAndroidChannel = const AndroidNotificationChannel(
  'sound_morning_android_channel',
  'طمأنينة - أذكار الصباح',
  description: 'قناة إشعارات أذكار الصباح في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("morning"),
);

//الاذكار المسائيه
var soundNightAndroidChannel = const AndroidNotificationChannel(
  'sound_night_android_channel',
  'طمأنينة - أذكار المساء',
  description: 'قناة إشعارات أذكار المساء في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("night"),
);

//الصلاة على محمد
var soundMohamedAndroidChannel = const AndroidNotificationChannel(
  'sound_mohamed_android_channel',
  'طمأنينة - الصلاة على النبي',
  description: 'قناة إشعارات الصلاة على النبي في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("mohummed"),
);
//الاذان
var soundAthanAndroidChannel = const AndroidNotificationChannel(
  'athan_android_channel_v2',
  'طمأنينة - الأذان',
  description: 'قناة إشعارات الأذان في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("athan"),
  audioAttributesUsage: AudioAttributesUsage.alarm,
);

//بقية الإشعارات
var defaultAndroidChannel = const AndroidNotificationChannel(
  'default_android_channel',
  'طمأنينة - الإشعارات العامة',
  description: 'قناة الإشعارات العامة في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("default_custom"),
);

//استغفر الله
var astgfer_allh = const AndroidNotificationChannel(
  'astgfer_allh_id',
  'طمأنينة - الاستغفار',
  description: 'قناة إشعارات الاستغفار في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("astgfer_allh"),
);

//حسبنا الله ونعم الوكيل
var hasbna_allh = const AndroidNotificationChannel(
  'hasbna_allh id',
  'طمأنينة - حسبنا الله',
  description: 'قناة إشعارات حسبنا الله في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("hasbna_allh"),
);
//لا حول ولا قوة الا بالله
var lahawla_wlaquoah = const AndroidNotificationChannel(
  'lahawla_wlaquoah_id',
  'طمأنينة - لا حول ولا قوة إلا بالله',
  description: 'قناة إشعارات لا حول ولا قوة إلا بالله في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("lahawla_wlaquoah"),
);
//سبحان الله
var subhan_allh = const AndroidNotificationChannel(
  'subhan_allh_id',
  'طمأنينة - سبحان الله',
  description: 'قناة إشعارات سبحان الله في تطبيق طمأنينة',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("subhan_allh"),
);

Future<void> initAllChannelAndroid({
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
  //sound Middle Night Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(soundMiddleNightAndroidChannel);

  //sound Morning Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(soundMorningAndroidChannel);

  //sound Night Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(soundNightAndroidChannel);

  //sound Mohamed Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(soundMohamedAndroidChannel);

  //default Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultAndroidChannel);

  //sound Athan Android Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(soundAthanAndroidChannel);

  //astgfer_allh
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(astgfer_allh);

  //hasbna_allh
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(hasbna_allh);

  //lahawla_wlaquoah
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(lahawla_wlaquoah);

  //subhan_allh
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(subhan_allh);
}
