import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_bottom_sheet.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_app/features/quran/controller/db_helper.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/page/read/widget/search_ayah_bottom.dart';

import '../../../../../quran_audio/ui/widgets/scroll_to_dialog.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  showBottomSheetFunction(
                      context: context, child: SearchAyahBottomSheet());
                },
                child: Text(
                  "البحث على ايه ؟",
                  style: titleSmall(context),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      QuranCubit.get(context).changeScreenSurahRead();
                    },
                    child: Text(
                      QuranCubit.get(context).isSurahReadAndListen
                          ? "وضع التفسير"
                          : "وضع القراءة",
                      style: titleMedium(context).copyWith(
                        color: QuranCubit.get(context).isSurahReadAndListen
                            ? ColorsManager.customPrimary
                            : Colors.red,
                      ),
                    ),
                  ),
                  QuranCubit.get(context).isSurahReadAndListen
                      ? IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => ScrollToDialog(),
                            );
                          },
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                        )
                      : const SizedBox(),
                  QuranCubit.get(context).isSurahReadAndListen
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            var cubit = QuranCubit.get(context);

                            QuranBookMarkModel quranBookMarkModel =
                                QuranBookMarkModel(
                              verseNumber: cubit.currentAyahSelected ?? 1,
                              pageNumber: cubit.currentPageSurahRead!,
                              nameSurah: cubit.currentNameSurahRead,
                              surahNumber: cubit.indexSurahRead,
                            );
                            cubit.saveBookMark(
                                quranBookMarkModel: quranBookMarkModel);
                          },
                          icon: const Icon(Icons.bookmark_border),
                        ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
