import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/ruqia_shareia/data/models/ruqia_shareia_model.dart';
import 'package:quran_app/features/ruqia_shareia/presentation/bloc/ruqia_shareia_bloc.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

/// الرقية الشرعية: قائمة رُقى، لكل رقية عدد تكرار ومرجع.
///
/// عدد التكرار هو ما يبحث عنه القارئ قبل أي شيء، فصار يُقرأ من طرف الصفّ
/// مباشرة بدل أن يختبئ في شارة داخل بطاقة.
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

  String _countOf(RuqiaShareiaModel item) =>
      item.count.trim().isEmpty ? '' : item.count.trim();

  String _referenceOf(RuqiaShareiaModel item) => item.reference.trim().isEmpty
      ? context.l10n.ruqyahDefaultReference
      : item.reference.trim();

  void _showDetails(
    BuildContext context,
    RuqiaShareiaModel item,
    int index,
  ) {
    final reference = _referenceOf(item);
    final count = _countOf(item);
    final shareContent = [
      item.category,
      '',
      item.zekr,
      '',
      context.l10n.ruqyahRepeatLine(
        count.isEmpty ? context.l10n.ruqyahUnspecified : count,
      ),
      context.l10n.ruqyahReferenceLine(reference),
      if (item.description.trim().isNotEmpty)
        context.l10n.ruqyahDescriptionLine(item.description),
    ].join('\n');

    unawaited(
      showLibraryDetailSheet(
        context,
        title: item.category,
        subtitle: context.l10n.ruqyahTitle,
        shareText: shareContent,
        shareSubject: context.l10n.ruqyahTitle,
        facts: [
          context.l10n.ruqyahNumber(index + 1),
          if (count.isNotEmpty) context.l10n.ruqyahRepeatLine(count),
          reference,
        ],
        sections: [
          LibraryDetailSection(
            title: context.l10n.ruqyahTextSection,
            content: item.zekr,
          ),
          LibraryDetailSection(
            title: context.l10n.ruqyahDescriptionSection,
            content: item.description,
            scripture: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RuqiaShareiaBloc()..add(LoadRuqiaShareiaEvent()),
      child: GroundScaffoldTheme(
        child: AppScaffoldWidget(
          title: context.l10n.ruqyahTitle,
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
                hintText: context.l10n.ruqyahSearchHint,
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
                        child: LibraryEmptyState(
                          title: context.l10n.ruqyahNoResultsTitle,
                          message: context.l10n.ruqyahNoResultsMessage,
                          actionLabel: context.l10n.ruqyahShowAll,
                          onAction: () => setState(() => _query = ''),
                        ),
                      );
                    }

                    return librarySliverGround(
                      context,
                      sliver: SliverList.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final count = _countOf(item);

                          return BaseAnimate(
                            index: index,
                            child: LibraryRow(
                              order: index + 1,
                              title: item.category,
                              subtitle: _preview(item.zekr),
                              trailingLabel: count.isEmpty ? null : count,
                              isLast: index == data.length - 1,
                              onTap: () => _showDetails(context, item, index),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  context: context,
                  sliverList: state.data,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
