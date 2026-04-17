

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/done_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/info_chip.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/summary_info_chip.dart';

class TravelAthkarScreen extends StatelessWidget {
  const TravelAthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelAthkarBloc(),
      child: const TravelAthkarView(),
    );
  }
}

class TravelAthkarView extends StatefulWidget {
  const TravelAthkarView({super.key});

  @override
  State<TravelAthkarView> createState() => _TravelAthkarViewState();
}

class _TravelAthkarViewState extends State<TravelAthkarView> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  Future<List<TravelDhikrModel>> _searchSuggestions(BuildContext context, String query) async {
    final bloc = context.read<TravelAthkarBloc>();
    final allItems = bloc.state.allItems;
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return allItems.take(18).toList();
    }

    return allItems
        .where((item) => _matchesSearch(item, normalized))
        .take(30)
        .toList();
  }
  
  bool _matchesSearch(TravelDhikrModel item, String query) {
    return item.title.contains(query) ||
        item.text.contains(query) ||
        item.virtue.contains(query) ||
        item.trigger.contains(query);
  }

  void _applySearch(BuildContext context, String query) {
    context.read<TravelAthkarBloc>().add(SearchAthkarEvent(query));
    _jumpToFirstPage();
  }

  String _searchPreview(String text) {
    final value = text.replaceAll('\n', ' ').trim();
    if (value.length <= 80) return value;
    return '${value.substring(0, 80)}...';
  }
  
  void _jumpToFirstPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_carouselController.ready) return;
      _carouselController.jumpToPage(0);
    });
  }
  
  String _triggerLabel(String trigger) {
    return travelTriggerLabels[trigger] ?? trigger;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'أذكار السفر',
      showLargeHeader: false,
      initialOffset: null,
      trailing: _buildHeaderActions(context),
      slivers: [
        _buildBodySliver(context),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
      buildWhen: (previous, current) => previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        final hasQuery = state.searchQuery.isNotEmpty;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasQuery)
              IconButton(
                tooltip: 'إلغاء البحث',
                onPressed: () => _applySearch(context, ''),
                icon: Icon(
                  Icons.filter_alt_off_rounded,
                  color: context.onSurfaceColor.withValues(alpha: 0.82),
                  size: 20.sp,
                ),
              ),
            _buildDisplayModeToggle(context),
            GenericSearchAnchorAsync<TravelDhikrModel>(
              hintText: 'ابحث في الأذكار',
              asyncSuggestions: (query) => _searchSuggestions(context, query),
              onSelected: (item) {
                _applySearch(context, item.title);
              },
              suggestionBuilder: (context, item) {
                return ListTile(
                  leading: Icon(
                    Icons.menu_book_rounded,
                    color: context.primaryColor,
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    _searchPreview(item.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurfaceColor.withValues(alpha: 0.65),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildDisplayModeToggle(BuildContext context) {
    return BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
      buildWhen: (previous, current) => previous.displayMode != current.displayMode,
      builder: (context, state) {
        final isPageMode = state.displayMode == AthkarDisplayMode.pageView;

        return Tooltip(
          message: isPageMode ? 'التحويل إلى ListView' : 'التحويل إلى PageView',
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              final next = isPageMode ? AthkarDisplayMode.listView : AthkarDisplayMode.pageView;
              context.read<TravelAthkarBloc>().add(UpdateDisplayModeEvent(next));
              if (next == AthkarDisplayMode.pageView) {
                _jumpToFirstPage();
              }
            },
            icon: Icon(
              isPageMode ? Icons.view_agenda_rounded : Icons.view_carousel_rounded,
              color: context.primaryColor,
              size: 18.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodySliver(BuildContext context) {
    return BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
      builder: (context, state) {
        if (state.status == TravelAthkarStatus.loading || state.status == TravelAthkarStatus.initial) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == TravelAthkarStatus.failure && state.errorMessage != null) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FilledButton.icon(
                      onPressed: () => context.read<TravelAthkarBloc>().add(LoadAthkarEvent()),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final visibleItems = state.filteredItems;

        return SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
            child: Column(
              children: [
                _buildSummaryCard(context, state),
                SizedBox(height: 10.h),
                Expanded(
                  child: _buildAthkarContent(context, state, visibleItems),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, TravelAthkarState state) {
    final fixedItemsCount = state.allItems.where((item) => item.repeatCount != null && !item.isDynamicRepeat).length;
    final fixedItems = state.allItems.where((item) => item.repeatCount != null && !item.isDynamicRepeat).toList();
    
    int completedItemsCount = 0;
    for (var item in fixedItems) {
      final current = state.repeatCounts[item.key] ?? 0;
      if (current >= (item.repeatCount ?? 0)) completedItemsCount++;
    }

    final fixedCount = fixedItemsCount;
    final completed = completedItemsCount;
    final dynamicCount = state.allItems.where((item) => item.isDynamicRepeat).length;
    final progress = fixedCount == 0 ? 0.0 : completed / fixedCount;
    final progressText = '$completed / $fixedCount';

    return CardWidget(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      border: Border.all(
        color: context.outlineVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16.sp,
                color: context.primaryColor,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'مساعد أذكار السفر',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 13.2.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  child: Text(
                    progressText,
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.5.h,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: SummaryInfoChip(
                  label: 'إجمالي',
                  value: '${state.allItems.length}',
                  color: context.primaryColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: SummaryInfoChip(
                  label: 'ديناميكي',
                  value: '$dynamicCount',
                  color: context.onSurfaceColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: SummaryInfoChip(
                  label: 'المكتمل',
                  value: '$completed',
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAthkarContent(BuildContext context, TravelAthkarState state, List<TravelDhikrModel> visibleItems) {
    if (visibleItems.isEmpty) {
      return _buildEmptyState(context);
    }

    if (state.displayMode == AthkarDisplayMode.listView) {
      return ListView.separated(
        itemCount: visibleItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = visibleItems[index];
          return _buildDhikrCard(context, state, item);
        },
      );
    }

    final safeIndex = state.currentPageIndex >= visibleItems.length
        ? visibleItems.length - 1
        : state.currentPageIndex;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CarouselSlider.builder(
                controller: _carouselController,
                itemCount: visibleItems.length,
                options: CarouselOptions(
                  height: constraints.maxHeight,
                  viewportFraction: 0.86,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.04,
                  initialPage: safeIndex,
                  onPageChanged: (value, _) {
                    context.read<TravelAthkarBloc>().add(UpdatePageIndexEvent(value));
                  },
                ),
                itemBuilder: (context, index, _) {
                  final item = visibleItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _buildDhikrCard(context, state, item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد نتائج مطابقة.',
        style: TextStyle(
          color: context.onSurfaceColor.withValues(alpha: 0.65),
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDhikrCard(BuildContext context, TravelAthkarState state, TravelDhikrModel item) {
    final current = state.repeatCounts[item.key] ?? 0;
    final target = item.repeatCount;
    final done = target != null && !item.isDynamicRepeat && current >= target;

    final shareText = [
      item.title,
      '',
      item.text,
      if (item.virtue.trim().isNotEmpty) ...[
        '',
        'الفضل: ${item.virtue}',
      ],
      '',
      'المصدر: ${item.reference.source} (${item.reference.hadith})',
    ].join('\n');

    return CardWidget(
      padding: EdgeInsets.all(12.sp),
      border: Border.all(
        color: done
            ? context.primaryColor.withValues(alpha: 0.45)
            : context.outlineVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconShareWidget(
                text: shareText,
                subject: 'أذكار السفر',
              ),
              CopyIconWidget(text: item.text),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              InfoChip(
                label: 'المناسبة',
                value: _triggerLabel(item.trigger),
                color: context.primaryColor,
              ),
              InfoChip(
                label: 'التكرار',
                value: item.repeatLabel,
                color: context.onSurfaceColor,
              ),
              InfoChip(
                label: 'المصدر',
                value: item.reference.source,
                color: context.onSurfaceColor,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SelectableText(
            item.text,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
          ),
          if (item.virtue.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'الفضل: ${item.virtue}',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.72),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.read<TravelAthkarBloc>().add(IncrementCounterEvent(item)),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  item.isDynamicRepeat
                      ? 'عدد التكرار: $current'
                      : '$current / ${item.repeatCount ?? 1}',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.read<TravelAthkarBloc>().add(ResetCounterEvent(item.key)),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('تصفير العداد'),
              ),
              if (done)
                DoneBadge(
                  text: 'تم',
                  color: context.primaryColor,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'المرجع: ${item.reference.source} - رقم ${item.reference.hadith}',
            style: TextStyle(
              color: context.onSurfaceColor.withValues(alpha: 0.66),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
