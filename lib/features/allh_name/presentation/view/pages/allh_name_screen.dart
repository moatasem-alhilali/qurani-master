import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_bloc.dart';

class AllhNameScreen extends StatefulWidget {
  const AllhNameScreen({super.key});

  @override
  State<AllhNameScreen> createState() => _AllhNameScreenState();
}

class _AllhNameScreenState extends State<AllhNameScreen> {
  String _query = '';

  List<AllahNameModel> _filterData(List<AllahNameModel> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.name.contains(query) || item.text.contains(query);
    }).toList();
  }

  void _showDetails(
    BuildContext context,
    AllahNameModel item,
    int index,
  ) {
    final shareContent = '${item.name}\n\n${item.text}';
    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: item.name,
        subtitle: 'اسم من أسماء الله الحسنى',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'أسماء الله الحسنى',
        badges: [
          UnifiedLibraryMeta(
            label: 'الترتيب',
            value: '${index + 1}',
            isPrimary: true,
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'المعنى',
            content: item.text,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllahNamesBloc()..add(LoadAllahNamesEvent()),
      child: AppScaffoldWidget(
        title: 'أسماء الله الحسنى',
        trailing: BlocBuilder<AllahNamesBloc, AllahNamesState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<AllahNameModel>(
              asyncSuggestions: (query) async {
                return (state.data ?? []).where((item) {
                  return item.name.contains(query) || item.text.contains(query);
                }).toList();
              },
              onSelected: (item) {
                setState(() {
                  _query = item.name;
                });
                final list = state.data ?? [];
                final index = list.indexOf(item);
                _showDetails(context, item, index < 0 ? 0 : index);
              },
              hintText: 'بحث عن أسماء الله الحسنى',
              suggestionBuilder: (context, item) => UnifiedLibrarySearchSuggestion(
                title: item.name,
                subtitle: item.text,
              ),
            );
          },
        ),
        slivers: [
          BlocBuilder<AllahNamesBloc, AllahNamesState>(
            builder: (context, state) {
              return state.state.whenSliver<AllahNameModel>(
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
                          child: const Text('لا توجد نتائج، عرض الكل'),
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
                          title: item.name,
                          subtitle: item.text,
                          leadingLabel: '${index + 1}',
                          badges: const [
                            UnifiedLibraryMeta(
                              label: 'القسم',
                              value: 'أسماء الله الحسنى',
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
