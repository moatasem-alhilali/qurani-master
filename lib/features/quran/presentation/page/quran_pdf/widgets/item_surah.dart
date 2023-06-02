import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/animation_list.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/model/surah_model.dart';

import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/page/pdf_read.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/function/function_navigate.dart';
import 'package:quran_app/core/jsons/assets_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ItemSurah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        return ScrollablePositionedList.builder(
          itemScrollController: FunctionNavigate.scrollSurahController,
          itemPositionsListener: FunctionNavigate.positionsSurahListener,
          itemCount: surahData.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return BaseAnimationListView(
              index: index,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    goTo(context: context, index: index, surahData: surahData);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
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
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              textAlign: TextAlign.right,
                              'عدد الايات: ${countOfVerses[index]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          surahData[index].place == 'Medina' ? 'مدنية' : 'مكية',
                          style: titleSmall(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void goTo({
  required BuildContext context,
  required int index,
  required List<SurahModel> surahData,
}) async {
  int page = int.parse(surahData[index].pages!);
  navigateTo(PdfRead(page: page), context);
  await CashHelper.setData(key: 'pdfSurah', value: page);
  pdfPage = page;
  lasSurahRead = surahData[index].titleAr;
  await CashHelper.setData(key: 'lastSurah', value: lasSurahRead);
  await CashHelper.setData(key: 'last_time', value: timeNow);
  lastTimeCash = timeNow;
  await CashHelper.setData(key: 'last_date', value: dateNow);
  lastDateCash = dateNow;

  HomeCubit.get(context).mySetState();
}
