import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/l10n/l10n.dart';

/// اللبنات المشتركة لشاشات المكتبة: صفوف نحيلة ومربّعات أيقونات،
/// بلا بطاقات ولا ألوان حرفية.

/// مربّع ميزة: أيقونة صغيرة واسم تحتها — بديل البطاقة في الشبكات.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: AppIcon(icon, color: skin.accent, size: 16.sp),
              ),
            ),
            SizedBox(height: 6.h),
            // ارتفاع ثابت لسطرين حتى تتساوى مربّعات الصفّ الواحد.
            SizedBox(
              height: 26.h,
              child: AutoSizeText(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                minFontSize: 7,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink.withValues(alpha: 0.9),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شبكة مربّعات بأربعة أعمدة والفجوة المعتمدة في الدليل.
class CategoryTileGrid extends StatelessWidget {
  const CategoryTileGrid({required this.tiles, super.key});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var start = 0; start < tiles.length; start += 4) {
      final end = (start + 4) > tiles.length ? tiles.length : start + 4;
      final slice = tiles.sublist(start, end);

      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: start + 4 < tiles.length ? 6.h : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i != 0) SizedBox(width: 6.w),
                Expanded(
                  child: i < slice.length ? slice[i] : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: AppSkin.gutter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }
}

/// صفّ قائمة نحيل: مربّع أيقونة، ثم عنوان ووصف، ثم سهم.
class CategoryRow extends StatelessWidget {
  const CategoryRow({
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.icon,
    this.leadingLabel,
    this.isLast = false,
  });

  final String title;
  final String? subtitle;
  final HugeIconData? icon;
  final String? leadingLabel;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasSubtitle = (subtitle ?? '').trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                child: leadingLabel != null
                    ? Text(
                        leadingLabel!,
                        maxLines: 1,
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : AppIcon(
                        icon ?? AppIcons.list,
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
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (hasSubtitle)
                    Text(
                      subtitle!,
                      maxLines: 2,
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
            SizedBox(width: 6.w),
            AppIcon(
              Directionality.of(context) == TextDirection.rtl
                  ? AppIcons.chevronLeft
                  : AppIcons.chevronRight,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// حقل بحث بلغة الشاشة: حدّ شعرة وأيقونة صغيرة، بلا تعبئة غريبة.
class CategorySearchField extends StatelessWidget {
  const CategorySearchField({
    required this.controller,
    required this.onChanged,
    super.key,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// نصّ التلميح؛ الافتراضي «بحث» بلغة الواجهة.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: skin.accent,
        style: TextStyle(
          color: skin.ink,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: skin.raised,
          hintText: hintText ?? context.l10n.commonSearch,
          hintStyle: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.w),
            child: AppIcon(AppIcons.search, color: skin.accent, size: 15.sp),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 34.w),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: context.l10n.categoriesClearSearch,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: AppIcon(
                    AppIcons.close,
                    color: skin.inkSoft.withValues(alpha: 0.7),
                    size: 14.sp,
                  ),
                ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: skin.hairline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: skin.raisedBorder),
          ),
        ),
      ),
    );
  }
}

/// انتظار هادئ بخطّ رفيع بدل دائرة تدور في وسط الصفحة.
class CategoryThinLoader extends StatelessWidget {
  const CategoryThinLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: LinearProgressIndicator(
          minHeight: 3.h,
          backgroundColor: skin.hairline,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      ),
    );
  }
}

/// رسالة حالة نحيلة.
class CategoryNotice extends StatelessWidget {
  const CategoryNotice({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Text(
        message,
        style: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.78),
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}

/// زرّ صغير بتعبئة ذهبية — للفعل الوحيد المميّز في الصفّ.
class CategoryActionButton extends StatelessWidget {
  const CategoryActionButton({
    required this.label,
    required this.onTap,
    super.key,
    this.icon,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback onTap;
  final HugeIconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.gold : skin.raised,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isPrimary ? AppColors.gold : skin.hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(
                icon!,
                color: isPrimary ? AppColors.brandIvory : skin.accent,
                size: 14.sp,
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPrimary ? AppColors.brandIvory : skin.ink,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
