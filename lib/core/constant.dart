import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_screen.dart';
import 'package:quran_app/features/home/pages/home_screen.dart';
import 'package:quran_app/features/offline/presentation/view/pages/offline_screen.dart';
import 'package:quran_app/features/read_quran/data/model/surah_model.dart';
import 'package:quran_app/features/sabih/model/subih_model.dart';
import 'package:quran_app/core/services/services_notification.dart';

const String ayah =
    "﴿رَبِّ أَوزِعني أَن أَشكُرَ نِعمَتَكَ التي أَنعَمتَ عَلَيَّ وعَلى والدَيَّ وأَن أَعمَلَ صالحاً ترضاهُ وأَصلِح لي في ذُريتي إِنّي تُبتُ إِلَيكَ وإِنّي مِنَ المُسلِمينَ﴾";
const String thikr =
    "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير";
//url audio
List<String> urlAudio = [];
List<SurahModel> surahDownload = [];
// List<SurahModel> surahData = [];
List<SubihModel> tusbihData = [];
//-----------Cash Helper-----------

bool fabIsClicked = false;
String? lasSurahRead;
int pdfSurah = 1;
int pdfPage = 1;
String lastTimeCash = '';
String lastDateCash = '';

String dateNow = DateFormat('yMMMd').format(DateTime.now());
String timeNow = DateFormat('jm').format(DateTime.now());

//-------Notification -------
late NotifyHelper notifyHelper;

//theme mode
bool isLightMode = false;

//masbah state
int masbahSize = 0;
//font name
String quran = 'quran';
String quran2 = 'quran2';
String fontMain = 'ios-1';
String? defaultNameQuran;
//font size
double? fontSizeQuran;
double? fontSizeAthkar;
//color type

Color defaultColor = const Color(0xff2f2f2f);
bool ISCONNECTED = true;
bool ISNOT_NOTIFY = true;

//
void navigateTo(Widget? child, context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => child!));
}

// selected Index
int selectedIndex = 3;

//url of audio reader
const String urlAudioReader =
    "https://cdn.islamic.network/quran/audio-surah/128";
//
int nextCurrentPrayer = 0;

List<Widget> screens = [
  const HomeScreenNew(),
  const CategoryScreen(),
  // const AnotherScreen(),

  const OfflineScreen(),
];

//
int lastPageRead = 0;
int currentThemeType = 0;
