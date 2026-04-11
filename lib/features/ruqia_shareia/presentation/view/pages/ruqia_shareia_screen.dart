import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/ruqia_shareia/data/models/ruqia_shareia_model.dart';
import 'package:quran_app/features/ruqia_shareia/presentation/bloc/ruqia_shareia_bloc.dart';

class RuqiaShareiaScreen extends StatefulWidget {
  const RuqiaShareiaScreen({super.key});

  @override
  State<RuqiaShareiaScreen> createState() => _RuqiaShareiaScreenState();
}

class _RuqiaShareiaScreenState extends State<RuqiaShareiaScreen> {
  String _query = '';

  List<RuqiaShareiaModel> _filterData(List<RuqiaShareiaModel> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.category.contains(query) ||
          item.zekr.contains(query) ||
          item.reference.contains(query) ||
          item.description.contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  String _preview(String value, {int maxChars = 120}) {
    final normalized = _normalize(value);
    if (normalized.length <= maxChars) return normalized;
    return '${normalized.substring(0, maxChars)}...';
  }

  void _showDetails(
    BuildContext context,
    RuqiaShareiaModel item,
    int index,
  ) {
    final reference =
        item.reference.trim().isEmpty ? 'القرآن الكريم' : item.reference;
    final count = item.count.trim().isEmpty ? 'غير محدد' : item.count;
    final shareContent = [
      item.category,
      '',
      item.zekr,
      '',
      'التكرار: $count',
      'المرجع: $reference',
      if (item.description.trim().isNotEmpty) 'الوصف: ${item.description}',
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: item.category,
        subtitle: 'الرقية الشرعية',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'الرقية الشرعية',
        badges: [
          UnifiedLibraryMeta(
            label: 'الترتيب',
            value: '${index + 1}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: 'التكرار',
            value: count,
          ),
          UnifiedLibraryMeta(
            label: 'المرجع',
            value: reference,
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'نص الرقية',
            content: item.zekr,
          ),
          UnifiedLibrarySection(
            title: 'الوصف',
            content: item.description,
          ),
          UnifiedLibrarySection(
            title: 'المرجع',
            content: reference,
            selectable: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RuqiaShareiaBloc()..add(LoadRuqiaShareiaEvent()),
      child: AppScaffoldWidget(
        title: 'الرقية الشرعية',
        trailing: BlocBuilder<RuqiaShareiaBloc, RuqiaShareiaState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<RuqiaShareiaModel>(
              asyncSuggestions: (query) async {
                return (state.data ?? []).where((item) {
                  return item.category.contains(query) ||
                      item.zekr.contains(query) ||
                      item.reference.contains(query) ||
                      item.description.contains(query);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.category;
                });
                final list = state.data ?? [];
                final index = list.indexOf(item);
                _showDetails(context, item, index < 0 ? 0 : index);
              },
              hintText: 'بحث عن رقية',
              suggestionBuilder: (context, item) =>
                  UnifiedLibrarySearchSuggestion(
                title: item.category,
                subtitle: _preview(item.zekr, maxChars: 90),
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<RuqiaShareiaBloc, RuqiaShareiaState>(
            builder: (context, state) {
              return state.state.whenSliver<RuqiaShareiaModel>(
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
                          child: const Text('لا توجد نتائج، عرض الرقى كلها'),
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
                          title: item.category,
                          subtitle: _preview(item.zekr),
                          leadingLabel: '${index + 1}',
                          badges: [
                            UnifiedLibraryMeta(
                              label: 'التكرار',
                              value: item.count.trim().isEmpty
                                  ? 'غير محدد'
                                  : item.count,
                              isPrimary: true,
                            ),
                            UnifiedLibraryMeta(
                              label: 'المرجع',
                              value: item.reference.trim().isEmpty
                                  ? 'القرآن الكريم'
                                  : item.reference,
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
