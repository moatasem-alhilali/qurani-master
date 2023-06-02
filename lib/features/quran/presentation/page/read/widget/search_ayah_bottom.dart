import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/search_ayah/cubit/serch_ayah_cubit.dart';

class SearchAyahBottomSheet extends StatelessWidget {
  SearchAyahBottomSheet({super.key});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical! * 60,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextFormField(
            controller: controller,
            height: 10,
            bottomMargin: 1,
            onChanged: (text) {},
            onEditingComplete: () {
              var cubit = QuranCubit.get(context);
              SearchAyahCubit.get(context).searchAyahInSurah(
                ayah: controller.text,
                surahNumber: cubit.indexSurahRead,
              );
            },
            onFieldSubmitted: (text) {
              var cubit = QuranCubit.get(context);
              SearchAyahCubit.get(context).searchAyahInSurah(
                ayah: controller.text,
                surahNumber: cubit.indexSurahRead,
              );
            },
            onSaved: (text) {
              var cubit = QuranCubit.get(context);
              SearchAyahCubit.get(context).searchAyahInSurah(
                ayah: controller.text,
                surahNumber: cubit.indexSurahRead,
              );
            },
            hintText: "الاية",
            obscureText: false,
            suffixIcon: IconButton(
              onPressed: () {
                var cubit = QuranCubit.get(context);
                SearchAyahCubit.get(context).searchAyahInSurah(
                  ayah: controller.text,
                  surahNumber: cubit.indexSurahRead,
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),

          //
          //widget data
          BlocBuilder<SearchAyahCubit, SerchAyahState>(
            builder: (context, state) {
              if (state is SerchAyahInSurahNoDataState) {
                return Text(
                  "لم يتم العثور على الاية",
                  style: titleSmall(context),
                );
              }
              if (state is SearchAyahInSurahSuccessState) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.resultAyah.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      var data = state.resultAyah[index];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.resultAyah[index]['ayah'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 237, 235, 235),
                                fontFamily: 'quran2',
                                fontSize: 16,
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Text(
                              "رقم الصفحة ${state.resultAyah[index]['pageNumber']}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
