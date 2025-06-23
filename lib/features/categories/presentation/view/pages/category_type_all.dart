import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_icon_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/quran_sheet.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/sheet_audio.dart';

class CategoryTypeDetail extends StatelessWidget {
  CategoryTypeDetail({super.key, this.data});
  final dynamic data;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      isScroll: false,
      title: data['title'].toString(),
      body: BlocProvider(
        create: (context) => CategoryBloc(
          repositoryImpl: sl.get<CategoryRepositoryImpl>(),
        )..add(GetQuranBookEvent(data['api_url'] as String)),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return state.quranBooksState.handle<List<dynamic>>(
              onSuccess: () {
                final allData = state.quranBooksDetailSearch;

                final randomShapeType = CardShapeType
                    .values[Random().nextInt(CardShapeType.values.length)];

                return Column(
                  children: [
                    MyTextFormField(
                      controller: search,
                      hintText: 'بحث',
                      suffixIcon: search.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                search.clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ).animate().fade()
                          : null,
                      onChanged: (text) {
                        _onSearchTextChanged(allData);
                        context.read<CategoryBloc>().add(SetStateEvent());
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _onSearchTextChanged(allData).length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = _onSearchTextChanged(allData)[index];
                          return FeatureCardIconWidget(
                            title: data['title'].toString(),
                            icon: Text(data['type'].toString()),
                            height: 100.h,
                            width: double.infinity,
                            shapeType: randomShapeType,
                            onTap: () {
                              data['apiurl'] = data['api_url'];
                              if (data['type'] == 'audios') {
                                context.showBottomSheet(
                                  child: SheetAudios(baseData: data),
                                );
                                return;
                              } else {
                                context.showBottomSheet(
                                  child: QuranBooksDetail(data: data),
                                );
                              }
                            },
                          );
                          //  _Item(allData);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data) {
    final res = data
        .where(
          (data) => data['title']
              .toString()
              .toLowerCase()
              .contains(search.text.toLowerCase()),
        )
        .toList();
    return res;
  }
}

//
