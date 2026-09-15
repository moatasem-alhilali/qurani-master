import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// ألوان الويدجت كما تُرسم على الشاشة الرئيسية فعلًا.
///
/// ثابتة عمدًا ولا تتبع ثيم التطبيق: الويدجت يجلس على خلفية المستخدم لا على
/// أرضية التطبيق، فألوانه محدّدة في `widget_surface_background.xml` وحده.
/// معاينةٌ تتبدّل مع الثيم كانت ستكذب على المستخدم.
abstract final class WidgetCanvas {
  static const surface = Color(0xFF20190F);
  static const surfaceTop = Color(0xFF2B2114);
  static const surfaceBottom = Color(0xFF15110B);
  static const border = Color(0xFFC9A46A);
  static const ink = Color(0xFFFFF7E1);
  static const muted = Color(0xFFD4B873);
  static const faint = Color(0xFF9C8149);
  static const chip = Color(0xFF2E2415);
}

/// حجم الويدجت بخانات الشبكة — وهو ما يراه المستخدم في مُشغّل الشاشة.
enum WidgetFootprint {
  wide1('4 × 1', 4, 1),
  wide2('4 × 2', 4, 2),
  small1('3 × 1', 3, 1),
  small2('3 × 2', 3, 2),
  tiny('2 × 1', 2, 1);

  const WidgetFootprint(this.label, this.columns, this.rows);

  final String label;
  final int columns;
  final int rows;

  /// ارتفاع المعاينة. خانة الشبكة أعرض منها ارتفاعًا، والنسبة هنا تقريب
  /// كافٍ ليُحسّ الفرق بين صفّ وصفّين.
  double get previewHeight => rows == 1 ? 74.h : 118.h;
}

/// بطاقة معاينة: الويدجت كما سيظهر، وتحته اسمه وحجمه وزرّ إضافته.
///
/// الشاشة كانت قائمة صفوف نصّية بأيقونة ووصف — ولا أحد يعرف من «ذكر عشوائي»
/// كيف سيبدو على شاشته ولا كم مساحة سيأخذ. فيضيف ثم يحذف ثم يجرّب غيره.
/// المعاينة تحسم الأمر قبل الإضافة.
class WidgetPreviewCard extends StatelessWidget {
  const WidgetPreviewCard({
    required this.title,
    required this.description,
    required this.footprint,
    required this.preview,
    required this.onAdd,
    required this.canAdd,
    this.badge,
    super.key,
  });

  final String title;
  final String description;
  final WidgetFootprint footprint;

  /// محتوى الويدجت مرسومًا بنفس ترتيب تخطيط الأندرويد.
  final Widget preview;

  final VoidCallback onAdd;
  final bool canAdd;

  /// وسمٌ صغير لما يستحقّ الانتباه — «تفاعلي» مثلًا.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // المعاينة داخل إطار الويدجت الحقيقي: تدرّج وحدّ ذهبي وزوايا ١٨.
          Container(
            width: double.infinity,
            height: footprint.previewHeight,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: WidgetCanvas.border),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  WidgetCanvas.surfaceTop,
                  WidgetCanvas.surface,
                  WidgetCanvas.surfaceBottom,
                ],
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: preview,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        _SizeTag(label: footprint.label),
                        if (badge != null) ...[
                          SizedBox(width: 5.w),
                          _SizeTag(label: badge!, highlighted: true),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              _AddButton(onTap: onAdd, enabled: canAdd),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeTag extends StatelessWidget {
  const _SizeTag({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: highlighted
            ? WidgetCanvas.border.withValues(alpha: 0.18)
            : onSurface.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlighted
              ? WidgetCanvas.border
              : onSurface.withValues(alpha: 0.55),
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap, required this.enabled});

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      button: true,
      label: 'إضافة إلى الشاشة الرئيسية',
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: enabled
                ? WidgetCanvas.border.withValues(alpha: 0.16)
                : onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                AppIcons.add,
                color: enabled
                    ? WidgetCanvas.border
                    : onSurface.withValues(alpha: 0.35),
                size: 13.sp,
              ),
              SizedBox(width: 5.w),
              Text(
                'إضافة',
                style: TextStyle(
                  color: enabled
                      ? WidgetCanvas.border
                      : onSurface.withValues(alpha: 0.35),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
