import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_app/core/components/base_bottom_sheet.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran/controller/repository_quran.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:al_quran/al_quran.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'ayah_bottom_sheet.dart';

class QuranListenAndRead extends StatelessWidget {
  const QuranListenAndRead({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        var cubit = QuranCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "سورة ${quran.getSurahNameArabic(QuranCubit.get(context).indexSurahRead)}",
                style: titleMedium(context).copyWith(color: Colors.grey),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: ControllerQuran.scrollSurahController,
                itemPositionsListener: ControllerQuran.positionsSurahListener,
                shrinkWrap: true,
                itemCount: AlQuran.surahDetails
                    .bySurahNumber(cubit.indexSurahRead)
                    .verse,
                // quran.getVerseCount(cubit.indexSurahRead),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  //var ayat
                  var ayat = AlQuran.surahDetails
                      .bySurahNumber(cubit.indexSurahRead)
                      .ayahs[index]
                      .text;
                  return InkWell(
                    onTap: () {
                      showAyahTafsir(context: context, indexAyah: index + 1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BlocBuilder<QuranCubit, QuranCubitState>(
                        builder: (context, state) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ayat,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: QuranCubit.get(context)
                                                .currentPlayingAyaIndex ==
                                            index
                                        ? Colors.redAccent
                                        : Colors.black,
                                    fontFamily: "quran2",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: index % 2 == 0
                                    ? ColorsManager.customPrimary
                                    : ColorsManager.customPrimarySecondary,
                                child: Text(
                                  "${index + 1}",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showAyahTafsir({required BuildContext context, required int indexAyah}) {
    //get the ayah tafsir
    final tafsirAyah = ControllerQuran.getTafsirAyah(
      ayah: indexAyah,
      surahNumber: QuranCubit.get(context).indexSurahRead,
    );

    ControllerQuran.audioPlayerPlayAyah.seek(
      Duration.zero,
      index: indexAyah - 1,
    );

    // show bottom sheet

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return AyahBottomSheet(
          index: indexAyah,
          tafsirAyah: tafsirAyah,
        );
      },
    ).whenComplete(() {
      ControllerQuran.audioPlayerPlayAyah.stop();
    });
  }
}
