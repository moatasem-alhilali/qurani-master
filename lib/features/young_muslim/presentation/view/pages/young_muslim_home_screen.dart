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

part 'young_muslim_home_screen_content.dart';
part '../widgets/young_muslim_home_screen_search.dart';

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
              SizedBox(width: 10.w),
              GenericSearchAnchorAsync<_YoungMuslimSearchSuggestion>(
                hintText: 'ابحث عن قصة...',
                asyncSuggestions: (query) async {
                  final trimmed = query.trim();
                  if (trimmed.isEmpty) return const [];
                  final repository = context.read<YoungMuslimRepository>();
                  final dashboard = await repository.getDashboard(
                    query: trimmed,
                    filters: state.filters,
                  );
                  return dashboard.searchResults
                      .take(10)
                      .map((video) => _YoungMuslimSearchSuggestion(
                            videoId: video.id,
                            title: video.title,
                            subtitle: _searchSuggestionSubtitle(dashboard, video),
                            duration: youngMuslimDuration(video.durationSeconds),
                          ))
                      .toList();
                },
                onSelected: (item) => _openVideo(context, item.videoId),
                suggestionBuilder: (context, item) => _YoungMuslimSearchSuggestionTile(item: item),
              ),
            ],
          );
        },
      ),
      onRefresh: () async {
        context.read<YoungMuslimBloc>().add(const YoungMuslimRefreshed());
      },
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
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
                      '${state.loadState.name}_'
                      '${dashboard?.categories.length ?? 0}_'
                      '${state.query}_${state.filters.hashCode}',
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
}
