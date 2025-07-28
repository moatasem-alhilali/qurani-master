import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdScreen extends StatelessWidget {
  const WirdScreen({required this.isMorning, super.key});
  final bool isMorning;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WirdBloc()..add(LoadWirdEvent()),
      child: AppScaffoldWidget(
        title: isMorning ? 'الورد الصباحي' : 'الورد المساءي',
        trailing: BlocBuilder<WirdBloc, WirdState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<WirdModel>(
              asyncSuggestions: (query) async {
                return state.data
                        ?.where((element) => element.text.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن الورد',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<WirdBloc, WirdState>(
            builder: (context, state) {
              return state.state.whenSliver<WirdModel>(
                onSuccess: () {
                  final data = state.data ?? [];
                  return SliverList.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return _Item(item: item);
                    },
                  );
                },
                context: context,
                sliverList: state.data,
                // list: state.data,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    super.key,
  });

  final WirdModel item;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: 0,
      child: Column(
        children: [
          DoaItem(
            childPageNumber: Text(
              '',
              style: context.titleSmall?.copyWith(
                color: context.primaryColor,
              ),
            ),
            color: context.primaryColor,
            content: item.text,
            text: item.text,
            number: 'التكرار :  ${item.counter} ',
            onLongPress: () async {
              await CopyService.copyToClipboard(
                item.text,
              );
            },
          ),
        ],
      ),
    );
  }
}
