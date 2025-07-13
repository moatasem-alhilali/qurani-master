import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/bloc/audio/share_audio_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/package/arabic_convert.dart';
import 'package:quran_app/core/theme/theme_data.dart';
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
  @override
  void initState() {
    super.initState();
  }

  String tafsirAyah() {
    return QuranReadHelper.getTafsirAyah(
      ayah: widget.ayahNum,
      surahNumber: widget.surahNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textCopy =
        '﴿${widget.ayahTextNormal}﴾ [${widget.surahName}-${ArabicNumbers.convert(widget.ayahNum)}]';

    return BlocProvider(
      create: (context) => ShareAudioBloc()
        ..add(InitAndSetUrlAudioPlayerEvent(url: widget.ayahUrl)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            CardWidget(
              width: double.infinity,
              padding: EdgeInsets.all(4.sp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'نسخ الايه',
                        style: titleMedium(context).copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      const Gap(10),
                      Semantics(
                        button: true,
                        enabled: true,
                        label: 'Copy Ayah',
                        child: CopyIconWidget(
                          text: textCopy,
                        ),
                      ),
                    ],
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
            ),
            const Gap(6),
            const Divider(),
            AyahBottomSheet(
              ayah: widget.ayahTextNormal,
              verseNumber: widget.ayahNum,
              text: tafsirAyah(),
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
