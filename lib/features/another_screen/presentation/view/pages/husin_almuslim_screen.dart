import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/bottom_sheet/extension_sheet.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_bloc.dart';

class HisnMuslimScreen extends StatelessWidget {
  const HisnMuslimScreen({super.key});

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
                return state.hisnMuslim
                        .where((element) => element.title.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن حصن المسلم',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<HisnMuslimBloc, HisnMuslimState>(
            builder: (context, state) {
              return state.state.whenSliver<HisnMuslimModel>(
                onSuccess: () {
                  final data = state.hisnMuslim;

                  return SliverList.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return InkWell(
                        onTap: () => _showDetailBottomSheet(context, item),
                        child: _Item(item: item),
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

  void _showDetailBottomSheet(BuildContext context, HisnMuslimModel item) {
    context.showSmoothSheetStyle(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(item.title, style: context.titleMedium)),
                Row(
                  children: [
                    IconShareWidget(
                      text: '${item.title}\n\n${item.text.join('\n\n')}',
                      subject: 'حصن المسلم',
                    ),
                    CopyIconWidget(
                      text: '${item.title}\n\n${item.text.join('\n\n')}',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Text
            ...item.text.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(t, style: context.titleSmall),
              ),
            ),

            const SizedBox(height: 12),

            if (item.footnote.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الحواشي:', style: context.titleSmall),
                  const SizedBox(height: 8),
                  ...item.footnote.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $f',
                        style: context.titleSmall?.copyWith(
                          color: context.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    super.key,
  });

  final HisnMuslimModel item;

  @override
  Widget build(BuildContext context) {
    return BaseAnimate(
      index: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.surfaceColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: context.titleSmall,
              ),
            ),
            CircleAvatar(
              backgroundColor: context.primaryColor,
              radius: 18,
              child: Text(
                item.title,
                style: context.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
