import 'package:flutter/material.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_library/quran_library.dart';

/// يفتح المصحف عند أوّل آية في الجلسة.
///
/// كان هذا المنطق مكرّرًا حرفًا بحرف في بطاقتي الجلسة، فجُمع هنا.
void openSessionInQuran(BuildContext context, QuranPlanSession session) {
  final quranCtrl = QuranCtrl.instance;
  final uqIndex = quranCtrl.resolveAyahUq(
    surahNumber: session.fromSurahId,
    ayahNumber: session.fromAyahNumber,
  );
  final ayah = quranCtrl.getAyahByUq(uqIndex);

  var targetPage = 1;

  if (ayah.ayahUQNumber != 0) {
    targetPage = ayah.page;
    // نُقفز في المتحكّم أيضًا حتى يعود القارئ إلى الصفحة نفسها لاحقًا.
    quranCtrl
      ..jumpToPage(targetPage - 1)
      ..toggleAyahSelection(ayah.ayahUQNumber);
  } else {
    final surah = _findSurah(session.fromSurahId);
    if (surah != null && surah.ayahs.isNotEmpty) {
      targetPage = surah.ayahs.first.page;
      quranCtrl.jumpToPage(targetPage - 1);
    }
  }

  context.push(ReadQuranScreen(page: targetPage - 1));
}

/// نصّ مدى الجلسة: «من الفاتحة ١ إلى البقرة ٥».
String sessionRangeLabel(QuranPlanSession session) {
  final fromSurah = _findSurah(session.fromSurahId);
  final toSurah = _findSurah(session.toSurahId);

  final fromName = fromSurah?.arabicName ?? 'سورة ${session.fromSurahId}';
  final toName = toSurah?.arabicName ?? 'سورة ${session.toSurahId}';

  return 'من $fromName الآية ${session.fromAyahNumber}'
      ' إلى $toName الآية ${session.toAyahNumber}';
}

/// يبحث عن سورة برقمها في بيانات المكتبة.
SurahModel? _findSurah(int surahId) {
  for (final surah in QuranCtrl.instance.surahs) {
    if (surah.surahNumber == surahId) {
      return surah;
    }
  }
  return null;
}
