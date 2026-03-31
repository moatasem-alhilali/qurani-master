part of '../pages/young_muslim_home_screen.dart';

class _YoungMuslimSearchSuggestion {
  const _YoungMuslimSearchSuggestion({
    required this.videoId,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  final String videoId;
  final String title;
  final String subtitle;
  final String duration;

  @override
  String toString() => title;
}

class _YoungMuslimSearchSuggestionTile extends StatelessWidget {
  const _YoungMuslimSearchSuggestionTile({
    required this.item,
  });

  final _YoungMuslimSearchSuggestion item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: youngMuslimPanelDecoration(context, radius: 22),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: context.primaryContainer.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: context.primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          YoungMuslimMetricChip(
            label: item.duration,
            icon: Icons.schedule_rounded,
            color: context.primaryColor,
          ),
        ],
      ),
    );
  }
}
