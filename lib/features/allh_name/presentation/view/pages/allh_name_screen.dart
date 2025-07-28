import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_bloc.dart';

class AllhNameScreen extends StatelessWidget {
  const AllhNameScreen({super.key});

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
                return state.data
                        ?.where((element) => element.name.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن أسماء الله الحسنى',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<AllahNamesBloc, AllahNamesState>(
            builder: (context, state) {
              return state.state.whenSliver<AllahNameModel>(
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
    required this.item, super.key,
  });

  final AllahNameModel item;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: 0,
      child: CardWidget(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: titleMedium(context).copyWith(
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.text,
              style: titleSmall(context).copyWith(
                fontSize: 10.sp,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            Row(
              children: [
                IconShareWidget(
                  text: '${item.name} : ${item.text}',
                  subject: 'أسماء الله الحسنى',
                ),
                CopyIconWidget(
                  text: '${item.name} : ${item.text}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
