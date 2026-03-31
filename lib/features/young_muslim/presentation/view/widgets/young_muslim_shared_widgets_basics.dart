part of 'young_muslim_shared_widgets.dart';

class YoungMuslimSectionHeader extends StatelessWidget {
  const YoungMuslimSectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class YoungMuslimMetricChip extends StatelessWidget {
  const YoungMuslimMetricChip({
    required this.label,
    required this.icon,
    this.color,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.primaryColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: resolvedColor == Colors.white
            ? Colors.white.withValues(alpha: 0.18)
            : resolvedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp, color: resolvedColor),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: resolvedColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class YoungMuslimEmptyState extends StatelessWidget {
  const YoungMuslimEmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: context.primaryContainer.withValues(alpha: 0.75),
            child: Icon(icon, color: context.primaryColor, size: 28.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.gray1,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class YoungMuslimLoadingPanel extends StatelessWidget {
  const YoungMuslimLoadingPanel({
    this.heightFactor = 0.42,
    super.key,
  });

  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      decoration: youngMuslimPanelDecoration(context),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
