import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// حقل بحث نحيل: مربّع الأيقونة نفسه ممدودًا، بلا إطار ولا ظلّ ولا ارتفاع.
class AudioSearchField extends StatefulWidget {
  const AudioSearchField({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<AudioSearchField> createState() => _AudioSearchFieldState();
}

class _AudioSearchFieldState extends State<AudioSearchField> {
  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasText = widget.controller.text.isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: skin.iconChip,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            AppIcon(AppIcons.search, color: skin.accent, size: 15.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: widget.controller,
                cursorColor: skin.accent,
                onChanged: (text) {
                  setState(() {});
                  widget.onChanged(text);
                },
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.62),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (hasText)
              InkWell(
                onTap: () {
                  widget.controller.clear();
                  setState(() {});
                  widget.onChanged('');
                },
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: AppIcon(
                    AppIcons.close,
                    color: skin.inkSoft.withValues(alpha: 0.7),
                    size: 13.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
