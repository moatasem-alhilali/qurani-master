part of 'qiblah_main_screen.dart';

/// صفّ قراءة واحد: أيقونة وعنوان وقيمة عند الحافة.
class _ReadingRow extends StatelessWidget {
  const _ReadingRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isNumeric = true,
    this.isLast = false,
  });

  final HugeIconData icon;
  final String label;
  final String value;
  final bool isNumeric;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final valueText = Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: skin.ink.withValues(alpha: 0.88),
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w600,
        fontFeatures: const [ui.FontFeature.tabularFigures()],
      ),
    );

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: skin.iconChip,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: AppIcon(icon, color: skin.accent, size: 15.sp),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: isNumeric
                ? Directionality(
                    textDirection: TextDirection.ltr,
                    child: valueText,
                  )
                : valueText,
          ),
        ],
      ),
    );
  }
}

/// حالة رسالة واحدة: تحميل أو خطأ — بلا بطاقة ولا زرّ ضخم.
class _QiblahMessage extends StatelessWidget {
  const _QiblahMessage({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final HugeIconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32.w, 60.h, 32.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, color: skin.accent, size: 26.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 8.h),
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(999.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
