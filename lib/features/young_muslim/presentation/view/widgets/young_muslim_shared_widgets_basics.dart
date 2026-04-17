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
    final isWhite = resolvedColor == Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.white.withValues(alpha: 0.18)
            : resolvedColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isWhite 
              ? Colors.white.withValues(alpha: 0.25)
              : resolvedColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: resolvedColor),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: resolvedColor,
                fontWeight: FontWeight.w800,
                fontSize: 11.sp,
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
      decoration: youngMuslimPanelDecoration(context, useGradient: true),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.primaryColor, size: 32.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: context.onSurfaceColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.onSurfaceVariant.withValues(alpha: 0.8),
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
