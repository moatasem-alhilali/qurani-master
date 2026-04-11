import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
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
  String _query = '';

  String _asBullets(List<String> lines) {
    if (lines.isEmpty) return '';
    return lines.map((line) => '• ${line.trim()}').join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahInfoBloc()..add(LoadSurahInfoEvent()),
      child: AppScaffoldWidget(
        title: 'موسوعة السور',
        trailing: BlocBuilder<SurahInfoBloc, SurahInfoState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<SurahInfoModel>(
              asyncSuggestions: (query) async {
                final normalized = query.trim();
                if (normalized.isEmpty) return state.data;

                return state.data.where((item) {
                  return item.surah.contains(normalized) ||
                      item.id.toString().contains(normalized) ||
                      item.ayaatiha.contains(normalized);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.surah;
                });
                _showSurahDetails(context, item, state.data.indexOf(item));
              },
              hintText: 'بحث عن سورة',
              suggestionBuilder: (context, item) =>
                  UnifiedLibrarySearchSuggestion(
                title: item.surah,
                subtitle: item.maqsiduhaAleamu,
                trailing: '#${item.id}',
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<SurahInfoBloc, SurahInfoState>(
            builder: (context, state) {
              return state.state.whenSliver<SurahInfoModel>(
                onSuccess: () {
                  final normalized = _query.trim();
                  final dataList = normalized.isEmpty
                      ? state.data
                      : state.data.where((item) {
                          return item.surah.contains(normalized) ||
                              item.id.toString().contains(normalized);
                        }).toList();

                  if (dataList.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 52,
                                color: context.primaryColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'لا توجد نتائج مطابقة',
                                style: context.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _query = '';
                                  });
                                },
                                child: const Text('عرض جميع السور'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 24),
                    sliver: SliverList.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final data = dataList[index];

                        return _SurahTile(
                          data: data,
                          onTap: () => _showSurahDetails(context, data, index),
                        );
                      },
                    ),
                  );
                },
                sliverList: state.data,
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSurahDetails(BuildContext context, SurahInfoModel data, int index) {
    final shareContent = [
      'سورة ${data.surah}',
      '',
      'رقم السورة: ${data.id}',
      'عدد الآيات: ${data.ayaatiha}',
      '',
      'معنى اسم السورة:',
      data.maeniAsamuha,
      '',
      'سبب التسمية:',
      data.sababTasmiatiha,
      '',
      'أسماء أخرى:',
      data.asmawuha,
      '',
      'المقصد العام:',
      data.maqsiduhaAleamu,
      '',
      'سبب النزول:',
      data.sababNuzuliha,
      '',
      'فضائل السورة:',
      _asBullets(data.fadluha),
      '',
      'مناسبات السورة:',
      _asBullets(data.munasabatiha),
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: data.surah,
        subtitle: 'موسوعة السور',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'موسوعة السور',
        badges: [
          UnifiedLibraryMeta(
            label: 'الترتيب',
            value: '${index + 1}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: 'رقم السورة',
            value: '${data.id}',
          ),
          UnifiedLibraryMeta(
            label: 'عدد الآيات',
            value: data.ayaatiha,
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'معنى اسم السورة',
            content: data.maeniAsamuha,
          ),
          UnifiedLibrarySection(
            title: 'سبب التسمية',
            content: data.sababTasmiatiha,
          ),
          UnifiedLibrarySection(
            title: 'أسماء أخرى للسورة',
            content: data.asmawuha,
          ),
          UnifiedLibrarySection(
            title: 'المقصد العام',
            content: data.maqsiduhaAleamu,
          ),
          UnifiedLibrarySection(
            title: 'سبب النزول',
            content: data.sababNuzuliha,
          ),
          UnifiedLibrarySection(
            title: 'فضائل السورة',
            content: _asBullets(data.fadluha),
          ),
          UnifiedLibrarySection(
            title: 'مناسبات السورة',
            content: _asBullets(data.munasabatiha),
          ),
        ],
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({
    required this.data,
    required this.onTap,
  });

  final SurahInfoModel data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: data.id,
      child: UnifiedLibraryCard(
        title: data.surah,
        subtitle: data.maqsiduhaAleamu,
        leadingLabel: '${data.id}',
        badges: [
          UnifiedLibraryMeta(
            label: 'عدد الآيات',
            value: data.ayaatiha,
            isPrimary: true,
          ),
        ],
        onTap: onTap,
      ),
    );
  }
}
