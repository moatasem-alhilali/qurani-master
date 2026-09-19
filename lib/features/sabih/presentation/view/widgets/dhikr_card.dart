import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/animated_tasbih_widget.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_counter.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/l10n/l10n.dart';

/// صفحة ذكر واحد داخل المسبحة.
///
/// لا بطاقة حول الذكر: النصّ يجلس على أرضية الصفحة، والعدّاد وحده هو
/// العنصر المرتفع — فهو ما يلمسه المستخدم مئات المرّات.
class DhikrCardWidget extends StatelessWidget {
  const DhikrCardWidget({
    required this.subih,
    required this.count,
    required this.onTap,
    required this.onReset,
    super.key,
    this.onEdit,
    this.onDelete,
    this.useAnimatedTasbih = false,
  });

  final SubihModel subih;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// مسبحة الحبّات التقليدية بدل حلقة التقدّم — تبقى متاحة لمن يفضّلها.
  final bool useAnimatedTasbih;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final content = subih.displayContent(context.l10n);
    final hasContent = content.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 0),
            child: Column(
              children: [
                Text(
                  subih.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: skin.ink,
                    fontFamily: FontFamily.scheherazade,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.85,
                  ),
                ),
                if (hasContent) ...[
                  SizedBox(height: 2.h),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 14.h),
          if (useAnimatedTasbih)
            SizedBox(
              height: 200.h,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: AnimatedTasbihWidget(
                  onCountChanged: (_) => onTap(),
                  primaryColor: AppColors.gold,
                  secondaryColor: skin.accent,
                ),
              ),
            )
          else
            TasbeehCounter(count: count, onTap: onTap),
          SizedBox(height: 14.h),
          skin.divider(),
          _ActionRow(
            icon: AppIcons.refresh,
            label: context.l10n.sabihResetTodayCounter,
            onTap: onReset,
          ),
          if (onEdit != null) ...[
            skin.divider(),
            _ActionRow(
              icon: AppIcons.edit,
              label: context.l10n.sabihEditThisDhikr,
              onTap: onEdit!,
            ),
          ],
          if (onDelete != null) ...[
            skin.divider(),
            _ActionRow(
              icon: AppIcons.delete,
              label: context.l10n.sabihDeleteThisDhikr,
              onTap: onDelete!,
              isDestructive: true,
            ),
          ],
        ],
      ),
    );
  }
}

/// صفّ فعل نحيل: مربّع أيقونة ثم عنوان، بلا بطاقة ولا ظل.
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color = isDestructive ? AppColors.error : skin.accent;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.10)
                    : skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: AppIcon(icon, color: color, size: 15.sp)),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDestructive ? color : skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            AppIcon(AppIcons.chevronLeft, color: color, size: 15.sp),
          ],
        ),
      ),
    );
  }
}
