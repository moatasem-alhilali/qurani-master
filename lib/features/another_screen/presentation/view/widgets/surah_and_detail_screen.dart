import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_bloc.dart';

class SurahWithAllDetailScreen extends StatelessWidget {
  const SurahWithAllDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahInfoBloc()..add(LoadSurahInfoEvent()),
      child: AppScaffoldWidget(
        title: 'معلومات حول السور',
        slivers: [
          BlocBuilder<SurahInfoBloc, SurahInfoState>(
            builder: (context, state) {
              return state.state.whenSliver<SurahInfoModel>(
                onSuccess: () {
                  final dataList = state.data;

                  return SliverList.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];

                      return BaseAnimate(
                        index: 0,
                        child: InkWell(
                          onTap: () {
                            context.showBottomSheet(
                              child: _BottomSheet(data: data),
                            );
                          },
                          child: CardWidget(
                            // padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(8),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(12),
                            //   color: index % 2 == 0
                            //       ? context.primaryColor
                            //       : Colors.transparent,
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'إسم السورة : ${data.surah}',
                                  style: titleSmall(context).copyWith(
                                      // color: context.gray2,
                                      ),
                                ),
                                CircleAvatar(
                                  backgroundColor: index % 2 == 0
                                      ? context.primaryColor
                                      : context.primaryColor.withOpacity(0.8),
                                  radius: 12.r,
                                  child: FittedBox(
                                    child: Text('${index + 1}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({required this.data});
  final SurahInfoModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerRow('إسم السورة', data.surah, 'عدد الآيات', data.ayaatiha),
            const Divider(),
            _section(context, 'معنى الإسم', data.maeniAsamuha),
            _section(context, 'سبب التسمية', data.sababTasmiatiha),
            _section(context, 'أسماء السورة', data.asmawuha),
            _section(context, 'المقصد العلمي من السورة', data.maqsiduhaAleamu),
            _section(context, 'سبب النزول', data.sababNuzuliha),
            _section(context, 'فضلها', (data.fadluha as List).join('\n\n')),
          ],
        ),
      ),
    );
  }

  Widget _headerRow(String key1, String value1, String key2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$key1 : $value1', style: const TextStyle(color: Colors.grey)),
        Text('$key2 : $value2', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _section(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleSmall(context)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
