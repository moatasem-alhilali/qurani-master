import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/readmore.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/hadith_40/presentation/bloc/hadith_40_bloc.dart';

class Hadith40Screen extends StatelessWidget {
  const Hadith40Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Hadith40Bloc()..add(LoadHadith40Event()),
      child: AppScaffoldWidget(
        title: 'الأربعين النووية',
        trailing: BlocBuilder<Hadith40Bloc, Hadith40State>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<Hadith40Model>(
              asyncSuggestions: (query) async {
                return state.data
                        ?.where((element) => element.hadith.contains(query))
                        .toList() ??
                    [];
              },
              onSelected: (item) {},
              hintText: 'بحث عن حديث',
              suggestionBuilder: (context, item) => _Item(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<Hadith40Bloc, Hadith40State>(
            builder: (context, state) {
              return state.state.whenSliver<Hadith40Model>(
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
                onError: const Center(
                  child: Text('error'),
                ),
                onLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
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
    super.key,
    required this.item,
  });

  final Hadith40Model item;

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
            ReadMoreText(
              item.hadith,
              trimLines: 5,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              textDirection: TextDirection.rtl,
              trimCollapsedText: 'عرض أكثر',
              trimExpandedText: 'عرض أقل',
              style: titleMedium(context),
              moreStyle: const TextStyle(
                color: Color.fromARGB(255, 162, 55, 47),
                fontSize: 14,
              ),
              lessStyle: const TextStyle(
                color: Color.fromARGB(255, 162, 55, 47),
                fontSize: 14,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Text(
              'شرح الحديث',
              style: titleMedium(context)
                  .copyWith(color: context.primaryColor),
            ),
            const SizedBox(
              height: 15,
            ),
            ReadMoreText(
              item.description,
              trimLines: 3,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              textDirection: TextDirection.rtl,
              trimCollapsedText: 'عرض أكثر',
              trimExpandedText: 'عرض أقل',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              moreStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              lessStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                IconShareWidget(
                  text:
                      '${item.hadith} : ${item.description}',
                  subject: 'الأربعين النووية',
                ),
                CopyIconWidget(
                  text:
                      '${item.hadith} : ${item.description}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
