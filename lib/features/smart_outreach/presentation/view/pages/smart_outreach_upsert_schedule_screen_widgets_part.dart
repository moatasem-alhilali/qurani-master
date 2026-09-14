part of 'smart_outreach_upsert_schedule_screen.dart';

/// حقل الاسم: سطر واحد فوق خطّ شعرة، لا صندوق ممتلئ حوله.
class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: const OutreachIconChip(icon: AppIcons.noteEdit),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              cursorColor: skin.accent,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                filled: false,
                isDense: true,
                hintText: 'مثال: تذكير الفجر',
                hintStyle: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                errorStyle: TextStyle(
                  color: AppColors.error,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.accent),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'اكتب اسمًا للقائمة';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// رقم واحد في القائمة: الاسم فوق والرقم تحته بترتيب لاتيني.
class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.name,
    required this.phone,
    required this.onRemove,
  });

  final String name;
  final String phone;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          const OutreachIconChip(icon: AppIcons.user),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
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
          OutreachTextAction(
            label: 'حذف',
            icon: AppIcons.delete,
            danger: true,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}

class _EditablePhoneRow {
  _EditablePhoneRow({
    required this.labelController,
    required this.phoneController,
    this.id,
  });

  final int? id;
  final TextEditingController labelController;
  final TextEditingController phoneController;

  void dispose() {
    labelController.dispose();
    phoneController.dispose();
  }
}

enum _ScheduleTimeOption {
  manual,
  fajr,
}
