import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// أفعال رأس شاشة أذكار السفر: إلغاء البحث، تبديل العرض، ثم البحث.
class TravelAthkarHeaderActions extends StatelessWidget {
  const TravelAthkarHeaderActions({
    required this.onJumpToFirstPage,
    super.key,
  });

  final VoidCallback onJumpToFirstPage;

  Future<List<TravelDhikrModel>> _searchSuggestions(
    BuildContext context,
    String query,
  ) async {
    final bloc = context.read<TravelAthkarBloc>();
    final allItems = bloc.state.allItems;
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return allItems.take(18).toList();
    }

    return allItems
        .where((item) => _matchesSearch(item, normalized))
        .take(30)
        .toList();
  }

  bool _matchesSearch(TravelDhikrModel item, String query) {
    return item.title.contains(query) ||
        item.text.contains(query) ||
        item.virtue.contains(query) ||
        item.trigger.contains(query);
  }

  void _applySearch(BuildContext context, String query) {
    context.read<TravelAthkarBloc>().add(SearchAthkarEvent(query));
    onJumpToFirstPage();
  }

  String _searchPreview(String text) {
    final value = text.replaceAll('\n', ' ').trim();
    if (value.length <= 80) return value;
    return '${value.substring(0, 80)}...';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
      buildWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery ||
          previous.displayMode != current.displayMode,
      builder: (context, state) {
        final hasQuery = state.searchQuery.isNotEmpty;
        final isPageMode = state.displayMode == AthkarDisplayMode.pageView;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasQuery)
              TravelerIconAction(
                icon: AppIcons.searchOff,
                tooltip: 'إلغاء البحث',
                onTap: () {
                  HapticFeedback.selectionClick();
                  _applySearch(context, '');
                },
              ),
            TravelerIconAction(
              icon: isPageMode ? AppIcons.list : AppIcons.layers,
              tooltip: isPageMode ? 'عرض كقائمة' : 'عرض كصفحات',
              active: true,
              onTap: () {
                HapticFeedback.selectionClick();
                final next = isPageMode
                    ? AthkarDisplayMode.listView
                    : AthkarDisplayMode.pageView;
                context
                    .read<TravelAthkarBloc>()
                    .add(UpdateDisplayModeEvent(next));
                if (next == AthkarDisplayMode.pageView) {
                  onJumpToFirstPage();
                }
              },
            ),
            GenericSearchAnchorAsync<TravelDhikrModel>(
              hintText: 'ابحث في الأذكار',
              asyncSuggestions: (query) => _searchSuggestions(context, query),
              onSelected: (item) => _applySearch(context, item.title),
              suggestionBuilder: (context, item) {
                return ListTile(
                  leading: AppIcon(
                    AppIcons.bookOpen,
                    color: skin.accent,
                    size: 17.sp,
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    _searchPreview(item.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
