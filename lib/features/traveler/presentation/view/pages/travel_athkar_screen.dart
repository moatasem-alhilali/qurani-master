import 'dart:convert';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';

class TravelAthkarScreen extends StatefulWidget {
  const TravelAthkarScreen({super.key});

  @override
  State<TravelAthkarScreen> createState() => _TravelAthkarScreenState();
}

class _TravelAthkarScreenState extends State<TravelAthkarScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<TravelDhikrModel> _allItems = const [];
  final Map<String, int> _repeatCounts = <String, int>{};

  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  _AthkarDisplayMode _displayMode = _AthkarDisplayMode.pageView;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/travel_azkar.json',
      );
      final rawList = jsonDecode(jsonString);
      if (rawList is! List<dynamic>) {
        throw const FormatException('Invalid travel azkar json');
      }

      final items = rawList
          .whereType<Map<dynamic, dynamic>>()
          .map(Map<String, dynamic>.from)
          .map(TravelDhikrModel.fromJson)
          .where((item) => item.key.isNotEmpty)
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _allItems = items;
        _isLoading = false;
        _currentPageIndex = 0;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'تعذر تحميل أذكار السفر.';
        _isLoading = false;
      });
    }
  }

  void _incrementCounter(TravelDhikrModel item) {
    final current = _repeatCounts[item.key] ?? 0;
    final target = item.repeatCount;

    if (target != null && !item.isDynamicRepeat && current >= target) {
      return;
    }

    setState(() {
      _repeatCounts[item.key] = current + 1;
    });
  }

  void _resetCounter(String key) {
    setState(() {
      _repeatCounts[key] = 0;
    });
  }

  List<TravelDhikrModel> get _visibleItems {
    final query = _searchQuery.trim();

    return _allItems.where((item) {
      if (query.isEmpty) {
        return true;
      }

      return _matchesSearch(item, query);
    }).toList();
  }

  int get _fixedItemsCount {
    return _allItems
        .where((item) => item.repeatCount != null && !item.isDynamicRepeat)
        .length;
  }

  int get _completedItemsCount {
    final fixed = _allItems
        .where((item) => item.repeatCount != null && !item.isDynamicRepeat)
        .toList();

    return fixed.where((item) {
      final current = _repeatCounts[item.key] ?? 0;
      return current >= (item.repeatCount ?? 0);
    }).length;
  }

  String _triggerLabel(String trigger) {
    return travelTriggerLabels[trigger] ?? trigger;
  }

  bool _matchesSearch(TravelDhikrModel item, String query) {
    return item.title.contains(query) ||
        item.text.contains(query) ||
        item.virtue.contains(query) ||
        _triggerLabel(item.trigger).contains(query);
  }

  Future<List<TravelDhikrModel>> _searchSuggestions(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return _allItems.take(18).toList();
    }

    return _allItems
        .where((item) => _matchesSearch(item, normalized))
        .take(30)
        .toList();
  }

  void _applySearch(String query) {
    setState(() {
      _searchQuery = query.trim();
      _currentPageIndex = 0;
    });
    _jumpToFirstPage();
  }

  String _searchPreview(String text) {
    final value = text.replaceAll('\n', ' ').trim();
    if (value.length <= 80) {
      return value;
    }
    return '${value.substring(0, 80)}...';
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
    final hasQuery = _searchQuery.trim().isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasQuery)
          IconButton(
            tooltip: 'إلغاء البحث',
            onPressed: () => _applySearch(''),
            icon: Icon(
              Icons.filter_alt_off_rounded,
              color: context.onSurfaceColor.withValues(alpha: 0.82),
              size: 20.sp,
            ),
          ),
        _buildDisplayModeToggle(context),
        GenericSearchAnchorAsync<TravelDhikrModel>(
          hintText: 'ابحث في الأذكار',
          asyncSuggestions: _searchSuggestions,
          onSelected: (item) {
            _applySearch(item.title);
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
  }

  Widget _buildBodySliver(BuildContext context) {
    if (_isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                FilledButton.icon(
                  onPressed: _loadContent,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final visibleItems = _visibleItems;

    return SliverFillRemaining(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
        child: Column(
          children: [
            _buildSummaryCard(context),
            SizedBox(height: 10.h),
            Expanded(
              child: _buildAthkarContent(
                context,
                visibleItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final fixedCount = _fixedItemsCount;
    final completed = _completedItemsCount;
    final dynamicCount = _allItems.where((item) => item.isDynamicRepeat).length;
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
                child: _SummaryInfoChip(
                  label: 'إجمالي',
                  value: '${_allItems.length}',
                  color: context.primaryColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _SummaryInfoChip(
                  label: 'ديناميكي',
                  value: '$dynamicCount',
                  color: context.onSurfaceColor,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _SummaryInfoChip(
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

  Widget _buildDisplayModeToggle(BuildContext context) {
    final isPageMode = _displayMode == _AthkarDisplayMode.pageView;

    return Tooltip(
      message: isPageMode ? 'التحويل إلى ListView' : 'التحويل إلى PageView',
      child: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () {
          final next = isPageMode
              ? _AthkarDisplayMode.listView
              : _AthkarDisplayMode.pageView;
          setState(() {
            _displayMode = next;
            _currentPageIndex = 0;
          });
          if (next == _AthkarDisplayMode.pageView) {
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
  }

  Widget _buildAthkarContent(
    BuildContext context,
    List<TravelDhikrModel> visibleItems,
  ) {
    if (visibleItems.isEmpty) {
      return _buildEmptyState(context);
    }

    if (_displayMode == _AthkarDisplayMode.listView) {
      return ListView.separated(
        itemCount: visibleItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = visibleItems[index];
          return _buildDhikrCard(context, item);
        },
      );
    }

    final safeIndex = _currentPageIndex >= visibleItems.length
        ? visibleItems.length - 1
        : _currentPageIndex;

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
                    setState(() {
                      _currentPageIndex = value;
                    });
                  },
                ),
                itemBuilder: (context, index, _) {
                  final item = visibleItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _buildDhikrCard(context, item),
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

  void _jumpToFirstPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_carouselController.ready) {
        return;
      }
      _carouselController.jumpToPage(0);
    });
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

  Widget _buildDhikrCard(BuildContext context, TravelDhikrModel item) {
    final current = _repeatCounts[item.key] ?? 0;
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
              _InfoChip(
                label: 'المناسبة',
                value: _triggerLabel(item.trigger),
                color: context.primaryColor,
              ),
              _InfoChip(
                label: 'التكرار',
                value: item.repeatLabel,
                color: context.onSurfaceColor,
              ),
              _InfoChip(
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
                onPressed: () => _incrementCounter(item),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  item.isDynamicRepeat
                      ? 'عدد التكرار: $current'
                      : '$current / ${item.repeatCount ?? 1}',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _resetCounter(item.key),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('تصفير العداد'),
              ),
              if (done)
                _DoneBadge(
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

enum _AthkarDisplayMode {
  pageView,
  listView,
}

class _SummaryInfoChip extends StatelessWidget {
  const _SummaryInfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Text(
          '$label: $value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 10.2.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        child: Text(
          '$label: $value',
          style: TextStyle(
            color: color,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DoneBadge extends StatelessWidget {
  const _DoneBadge({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: color,
              size: 16.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
