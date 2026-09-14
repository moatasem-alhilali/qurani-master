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

  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isFocused = _focus.hasFocus;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          // الحقل على أرضية الصفحة نفسها، يحدّه شعرة.
          //
          // كان معبّأً بـ `iconChip` — وهو ذهب بشفافية معايَرة لمربّع أيقونة
          // صغير. ممدودًا على عرض الشاشة يصير لوحًا موحلًا فوق الأسود، وحافّته
          // ليست حدًّا مقصودًا بل طرف الشفافية. وفوق ذلك يزاحم الذهب المحجوز
          // لزرّ التشغيل والإبرة، فيضيع معنى اللون البارز.
          color: skin.ground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isFocused ? skin.accent.withValues(alpha: 0.55) : skin.hairline,
            width: isFocused ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            AppIcon(
              AppIcons.search,
              color:
                  isFocused ? skin.accent : skin.inkSoft.withValues(alpha: 0.6),
              size: 15.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                onChanged: (value) => widget.query.value = value,
                textInputAction: TextInputAction.search,
                cursorColor: skin.accent,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  // الثيم العام يضع `filled: true` بلون `darkSurface`
                  // (#222326) — رمادٌ بارد محايد خارج ألوان الهوية. بدونه
                  // يرسم الحقل مستطيله الرمادي داخل إطارنا، فيظهر لونان
                  // متداخلان في مكان واحد.
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
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
