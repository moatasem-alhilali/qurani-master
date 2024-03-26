import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/add_bookmark_button.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/copy_button.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/show_ayah_tafsir.dart';

void showAyahMenu(
  int surahNum,
  int ayahNum,
  String ayahText,
  int pageIndex,
  String ayahTextNormal,
  int ayahUQNum,
  String surahName,
  int index, {
  dynamic details,
  BuildContext? myContext,
   required String ayahUrl,

}) {
  BotToast.showAttachedWidget(
    target: details.globalPosition,
    verticalOffset: 30.0,
    horizontalOffset: 0.0,
    animationDuration: const Duration(microseconds: 700),
    animationReverseDuration: const Duration(microseconds: 700),
    attachedBuilder: (cancel) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: currentThemeData.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: currentThemeData.colorScheme.background.withOpacity(.95),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                width: 2,
                color: currentThemeData.colorScheme.primary.withOpacity(.5))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CopyButton(
                ayahNum: ayahNum,
                surahName: surahName,
                ayahTextNormal: ayahTextNormal,
                cancel: cancel,
              ),
              const Gap(6),
              vDivider(height: 18.0),
              const Gap(6),
              AddBookmarkButton(
                ayahNum: ayahNum,
                surahName: surahName,
                cancel: cancel,
                ayahUQNum: ayahUQNum,
                pageIndex: pageIndex,
                surahNum: surahNum,
              ),
              const Gap(6),
              vDivider(height: 18.0),
              const Gap(6),
              TafsierButton(
                ayah: ayahTextNormal,
                ayahNum: ayahNum,
                surahName: surahName,
                cancel: cancel,
                ayahUQNum: ayahUQNum,
                pageIndex: pageIndex,
                surahNum: surahNum,
                myContext: myContext!,
                ayahUrl: ayahUrl,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget vDivider({double? height, Color? color}) {
  return Container(
    height: height ?? 20,
    width: 2,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    color: color ?? currentThemeData.colorScheme.surface,
  );
}
