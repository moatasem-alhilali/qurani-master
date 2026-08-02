import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:quran_app/core/bloc/bloc_observer.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/home_widgets/home_widgets_service.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/firebase_notification.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/time_zone_service.dart';
import 'package:quran_app/features/floating_adhkar/overlay/floating_adhkar_overlay_entrypoint.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/main_view.dart';
import 'package:quran_app/src/core/review/app_review_service.dart';
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

  // Networking is a plain synchronous object build. It must exist before any
  // request because `DioHelper.dio` is `late` (a request before init would
  // throw a LateInitializationError), so we build it now — it costs nothing.
  DioHelper.init();

  // These initializers are mutually independent, so we run them concurrently:
  // cold start is then bounded by the slowest one instead of their sum. Each is
  // self-guarded so a single failure can't reject the whole batch.
  //
  // They still complete BEFORE runApp on purpose: the widget tree resolves
  // `sl<...>()` synchronously during the first build and the eager (lazy:false)
  // blocs immediately fire data/DB/network events, so their prerequisites must
  // be ready. Notably:
  //  - Firebase must be up before setupServiceLocator (it reads
  //    Firestore/Messaging `.instance`), so DI stays after this batch.
  //  - The DB is pre-warmed here (not left to lazy first-access) to avoid a
  //    concurrent `openDatabase` race (the getter has no in-flight guard).
  await Future.wait([
    _guardedInit('Firebase', () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }),
    _guardedInit('Timezone', () => TimeZoneService().setupTimezone()),
    _guardedInit('Cache', CacheConfig.loadConfig),
    _guardedInit('QuranLibrary', QuranLibrary.init),
    _guardedInit('Database', () => DatabaseService().database),
  ]);

  // Register app dependencies. Depends on Firebase (above) being initialized;
  // may touch the DB, which is already warmed so there is no open race.
  await setupServiceLocator();

  // Observe bloc transitions globally.
  Bloc.observer = MyBlocObserver();

  runApp(
    const MyApp(),
  );

  // Everything below is non-visual and not needed by the first frame or by the
  // eager startup blocs, so we kick it off after runApp to shorten cold start.
  unawaited(_initAfterFirstFrame());
}

/// Runs [task] and swallows/logs any error so one failing initializer can never
/// reject the whole [Future.wait] batch (or crash launch).
Future<void> _guardedInit<T>(String label, Future<T> Function() task) async {
  try {
    await task();
  } catch (e) {
    debugPrint('$label initialization failed: $e');
  }
}

/// Non-critical startup work moved off the launch critical path. None of it is
/// required to render the first frame or by the eager startup blocs:
///  - Download service is only needed once the user downloads something.
///  - Home-screen widgets are a background convenience (Android only).
///  - The iOS background-message handler only matters once app is backgrounded.
Future<void> _initAfterFirstFrame() async {
  await _guardedInit('DownloadService', () => DownloadService().initialize());

  // Count this launch for the in-app review eligibility policy (days since
  // install + number of opens). Purely local; never blocks or prompts here.
  await _guardedInit('AppReview', () => AppReviewService().registerAppOpen());

  // Home-screen widgets are disabled on iOS only (widget extension signing is
  // unresolved). Android keeps working normally.
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.iOS) {
    await _guardedInit('HomeWidgets', () async {
      final homeWidgetsService = HomeWidgetsService();
      await homeWidgetsService.refreshAll();
      await homeWidgetsService.startBackgroundUpdates();
    });
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
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


// com.tamaneena.tamaneena_app old telegram
// com.nanohive.tamaneena
// dart pub global run rename setBundleId --targets android --value "com.nanohive.tamaneena"
// dart pub global run rename setBundleId --targets android --value "com.tamaneena.tamaneena_app"
