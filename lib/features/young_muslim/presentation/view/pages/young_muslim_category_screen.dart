import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_video_details_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';
import 'package:quran_app/l10n/l10n.dart';

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
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        showLargeHeader: false,
        initialOffset: null,
        titleWidget: BlocSelector<YoungMuslimBloc, YoungMuslimState, String>(
          selector: (state) {
            final details = state.categoryDetails;
            if (details != null && details.category.id == widget.categoryId) {
              return details.category.titleAr;
            }
            return context.l10n.youngMuslimTitle;
          },
          builder: (context, title) => Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ColoredBox(
          color: skin.ground,
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
                child = const YoungMuslimLoadingPanel();
              } else {
                child = _buildCategoryContent(context, details);
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(
                    '${state.categoryState.name}_'
                    '${details?.category.id ?? widget.categoryId}_'
                    '${_selectedSeriesId ?? ''}',
                  ),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(
    BuildContext context,
    YoungMuslimCategoryDetailsEntity details,
  ) {
    final skin = AppSkin.of(context);
    final selectedSeriesId = _resolveSelectedSeriesId(details);
    final filteredVideos = details.videos
        .where(
          (video) =>
              selectedSeriesId == null || video.seriesId == selectedSeriesId,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RepaintBoundary(
          child: YoungMuslimCover(
            imageUrl: details.category.bannerImage,
            title: details.category.titleAr,
            description: details.category.description,
            chips: [
              YoungMuslimMetricChip(
                label: details.category.audience == 'kids'
                    ? context.l10n.youngMuslimAudienceKidsSafe
                    : context.l10n.youngMuslimAudienceGeneral,
                icon: AppIcons.shield,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        YoungMuslimStatStrip(
          cells: [
            YoungMuslimStatCell(
              value: '${details.series.length}',
              label: context.l10n.youngMuslimStatSeries,
              icon: AppIcons.layers,
            ),
            YoungMuslimStatCell(
              value: '${details.videos.length}',
              label: context.l10n.youngMuslimStatEpisode,
              icon: AppIcons.play,
            ),
          ],
        ),
        skin.divider(),
        HomeSectionHeader(title: context.l10n.youngMuslimChooseSeries),
        Padding(
          padding: AppSkin.gutter,
          child: Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              for (final series in details.series)
                YoungMuslimPillButton(
                  label: series.titleAr,
                  selected: selectedSeriesId == series.id,
                  onTap: () => setState(() => _selectedSeriesId = series.id),
                ),
            ],
          ),
        ),
        skin.divider(),
        YoungMuslimSectionHeader(
          title: context.l10n.youngMuslimEpisodes,
          trailing: YoungMuslimMetricChip(
            label: context.l10n.youngMuslimEpisodesCount(filteredVideos.length),
          ),
        ),
        if (filteredVideos.isEmpty)
          YoungMuslimEmptyState(
            title: context.l10n.youngMuslimNoEpisodesTitle,
            subtitle: context.l10n.youngMuslimNoEpisodesSubtitle,
            icon: AppIcons.play,
          )
        else
          RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < filteredVideos.length; i++)
                  YoungMuslimVideoRow(
                    video: filteredVideos[i],
                    seriesTitle:
                        _seriesTitle(details, filteredVideos[i].seriesId),
                    isLast: i == filteredVideos.length - 1,
                    onTap: () => _openVideo(context, filteredVideos[i].id),
                    onFavoriteToggle: () => context
                        .read<YoungMuslimBloc>()
                        .add(YoungMuslimFavoriteToggled(filteredVideos[i].id)),
                    onWatchLaterToggle: () =>
                        context.read<YoungMuslimBloc>().add(
                              YoungMuslimWatchLaterToggled(
                                filteredVideos[i].id,
                              ),
                            ),
                  ),
              ],
            ),
          ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: context.l10n.youngMuslimCategoryLoadError,
      subtitle: message ?? context.l10n.youngMuslimTryAgainShortly,
      icon: AppIcons.warning,
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
        screenName: 'YoungMuslimVideoDetailsScreen',
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimVideoDetailsScreen(videoId: videoId),
        ),
      ),
    );
  }
}
