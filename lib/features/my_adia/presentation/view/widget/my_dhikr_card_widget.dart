import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// دورة التسبيح الواحدة. عندها يهتزّ الجهاز اهتزازة أوضح ويبدأ العدّاد
/// من جديد بصريًّا، فيُحسّ المستخدم أنه أتمّ شيئًا لا أنّ رقمًا زاد.
const int kDhikrRound = 33;

enum _RowMenuAction { edit, reset, delete }

/// صفّ دعاء واحد في «أدعيتي».
///
/// لمس الصفّ كلّه يزيد العدّاد: الذهب يرتفع داخل المربّع، والرقم ينبض،
/// ويهتزّ الجهاز اهتزازة خفيفة عند كل لمسة وأوضح عند إتمام الدورة.
class MyDhikrCardWidget extends StatelessWidget {
  const MyDhikrCardWidget({
    required this.subih,
    required this.count,
    required this.onTap,
    required this.onReset,
    super.key,
    this.isLast = false,
    this.onEdit,
    this.onDelete,
  });

  final SubihModel subih;
  final int count;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  void _handleMenuAction(_RowMenuAction action) {
    switch (action) {
      case _RowMenuAction.edit:
        onEdit?.call();
      case _RowMenuAction.reset:
        onReset();
      case _RowMenuAction.delete:
        onDelete?.call();
    }
  }

  void _handleTap() {
    // الاهتزاز قبل انتظار الحالة: التفاعل يجب أن يسبق الرقم لا أن يتأخّر
    // عنه، وإلا شعر المستخدم بأن اللمسة ضاعت.
    if ((count + 1) % kDhikrRound == 0) {
      unawaited(HapticFeedback.mediumImpact());
    } else {
      unawaited(HapticFeedback.selectionClick());
    }
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final canEdit = onEdit != null;
    final canDelete = onDelete != null;
    final content = subih.content.trim();

    return InkWell(
      onTap: _handleTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            DhikrCounterBadge(count: count),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subih.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: FontFamily.scheherazade,
                      color: skin.ink,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.85,
                    ),
                  ),
                  if (content.isNotEmpty)
                    Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<_RowMenuAction>(
              tooltip: 'خيارات الدعاء',
              onSelected: _handleMenuAction,
              color: skin.raised,
              itemBuilder: (context) => [
                if (canEdit)
                  const PopupMenuItem<_RowMenuAction>(
                    value: _RowMenuAction.edit,
                    child: _MenuItemLabel(
                      icon: AppIcons.edit,
                      label: 'تعديل',
                    ),
                  ),
                const PopupMenuItem<_RowMenuAction>(
                  value: _RowMenuAction.reset,
                  child: _MenuItemLabel(
                    icon: AppIcons.refresh,
                    label: 'تصفير عداد اليوم',
                  ),
                ),
                if (canDelete)
                  const PopupMenuItem<_RowMenuAction>(
                    value: _RowMenuAction.delete,
                    child: _MenuItemLabel(
                      icon: AppIcons.delete,
                      label: 'حذف',
                    ),
                  ),
              ],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: AppIcon(
                  AppIcons.more,
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  size: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// مربّع العدّاد: الذهب يرتفع فيه مع كل تسبيحة حتى تكتمل الدورة.
class DhikrCounterBadge extends StatefulWidget {
  const DhikrCounterBadge({required this.count, super.key});

  final int count;

  @override
  State<DhikrCounterBadge> createState() => _DhikrCounterBadgeState();
}

class _DhikrCounterBadgeState extends State<DhikrCounterBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: 1,
  );

  late double _from = _fractionOf(widget.count);
  late double _to = _fractionOf(widget.count);

  double _fractionOf(int count) {
    if (count <= 0) return 0;
    final inRound = count % kDhikrRound;
    // آخر تسبيحة في الدورة تملأ المربّع كاملًا قبل أن يعود فارغًا.
    return inRound == 0 ? 1 : inRound / kDhikrRound;
  }

  @override
  void didUpdateWidget(covariant DhikrCounterBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count == oldWidget.count) return;

    final next = _fractionOf(widget.count);
    final previous = _fractionOf(oldWidget.count);
    setState(() {
      // بدء دورة جديدة: نبدأ من القاع بدل أن ينزل الذهب إلى الخلف.
      _from = next < previous && previous >= 0.99 ? 0 : previous;
      _to = next;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final eased = Curves.easeOutCubic.transform(_controller.value);
        final fill = _from + (_to - _from) * eased;
        final textColor = Color.lerp(skin.accent, AppColors.brandIvory, fill)!;
        // نبضة حجم خفيفة مع كل زيادة: اللمسة تُحسّ لا تُرى فقط.
        final pop = 1 + 0.07 * (1 - (2 * _controller.value - 1).abs());

        return Transform.scale(
          scale: _controller.isAnimating ? pop : 1.0,
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: skin.iconChip,
              borderRadius: radius,
              border: Border.all(
                color: Color.lerp(
                  AppColors.gold.withValues(alpha: 0.42),
                  AppColors.gold,
                  fill,
                )!,
              ),
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: fill.clamp(0.0, 1.0),
                      child: const ColoredBox(color: AppColors.gold),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${widget.count}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [
                          ui.FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuItemLabel extends StatelessWidget {
  const _MenuItemLabel({required this.icon, required this.label});

  final HugeIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      children: [
        AppIcon(icon, color: skin.accent, size: 14.sp),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: skin.ink,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
