part of '../pages/young_muslim_home_screen.dart';

class _YoungMuslimSearchSuggestion {
  const _YoungMuslimSearchSuggestion({
    required this.videoId,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.thumbnailUrl,
  });

  final String videoId;
  final String title;
  final String subtitle;
  final String duration;
  final String thumbnailUrl;

  @override
  String toString() => title;
}

/// نتيجة بحث واحدة: صفّ بسيط تفصله شعرة، لا بطاقة حوله.
class _YoungMuslimSearchSuggestionTile extends StatelessWidget {
  const _YoungMuslimSearchSuggestionTile({
    required this.item,
  });

  final _YoungMuslimSearchSuggestion item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          YoungMuslimThumb(
            imageUrl: item.thumbnailUrl,
            width: 56.w,
            height: 36.w,
            radius: 11.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowTitle(skin),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          YoungMuslimMetricChip(
            label: item.duration,
            icon: AppIcons.clock,
          ),
        ],
      ),
    );
  }
}
