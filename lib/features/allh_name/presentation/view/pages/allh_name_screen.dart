import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_bloc.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// أسماء الله الحسنى.
///
/// الاسم هو البطل: يُكتب بخطّ المصحف كبيرًا، والمعنى همسٌ تحته في سطر
/// واحد. حُذفت الشارة التي كانت تكرّر عنوان الشاشة تحت كل اسم، ورقم
/// الترتيب انزاح إلى الطرف صغيرًا حتى لا ينافس الاسم على النظر.
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

    unawaited(
      showLibraryDetailSheet(
        context,
        title: item.name,
        subtitle: 'الاسم ${index + 1} من أسماء الله الحسنى',
        shareText: shareContent,
        shareSubject: 'أسماء الله الحسنى',
        titleSize: 26,
        titleFontFamily: FontFamily.scheherazade,
        sections: [
          LibraryDetailSection(
            title: 'المعنى',
            content: item.text,
            scripture: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllahNamesBloc()..add(LoadAllahNamesEvent()),
      child: GroundScaffoldTheme(
        child: AppScaffoldWidget(
          title: 'أسماء الله الحسنى',
          trailing: BlocBuilder<AllahNamesBloc, AllahNamesState>(
            builder: (context, state) {
              return GenericSearchAnchorAsync<AllahNameModel>(
                asyncSuggestions: (query) async {
                  return (state.data ?? []).where((item) {
                    return item.name.contains(query) ||
                        item.text.contains(query);
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
                suggestionBuilder: (context, item) =>
                    UnifiedLibrarySearchSuggestion(
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
                        child: LibraryEmptyState(
                          title: 'لا توجد نتائج',
                          message: 'لم نجد اسمًا يطابق بحثك.',
                          actionLabel: 'عرض الأسماء كلها',
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
                          return BaseAnimate(
                            index: index,
                            child: _AllahNameRow(
                              order: index + 1,
                              item: item,
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

/// صفّ اسم واحد: الاسم كبير بخطّ المصحف، ومعناه سطر واحد تحته.
class _AllahNameRow extends StatelessWidget {
  const _AllahNameRow({
    required this.order,
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  final int order;
  final AllahNameModel item;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final meaning = item.text.replaceAll('\n', ' ').trim();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 11.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: FontFamily.scheherazade,
                      color: skin.ink,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                  if (meaning.isNotEmpty)
                    Text(
                      meaning,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '$order',
              style: TextStyle(
                color: skin.accent.withValues(alpha: 0.75),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
