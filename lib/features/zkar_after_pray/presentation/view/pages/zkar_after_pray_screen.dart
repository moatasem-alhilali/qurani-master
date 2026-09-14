import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/zkar_after_pray/data/models/zkar_after_pray_model.dart';
import 'package:quran_app/features/zkar_after_pray/presentation/bloc/zkar_after_pray_bloc.dart';

/// أذكار ما بعد الصلاة: قائمة صفوف نحيلة على أرضية الصفحة، بلا بطاقات.
class ZkarAfterPrayScreen extends StatefulWidget {
  const ZkarAfterPrayScreen({super.key});

  @override
  State<ZkarAfterPrayScreen> createState() => _ZkarAfterPrayScreenState();
}

class _ZkarAfterPrayScreenState extends State<ZkarAfterPrayScreen> {
  String _query = '';

  List<ZkarAfterPrayModel> _filterData(List<ZkarAfterPrayModel> source) {
    final query = _query.trim();
    if (query.isEmpty) return source;

    return source.where((item) {
      return item.zekr.contains(query) ||
          item.bless.contains(query) ||
          item.repeat.toString().contains(query);
    }).toList();
  }

  String _normalize(String value) {
    return value.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  String _titleForCard(ZkarAfterPrayModel item, int index) {
    final normalized = _normalize(item.zekr);
    if (normalized.isEmpty) return 'ذكر بعد الصلاة ${index + 1}';

    final splits = normalized
        .split(RegExp('[،.]'))
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .toList();
    final title = splits.isNotEmpty ? splits.first : normalized;

    if (title.length <= 50) return title;
    return '${title.substring(0, 50)}...';
  }

  void _showDetails(
    BuildContext context,
    ZkarAfterPrayModel item,
    int index,
  ) {
    final shareContent = [
      _titleForCard(item, index),
      '',
      item.zekr,
      '',
      'عدد التكرار: ${item.repeat}',
      if (item.bless.trim().isNotEmpty) 'الفضل: ${item.bless}',
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: _titleForCard(item, index),
        subtitle: 'أذكار ما بعد الصلاة',
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: 'أذكار ما بعد الصلاة',
        badges: [
          UnifiedLibraryMeta(
            label: 'التكرار',
            value: '${item.repeat}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: 'الفضل',
            value: item.bless.trim().isEmpty ? 'غير مذكور' : 'مذكور',
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: 'نص الذكر',
            content: item.zekr,
          ),
          UnifiedLibrarySection(
            title: 'فضل الذكر',
            content: item.bless,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => ZkarAfterPrayBloc()..add(LoadZkarAfterPrayEvent()),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: 'أذكار بعد الصلاة',
          trailing: BlocBuilder<ZkarAfterPrayBloc, ZkarAfterPrayState>(
            builder: (context, state) {
              return GenericSearchAnchorAsync<ZkarAfterPrayModel>(
                asyncSuggestions: (query) async {
                  return (state.data ?? []).where((item) {
                    return item.zekr.contains(query) ||
                        item.bless.contains(query) ||
                        item.repeat.toString().contains(query);
                  }).toList();
                },
                onSelected: (item) {
                  setState(() {
                    _query = item.zekr;
                  });
                  final list = state.data ?? [];
                  final index = list.indexOf(item);
                  _showDetails(context, item, index < 0 ? 0 : index);
                },
                hintText: 'بحث عن أذكار',
                suggestionBuilder: (context, item) =>
                    UnifiedLibrarySearchSuggestion(
                  title: _titleForCard(item, 0),
                  subtitle: _normalize(item.zekr),
                ),
              );
            },
          ),
          slivers: [
            BlocBuilder<ZkarAfterPrayBloc, ZkarAfterPrayState>(
              builder: (context, state) {
                return state.state.whenSliver<ZkarAfterPrayModel>(
                  onSuccess: () {
                    final data = _filterData(state.data ?? []);

                    if (data.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ZkarEmptyState(
                          onReset: () => setState(() => _query = ''),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: AppSkin.gutter,
                      sliver: SliverList.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return BaseAnimate(
                            index: index,
                            child: _ZkarRow(
                              order: index + 1,
                              title: _titleForCard(item, index),
                              subtitle: _normalize(item.zekr),
                              repeat: item.repeat,
                              isLast: index == data.length - 1,
                              onTap: () => _showDetails(context, item, index),
                            ),
                          );
                        },
                      ),
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
      ),
    );
  }
}

/// صفّ ذكر واحد: رقمه في مربّع صغير، ثم عنوانه ونصّه، ثم عدد التكرار.
class _ZkarRow extends StatelessWidget {
  const _ZkarRow({
    required this.order,
    required this.title,
    required this.subtitle,
    required this.repeat,
    required this.isLast,
    required this.onTap,
  });

  final int order;
  final String title;
  final String subtitle;
  final int repeat;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
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
                    fontSize: 10.5.sp,
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
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                repeat > 1 ? '$repeat مرات' : 'مرة',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Padding(
              padding: EdgeInsets.only(top: 1.h),
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

class _ZkarEmptyState extends StatelessWidget {
  const _ZkarEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(AppIcons.searchOff, color: skin.accent, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            'لا توجد نتائج مطابقة',
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: onReset,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Text(
                'عرض الأذكار كلها',
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
    );
  }
}
