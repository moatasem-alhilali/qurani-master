import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/zkar_after_pray/data/models/zkar_after_pray_model.dart';
import 'package:quran_app/features/zkar_after_pray/presentation/bloc/zkar_after_pray_bloc.dart';

class ZkarAfterPrayScreen extends StatefulWidget {
  const ZkarAfterPrayScreen({super.key});

  @override
  State<ZkarAfterPrayScreen> createState() => _ZkarAfterPrayScreenState();
}

class _ZkarAfterPrayScreenState extends State<ZkarAfterPrayScreen> {
  String _query = '';

  List<ZkarAfterPrayModel> _filterData(List<ZkarAfterPrayModel> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.zekr.contains(query) ||
          item.bless.contains(query) ||
          item.repeat.toString().contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  String _titleForCard(ZkarAfterPrayModel item, int index) {
    final normalized = _normalize(item.zekr);
    if (normalized.isEmpty) return 'ذكر بعد الصلاة ${index + 1}';

    final splits = normalized
        .split(RegExp(r'[،.]'))
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .toList();
    final title = splits.isNotEmpty ? splits.first : normalized;

    if (title.length <= 50) return title;
    return '${title.substring(0, 50)}...';
  }

  void _showDetails(
    BuildContext context,
    ZkarAfterPrayModel item,
    int index,
  ) {
    final shareContent = [
      _titleForCard(item, index),
      '',
      item.zekr,
      '',
      'عدد التكرار: ${item.repeat}',
      if (item.bless.trim().isNotEmpty) 'الفضل: ${item.bless}',
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: _titleForCard(item, index),
        subtitle: 'أذكار ما بعد الصلاة',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'أذكار ما بعد الصلاة',
        badges: [
          UnifiedLibraryMeta(
            label: 'التكرار',
            value: '${item.repeat}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: 'الفضل',
            value: item.bless.trim().isEmpty ? 'غير مذكور' : 'مذكور',
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'نص الذكر',
            content: item.zekr,
          ),
          UnifiedLibrarySection(
            title: 'فضل الذكر',
            content: item.bless,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ZkarAfterPrayBloc()..add(LoadZkarAfterPrayEvent()),
      child: AppScaffoldWidget(
        title: 'أذكار بعد الصلاة',
        trailing: BlocBuilder<ZkarAfterPrayBloc, ZkarAfterPrayState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<ZkarAfterPrayModel>(
              asyncSuggestions: (query) async {
                return (state.data ?? []).where((item) {
                  return item.zekr.contains(query) ||
                      item.bless.contains(query) ||
                      item.repeat.toString().contains(query);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.zekr;
                });
                final list = state.data ?? [];
                final index = list.indexOf(item);
                _showDetails(context, item, index < 0 ? 0 : index);
              },
              hintText: 'بحث عن أذكار',
              suggestionBuilder: (context, item) => UnifiedLibrarySearchSuggestion(
                title: _titleForCard(item, 0),
                subtitle: _normalize(item.zekr),
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<ZkarAfterPrayBloc, ZkarAfterPrayState>(
            builder: (context, state) {
              return state.state.whenSliver<ZkarAfterPrayModel>(
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
                          child: const Text('لا توجد نتائج، عرض الأذكار كلها'),
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
                          title: _titleForCard(item, index),
                          subtitle: _normalize(item.zekr),
                          leadingLabel: '${index + 1}',
                          badges: [
                            UnifiedLibraryMeta(
                              label: 'التكرار',
                              value: '${item.repeat}',
                              isPrimary: true,
                            ),
                            UnifiedLibraryMeta(
                              label: 'الفضل',
                              value: item.bless.trim().isEmpty
                                  ? 'غير مذكور'
                                  : 'مذكور',
                            ),
                          ],
                          onTap: () => _showDetails(context, item, index),
                        ),
                      );
                    },
                  );
                },
                context: context,
                onRefresh: () {
                  context
                      .read<ZkarAfterPrayBloc>()
                      .add(LoadZkarAfterPrayEvent());
                },
                onLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
                sliverList: state.data,
              );
            },
          ),
        ],
      ),
    );
  }
}
