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
        HomeSectionHeader(title: context.l10n.youngMuslimAchievements),
        RepaintBoundary(
          child: _buildRewardsBlock(context, dashboard),
        ),
        skin.divider(),
        HomeSectionHeader(title: context.l10n.youngMuslimQuickFilter),
        _buildQuickFilters(context, state),
        if (state.filters.hasActiveFilters) ...[
          _buildActiveFiltersRow(context),
          YoungMuslimSectionHeader(
            title: context.l10n.youngMuslimFilterResults,
            trailing: YoungMuslimMetricChip(
              label: context.l10n
                  .youngMuslimResultsCount(dashboard.searchResults.length),
            ),
          ),
          if (dashboard.searchResults.isEmpty)
            YoungMuslimEmptyState(
              title: context.l10n.youngMuslimNoMatchesTitle,
              subtitle: context.l10n.youngMuslimNoMatchesSubtitle,
              icon: AppIcons.searchOff,
            )
          else
            RepaintBoundary(
              child: _buildRail(context, dashboard, dashboard.searchResults),
            ),
        ],
        skin.divider(),
        HomeSectionHeader(title: context.l10n.youngMuslimSections),
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
          title: context.l10n.youngMuslimContinueWatching,
          videos: remainingResume,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: context.l10n.youngMuslimRecentlyWatched,
          videos: dashboard.recentlyWatched,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: context.l10n.youngMuslimFavorites,
          videos: dashboard.favorites,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: context.l10n.youngMuslimWatchLater,
          videos: dashboard.watchLater,
          dashboard: dashboard,
        ),
        _buildRailSection(
          context,
          title: context.l10n.youngMuslimSuggestions,
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
            ? context.l10n.youngMuslimGreetingWelcome
            : waiting == 0
                ? context.l10n.youngMuslimGreetingPickNew
                : context.l10n.youngMuslimGreetingWaiting(waiting),
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
          title: context.l10n.youngMuslimRewardsTitle,
          subtitle:
              context.l10n.youngMuslimLevelAndPoints(rewards.level, rewards.xp),
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
                  context.l10n.youngMuslimNextLevelProgress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin),
                ),
              ),
              Text(
                context.l10n
                    .youngMuslimProgressOf(rewards.xpIntoCurrentLevel, 100),
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
              label: context.l10n.youngMuslimStatAchievements,
              icon: AppIcons.star,
            ),
            YoungMuslimStatCell(
              value: '${rewards.completedVideos}',
              label: context.l10n.youngMuslimStatEpisodes,
              icon: AppIcons.play,
            ),
            YoungMuslimStatCell(
              value: '${rewards.correctAnswers}',
              label: context.l10n.youngMuslimStatAnswers,
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
    final l10n = context.l10n;
    final statuses = <YoungMuslimStatusFilter, String>{
      YoungMuslimStatusFilter.all: l10n.youngMuslimFilterAll,
      YoungMuslimStatusFilter.inProgress: l10n.youngMuslimStatusInProgress,
      YoungMuslimStatusFilter.completed: l10n.youngMuslimStatusCompleted,
      YoungMuslimStatusFilter.favorites: l10n.youngMuslimFavorites,
      YoungMuslimStatusFilter.watchLater: l10n.youngMuslimStatusWatchLater,
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
              context.l10n.youngMuslimFiltersActiveNote,
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
                context.l10n.youngMuslimClearFilters,
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
}
