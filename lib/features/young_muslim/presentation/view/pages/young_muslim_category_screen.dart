import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
      body: BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
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
          if (!hasCurrentDetails && state.categoryState == RequestState.error) {
            child = YoungMuslimEmptyState(
              title: 'تعذر تحميل القسم',
              subtitle: state.errorMessage ?? 'حاول مرة أخرى بعد قليل.',
              icon: Icons.cloud_off_rounded,
            );
          } else if (!hasCurrentDetails) {
            child = const SizedBox(
              height: 420,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            _selectedSeriesId ??=
                details.series.isNotEmpty ? details.series.first.id : null;
            final filteredVideos = details.videos
                .where(
                  (video) =>
                      _selectedSeriesId == null ||
                      video.seriesId == _selectedSeriesId,
                )
                .toList();

            child = Padding(
              padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 28.h),
              child: Column(
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
                      padding: EdgeInsets.all(16.w),
                      decoration: youngMuslimPanelDecoration(context),
                      child: Wrap(
                        spacing: 10.w,
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
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      for (final series in details.series)
                        ChoiceChip(
                          label: Text(series.titleAr),
                          selected: _selectedSeriesId == series.id,
                          onSelected: (_) {
                            setState(() => _selectedSeriesId = series.id);
                          },
                          selectedColor: youngMuslimAccentColor(
                            context,
                            series.accentStart,
                          ).withValues(alpha: 0.18),
                          labelStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: _selectedSeriesId == series.id
                                        ? youngMuslimAccentColor(
                                            context,
                                            series.accentStart,
                                          )
                                        : context.gray1,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  YoungMuslimSectionHeader(
                    title: 'الحلقات',
                    subtitle:
                        '${filteredVideos.length} عنصر داخل السلسلة المختارة',
                  ),
                  SizedBox(height: 14.h),
                  if (filteredVideos.isEmpty)
                    const YoungMuslimEmptyState(
                      title: 'لا توجد حلقات الآن',
                      subtitle:
                          'غيّر السلسلة المختارة أو عد لاحقًا بعد تحديث الفلاتر.',
                      icon: Icons.video_collection_outlined,
                    )
                  else
                    RepaintBoundary(
                      child: MasonryGridView.count(
                        crossAxisCount: _videoCrossAxisCount(context),
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 12.w,
                        itemCount: filteredVideos.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final video = filteredVideos[index];
                          return YoungMuslimVideoCard(
                            video: video,
                            seriesTitle: _seriesTitle(details, video.seriesId),
                            compact: true,
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
              ),
            );
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
    );
  }

  String _seriesTitle(YoungMuslimCategoryDetailsEntity details, String id) {
    for (final item in details.series) {
      if (item.id == id) {
        return item.titleAr;
      }
    }
    return '';
  }

  int _videoCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) {
      return 4;
    }
    if (width >= 820) {
      return 3;
    }
    return 2;
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
