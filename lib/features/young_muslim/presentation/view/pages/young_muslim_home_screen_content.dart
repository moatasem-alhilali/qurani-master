part of 'young_muslim_home_screen.dart';

extension _YoungMuslimHomeScreenContent on _YoungMuslimHomeScreenState {
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
      padding: EdgeInsets.all(20.w),
      decoration: youngMuslimPanelDecoration(context, radius: 28, useGradient: true),
      child: Stack(
        children: [
          Positioned(
            bottom: -30.h,
            left: -20.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.first.withValues(alpha: 0.04),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: colors,
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المسلم الصغير',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: context.onSurfaceColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      dashboard == null
                          ? 'قصص مرئية، متابعة ذكية، وأسئلة بسيطة بعد المشاهدة.'
                          : 'لديك ${dashboard.continueWatching.length} عناصر'
                              ' يمكنك إكمالها الآن.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    if (dashboard != null) ...[
                      SizedBox(height: 14.h),
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
        viewportFraction: 0.9,
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
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: youngMuslimPanelDecoration(context, radius: 28, useGradient: true),
        child: Stack(
          children: [
            Positioned(
              top: -30.h,
              left: -30.w,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor.withValues(alpha: 0.04),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: youngMuslimRewardColor(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: youngMuslimRewardColor(context),
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    const Expanded(
                      child: YoungMuslimSectionHeader(
                        title: 'نقاطك وإنجازاتك',
                        subtitle: 'تقدّمك الكامل في رحلة التعلم والنمو',
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: context.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: YoungMuslimMetricChip(
                        label: '${rewards.xp} XP',
                        icon: Icons.bolt_rounded,
                        color: youngMuslimRewardColor(context),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: YoungMuslimMetricChip(
                        label: 'المستوى ${rewards.level}',
                        icon: Icons.emoji_events_rounded,
                        color: context.primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: YoungMuslimMetricChip(
                        label: '${rewards.unlockedAchievements} إنجاز',
                        icon: Icons.stars_rounded,
                        color: context.secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'التقدّم للمستوى التالي',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: context.onSurfaceColor,
                        ),
                      ),
                    ),
                    Text(
                      '${rewards.xpIntoCurrentLevel}/100',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.onSurfaceVariant.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Stack(
                  children: [
                    Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: context.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: levelProgress,
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              youngMuslimRewardColor(context),
                              youngMuslimRewardColor(context).withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: youngMuslimRewardColor(context).withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: YoungMuslimMetricChip(
                        label: '${rewards.completedVideos} فيديو مكتمل',
                        icon: Icons.play_lesson_rounded,
                        color: context.primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: YoungMuslimMetricChip(
                        label: '${rewards.correctAnswers} إجابة صحيحة',
                        icon: Icons.quiz_rounded,
                        color: context.secondaryColor,
                      ),
                    ),
                  ],
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

  String _searchSuggestionSubtitle(
    YoungMuslimDashboardEntity dashboard,
    YoungMuslimVideoEntity video,
  ) {
    return '${_seriesTitleFor(dashboard, video.seriesId)}'
        ' • '
        '${_categoryTitleFor(dashboard, video.categoryId)}';
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
