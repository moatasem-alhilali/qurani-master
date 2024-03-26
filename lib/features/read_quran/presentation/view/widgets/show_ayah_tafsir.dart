import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/ayah_bottom_sheet.dart';

class TafsierButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;
  final String ayah;
  final String ayahUrl;
  final Function? cancel;
  final BuildContext myContext;

  const TafsierButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahName,
    required this.myContext,
    required this.ayah,
    required this.ayahUrl,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Add Bookmark',
        child: tafsir_icon(height: 30.0),
      ),
      onTap: () async {
        final tafsirAyah = QuranReadHelper.getTafsirAyah(
          ayah: ayahNum,
          surahNumber: surahNum,
        );

        AudioPlayer audioPlayer = AudioPlayer();
        audioPlayer.setUrl(ayahUrl);
        myContext.showBottomSheet(
          child: AyahBottomSheet(
            ayah: ayah,
            verseNumber: ayahNum,
            text: tafsirAyah,
            audioPlayer: audioPlayer,
            surahNumber: surahNum,
          ),
          whenCompleted: () {
            audioPlayer.stop();
          },
        );
      },
    );
  }
}
