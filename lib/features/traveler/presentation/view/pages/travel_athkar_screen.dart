import 'dart:convert';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/cash/cache_service.dart';
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
  static const String _favoritesCacheKey = 'travel_athkar_favorites';

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<TravelDhikrModel> _allItems = const [];
  final Set<String> _favoriteKeys = <String>{};
  final Map<String, int> _repeatCounts = <String, int>{};

  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'all';
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

      final cachedFavorites =
          CacheService().getString(_favoritesCacheKey) ?? '[]';
      final decodedFavorites = jsonDecode(cachedFavorites);
      final favorites = <String>{};
      if (decodedFavorites is List<dynamic>) {
        favorites.addAll(
          decodedFavorites
              .whereType<String>()
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty),
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _allItems = items;
        _favoriteKeys
          ..clear()
          ..addAll(favorites);
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

  Future<void> _toggleFavorite(String key) async {
    if (key.trim().isEmpty) {
      return;
    }

    setState(() {
      if (_favoriteKeys.contains(key)) {
        _favoriteKeys.remove(key);
      } else {
        _favoriteKeys.add(key);
      }
    });

    final payload = jsonEncode(_favoriteKeys.toList());
    await CacheService().setString(_favoritesCacheKey, payload);
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

  List<String> get _triggerFilters {
    final triggers = _allItems.map((item) => item.trigger).toSet().toList()
      ..sort((first, second) => first.compareTo(second));
    return triggers;
  }

  List<TravelDhikrModel> get _visibleItems {
    final query = _searchQuery.trim();

    return _allItems.where((item) {
      if (_selectedFilter == 'favorites' && !_favoriteKeys.contains(item.key)) {
        return false;
      }

      if (_selectedFilter != 'all' &&
          _selectedFilter != 'favorites' &&
          item.trigger != _selectedFilter) {
        return false;
      }

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
      _selectedFilter = 'all';
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
      trailing: GenericSearchAnchorAsync<TravelDhikrModel>(
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
      slivers: [
        _buildBodySliver(context),
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
            _buildToolbarRow(context),
            SizedBox(height: 10.h),
            _buildFilterRow(context),
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

  Widget _buildToolbarRow(BuildContext context) {
    final hasQuery = _searchQuery.trim().isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: hasQuery
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: context.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: context.primaryColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            _searchQuery,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.onSurfaceColor,
                              fontSize: 11.8.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _applySearch(''),
                          borderRadius: BorderRadius.circular(999.r),
                          child: Padding(
                            padding: EdgeInsets.all(2.sp),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16.sp,
                              color:
                                  context.onSurfaceColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(
                  'استخدم البحث من أيقونة العدسة بالأعلى',
                  style: TextStyle(
                    color: context.onSurfaceColor.withValues(alpha: 0.65),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        SizedBox(width: 8.w),
        _buildDisplayModeToggle(context),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final fixedCount = _fixedItemsCount;
    final completed = _completedItemsCount;
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
                  label: 'المفضلة',
                  value: '${_favoriteKeys.length}',
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
        style: IconButton.styleFrom(
          backgroundColor: context.surfaceColor,
          side: BorderSide(
            color: context.outlineVariant.withValues(alpha: 0.32),
          ),
          padding: EdgeInsets.all(6.sp),
          minimumSize: Size(38.w, 38.w),
          maximumSize: Size(40.w, 40.w),
        ),
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

  Widget _buildFilterRow(BuildContext context) {
    final filters = <String>[
      'all',
      ..._triggerFilters,
      'favorites',
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = _selectedFilter == filter;

          return ChoiceChip(
            label: Text(_filterLabel(filter)),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
                _currentPageIndex = 0;
              });
              _jumpToFirstPage();
            },
          );
        },
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
        Row(
          children: [
            Text(
              'دعاء ${safeIndex + 1} / ${visibleItems.length}',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.7),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: safeIndex <= 0 ? null : () => _goToPage(safeIndex - 1),
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'السابق',
            ),
            IconButton(
              onPressed: safeIndex >= visibleItems.length - 1
                  ? null
                  : () => _goToPage(safeIndex + 1),
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'التالي',
            ),
          ],
        ),
        SizedBox(height: 6.h),
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

  void _goToPage(int index) {
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
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
    final favorite = _favoriteKeys.contains(item.key);
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
              IconButton(
                onPressed: () => _toggleFavorite(item.key),
                icon: Icon(
                  favorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: favorite ? Colors.amber : context.onSurfaceColor,
                ),
                tooltip: favorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
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

  String _filterLabel(String key) {
    if (key == 'all') {
      return 'الكل';
    }
    if (key == 'favorites') {
      return 'المفضلة';
    }
    return _triggerLabel(key);
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
