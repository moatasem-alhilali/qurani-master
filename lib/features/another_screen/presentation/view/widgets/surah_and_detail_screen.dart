import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
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
                _showSurahDetails(context, item);
              },
              hintText: 'بحث عن سورة',
              suggestionBuilder: (context, item) =>
                  _SurahSuggestion(item: item),
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
                          onTap: () => _showSurahDetails(context, data),
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

  void _showSurahDetails(BuildContext context, SurahInfoModel data) {
    context.showBottomSheet(
      child: _SurahDetailSheet(data: data),
    );
  }
}

class _SurahSuggestion extends StatelessWidget {
  const _SurahSuggestion({required this.item});

  final SurahInfoModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(item.surah, style: context.titleSmall),
      subtitle: Text('عدد الآيات: ${item.ayaatiha}', style: context.bodySmall),
      trailing: Text('#${item.id}', style: context.bodySmall),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: CardWidget(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: context.primaryColor.withValues(alpha: 0.14),
                child: Text(
                  '${data.id}',
                  style: context.labelLarge?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.surah,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'عدد الآيات: ${data.ayaatiha}',
                      style: context.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: context.onSurfaceColor.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahDetailSheet extends StatelessWidget {
  const _SurahDetailSheet({required this.data});

  final SurahInfoModel data;

  String _asBullets(List<String> lines) {
    if (lines.isEmpty) return 'لا توجد بيانات.';
    return lines.map((line) => '• $line').join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.surah,
                    style: context.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(title: 'رقم السورة', value: '${data.id}'),
                      _MetaChip(title: 'عدد الآيات', value: data.ayaatiha),
                    ],
                  ),
                ],
              ),
            ),
            _DetailSection(
              title: 'معنى اسم السورة',
              content: data.maeniAsamuha,
            ),
            _DetailSection(title: 'سبب التسمية', content: data.sababTasmiatiha),
            _DetailSection(title: 'أسماء أخرى للسورة', content: data.asmawuha),
            _DetailSection(
              title: 'المقصد العام',
              content: data.maqsiduhaAleamu,
            ),
            _DetailSection(title: 'سبب النزول', content: data.sababNuzuliha),
            _DetailSection(
              title: 'فضائل السورة',
              content: _asBullets(data.fadluha),
            ),
            _DetailSection(
              title: 'مناسبات السورة',
              content: _asBullets(data.munasabatiha),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$title: $value',
          style: context.labelMedium?.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          SelectableText(
            content.trim().isEmpty ? 'لا توجد بيانات.' : content,
            textDirection: TextDirection.rtl,
            style: context.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
