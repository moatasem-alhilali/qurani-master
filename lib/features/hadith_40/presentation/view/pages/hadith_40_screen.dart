import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/hadith_40/presentation/bloc/hadith_40_bloc.dart';

class Hadith40Screen extends StatefulWidget {
  const Hadith40Screen({super.key});

  @override
  State<Hadith40Screen> createState() => _Hadith40ScreenState();
}

class _Hadith40ScreenState extends State<Hadith40Screen> {
  String _query = '';

  List<Hadith40Model> _filterData(List<Hadith40Model> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.hadith.contains(query) || item.description.contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', '').trim();
  }

  String _extractTitle(Hadith40Model item, int index) {
    final lines = _normalize(item.hadith)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isNotEmpty && lines.first.startsWith('الحديث')) {
      return lines.first;
    }

    return 'الحديث ${index + 1}';
  }

  String _extractPreview(Hadith40Model item) {
    final lines = _normalize(item.hadith)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) return '';
    if (lines.length == 1) return lines.first;

    final skipTitle = lines.first.startsWith('الحديث');
    final contentLines = skipTitle ? lines.skip(1).toList() : lines;
    return contentLines.take(2).join(' ');
  }

  void _showDetails(BuildContext context, Hadith40Model item, int index) {
    final title = _extractTitle(item, index);
    final shareContent =
        '$title\n\n${item.hadith}\n\nشرح الحديث:\n${item.description}';

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: title,
        subtitle: 'الأربعون النووية',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'الأربعون النووية',
        badges: [
          UnifiedLibraryMeta(
            label: 'الترتيب',
            value: '${index + 1}',
            isPrimary: true,
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'نص الحديث',
            content: item.hadith,
          ),
          UnifiedLibrarySection(
            title: 'شرح الحديث',
            content: item.description,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Hadith40Bloc()..add(LoadHadith40Event()),
      child: AppScaffoldWidget(
        title: 'الأربعين النووية',
        trailing: BlocBuilder<Hadith40Bloc, Hadith40State>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<Hadith40Model>(
              asyncSuggestions: (query) async {
                return (state.data ?? []).where((item) {
                  return item.hadith.contains(query) ||
                      item.description.contains(query);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.hadith;
                });
                final list = state.data ?? [];
                final index = list.indexOf(item);
                _showDetails(context, item, index < 0 ? 0 : index);
              },
              hintText: 'بحث عن حديث',
              suggestionBuilder: (context, item) =>
                  UnifiedLibrarySearchSuggestion(
                title: _extractTitle(item, 0),
                subtitle: _extractPreview(item),
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<Hadith40Bloc, Hadith40State>(
            builder: (context, state) {
              return state.state.whenSliver<Hadith40Model>(
                onSuccess: () {
                  final data = _filterData(state.data ?? []);

                  if (data.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _query = '';
                            });
                          },
                          child: const Text('لا توجد نتائج، عرض الأحاديث كلها'),
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return BaseAnimate(
                        index: index,
                        child: UnifiedLibraryCard(
                          title: _extractTitle(item, index),
                          subtitle: _extractPreview(item),
                          leadingLabel: '${index + 1}',
                          badges: const [
                            UnifiedLibraryMeta(
                              label: 'الشرح',
                              value: 'متاح',
                            ),
                          ],
                          onTap: () => _showDetails(context, item, index),
                        ),
                      );
                    },
                  );
                },
                context: context,
                sliverList: state.data,
              );
            },
          ),
        ],
      ),
    );
  }
}
