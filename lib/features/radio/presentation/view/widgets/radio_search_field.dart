import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// بحث فوري في المحطات.
///
/// أربع وعشرون محطة بلا بحث تعني مسحًا بصريًّا لكل صفّ. والنصّ في
/// [ValueNotifier] لا في الـ bloc: الكتابة تعيد بناء القائمة وحدها، لا
/// المؤشّر ولا الأغلفة المحمّلة فوقه.
class RadioSearchField extends StatefulWidget {
  const RadioSearchField({required this.query, super.key});

  final ValueNotifier<String> query;

  @override
  State<RadioSearchField> createState() => _RadioSearchFieldState();
}

class _RadioSearchFieldState extends State<RadioSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.query.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: skin.iconChip,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            AppIcon(
              AppIcons.search,
              color: skin.inkSoft.withValues(alpha: 0.6),
              size: 15.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) => widget.query.value = value,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11.h),
                  hintText: 'ابحث عن قارئ أو برنامج',
                  hintStyle: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.55),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: widget.query,
              builder: (context, value, _) {
                if (value.isEmpty) return const SizedBox.shrink();
                return InkWell(
                  onTap: () {
                    _controller.clear();
                    widget.query.value = '';
                    FocusScope.of(context).unfocus();
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
