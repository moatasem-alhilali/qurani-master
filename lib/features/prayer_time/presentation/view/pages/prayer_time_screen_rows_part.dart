part of 'prayer_time_screen.dart';

/// صفّ داخل ورقة التفاصيل.
class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    this.value,
    this.child,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final Widget? child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          child ??
              Text(
                value ?? '',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
        ],
      ),
    );
  }
}

/// صفّ معلومة: أيقونة وعنوان ووصف، والوقت عند الحافة.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.time,
    this.isLast = false,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final DateTime time;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          _IconChip(icon: icon, skin: skin),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _ClockText(time: time, size: 12.5.sp, weight: FontWeight.w600),
        ],
      ),
    );
  }
}

/// وقت بصيغة ١٢ ساعة مع ص/م — الأرقام بخانات ثابتة واتجاه لاتيني.
class _ClockText extends StatelessWidget {
  const _ClockText({
    required this.time,
    required this.size,
    required this.weight,
  });

  final DateTime time;
  final double size;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            _formatClock(time),
            style: TextStyle(
              color: skin.ink.withValues(alpha: 0.88),
              fontSize: size,
              fontWeight: weight,
              height: 1.2,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          time.hour < 12 ? 'ص' : 'م',
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.8),
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

/// صفّ الموقع: ضغطة على الصفّ تفتح المنتقي، والزرّ الصغير يأخذ موقع الجهاز.
class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.selectedLocation,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
  });

  final PrayerLocationSelection? selectedLocation;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final label = selectedLocation?.label.trim();
    final details = selectedLocation?.detailsLabel.trim();
    final isManual = selectedLocation?.isManual ?? false;
    final sourceLabel = isManual ? 'اختيار يدوي' : 'موقع الجهاز';
    final subtitle = (details == null || details.isEmpty)
        ? (label == null || label.isEmpty
            ? 'اختر مدينة أو استخدم موقع الجهاز'
            : sourceLabel)
        : '$details · $sourceLabel';

    return InkWell(
      onTap: onChangeLocation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
        child: Row(
          children: [
            _IconChip(icon: AppIcons.mapPin, skin: skin),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (label == null || label.isEmpty)
                        ? 'لم يتم تحديد موقع بعد'
                        : label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            _MiniIconButton(
              icon: AppIcons.location,
              tooltip: 'موقعي الحالي',
              onTap: onUseCurrentLocation,
            ),
            SizedBox(width: 4.w),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

/// تنبيه الموقع: سطر واحد ثم روابط الإجراءات — بلا صندوق ملوّن.
class _LocationNoticeRow extends StatelessWidget {
  const _LocationNoticeRow({
    required this.message,
    required this.needsAction,
    required this.onGrantPermission,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final String message;
  final bool needsAction;
  final VoidCallback onGrantPermission;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconChip(icon: AppIcons.warning, skin: skin),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  spacing: 14.w,
                  runSpacing: 2.h,
                  children: [
                    if (needsAction)
                      _TextLink(
                        label: 'منح الصلاحية',
                        onTap: onGrantPermission,
                      ),
                    if (needsAction)
                      _TextLink(label: 'الإعدادات', onTap: onOpenSettings),
                    _TextLink(label: 'تحديث', onTap: onRetry),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWeekState extends StatelessWidget {
  const _EmptyWeekState({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 10.h),
      child: Column(
        children: [
          AppIcon(AppIcons.mapPin, color: skin.accent, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            'حدّد موقعك ليظهر جدول الأسبوع',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'ابحث عن مدينتك أو استخدم موقع الجهاز',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h),
          _TextLink(label: 'تحديد الموقع', onTap: onChangeLocation),
        ],
      ),
    );
  }
}
