import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_bloc.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_event.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_state.dart';

class SurahWithAllDetailScreen extends StatefulWidget {
  const SurahWithAllDetailScreen({super.key});

  @override
  State<SurahWithAllDetailScreen> createState() =>
      _SurahWithAllDetailScreenState();
}

class _SurahWithAllDetailScreenState extends State<SurahWithAllDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SurahInfoBloc>().add(LoadSurahInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: 'معلومات حول السور',
      body: BlocBuilder<SurahInfoBloc, SurahInfoState>(
        builder: (context, state) {
          if (state is SurahInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SurahInfoError) {
            return Center(child: Text(state.message));
          }

          if (state is SurahInfoLoaded) {
            final dataList = state.data;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];

                return BaseAnimate(
                  index: index,
                  child: InkWell(
                    onTap: () {
                      context.showBottomSheet(
                        child: _BottomSheet(data: data),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: index % 2 == 0
                            ? context.primaryScheme
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إسم السورة : ${data.surah}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          CircleAvatar(
                            backgroundColor: index % 2 == 0
                                ? context.primaryScheme
                                : context.primarySecondary,
                            radius: 18,
                            child: Text('${index + 1}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
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
