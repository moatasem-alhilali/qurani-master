part of 'prayer_time_settings_screen.dart';

class _IosAlternativeNote extends StatelessWidget {
  const _IosAlternativeNote();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrayerSettingsIconChip(icon: AppIcons.notifications),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'سيتم إرسال تنبيه عند كل صلاة قادمة لتذكيرك بتفعيل الصامت '
              'أو وضع التركيز من النظام.',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                isSaving ? 'جارِ الحفظ' : 'حفظ الإعدادات',
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
