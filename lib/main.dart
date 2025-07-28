import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/core/bloc/bloc_observer.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/firebase_notification.dart';
import 'package:quran_app/core/services/permission/location_permission_service.dart';
import 'package:quran_app/core/services/permission/notification_permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/time_zone_service.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/main_view.dart';

// Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup local notifications for background processing
  await FirebaseNotificationService.instance.setupFlutterNotifications();

  // Show the notification
  await FirebaseNotificationService.instance.showNotification(message);
}

// ✅ Logger instance used globally for debugging and logging
Logger logger = Logger();

void main() async {
  // 🧠 Ensures binding is initialized before running async code (important for plugins)
  WidgetsFlutterBinding.ensureInitialized();
  await PackageInfo.fromPlatform();
  // 🌐 Initialize timezone support to handle local timezones correctly
  await TimeZoneService().setupTimezone();

  await DownloadService().initialize();
  // 🧩 Register dependencies using service locator (e.g., GetIt)
  await setupServiceLocator();

  // 👁️ Set a custom Bloc observer to monitor Bloc events and transitions globally
  Bloc.observer = MyBlocObserver();

  // 🌍 Initialize the Dio HTTP client with base config (headers, interceptors, etc.)
  await DioHelper.init();

  // 🗂️ Initialize SQLite database and ensure all required tables are created
  await DatabaseService().database;

  // 💾 Initialize local cache (e.g., SharedPreferences)
  await CacheConfig.loadConfig();

  // 🔐 Request critical permissions (e.g., storage, notifications)
  await LocationPermissionService.init();

  // Initialize Firebase first
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // // Set background message handler AFTER Firebase initialization
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize notification service
  // try {
  //   await FirebaseNotificationService.instance.initialize();
  //   debugPrint('Notification service initialized successfully');
  // } catch (e) {
  //   debugPrint('Notification service initialization failed: $e');
  // }

  //
  await NotificationPermissionService.handelNotification();

  // 🚀 Launch the root of the Flutter application
  runApp(const MyApp());
}




// https://vercel-pdf-proxy.vercel.app/proxy?url=https://www.archive.org/download/waq79565/79565.pdf
// https://waqfeya.net/


// https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions.json

// https://www.jsdelivr.com/package/gh/fawazahmed0/quran-api


// flutter build apk --release --split-per-abi
// flutter build apk --release --target-platform android-arm,android-arm64 --split-per-abi
// flutter build apk --release --target-platform android-arm
// flutter build apk --release --target-platform android-arm64

// flutter build apk --release --analyze-size --target-platform=android-arm64



// استخدم في حق القرأن صوت نفس البتوم شيت حق قراءة قرأن

// test cici