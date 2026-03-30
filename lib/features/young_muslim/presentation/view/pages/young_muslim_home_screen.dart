import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_category_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_video_details_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_rewards_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';

class YoungMuslimHomeScreen extends StatefulWidget {
  const YoungMuslimHomeScreen({super.key});

  @override
  State<YoungMuslimHomeScreen> createState() => _YoungMuslimHomeScreenState();
}

class _YoungMuslimHomeScreenState extends State<YoungMuslimHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'المسلم الصغير',
      showLargeHeader: false,
      initialOffset: null,
      trailing: BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
        buildWhen: (previous, current) {
          return previous.filters != current.filters ||
              previous.dashboard != current.dashboard;
        },
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterAction(context, state),
              SizedBox(width: 8.w),
              GenericSearchAnchorAsync<_YoungMuslimSearchSuggestion>(
                hintText: 'ابحث عن قصة أو حلقة',
                asyncSuggestions: (query) async {
                  final trimmed = query.trim();
                  if (trimmed.isEmpty) {
                    return const <_YoungMuslimSearchSuggestion>[];
                  }

                  final repository = context.read<YoungMuslimRepository>();
                  final dashboard = await repository.getDashboard(
                    query: trimmed,
                    filters: state.filters,
                  );

                  return dashboard.searchResults
                      .take(12)
                      .map(
                        (video) => _YoungMuslimSearchSuggestion(
                          videoId: video.id,
                          title: video.title,
                          subtitle:
                              '${_seriesTitleFor(dashboard, video.seriesId)} • ${_categoryTitleFor(dashboard, video.categoryId)}',
                          duration: youngMuslimDuration(
                            video.durationSeconds,
                          ),
                        ),
                      )
                      .toList(growable: false);
                },
                onSelected: (item) => _openVideo(context, item.videoId),
                suggestionBuilder: (context, item) {
                  return _YoungMuslimSearchSuggestionTile(item: item);
                },
              ),
            ],
          );
        },
      ),
      onRefresh: () async {
        context.read<YoungMuslimBloc>().add(const YoungMuslimRefreshed());
      },
      body: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<YoungMuslimBloc, YoungMuslimState,
                YoungMuslimDashboardEntity?>(
              selector: (state) => state.dashboard,
              builder: _buildTopHeader,
            ),
            SizedBox(height: 18.h),
            BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
              buildWhen: (previous, current) {
                return previous.filters != current.filters;
              },
              builder: (context, state) {
                if (!state.filters.hasActiveFilters) {
                  return const SizedBox.shrink();
                }
                return _buildActiveFiltersSummary(context, state);
              },
            ),
            SizedBox(height: 18.h),
            BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
              buildWhen: (previous, current) {
                return previous.loadState != current.loadState ||
                    previous.dashboard != current.dashboard ||
                    previous.query != current.query ||
                    previous.filters != current.filters ||
                    previous.errorMessage != current.errorMessage;
              },
              builder: (context, state) {
                final dashboard = state.dashboard;
                Widget child;
                if (state.loadState == RequestState.loading &&
                    dashboard == null) {
                  child = _buildLoadingBody(context);
                } else if (state.loadState == RequestState.error &&
                    dashboard == null) {
                  child = _buildErrorBody(context, state.errorMessage);
                } else if (dashboard == null) {
                  child = _buildLoadingBody(context);
                } else {
                  child = _buildDashboardContent(context, state, dashboard);
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: KeyedSubtree(
                    key: ValueKey(
                      '${state.loadState.name}_${dashboard?.categories.length ?? 0}_${state.query}_${state.filters.hashCode}',
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    YoungMuslimState state,
    YoungMuslimDashboardEntity dashboard,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: _buildHeroCarousel(context, dashboard),
        ),
        SizedBox(height: 18.h),
        RepaintBoundary(
          child: _buildRewardsSummary(context, dashboard),
        ),
        SizedBox(height: 18.h),
        _buildQuickFilters(context, state),
        SizedBox(height: 22.h),
        const YoungMuslimSectionHeader(
          title: 'الأقسام الرئيسية',
          subtitle: 'اختر القسم الذي يناسب عمر الطفل واهتمامه',
        ),
        SizedBox(height: 14.h),
        RepaintBoundary(
          child: ListView.separated(
            itemCount: dashboard.categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            separatorBuilder: (_, __) => SizedBox(height: 14.h),
            itemBuilder: (context, index) {
              final category = dashboard.categories[index];
              return YoungMuslimCategoryCard(
                category: category,
                onTap: () => _openCategory(context, category.id),
                height: 196,
              );
            },
          ),
        ),
        SizedBox(height: 22.h),
        if (state.filters.hasActiveFilters) ...[
          YoungMuslimSectionHeader(
            title: 'نتائج الفلترة',
            subtitle: '${dashboard.searchResults.length} نتيجة',
          ),
          SizedBox(height: 14.h),
          if (dashboard.searchResults.isEmpty)
            const YoungMuslimEmptyState(
              title: 'لا توجد نتائج مطابقة',
              subtitle: 'جرّب كلمات أبسط أو غيّر الفلاتر لتظهر لك حلقات أكثر.',
              icon: Icons.search_off_rounded,
            )
          else
            RepaintBoundary(
              child: YoungMuslimVideoCarousel(
                videos: dashboard.searchResults,
                seriesTitleBuilder: (video) =>
                    _seriesTitleFor(dashboard, video.seriesId),
                onTap: (videoId) => _openVideo(context, videoId),
                onFavoriteToggle: (videoId) => context
                    .read<YoungMuslimBloc>()
                    .add(YoungMuslimFavoriteToggled(videoId)),
                onWatchLaterToggle: (videoId) => context
                    .read<YoungMuslimBloc>()
                    .add(YoungMuslimWatchLaterToggled(videoId)),
              ),
            ),
          SizedBox(height: 22.h),
        ],
        _buildRailSection(
          context,
          title: 'أكمل المشاهدة',
          subtitle: 'ارجع من حيث توقفت بسهولة',
          videos: dashboard.continueWatching,
          dashboard: dashboard,
        ),
        SizedBox(height: 22.h),
        _buildRailSection(
          context,
          title: 'شاهدت مؤخرًا',
          subtitle: 'آخر ما شاهده الطفل داخل التطبيق',
          videos: dashboard.recentlyWatched,
          dashboard: dashboard,
        ),
        SizedBox(height: 22.h),
        _buildRailSection(
          context,
          title: 'المفضلة',
          subtitle: 'حلقات أحببت الاحتفاظ بها',
          videos: dashboard.favorites,
          dashboard: dashboard,
        ),
        SizedBox(height: 22.h),
        _buildRailSection(
          context,
          title: 'سأشاهد لاحقًا',
          subtitle: 'قائمة مرتبة للعودة لاحقًا',
          videos: dashboard.watchLater,
          dashboard: dashboard,
        ),
        SizedBox(height: 22.h),
        _buildRailSection(
          context,
          title: 'اقتراحات مناسبة',
          subtitle: 'مقترحات من نفس الجو القصصي الذي يحبه الطفل',
          videos: dashboard.suggestions,
          dashboard: dashboard,
        ),
      ],
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    YoungMuslimDashboardEntity? dashboard,
  ) {
    final firstCategory = (dashboard?.categories.isNotEmpty ?? false)
        ? dashboard!.categories.first
        : null;
    final colors = firstCategory == null
        ? [context.primaryColor, context.secondaryColor]
        : youngMuslimGradientColors(
            context,
            startHex: firstCategory.accentStart,
            endHex: firstCategory.accentEnd,
          );
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المسلم الصغير',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                SizedBox(height: 6.h),
                Text(
                  dashboard == null
                      ? 'قصص مرئية، متابعة ذكية، وأسئلة بسيطة بعد المشاهدة.'
                      : 'لديك ${dashboard.continueWatching.length} عناصر يمكنك إكمالها الآن.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                ),
                if (dashboard != null) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      YoungMuslimMetricChip(
                        label: '${dashboard.categories.length} أقسام',
                        icon: Icons.grid_view_rounded,
                        color: context.primaryColor,
                      ),
                      YoungMuslimMetricChip(
                        label: '${dashboard.favorites.length} مفضلة',
                        icon: Icons.favorite_rounded,
                        color: youngMuslimRewardColor(context),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersSummary(
    BuildContext context,
    YoungMuslimState state,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Row(
        children: [
          Icon(
            Icons.tune_rounded,
            color: context.primaryColor,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'الفلاتر مفعلة الآن. يمكنك تعديلها من زر البحث أعلى الصفحة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.gray1,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<YoungMuslimBloc>().add(
                    const YoungMuslimFiltersChanged(
                      YoungMuslimFilters.empty,
                    ),
                  );
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAction(
    BuildContext context,
    YoungMuslimState state,
  ) {
    return BlocSelector<YoungMuslimBloc, YoungMuslimState,
        YoungMuslimDashboardEntity?>(
      selector: (blocState) => blocState.dashboard,
      builder: (context, dashboard) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: dashboard == null
                  ? null
                  : () => _showFiltersSheet(context, state, dashboard),
              borderRadius: BorderRadius.circular(18.r),
              child: Ink(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: context.outlineVariant.withValues(alpha: 0.45),
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: context.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            if (state.filters.hasActiveFilters)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: youngMuslimRewardColor(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeroCarousel(
    BuildContext context,
    YoungMuslimDashboardEntity dashboard,
  ) {
    return CarouselSlider.builder(
      itemCount: dashboard.categories.length,
      options: CarouselOptions(
        height: 198.h,
        enlargeCenterPage: false,
        viewportFraction: 0.9,
        autoPlay: false,
        enableInfiniteScroll: dashboard.categories.length > 1,
      ),
      itemBuilder: (context, index, realIndex) {
        final category = dashboard.categories[index];
        return YoungMuslimMediaBanner(
          title: category.titleAr,
          subtitle: category.description,
          imageUrl: category.bannerImage,
          accentStart: category.accentStart,
          accentEnd: category.accentEnd,
          onTap: () => _openCategory(context, category.id),
          badges: [
            YoungMuslimMetricChip(
              label: category.audience == 'kids' ? 'للأطفال' : 'عام',
              icon: Icons.shield_moon_rounded,
              color: Colors.white,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRewardsSummary(
    BuildContext context,
    YoungMuslimDashboardEntity dashboard,
  ) {
    final rewards = dashboard.rewardsSummary;
    final levelProgress = (rewards.xpIntoCurrentLevel / 100).clamp(0.0, 1.0);

    return InkWell(
      onTap: () {
        YoungMuslimRewardsSheet.show(
          context: context,
          rewardsSummary: rewards,
          achievements: dashboard.achievements,
        );
      },
      borderRadius: BorderRadius.circular(28.r),
      child: Ink(
        padding: EdgeInsets.all(18.w),
        decoration: youngMuslimPanelDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: YoungMuslimSectionHeader(
                    title: 'نقاطك وإنجازاتك',
                    subtitle: 'اضغط لعرض التقدّم الكامل والإنجازات القادمة',
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: context.gray1,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: YoungMuslimMetricChip(
                    label: '${rewards.xp} XP',
                    icon: Icons.bolt_rounded,
                    color: youngMuslimRewardColor(context),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: YoungMuslimMetricChip(
                    label: 'المستوى ${rewards.level}',
                    icon: Icons.emoji_events_rounded,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: YoungMuslimMetricChip(
                    label: '${rewards.unlockedAchievements} إنجاز',
                    icon: Icons.stars_rounded,
                    color: context.secondaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'التقدّم للمستوى التالي',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  '${rewards.xpIntoCurrentLevel}/100',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: context.gray1,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: levelProgress,
              minHeight: 9.h,
              borderRadius: BorderRadius.circular(18.r),
              backgroundColor: context.outline.withValues(alpha: 0.18),
              color: youngMuslimRewardColor(context),
            ),
            SizedBox(height: 14.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                YoungMuslimMetricChip(
                  label: '${rewards.completedVideos} فيديو مكتمل',
                  icon: Icons.play_lesson_rounded,
                  color: context.primaryColor,
                ),
                YoungMuslimMetricChip(
                  label: '${rewards.correctAnswers} إجابة صحيحة',
                  icon: Icons.quiz_rounded,
                  color: context.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters(
    BuildContext context,
    YoungMuslimState state,
  ) {
    final statuses = {
      YoungMuslimStatusFilter.all: 'الكل',
      YoungMuslimStatusFilter.inProgress: 'قيد المشاهدة',
      YoungMuslimStatusFilter.completed: 'مكتمل',
      YoungMuslimStatusFilter.favorites: 'المفضلة',
      YoungMuslimStatusFilter.watchLater: 'لاحقًا',
    };

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final entry = statuses.entries.elementAt(index);
          final selected = state.filters.status == entry.key;
          return ChoiceChip(
            label: Text(entry.value),
            selected: selected,
            onSelected: (_) {
              context.read<YoungMuslimBloc>().add(
                    YoungMuslimFiltersChanged(
                      state.filters.copyWith(status: entry.key),
                    ),
                  );
            },
            selectedColor: context.primaryContainer.withValues(alpha: 0.9),
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? context.primaryColor : context.gray1,
                  fontWeight: FontWeight.w700,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
      ),
    );
  }

  Widget _buildLoadingBody(BuildContext context) {
    return const YoungMuslimLoadingPanel();
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: 'تعذر تحميل المحتوى',
      subtitle: message ?? 'حاول تحديث الصفحة مرة أخرى.',
      icon: Icons.cloud_off_rounded,
    );
  }

  Widget _buildRailSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<YoungMuslimVideoEntity> videos,
    required YoungMuslimDashboardEntity dashboard,
  }) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoungMuslimSectionHeader(
            title: title,
            subtitle: subtitle,
          ),
          SizedBox(height: 14.h),
          YoungMuslimVideoCarousel(
            videos: videos,
            seriesTitleBuilder: (video) =>
                _seriesTitleFor(dashboard, video.seriesId),
            onTap: (videoId) => _openVideo(context, videoId),
            onFavoriteToggle: (videoId) => context
                .read<YoungMuslimBloc>()
                .add(YoungMuslimFavoriteToggled(videoId)),
            onWatchLaterToggle: (videoId) => context
                .read<YoungMuslimBloc>()
                .add(YoungMuslimWatchLaterToggled(videoId)),
          ),
        ],
      ),
    );
  }

  String _seriesTitleFor(
    YoungMuslimDashboardEntity dashboard,
    String seriesId,
  ) {
    for (final series in dashboard.series) {
      if (series.id == seriesId) {
        return series.titleAr;
      }
    }
    return '';
  }

  String _categoryTitleFor(
    YoungMuslimDashboardEntity dashboard,
    String categoryId,
  ) {
    for (final category in dashboard.categories) {
      if (category.id == categoryId) {
        return category.titleAr;
      }
    }
    return '';
  }

  void _openCategory(BuildContext context, String categoryId) {
    Navigator.of(context).push(
      youngMuslimPageRoute<void>(
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimCategoryScreen(categoryId: categoryId),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, String videoId) {
    Navigator.of(context).push(
      youngMuslimPageRoute<void>(
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimVideoDetailsScreen(videoId: videoId),
        ),
      ),
    );
  }

  Future<void> _showFiltersSheet(
    BuildContext context,
    YoungMuslimState state,
    YoungMuslimDashboardEntity dashboard,
  ) async {
    var selectedCategoryId = state.filters.categoryId;
    var selectedLanguage = state.filters.language;
    var selectedContentType = state.filters.contentType;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget wrapOptions(
              List<Widget> children,
            ) {
              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: children,
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 34.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YoungMuslimSectionHeader(
                      title: 'تصفية المحتوى',
                      subtitle: 'حدّد القسم أو اللغة أو نوع المحتوى',
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'القسم',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    wrapOptions([
                      ChoiceChip(
                        label: const Text('الكل'),
                        selected: selectedCategoryId == null,
                        onSelected: (_) =>
                            setState(() => selectedCategoryId = null),
                      ),
                      for (final category in dashboard.categories)
                        ChoiceChip(
                          label: Text(category.titleAr),
                          selected: selectedCategoryId == category.id,
                          onSelected: (_) =>
                              setState(() => selectedCategoryId = category.id),
                        ),
                    ]),
                    SizedBox(height: 18.h),
                    Text(
                      'اللغة',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    wrapOptions([
                      ChoiceChip(
                        label: const Text('الكل'),
                        selected: selectedLanguage == null,
                        onSelected: (_) =>
                            setState(() => selectedLanguage = null),
                      ),
                      ChoiceChip(
                        label: const Text('العربية'),
                        selected: selectedLanguage == 'ar',
                        onSelected: (_) =>
                            setState(() => selectedLanguage = 'ar'),
                      ),
                      ChoiceChip(
                        label: const Text('الفرنسية'),
                        selected: selectedLanguage == 'fr',
                        onSelected: (_) =>
                            setState(() => selectedLanguage = 'fr'),
                      ),
                      ChoiceChip(
                        label: const Text('مختلط'),
                        selected: selectedLanguage == 'mixed',
                        onSelected: (_) =>
                            setState(() => selectedLanguage = 'mixed'),
                      ),
                    ]),
                    SizedBox(height: 18.h),
                    Text(
                      'نوع المحتوى',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    wrapOptions([
                      ChoiceChip(
                        label: const Text('الكل'),
                        selected: selectedContentType == null,
                        onSelected: (_) =>
                            setState(() => selectedContentType = null),
                      ),
                      ChoiceChip(
                        label: const Text('سلاسل قصصية'),
                        selected: selectedContentType == 'story_series',
                        onSelected: (_) => setState(
                          () => selectedContentType = 'story_series',
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('كواليس'),
                        selected: selectedContentType == 'behind_the_scenes',
                        onSelected: (_) => setState(
                          () => selectedContentType = 'behind_the_scenes',
                        ),
                      ),
                    ]),
                    SizedBox(height: 28.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<YoungMuslimBloc>().add(
                                YoungMuslimFiltersChanged(
                                  state.filters.copyWith(
                                    categoryId: selectedCategoryId,
                                    language: selectedLanguage,
                                    contentType: selectedContentType,
                                    clearCategory: selectedCategoryId == null,
                                    clearLanguage: selectedLanguage == null,
                                    clearContentType:
                                        selectedContentType == null,
                                  ),
                                ),
                              );
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('تطبيق الفلاتر'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _YoungMuslimSearchSuggestion {
  const _YoungMuslimSearchSuggestion({
    required this.videoId,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  final String videoId;
  final String title;
  final String subtitle;
  final String duration;

  @override
  String toString() => title;
}

class _YoungMuslimSearchSuggestionTile extends StatelessWidget {
  const _YoungMuslimSearchSuggestionTile({
    required this.item,
  });

  final _YoungMuslimSearchSuggestion item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: youngMuslimPanelDecoration(context, radius: 22),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: context.primaryContainer.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: context.primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          YoungMuslimMetricChip(
            label: item.duration,
            icon: Icons.schedule_rounded,
            color: context.primaryColor,
          ),
        ],
      ),
    );
  }
}
