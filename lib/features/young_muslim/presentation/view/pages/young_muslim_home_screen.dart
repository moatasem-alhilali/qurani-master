import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_category_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_video_details_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';

class YoungMuslimHomeScreen extends StatefulWidget {
  const YoungMuslimHomeScreen({super.key});

  @override
  State<YoungMuslimHomeScreen> createState() => _YoungMuslimHomeScreenState();
}

class _YoungMuslimHomeScreenState extends State<YoungMuslimHomeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
      builder: (context, state) {
        final dashboard = state.dashboard;
        return AppScaffoldWidget(
          title: 'المسلم الصغير',
          onRefresh: () async {
            context.read<YoungMuslimBloc>().add(const YoungMuslimRefreshed());
          },
          body: dashboard == null && state.loadState == RequestState.loading
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 120.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopHeader(context, dashboard),
                      SizedBox(height: 18.h),
                      _buildSearchBar(context, state, dashboard),
                      SizedBox(height: 18.h),
                      if (dashboard != null) ...[
                        _buildHeroCarousel(context, dashboard),
                        SizedBox(height: 18.h),
                        _buildRewardsSummary(context, dashboard.rewardsSummary),
                        SizedBox(height: 18.h),
                        _buildQuickFilters(context, state, dashboard),
                        SizedBox(height: 22.h),
                        const YoungMuslimSectionHeader(
                          title: 'الأقسام الرئيسية',
                          subtitle: 'اختر القسم الذي يناسب عمر الطفل واهتمامه',
                        ),
                        SizedBox(height: 14.h),
                        GridView.builder(
                          itemCount: dashboard.categories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14.h,
                            crossAxisSpacing: 14.w,
                            childAspectRatio: 1.02,
                          ),
                          itemBuilder: (context, index) {
                            final category = dashboard.categories[index];
                            return YoungMuslimCategoryCard(
                              category: category,
                              onTap: () => _openCategory(context, category.id),
                            );
                          },
                        ),
                        SizedBox(height: 22.h),
                        if (state.query.isNotEmpty ||
                            state.filters.hasActiveFilters) ...[
                          YoungMuslimSectionHeader(
                            title: 'نتائج البحث',
                            subtitle: '${dashboard.searchResults.length} نتيجة',
                          ),
                          SizedBox(height: 14.h),
                          if (dashboard.searchResults.isEmpty)
                            const YoungMuslimEmptyState(
                              title: 'لا توجد نتائج مطابقة',
                              subtitle:
                                  'جرّب كلمات أبسط أو غيّر الفلاتر لتظهر لك حلقات أكثر.',
                              icon: Icons.search_off_rounded,
                            )
                          else
                            SizedBox(
                              height: 305.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final video = dashboard.searchResults[index];
                                  return YoungMuslimVideoCard(
                                    video: video,
                                    seriesTitle: _seriesTitleFor(
                                      dashboard,
                                      video.seriesId,
                                    ),
                                    onTap: () => _openVideo(context, video.id),
                                    onFavoriteToggle: () =>
                                        context.read<YoungMuslimBloc>().add(
                                              YoungMuslimFavoriteToggled(
                                                video.id,
                                              ),
                                            ),
                                    onWatchLaterToggle: () =>
                                        context.read<YoungMuslimBloc>().add(
                                              YoungMuslimWatchLaterToggled(
                                                video.id,
                                              ),
                                            ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 12.w),
                                itemCount: dashboard.searchResults.length,
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
                          subtitle:
                              'مقترحات من نفس الجو القصصي الذي يحبه الطفل',
                          videos: dashboard.suggestions,
                          dashboard: dashboard,
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    YoungMuslimDashboardEntity? dashboard,
  ) {
    final firstCategory = dashboard?.categories.isNotEmpty == true
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colors.first,
            Color.lerp(colors.first, colors.last, 0.6) ?? colors.first,
            colors.last,
          ],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18.r),
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
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                SizedBox(height: 6.h),
                Text(
                  dashboard == null
                      ? 'قصص مرئية، متابعة ذكية، وأسئلة بسيطة بعد المشاهدة.'
                      : 'لديك ${dashboard.continueWatching.length} عناصر يمكنك إكمالها الآن.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    YoungMuslimState state,
    YoungMuslimDashboardEntity? dashboard,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              context
                  .read<YoungMuslimBloc>()
                  .add(YoungMuslimSearchChanged(value));
            },
            decoration: InputDecoration(
              hintText: 'ابحث في الحلقات، الأقسام، أو السلاسل',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: state.query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<YoungMuslimBloc>()
                            .add(const YoungMuslimSearchChanged(''));
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              filled: true,
              fillColor: context.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide(
                  color: context.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide(
                  color: context.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        InkWell(
          onTap: dashboard == null
              ? null
              : () => _showFiltersSheet(context, state, dashboard),
          borderRadius: BorderRadius.circular(20.r),
          child: Ink(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: context.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: context.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCarousel(
    BuildContext context,
    YoungMuslimDashboardEntity dashboard,
  ) {
    return CarouselSlider.builder(
      itemCount: dashboard.categories.length,
      options: CarouselOptions(
        height: 210.h,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final category = dashboard.categories[index];
        final colors = youngMuslimGradientColors(
          context,
          startHex: category.accentStart,
          endHex: category.accentEnd,
        );
        return InkWell(
          onTap: () => _openCategory(context, category.id),
          borderRadius: BorderRadius.circular(32.r),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: colors,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: Image.network(
                      category.bannerImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.scrim.withValues(alpha: 0.08),
                          context.scrim.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      YoungMuslimMetricChip(
                        label: category.audience == 'kids' ? 'للأطفال' : 'عام',
                        icon: Icons.shield_moon_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        category.titleAr,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardsSummary(
    BuildContext context,
    YoungMuslimRewardsSummaryEntity rewards,
  ) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const YoungMuslimSectionHeader(
            title: 'نقاطك وإنجازاتك',
            subtitle: 'تابع التقدّم بدون تعقيد',
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
        ],
      ),
    );
  }

  Widget _buildQuickFilters(
    BuildContext context,
    YoungMuslimState state,
    YoungMuslimDashboardEntity dashboard,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoungMuslimSectionHeader(
          title: title,
          subtitle: subtitle,
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 305.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final video = videos[index];
              return YoungMuslimVideoCard(
                video: video,
                seriesTitle: _seriesTitleFor(dashboard, video.seriesId),
                onTap: () => _openVideo(context, video.id),
                onFavoriteToggle: () => context
                    .read<YoungMuslimBloc>()
                    .add(YoungMuslimFavoriteToggled(video.id)),
                onWatchLaterToggle: () => context
                    .read<YoungMuslimBloc>()
                    .add(YoungMuslimWatchLaterToggled(video.id)),
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemCount: videos.length,
          ),
        ),
      ],
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

  void _openCategory(BuildContext context, String categoryId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimCategoryScreen(categoryId: categoryId),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, String videoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => YoungMuslimRouteScope.inherit(
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
