import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/package/arabic_convert.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/util/toast_message.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/add_bookmark_ayah_button.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/ayah_bottom_sheet.dart';

class MenuActionWidget extends StatefulWidget {
  const MenuActionWidget({
    required this.ayahNum,
    required this.surahName,
    required this.ayahTextNormal,
    required this.cancel,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahNum,
    required this.ayahUrl,
    required this.myContext,
    super.key,
  });
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;
  final int ayahUQNum;
  final int pageIndex;
  final int surahNum;
  final String ayahUrl;
  final BuildContext myContext;

  @override
  State<MenuActionWidget> createState() => _MenuActionWidgetState();
}

class _MenuActionWidgetState extends State<MenuActionWidget> {
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    setUrl();
    super.initState();
  }

  String tafsirAyah() {
    return QuranReadHelper.getTafsirAyah(
      ayah: widget.ayahNum,
      surahNumber: widget.surahNum,
    );
  }

  Future<void> setUrl() async {
    await audioPlayer.setUrl(widget.ayahUrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            const Gap(6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CopyButton(
                  ayahNum: widget.ayahNum,
                  surahName: widget.surahName,
                  ayahTextNormal: widget.ayahTextNormal,
                  cancel: widget.cancel,
                ),
                const Gap(6),
                vDivider(height: 18, context: context),
                const Gap(6),
                AddBookmarkAyahButton(
                  ayahNum: widget.ayahNum,
                  surahName: widget.surahName,
                  cancel: widget.cancel,
                  ayahUQNum: widget.ayahUQNum,
                  pageIndex: widget.pageIndex,
                  surahNum: widget.surahNum,
                ),
                const Gap(6),
              ],
            ),
            const Gap(6),
            const Divider(),
            AyahBottomSheet(
              ayah: widget.ayahTextNormal,
              verseNumber: widget.ayahNum,
              text: tafsirAyah(),
              audioPlayer: audioPlayer,
              surahNumber: widget.surahNum,
            ),
          ],
        ),
      ),
    );
  }
}

Widget vDivider({required BuildContext context, double? height, Color? color}) {
  return Container(
    height: height ?? 20,
    width: 2,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: color ?? context.quranTheme.colorScheme.surface,
  );
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.ayahNum,
    required this.surahName,
    required this.ayahTextNormal,
    super.key,
    this.cancel,
  });
  final int ayahNum;
  final String surahName;
  final String ayahTextNormal;
  final Function? cancel;

  @override
  Widget build(BuildContext context) {
    ToastMessage.init(context);
    return Row(
      children: [
        Text(
          'نسخ الايه',
          style: titleMedium(context).copyWith(
            fontSize: 16.sp,
          ),
        ),
        const Gap(10),
        GestureDetector(
          child: Semantics(
            button: true,
            enabled: true,
            label: 'Copy Ayah',
            child: copy_icon(height: 30),
          ),
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text:
                    '﴿$ayahTextNormal﴾ [$surahName-${ArabicNumbers.convert(ayahNum)}]',
              ),
            ).then((value) {
              ToastServes.showToast(message: 'تم النسخ بنجاح');
            });
          },
        ),
      ],
    );
  }
}
