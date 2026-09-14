part of 'prayer_location_picker_sheet.dart';

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختيار المنطقة',
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Text(
                'ابحث أو حدّد نقطة من الخريطة',
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
        InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(999.r),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: AppIcon(AppIcons.close, color: skin.inkSoft, size: 16.sp),
          ),
        ),
      ],
    );
  }
}

/// الفعل الرئيسي في الورقة — الوحيد المعبّأ ذهبًا.
class _CurrentLocationButton extends StatelessWidget {
  const _CurrentLocationButton({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.gold.withValues(alpha: 0.5)
              : AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          height: 38.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox.square(
                  dimension: 13.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.brandIvory,
                    ),
                  ),
                )
              else
                const AppIcon(
                  AppIcons.location,
                  color: AppColors.brandIvory,
                  size: 15,
                ),
              SizedBox(width: 8.w),
              Text(
                isLoading
                    ? 'جارِ استخدام موقع الجهاز...'
                    : 'استخدام موقع الجهاز الحالي',
                style: TextStyle(
                  color: AppColors.brandIvory,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// تبويبان بخطّ سفلي واحد — بلا صندوق حولهما.
class _PickerTabs extends StatelessWidget {
  const _PickerTabs();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return TabBar(
      indicatorColor: skin.accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: skin.hairline,
      dividerHeight: 1,
      labelColor: skin.ink,
      labelStyle: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
      unselectedLabelColor: skin.inkSoft.withValues(alpha: 0.7),
      unselectedLabelStyle: TextStyle(
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        Tab(text: 'بحث'),
        Tab(text: 'الخريطة'),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: skin.hairline),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: skin.accent,
      style: TextStyle(
        color: skin.ink,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'اسم المدينة أو الدولة',
        hintStyle: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.6),
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppIcon(AppIcons.search, color: skin.accent, size: 15.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 32.w),
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        border: border,
        enabledBorder: border,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: skin.accent),
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            hasQuery ? AppIcons.searchOff : AppIcons.search,
            color: skin.accent,
            size: 22.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            hasQuery ? 'لم نعثر على نتائج مطابقة' : 'ابدأ بكتابة اسم المدينة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationResultRow extends StatelessWidget {
  const _LocationResultRow({
    required this.result,
    required this.isLast,
    required this.onTap,
  });

  final PrayerLocationSelection result;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
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
                child: AppIcon(
                  AppIcons.mapPin,
                  color: skin.accent,
                  size: 15.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (result.detailsLabel.isNotEmpty)
                    Text(
                      result.detailsLabel,
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
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

class _MapSelectionRow extends StatelessWidget {
  const _MapSelectionRow({
    required this.selected,
    required this.isApplying,
    required this.onApply,
  });

  final PrayerLocationSelection? selected;
  final bool isApplying;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final canApply = selected != null && !isApplying;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selected?.label ?? 'لم يتم تحديد موقع بعد',
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
                  (selected?.detailsLabel.isNotEmpty ?? false)
                      ? selected!.detailsLabel
                      : 'اضغط على الخريطة لاختيار المنطقة',
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
          SizedBox(width: 10.w),
          InkWell(
            onTap: canApply ? onApply : null,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isApplying)
                    SizedBox.square(
                      dimension: 13.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
                      ),
                    )
                  else
                    AppIcon(
                      AppIcons.checkSmall,
                      color: canApply
                          ? skin.accent
                          : skin.inkSoft.withValues(alpha: 0.45),
                      size: 15.sp,
                    ),
                  SizedBox(width: 5.w),
                  Text(
                    isApplying ? 'جارِ الاعتماد' : 'اعتماد',
                    style: TextStyle(
                      color: canApply || isApplying
                          ? skin.accent
                          : skin.inkSoft.withValues(alpha: 0.45),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
