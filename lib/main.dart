import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:quran_app/features/floating_adhkar/overlay/floating_adhkar_overlay_entrypoint.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/main_view.dart';
import 'package:quran_library/quran.dart';

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

Logger logger = Logger();

@pragma('vm:entry-point')
Future<void> overlayMain() async {
  await runFloatingAdhkarOverlay();
}

void main() async {
  // Ensures plugins are ready before async startup work.
  WidgetsFlutterBinding.ensureInitialized();
  await PackageInfo.fromPlatform();

  // Initialize timezone support.
  await TimeZoneService().setupTimezone();

  await DownloadService().initialize();

  // Initialize Firebase early because some app-level services depend on it.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Register app dependencies.
  await setupServiceLocator();

  // Observe bloc transitions globally.
  Bloc.observer = MyBlocObserver();

  // Initialize networking.
  await DioHelper.init();

  // Initialize local database.
  await DatabaseService().database;

  // Initialize local cache.
  await CacheConfig.loadConfig();

  // Prime location permission service.
  await LocationPermissionService.init();

  try {
    await QuranLibrary.init();
  } catch (e) {
    debugPrint('QuranLibrary initialization failed: $e');
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  //
  await NotificationPermissionService.handelNotification();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
  // runApp(const MyApp());
}

// https://vercel-pdf-proxy.vercel.app/proxy?url=https://www.archive.org/download/waq79565/79565.pdf
// https://waqfeya.net/

// https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions.json

// https://www.jsdelivr.com/package/gh/fawazahmed0/quran-api

// flutter build apk --release --split-per-abi
// flutter build apk --release --target-platform
// android-arm,android-arm64 --split-per-abi
// flutter build apk --release --target-platform android-arm
// flutter build apk --release --target-platform android-arm64

// flutter build apk --release --analyze-size --target-platform=android-arm64

// استخدم في حق القرأن صوت نفس البتوم شيت حق قراءة قرأن
