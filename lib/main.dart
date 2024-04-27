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

//flutter pub outdated

//flutter build appbundle --no-tree-shake-icons
//keytool -importkeystore -srckeystore upload-keystore.jks -destkeystore upload-keystore.jks -deststoretype pkcs12

Logger logger = Logger();
//flutter build appbundle --release --no-sound-null-safety
//flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --no-sound-null-safety
//flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --no-sound-null-safety --obfuscate --split-debug-info=symbols/

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

//https://raw.githubusercontent.com/islamic-network/cdn/master/info/cdn_surah_audio.json

//https://api.alquran.cloud/v1/edition/format/audio

//ai:https://islam-ai-api.p.rapidapi.com/api/bot?question="اهميه الصلاة"
//ai:https://islam-ai-api.p.rapidapi.com/api/chat?question="اهميه الصلاة"
