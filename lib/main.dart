import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:quran_app/core/bloc/bloc_observer.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/time_zone_service.dart';
import 'package:quran_app/main_view.dart';


// ✅ Logger instance used globally for debugging and logging
Logger logger = Logger();

void main() async {
  // 🧠 Ensures binding is initialized before running async code (important for plugins)
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Initialize timezone support to handle local timezones correctly
  await TimeZoneService().setupTimezone();

  // 📥 Initialize the FlutterDownloader for background downloading support
  await FlutterDownloader.initialize();

  // 🧩 Register dependencies using service locator (e.g., GetIt)
  setupServiceLocator();

  // 👁️ Set a custom Bloc observer to monitor Bloc events and transitions globally
  Bloc.observer = MyBlocObserver();

  // 🌍 Initialize the Dio HTTP client with base config (headers, interceptors, etc.)
  await DioHelper.init();

  // 🗂️ Initialize SQLite database and ensure all required tables are created
  await DatabaseService().database;

  // 💾 Initialize local cache (e.g., SharedPreferences)
  await CacheService.init();

  // 💾 Initialize local cache (e.g., SharedPreferences)
  await CacheConfig.init();

  // 🔐 Request critical permissions (e.g., storage, notifications)
  await PermissionService.init();

  // 🚀 Launch the root of the Flutter application
  runApp(const MyApp());
}




// https://vercel-pdf-proxy.vercel.app/proxy?url=https://www.archive.org/download/waq79565/79565.pdf
// https://waqfeya.net/