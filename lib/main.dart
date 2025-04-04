import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';

import 'package:quran_app/core/BlocObserver/BlocObserver.dart';
import 'main_view.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';


Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  //
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  DBHelper.initDb();
  await CashConfig.init();
  setupServiceLocator();

  await PermissionService.init();

  runApp(const MyApp());
}

