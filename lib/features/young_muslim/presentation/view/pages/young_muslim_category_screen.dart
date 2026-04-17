import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_video_details_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';

class YoungMuslimCategoryScreen extends StatefulWidget {
  const YoungMuslimCategoryScreen({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<YoungMuslimCategoryScreen> createState() =>
      _YoungMuslimCategoryScreenState();
}

class _YoungMuslimCategoryScreenState extends State<YoungMuslimCategoryScreen> {
  String? _selectedSeriesId;

  @override
  void initState() {
    super.initState();
    context
        .read<YoungMuslimBloc>()
        .add(YoungMuslimCategoryRequested(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      showLargeHeader: false,
      initialOffset: null,
      titleWidget: BlocSelector<YoungMuslimBloc, YoungMuslimState, String>(
        selector: (state) {
          final details = state.categoryDetails;
          if (details != null && details.category.id == widget.categoryId) {
            return details.category.titleAr;
          }
          return 'المسلم الصغير';
        },
        builder: (context, title) => Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 28.h),
        child: BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
          buildWhen: (previous, current) {
            return previous.categoryState != current.categoryState ||
                previous.categoryDetails != current.categoryDetails ||
                previous.errorMessage != current.errorMessage;
          },
          builder: (context, state) {
            final details = state.categoryDetails;
            final hasCurrentDetails =
                details != null && details.category.id == widget.categoryId;

            Widget child;
            if (!hasCurrentDetails &&
                state.categoryState == RequestState.error) {
              child = _buildErrorBody(context, state.errorMessage);
            } else if (!hasCurrentDetails) {
              child = _buildLoadingBody();
            } else {
              child = _buildCategoryContent(context, details);
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(
                  '${state.categoryState.name}_${details?.category.id ?? widget.categoryId}_${_selectedSeriesId ?? ''}',
                ),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryContent(
    BuildContext context,
    YoungMuslimCategoryDetailsEntity details,
  ) {
    final selectedSeriesId = _resolveSelectedSeriesId(details);
    final filteredVideos = details.videos
        .where(
          (video) =>
              selectedSeriesId == null || video.seriesId == selectedSeriesId,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: YoungMuslimMediaBanner(
            title: details.category.titleAr,
            subtitle: details.category.description,
            imageUrl: details.category.bannerImage,
            accentStart: details.category.accentStart,
            accentEnd: details.category.accentEnd,
            height: 228,
            badges: [
              YoungMuslimMetricChip(
                label: details.category.audience == 'kids'
                    ? 'واجهة آمنة للأطفال'
                    : 'مشاهدة عامة',
                icon: Icons.child_care_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        RepaintBoundary(
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: youngMuslimPanelDecoration(context, useGradient: true),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 10.h,
              children: [
                YoungMuslimMetricChip(
                  label: '${details.series.length} سلسلة',
                  icon: Icons.video_library_rounded,
                  color: context.primaryColor,
                ),
                YoungMuslimMetricChip(
                  label: '${details.videos.length} حلقة',
                  icon: Icons.ondemand_video_rounded,
                  color: context.secondaryColor,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 22.h),
        const YoungMuslimSectionHeader(
          title: 'اختر السلسلة',
          subtitle: 'تنقّل بين السلاسل أو اللغات داخل هذا القسم',
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 10.h,
          children: [
            for (final series in details.series)
              ChoiceChip(
                label: Text(series.titleAr),
                selected: selectedSeriesId == series.id,
                onSelected: (_) {
                  setState(() => _selectedSeriesId = series.id);
                },
                selectedColor: youngMuslimAccentColor(
                  context,
                  series.accentStart,
                ).withValues(alpha: 0.18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: BorderSide(
                    color: selectedSeriesId == series.id
                        ? youngMuslimAccentColor(context, series.accentStart)
                        : context.outline.withValues(alpha: 0.3),
                  ),
                ),
                labelStyle: TextStyle(
                  fontSize: 12.sp,
                  color: selectedSeriesId == series.id
                      ? youngMuslimAccentColor(
                          context,
                          series.accentStart,
                        )
                      : context.onSurfaceVariant.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        SizedBox(height: 22.h),
        YoungMuslimSectionHeader(
          title: 'الحلقات',
          subtitle: '${filteredVideos.length} عنصر داخل السلسلة المختارة',
        ),
        SizedBox(height: 14.h),
        if (filteredVideos.isEmpty)
          const YoungMuslimEmptyState(
            title: 'لا توجد حلقات الآن',
            subtitle: 'غيّر السلسلة المختارة أو عد لاحقًا بعد تحديث الفلاتر.',
            icon: Icons.video_collection_outlined,
          )
        else
          RepaintBoundary(
            child: ListView.separated(
              itemCount: filteredVideos.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final video = filteredVideos[index];
                return YoungMuslimVideoCard(
                  video: video,
                  seriesTitle: _seriesTitle(details, video.seriesId),
                  fillWidth: true,
                  onTap: () => _openVideo(context, video.id),
                  onFavoriteToggle: () => context
                      .read<YoungMuslimBloc>()
                      .add(YoungMuslimFavoriteToggled(video.id)),
                  onWatchLaterToggle: () => context
                      .read<YoungMuslimBloc>()
                      .add(YoungMuslimWatchLaterToggled(video.id)),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingBody() {
    return const YoungMuslimLoadingPanel();
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: 'تعذر تحميل القسم',
      subtitle: message ?? 'حاول مرة أخرى بعد قليل.',
      icon: Icons.cloud_off_rounded,
    );
  }

  String? _resolveSelectedSeriesId(YoungMuslimCategoryDetailsEntity details) {
    if (_selectedSeriesId != null &&
        details.series.any((series) => series.id == _selectedSeriesId)) {
      return _selectedSeriesId;
    }
    return details.series.isNotEmpty ? details.series.first.id : null;
  }

  String _seriesTitle(YoungMuslimCategoryDetailsEntity details, String id) {
    for (final item in details.series) {
      if (item.id == id) {
        return item.titleAr;
      }
    }
    return '';
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
}
