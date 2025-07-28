import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_bloc.dart';

class SurahWithAllDetailScreen extends StatefulWidget {
  const SurahWithAllDetailScreen({super.key});

  @override
  State<SurahWithAllDetailScreen> createState() =>
      _SurahWithAllDetailScreenState();
}

class _SurahWithAllDetailScreenState extends State<SurahWithAllDetailScreen> {
  final searchController = SearchController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahInfoBloc()..add(LoadSurahInfoEvent()),
      child: AppScaffoldWidget(
        title: 'السور وسبب النزول',
        trailing: BlocBuilder<SurahInfoBloc, SurahInfoState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<SurahInfoModel>(
              asyncSuggestions: (query) async {
                return state.data
                    .where((element) => element.surah.contains(query))
                    .toList();
              },
              onSelected: (item) {},
              hintText: 'بحث عن سورة',
              suggestionBuilder: (context, item) => _Item(data: item),
            );
          },
        ),
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

                      return _Item(data: data);
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

class _Item extends StatelessWidget {
  const _Item({
    required this.data,
    super.key,
  });

  final SurahInfoModel data;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: 0,
      child: InkWell(
        onTap: () {
          context.showBottomSheet(
            child: _BottomSheet(data: data),
          );
        },
        child: CardWidget(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إسم السورة : ${data.surah}',
                style: titleSmall(context).copyWith(
                    // color: context.gray2,
                    ),
              ),
              // CircleAvatar(
              //   backgroundColor: context.surfaceColor,
              //   radius: 12.r,
              //   child: FittedBox(
              //     child: Text('${data.surah}'),
              //   ),
              // ),
            ],
          ),
        ),
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
