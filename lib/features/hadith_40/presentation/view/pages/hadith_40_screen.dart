import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/hadith_40/presentation/bloc/hadith_40_bloc.dart';
import 'package:quran_app/features/hadith_40/presentation/view/widgets/hadith_40_sheet.dart';
import 'package:quran_app/gen/fonts.gen.dart';

class Hadith40Screen extends StatefulWidget {
  const Hadith40Screen({super.key});

  @override
  State<Hadith40Screen> createState() => _Hadith40ScreenState();
}

class _Hadith40ScreenState extends State<Hadith40Screen> {
  String _query = '';

  List<Hadith40Model> _filterData(List<Hadith40Model> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.hadith.contains(query) || item.description.contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', '').trim();
  }

  String _extractTitle(Hadith40Model item, int index) {
    final lines = _normalize(item.hadith)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isNotEmpty && lines.first.startsWith('الحديث')) {
      return lines.first;
    }

    return 'الحديث ${index + 1}';
  }

  String _extractPreview(Hadith40Model item) {
    final lines = _normalize(item.hadith)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) return '';
    if (lines.length == 1) return lines.first;

    final skipTitle = lines.first.startsWith('الحديث');
    final contentLines = skipTitle ? lines.skip(1).toList() : lines;
    return contentLines.take(2).join(' ');
  }

  Future<void> _showDetails(
    BuildContext context,
    Hadith40Model item,
    int index,
  ) {
    return showHadith40Sheet(
      context,
      title: _extractTitle(item, index),
      order: index + 1,
      hadith: _normalize(item.hadith),
      explanation: _normalize(item.description),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => Hadith40Bloc()..add(LoadHadith40Event()),
      // أرضية واحدة من أعلى الشاشة إلى أسفلها.
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: 'الأربعون النووية',
          trailing: BlocBuilder<Hadith40Bloc, Hadith40State>(
            builder: (context, state) {
              return GenericSearchAnchorAsync<Hadith40Model>(
                asyncSuggestions: (query) async {
                  return (state.data ?? []).where((item) {
                    return item.hadith.contains(query) ||
                        item.description.contains(query);
                  }).toList();
                },
                onSelected: (item) {
                  setState(() {
                    _query = item.hadith;
                  });
                  final list = state.data ?? [];
                  final index = list.indexOf(item);
                  _showDetails(context, item, index < 0 ? 0 : index);
                },
                hintText: 'بحث عن حديث',
                suggestionBuilder: (context, item) => _SearchSuggestion(
                  title: _extractTitle(item, 0),
                  subtitle: _extractPreview(item),
                ),
              );
            },
          ),
          slivers: [
            BlocBuilder<Hadith40Bloc, Hadith40State>(
              builder: (context, state) {
                return state.state.whenSliver<Hadith40Model>(
                  onSuccess: () {
                    final data = _filterData(state.data ?? []);

                    if (data.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyResult(
                          onReset: () {
                            setState(() {
                              _query = '';
                            });
                          },
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return _HadithRow(
                          order: index + 1,
                          title: _extractTitle(item, index),
                          preview: _extractPreview(item),
                          isLast: index == data.length - 1,
                          onTap: () => _showDetails(context, item, index),
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
      ),
    );
  }
}

/// صفّ حديث: رقمه على اليمين، ثم عنوانه ومطلع نصّه بخطّ شهرزاد.
class _HadithRow extends StatelessWidget {
  const _HadithRow({
    required this.order,
    required this.title,
    required this.preview,
    required this.isLast,
    required this.onTap,
  });

  final int order;
  final String title;
  final String preview;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '$order',
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (preview.trim().isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontFamily: FontFamily.scheherazade,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.85,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 6.w),
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: AppIcon(
                AppIcons.chevronLeft,
                color: skin.accent,
                size: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لا توجد نتائج لهذا البحث',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: onReset,
              borderRadius: BorderRadius.circular(999.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Text(
                  'عرض الأحاديث كلها',
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// اقتراح البحث: سطر عنوان وسطر من نصّ الحديث.
class _SearchSuggestion extends StatelessWidget {
  const _SearchSuggestion({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
