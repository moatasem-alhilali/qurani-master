part of 'young_muslim_home_screen.dart';

/// بقيّة واجهة الشاشة: الشريط الجانبي وحالات الخطأ والتنقّل.
///
/// امتداد ثانٍ على الحالة نفسها — الأوّل في
/// `young_muslim_home_screen_content.dart` — حتى لا يتجاوز ملفّ واحد
/// ستّمئة سطر.
extension _YoungMuslimHomeScreenRail on _YoungMuslimHomeScreenState {
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
