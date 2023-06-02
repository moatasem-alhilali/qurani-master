import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/page/read/widget/quran_listen_and_read.dart';

class BodyDetail extends StatelessWidget {
  const BodyDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranCubit, QuranCubitState>(
      listener: (context, state) {
        if (state is SaveBookMarkSuccessesState) {
          ToastServes.showToast(message: "تم حفظ العلامة بنجاح");
        }
        if (state is SaveBookMarkErrorState) {
          ToastServes.showToast(message: "خطأ لم يتم حفظ العلامة");
        }
      },
      builder: (context, state) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: QuranCubit.get(context).isSurahReadAndListen
                ? const QuranListenAndRead()
                : _body(),
          ),
        );
      },
    );
  }
}

class _body extends StatelessWidget {
  _body({
    super.key,
  });
  List<int> indexAyahPageList = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        var cubit = QuranCubit.get(context);
        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: QuranCubit.get(context).pageController,
          onPageChanged: (index) {
            cubit.mySetState();

            indexAyahPageList.clear();
            //
            cubit.currentPageSurahRead = index + 1;
            cubit.currentNameSurahRead =
                quran.getSurahNameArabic(cubit.indexSurahRead);
            //
            cubit.currentAyahSelected = null;
          },
          itemCount: quran
              .getSurahPages(QuranCubit.get(context).indexSurahRead)
              .length,
          itemBuilder: (context, indexPage) {
            var surahPage = quran.getSurahPages(
                QuranCubit.get(context).indexSurahRead)[indexPage];
            final versePage = Column(
              children: [
                indexPage == 0
                    ? const Text(
                        "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          wordSpacing: 5,
                          color: Colors.black,
                          fontFamily: "quran2",
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const SizedBox(),
                _Ayah(surahPage: surahPage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "سورة ${quran.getSurahNameArabic(cubit.indexSurahRead)}",
                      style: titleSmall(context).copyWith(color: Colors.grey),
                    ),
                    Text(
                      "الصفحة ${cubit.currentPageSurahRead}",
                      style: titleSmall(context).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            );

            //verse
            return versePage;
          },
        );
      },
    );
  }
}

class _Ayah extends StatelessWidget {
  const _Ayah({super.key, required this.surahPage});

  final int surahPage;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Wrap(
              textDirection: TextDirection.rtl,
              children: quran
                  .getVersesTextByPage(surahPage, verseEndSymbol: true)
                  .map(
                (ayah) {
                  return Text(
                    ayah,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "quran2",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}
