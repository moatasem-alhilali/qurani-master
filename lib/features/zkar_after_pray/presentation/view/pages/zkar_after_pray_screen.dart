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
import 'package:quran_app/features/zkar_after_pray/data/models/zkar_after_pray_model.dart';
import 'package:quran_app/features/zkar_after_pray/presentation/bloc/zkar_after_pray_bloc.dart';

class ZkarAfterPrayScreen extends StatelessWidget {
  const ZkarAfterPrayScreen({super.key});

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
                return state.data
                        ?.where((element) => element.zekr.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن أذكار',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<ZkarAfterPrayBloc, ZkarAfterPrayState>(
            builder: (context, state) {
              return state.state.whenSliver<ZkarAfterPrayModel>(
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

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    super.key,
  });

  final ZkarAfterPrayModel item;

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
              item.zekr,
              style: titleMedium(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (item.bless == '')
                    Container()
                  else
                    Expanded(
                      child: Text(
                        'العدد: ${item.bless}',
                        style: titleSmall(context).copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (item.repeat == '')
                    Container()
                  else
                    Text(
                      'التكرار :  ${item.repeat}',
                      style: titleSmall(context).copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconShareWidget(
                  text: item.zekr,
                  subject: 'أذكار بعد الصلاة',
                ),
                CopyIconWidget(
                  text: '${item.zekr} : ${item.bless}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
