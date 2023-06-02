import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/features/search_ayah/cubit/serch_ayah_cubit.dart';
import 'package:quran_app/features/search_ayah/widgets/search_bar_item.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran/quran.dart' as quran;

class SearchAyahScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
          child: Column(
            children: [
              MyTextFormField(
                controller: controller,
                height: 10,
                bottomMargin: 1,
                onChanged: (text) {},
                onEditingComplete: () {
                  SearchAyahCubit.get(context)
                      .searchAyahInAllSurah(ayh: controller.text);
                },
                onFieldSubmitted: (text) {
                  SearchAyahCubit.get(context).searchAyahInAllSurah(ayh: text);
                },
                onSaved: (text) {
                  SearchAyahCubit.get(context).searchAyahInAllSurah(ayh: text!);
                },
                hintText: "الاية",
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {
                    SearchAyahCubit.get(context)
                        .searchAyahInAllSurah(ayh: controller.text);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),

              //widget data
              BlocBuilder<SearchAyahCubit, SerchAyahState>(
                builder: (context, state) {
                  if (state is SerchAyahQuranNoDataState) {
                    return Text(
                      "لم يتم العثور على الاية",
                      style: titleSmall(context),
                    );
                  }
                  if (state is SerchAyahQuranSuccessState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.resultAyah.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        var data = state.resultAyah[index];
                        return SearchBarItem(
                          searchAyahResultModel: data,
                          index: index,
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      customAppBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "البحث على أية",
              style: titleMedium(context),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ],
        ),
      ),
    );
  }
}
