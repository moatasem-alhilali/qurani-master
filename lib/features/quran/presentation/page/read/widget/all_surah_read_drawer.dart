import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/jsons/assets_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/page/read/widget/search_surah_drwaer_item.dart';
import 'package:quran_app/features/search_ayah/cubit/serch_ayah_cubit.dart';

class AllSurahReadDrawer extends StatelessWidget {
  const AllSurahReadDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: ColorsManager.customPrimary,
            unselectedLabelColor: Colors.grey,
            labelColor: ColorsManager.customPrimary,
            tabs: const [
              Tab(
                text: "السور",
              ),
              Tab(
                text: "المحفوضات",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                surahItemDrawer(),

                //
                _bookMark(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _bookMark extends StatelessWidget {
  const _bookMark({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quranBookMark.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var data = quranBookMark[index];
        return InkWell(
          onTap: () {
            // QuranCubit.get(context).mySetState();
            if (QuranCubit.get(context).isSurahReadAndListen) {
              QuranCubit.get(context).isSurahReadAndListen = false;
              QuranCubit.get(context).mySetState();
              ToastServes.showToast(message: "تم التحويل الى وضع القراءة");
              ToastServes.showToast(message: "اضغط مرة اخرى");
            } else {
              QuranCubit.get(context).indexSurahRead = data.surahNumber!;
              QuranCubit.get(context).currentNameSurahRead = data.nameSurah!;
              QuranCubit.get(context).mySetState();
              QuranCubit.get(context).currentAyahSelected = null;
              Scaffold.of(context).closeDrawer();
              QuranCubit.get(context)
                  .pageController!
                  .jumpToPage(data.pageNumber! - 1);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: index % 2 == 0 ? null : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "اسم السورة : ${data.nameSurah!}",
                      style: titleSmall(context),
                    ),
                    Text(
                      "رقم الصفحة : ${data.pageNumber!}",
                      style: titleSmall(context).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class surahItemDrawer extends StatelessWidget {
  surahItemDrawer({
    super.key,
  });
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
          child: MyTextFormField(
            controller: controller,
            height: 8,
            bottomMargin: 1,
            onChanged: (text) {
              QuranCubit.get(context).searchSurahDrawer(text: text);
            },
            onEditingComplete: () {
              var cubit = QuranCubit.get(context);
              SearchAyahCubit.get(context).searchAyahInSurah(
                ayah: controller.text,
                surahNumber: cubit.indexSurahRead,
              );
            },
            onFieldSubmitted: (text) {
              var cubit = QuranCubit.get(context);
            },
            onSaved: (text) {
              var cubit = QuranCubit.get(context);
            },
            hintText: "البحث على سورة",
            obscureText: false,
            suffixIcon: IconButton(
              onPressed: () {
                var cubit = QuranCubit.get(context);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
        BlocBuilder<QuranCubit, QuranCubitState>(
          builder: (context, state) {
            if (controller.text.isNotEmpty) {
              return SearchSurahDrawerItem();
            } else {
              return _allSurahItem();
            }
          },
        ),
      ],
    );
  }
}

class _allSurahItem extends StatelessWidget {
  const _allSurahItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: surahData.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (QuranCubit.get(context).isSurahReadAndListen) {
                  QuranCubit.get(context).currentAyahSelected = null;
                  QuranCubit.get(context).indexSurahRead = index + 1;
                  QuranCubit.get(context).initPlayerPlayAyah(
                    surahNumber: QuranCubit.get(context).indexSurahRead,
                  );
                  Scaffold.of(context).closeDrawer();
                  QuranCubit.get(context).mySetState();
                } else {
                  QuranCubit.get(context).currentAyahSelected = null;
                  QuranCubit.get(context).indexSurahRead = index + 1;
                  QuranCubit.get(context).pageController!.jumpToPage(0);
                  QuranCubit.get(context).initPlayerPlayAyah(
                    surahNumber: QuranCubit.get(context).indexSurahRead,
                  );
                  Scaffold.of(context).closeDrawer();
                  QuranCubit.get(context).mySetState();
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? null : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surahData[index].titleAr!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          textAlign: TextAlign.right,
                          'عدد الايات: ${countOfVerses[index]} - ${surahData[index].place == 'Medina' ? 'مدنية' : 'مكية'}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: ColorsManager.customPrimary,
                      child: Text(
                        "${index + 1}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
