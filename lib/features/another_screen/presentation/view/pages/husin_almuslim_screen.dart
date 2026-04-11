import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_bloc.dart';

class HisnMuslimScreen extends StatefulWidget {
  const HisnMuslimScreen({super.key});

  @override
  State<HisnMuslimScreen> createState() => _HisnMuslimScreenState();
}

class _HisnMuslimScreenState extends State<HisnMuslimScreen> {
  String _query = '';

  List<HisnMuslimModel> _filterData(List<HisnMuslimModel> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      final textContent = item.text.join(' ');
      final footnoteContent = item.footnote.join(' ');
      return item.title.contains(query) ||
          textContent.contains(query) ||
          footnoteContent.contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  String _preview(HisnMuslimModel item, {int maxChars = 120}) {
    final content = item.text.isEmpty ? '' : item.text.first;
    final normalized = _normalize(content);
    if (normalized.length <= maxChars) return normalized;
    return '${normalized.substring(0, maxChars)}...';
  }

  String _asBullets(List<String> lines) {
    if (lines.isEmpty) return '';
    return lines.map((line) => '• ${line.trim()}').join('\n\n');
  }

  void _showDetailBottomSheet(
    BuildContext context,
    HisnMuslimModel item,
    int index,
  ) {
    final textContent = item.text.join('\n\n');
    final footnoteContent = _asBullets(item.footnote);
    final shareContent = [
      item.title,
      '',
      textContent,
      if (item.footnote.isNotEmpty) ...[
        '',
        'الحواشي:',
        footnoteContent,
      ],
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: item.title,
        subtitle: 'حصن المسلم',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'حصن المسلم',
        badges: [
          UnifiedLibraryMeta(
            label: 'الترتيب',
            value: '${index + 1}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: 'عدد النصوص',
            value: '${item.text.length}',
          ),
          UnifiedLibraryMeta(
            label: 'الحواشي',
            value: '${item.footnote.length}',
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'نص الذكر',
            content: textContent,
          ),
          UnifiedLibrarySection(
            title: 'الحواشي',
            content: footnoteContent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HisnMuslimBloc()..add(LoadHisnMuslimEvent()),
      child: AppScaffoldWidget(
        title: 'حصن المسلم',
        trailing: BlocBuilder<HisnMuslimBloc, HisnMuslimState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<HisnMuslimModel>(
              asyncSuggestions: (query) async {
                return state.hisnMuslim.where((item) {
                  final textContent = item.text.join(' ');
                  final footnoteContent = item.footnote.join(' ');
                  return item.title.contains(query) ||
                      textContent.contains(query) ||
                      footnoteContent.contains(query);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.title;
                });
                final index = state.hisnMuslim.indexOf(item);
                _showDetailBottomSheet(context, item, index < 0 ? 0 : index);
              },
              hintText: 'بحث عن حصن المسلم',
              suggestionBuilder: (context, item) =>
                  UnifiedLibrarySearchSuggestion(
                title: item.title,
                subtitle: _preview(item, maxChars: 90),
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<HisnMuslimBloc, HisnMuslimState>(
            builder: (context, state) {
              return state.state.whenSliver<HisnMuslimModel>(
                onSuccess: () {
                  final data = _filterData(state.hisnMuslim);

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
                          child: const Text('لا توجد نتائج، عرض جميع الأذكار'),
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
                          title: item.title,
                          subtitle: _preview(item),
                          leadingLabel: '${index + 1}',
                          badges: [
                            UnifiedLibraryMeta(
                              label: 'النصوص',
                              value: '${item.text.length}',
                              isPrimary: true,
                            ),
                            UnifiedLibraryMeta(
                              label: 'الحواشي',
                              value: '${item.footnote.length}',
                            ),
                          ],
                          onTap: () => _showDetailBottomSheet(
                            context,
                            item,
                            index,
                          ),
                        ),
                      );
                    },
                  );
                },
                context: context,
                sliverList: state.hisnMuslim,
              );
            },
          ),
        ],
      ),
    );
  }
}
