import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/ruqia_shareia/data/models/ruqia_shareia_model.dart';
import 'package:quran_app/features/ruqia_shareia/presentation/bloc/ruqia_shareia_bloc.dart';

class RuqiaShareiaScreen extends StatelessWidget {
  const RuqiaShareiaScreen({super.key});

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
                return state.data
                        ?.where((element) => element.zekr.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن رقية',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<RuqiaShareiaBloc, RuqiaShareiaState>(
            builder: (context, state) {
              return state.state.whenSliver<RuqiaShareiaModel>(
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

  final RuqiaShareiaModel item;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: 0,
      child: CardWidget(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.category,
              style: titleMedium(context),
            ),
            const SizedBox(
              height: 5,
            ),
            SelectableText(
              item.zekr,
              style: titleSmall(context).copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "المرجع : ${item.reference == "" ? "القرأن الكريم" : item.reference}",
              style: titleSmall(context).copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              children: [
                IconShareWidget(
                  text: item.zekr,
                  subject: 'الرقية الشرعية',
                ),
                CopyIconWidget(
                  text: item.zekr,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
