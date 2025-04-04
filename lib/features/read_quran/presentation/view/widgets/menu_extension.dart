import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/add_bookmark_button.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/ayah_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/package/arabic_convert.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/util/toast_message.dart';

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
  required BuildContext context,
}) {
  BotToast.showAttachedWidget(
    target: details.globalPosition,
    verticalOffset: 30.0,
    horizontalOffset: 0.0,
    animationDuration: const Duration(microseconds: 700),
    animationReverseDuration: const Duration(microseconds: 700),
    attachedBuilder: (cancel) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: context.currentThemeData.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              context.currentThemeData.colorScheme.background.withOpacity(.95),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            width: 1,
            color: context.currentThemeData.colorScheme.primary.withOpacity(.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CopyButton(
                ayahNum: ayahNum,
                surahName: surahName,
                ayahTextNormal: ayahTextNormal,
                cancel: cancel,
              ),
              const Gap(6),
              vDivider(height: 18.0, context: context),
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
              vDivider(height: 18.0, context: context),
              const Gap(6),
              _TafsierButtonWidget(
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

Widget vDivider({double? height, Color? color, required BuildContext context}) {
  return Container(
    height: height ?? 20,
    width: 2,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    color: color ?? context.currentThemeData.colorScheme.surface,
  );
}

class _TafsierButtonWidget extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;
  final String ayah;
  final String ayahUrl;
  final Function? cancel;
  final BuildContext myContext;

  const _TafsierButtonWidget({
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

class _CopyButton extends StatelessWidget {
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  const _CopyButton(
      {super.key,
      required this.ayahNum,
      required this.surahName,
      required this.ayahTextNormal,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    ToastMessage.init(context);
    return GestureDetector(
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Copy Ayah',
        child: copy_icon(height: 30.0),
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text:
                    '﴿$ayahTextNormal﴾ [$surahName-${ArabicNumbers.convert(ayahNum)}]'))
            .then((value) {
          ToastServes.showToast(message: "تم النسخ بنجاح");
        });
      },
    );
  }
}
