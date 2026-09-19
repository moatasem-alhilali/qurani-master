part of 'prayer_time_settings_screen.dart';

/// زرّ الحفظ: التعبئة الذهبية المسموح بها للفعل الرئيسي في الشاشة.
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaving, required this.onTap});

  final bool isSaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.gold.withValues(alpha: 0.5)
              : AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          height: 40.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSaving)
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
                  AppIcons.save,
                  color: AppColors.brandIvory,
                  size: 15,
                ),
              SizedBox(width: 8.w),
              Text(
                isSaving
                    ? context.l10n.prayerTimeSaving
                    : context.l10n.prayerTimeSaveSettings,
                style: TextStyle(
                  color: AppColors.brandIvory,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
