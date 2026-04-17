import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_collection_view.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_search_suggestion.dart';

class WirdScreen extends StatelessWidget {
  const WirdScreen({required this.isMorning, super.key})
      : titleOverride = null,
        assetPath = JsonLoaderService.wirdsPath,
        filterByPeriod = true;

  const WirdScreen.custom({
    required String title,
    required this.assetPath,
    this.isMorning = true,
    this.filterByPeriod = false,
    super.key,
  }) : titleOverride = title;

  final bool isMorning;
  final String? titleOverride;
  final String assetPath;
  final bool filterByPeriod;

  bool _matchesQuery(WirdModel item, String query) {
    final q = query.trim();
    return item.title.contains(q) ||
        item.text.contains(q) ||
        item.virtue.contains(q) ||
        item.source.contains(q) ||
        item.hadithText.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WirdBloc()
        ..add(
          LoadWirdEvent(
            isMorning: isMorning,
            assetPath: assetPath,
            filterByPeriod: filterByPeriod,
          ),
        ),
      child: AppScaffoldWidget(
        title: titleOverride ?? (isMorning ? 'الورد الصباحي' : 'الورد المسائي'),
        trailing: BlocBuilder<WirdBloc, WirdState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<WirdModel>(
              asyncSuggestions: (query) async {
                if (query.trim().isEmpty) return state.data ?? [];
                return state.data
                        ?.where((item) => _matchesQuery(item, query))
                        .toList() ??
                    [];
              },
              onSelected: (item) async {
                await CopyService.copyToClipboard(item.text);
              },
              hintText: 'بحث عن ذكر',
              suggestionBuilder: (context, item) =>
                  WirdSearchSuggestion(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<WirdBloc, WirdState>(
            builder: (context, state) {
              return state.state.whenSliver<WirdModel>(
                onSuccess: () {
                  return const SliverToBoxAdapter(
                    child: WirdCollectionView(),
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
