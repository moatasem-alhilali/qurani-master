part of 'young_muslim_home_screen.dart';

extension _YoungMuslimHomeScreenContent on _YoungMuslimHomeScreenState {
  Widget _buildDashboardContent(
    BuildContext context,
    YoungMuslimState state,
    YoungMuslimDashboardEntity dashboard,
  ) {
    final skin = AppSkin.of(context);
    final resume = dashboard.continueWatching.isEmpty
        ? null
        : dashboard.continueWatching.first;
    final remainingResume = dashboard.continueWatching.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // العنصر الوحيد المرتفع في الشاشة: الحلقة التي توقّف عندها الطفل.
        if (resume != null)
          RepaintBoundary(
            child: YoungMuslimResumeTile(
              video: resume,
              seriesTitle: _seriesTitleFor(dashboard, resume.seriesId),
              onTap: () => _openVideo(context, resume.id),
            ),
          ),
        skin.divider(),
        const HomeSectionHeader(title: 'الإنجازات'),
        RepaintBoundary(
          child: _buildRewardsBlock(context, dashboard),
        ),
        skin.divider(),
        const HomeSectionHeader(title: 'تصفية سريعة'),
        _buildQuickFilters(context, state),
        if (state.filters.hasActiveFilters) ...[
          _buildActiveFiltersRow(context),
          YoungMuslimSectionHeader(
            title: 'نتائج الفلترة',
            trailing: YoungMuslimMetricChip(
              label: '${dashboard.searchResults.length} نتيجة',
            ),
          ),
          if (dashboard.searchResults.isEmpty)
            const YoungMuslimEmptyState(
              title: 'لا توجد نتائج مطابقة',
              subtitle: 'جرّب كلمات أبسط أو غيّر الفلاتر لتظهر حلقات أكثر.',
              icon: AppIcons.searchOff,
            )
          else
            RepaintBoundary(
              child: _buildRail(context, dashboard, dashboard.searchResults),
            ),
        ],
        skin.divider(),
        const HomeSectionHeader(title: 'الأقسام'),
        RepaintBoundary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < dashboard.categories.length; i++)
                YoungMuslimCategoryRow(
                  category: dashboard.categories[i],
                  isLast: i == dashboard.categories.length - 1,
                  onTap: () => _openCategory(
                    context,
                    dashboard.categories[i].id,
                  ),
                ),
            ],
          ),
        ),
        _buildRailSection(
          context,
          title: 'أكمل المشاهدة',
          videos: remainingResume,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: 'شاهدت مؤخرًا',
          videos: dashboard.recentlyWatched,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: 'المفضلة',
          videos: dashboard.favorites,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: 'سأشاهد لاحقًا',
          videos: dashboard.watchLater,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: 'اقتراحات مناسبة',
          videos: dashboard.suggestions,
          dashboard: dashboard,
        ),
      ],
    );
  }

  /// سطر ترحيب واحد تحت العنوان — لا لوحة ولا أيقونة كبيرة.
  Widget _buildGreetingLine(
    BuildContext context,
    YoungMuslimDashboardEntity? dashboard,
  ) {
    final skin = AppSkin.of(context);
    final waiting = dashboard?.continueWatching.length ?? 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
      child: Text(
        dashboard == null
            ? 'مرحبًا بك في عالم القصص والتعلّم'
            : waiting == 0
                ? 'اختر قصة جديدة وابدأ رحلتك اليوم'
                : 'لديك $waiting حلقة بانتظارك لتعود إليها',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: youngMuslimRowSubtitle(skin, size: 10.sp),
      ),
    );
  }

  /// كتلة النقاط: صفّ يفتح اللوحة، ثم شريط التقدّم وثلاث خانات إحصاء.
  Widget _buildRewardsBlock(
    BuildContext context,
    YoungMuslimDashboardEntity dashboard,
  ) {
    final skin = AppSkin.of(context);
    final rewards = dashboard.rewardsSummary;
    final levelProgress = (rewards.xpIntoCurrentLevel / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YoungMuslimActionRow(
          icon: AppIcons.target,
          title: 'نقاطي وإنجازاتي',
          subtitle: 'المستوى ${rewards.level} · ${rewards.xp} نقطة',
          isLast: true,
          onTap: () {
            YoungMuslimRewardsSheet.show(
              context: context,
              rewardsSummary: rewards,
              achievements: dashboard.achievements,
            );
          },
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 5.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'التقدّم للمستوى التالي',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin),
                ),
              ),
              Text(
                '${rewards.xpIntoCurrentLevel} من 100',
                style: youngMuslimNumber(skin, size: 10.sp),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppSkin.gutter,
          child: YoungMuslimProgressBar(value: levelProgress),
        ),
        SizedBox(height: 12.h),
        YoungMuslimStatStrip(
          cells: [
            YoungMuslimStatCell(
              value: '${rewards.unlockedAchievements}',
              label: 'إنجازات',
              icon: AppIcons.star,
            ),
            YoungMuslimStatCell(
              value: '${rewards.completedVideos}',
              label: 'حلقات',
              icon: AppIcons.play,
            ),
            YoungMuslimStatCell(
              value: '${rewards.correctAnswers}',
              label: 'إجابات',
              icon: AppIcons.checkSmall,
            ),
          ],
        ),
      ],
    );
  }

  /// صفّ المرشّحات السريعة: حبّات أفقية، المفعّلة منها ممتلئة ذهبًا.
  Widget _buildQuickFilters(
    BuildContext context,
    YoungMuslimState state,
  ) {
    const statuses = <YoungMuslimStatusFilter, String>{
      YoungMuslimStatusFilter.all: 'الكل',
      YoungMuslimStatusFilter.inProgress: 'قيد المشاهدة',
      YoungMuslimStatusFilter.completed: 'مكتمل',
      YoungMuslimStatusFilter.favorites: 'المفضلة',
      YoungMuslimStatusFilter.watchLater: 'لاحقًا',
    };

    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final entry = statuses.entries.elementAt(index);
          return YoungMuslimPillButton(
            label: entry.value,
            selected: state.filters.status == entry.key,
            onTap: () {
              context.read<YoungMuslimBloc>().add(
                    YoungMuslimFiltersChanged(
                      state.filters.copyWith(status: entry.key),
                    ),
                  );
            },
          );
        },
      ),
    );
  }

  /// تنبيه بأن الفلاتر مفعّلة، ومعه زرّ مسحها.
  Widget _buildActiveFiltersRow(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          const YoungMuslimIconChip(icon: AppIcons.sliders),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'الفلاتر مفعّلة الآن، ويمكنك تعديلها من زرّ التصفية أعلى الصفحة.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: youngMuslimRowSubtitle(skin),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () {
              context.read<YoungMuslimBloc>().add(
                    const YoungMuslimFiltersChanged(
                      YoungMuslimFilters.empty,
                    ),
                  );
            },
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Text(
                'مسح',
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

  /// زرّ التصفية في رأس الصفحة، وعليه نقطة ذهبية متى كانت الفلاتر مفعّلة.
  Widget _buildFilterAction(
    BuildContext context,
    YoungMuslimState state,
  ) {
    return BlocSelector<YoungMuslimBloc, YoungMuslimState,
        YoungMuslimDashboardEntity?>(
      selector: (blocState) => blocState.dashboard,
      builder: (context, dashboard) {
        final skin = AppSkin.of(context);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: dashboard == null
                  ? null
                  : () => _showFiltersSheet(context, state, dashboard),
              borderRadius: BorderRadius.circular(11.r),
              child: Ink(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: skin.iconChip,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: AppIcon(
                    AppIcons.sliders,
                    color: skin.accent,
                    size: 15.sp,
                  ),
                ),
              ),
            ),
            if (state.filters.hasActiveFilters)
              PositionedDirectional(
                top: -1,
                end: -1,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: 'تعذّر تحميل المحتوى',
      subtitle: message ?? 'اسحب الصفحة للأسفل لإعادة المحاولة.',
      icon: AppIcons.warning,
    );
  }

  Widget _buildRail(
    BuildContext context,
    YoungMuslimDashboardEntity dashboard,
    List<YoungMuslimVideoEntity> videos,
  ) {
    return YoungMuslimVideoRail(
      videos: videos,
      seriesTitleBuilder: (video) => _seriesTitleFor(dashboard, video.seriesId),
      onTap: (videoId) => _openVideo(context, videoId),
      onFavoriteToggle: (videoId) => context
          .read<YoungMuslimBloc>()
          .add(YoungMuslimFavoriteToggled(videoId)),
      onWatchLaterToggle: (videoId) => context
          .read<YoungMuslimBloc>()
          .add(YoungMuslimWatchLaterToggled(videoId)),
    );
  }

  Widget _buildRailSection(
    BuildContext context, {
    required String title,
    required List<YoungMuslimVideoEntity> videos,
    required YoungMuslimDashboardEntity dashboard,
  }) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    final skin = AppSkin.of(context);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          skin.divider(),
          HomeSectionHeader(title: title),
          _buildRail(context, dashboard, videos),
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
        ' · '
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
    final skin = AppSkin.of(context);
    var selectedCategoryId = state.filters.categoryId;
    var selectedLanguage = state.filters.language;
    var selectedContentType = state.filters.contentType;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: skin.ground,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Widget groupLabel(String text) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 16.h, 0, 8.h),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: skin.hairline,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    YoungMuslimSectionHeader(
                      title: 'تصفية المحتوى',
                      padded: false,
                      trailing: InkWell(
                        onTap: () => Navigator.of(sheetContext).pop(),
                        borderRadius: BorderRadius.circular(999.r),
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: AppIcon(
                            AppIcons.close,
                            color: skin.accent,
                            size: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    groupLabel('القسم'),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        YoungMuslimPillButton(
                          label: 'الكل',
                          selected: selectedCategoryId == null,
                          onTap: () => setSheetState(
                            () => selectedCategoryId = null,
                          ),
                        ),
                        for (final category in dashboard.categories)
                          YoungMuslimPillButton(
                            label: category.titleAr,
                            selected: selectedCategoryId == category.id,
                            onTap: () => setSheetState(
                              () => selectedCategoryId = category.id,
                            ),
                          ),
                      ],
                    ),
                    groupLabel('اللغة'),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        YoungMuslimPillButton(
                          label: 'الكل',
                          selected: selectedLanguage == null,
                          onTap: () => setSheetState(
                            () => selectedLanguage = null,
                          ),
                        ),
                        YoungMuslimPillButton(
                          label: 'العربية',
                          selected: selectedLanguage == 'ar',
                          onTap: () => setSheetState(
                            () => selectedLanguage = 'ar',
                          ),
                        ),
                        YoungMuslimPillButton(
                          label: 'الفرنسية',
                          selected: selectedLanguage == 'fr',
                          onTap: () => setSheetState(
                            () => selectedLanguage = 'fr',
                          ),
                        ),
                        YoungMuslimPillButton(
                          label: 'مختلط',
                          selected: selectedLanguage == 'mixed',
                          onTap: () => setSheetState(
                            () => selectedLanguage = 'mixed',
                          ),
                        ),
                      ],
                    ),
                    groupLabel('نوع المحتوى'),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        YoungMuslimPillButton(
                          label: 'الكل',
                          selected: selectedContentType == null,
                          onTap: () => setSheetState(
                            () => selectedContentType = null,
                          ),
                        ),
                        YoungMuslimPillButton(
                          label: 'سلاسل قصصية',
                          selected: selectedContentType == 'story_series',
                          onTap: () => setSheetState(
                            () => selectedContentType = 'story_series',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    YoungMuslimPrimaryButton(
                      label: 'تطبيق الفلاتر',
                      icon: AppIcons.check,
                      onTap: () {
                        context.read<YoungMuslimBloc>().add(
                              YoungMuslimFiltersChanged(
                                state.filters.copyWith(
                                  categoryId: selectedCategoryId,
                                  language: selectedLanguage,
                                  contentType: selectedContentType,
                                  clearCategory: selectedCategoryId == null,
                                  clearLanguage: selectedLanguage == null,
                                  clearContentType: selectedContentType == null,
                                ),
                              ),
                            );
                        Navigator.of(sheetContext).pop();
                      },
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
