import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';

/// صفّ مكان قريب: سهم الاتجاه، ثم الاسم، ثم المسافة وزمن المشي.
///
/// السهم ليس زينة. «٣٢٠ م» وحدها لا تكفي لمن يمشي — في أي جهة؟ وكان الجواب
/// يتطلّب فتح الخريطة وتمييز دبّوس من بين دبابيس متشابهة.
class TravelPlacesRow extends StatelessWidget {
  const TravelPlacesRow({
    required this.place,
    required this.bearingDegrees,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final TravelerPlace place;

  /// من الشمال باتجاه عقارب الساعة.
  final double bearingDegrees;

  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: showDivider
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              )
            : null,
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: CustomPaint(
                painter: _BearingArrowPainter(
                  degrees: bearingDegrees,
                  color: isSelected ? skin.accent : skin.inkSoft,
                  ring: skin.hairline,
                  isSelected: isSelected,
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
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? skin.accent : skin.ink,
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  if (place.address.trim().isNotEmpty)
                    Text(
                      place.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.62),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place.distanceLabel,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  place.walkingEtaLabel,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.6),
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
            if (place.phone != null && place.phone!.trim().isNotEmpty) ...[
              SizedBox(width: 6.w),
              AppIcon(
                AppIcons.phone,
                color: skin.inkSoft.withValues(alpha: 0.45),
                size: 12.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// سهم داخل حلقة، يشير إلى جهة المكان.
///
/// الشمال أعلى الحلقة دائمًا — بوصلة ثابتة لا تدور مع الجهاز. الدوران مع
/// المغناطيس يحتاج حسّاسًا يعمل، والقراءة وأنت تمشي تصير مهتزّة؛ والجهة
/// الثابتة تكفي لتعرف «خلفي» من «أمامي» على الخريطة الذهنية.
class _BearingArrowPainter extends CustomPainter {
  const _BearingArrowPainter({
    required this.degrees,
    required this.color,
    required this.ring,
    required this.isSelected,
  });

  final double degrees;
  final Color color;
  final Color ring;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    canvas.drawCircle(
      center,
      radius - 0.8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 1.6 : 1
        ..color = isSelected ? color.withValues(alpha: 0.7) : ring,
    );

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      // صفر درجة شمالًا، والرسم يبدأ من محور السين، فنطرح ربع دورة.
      ..rotate(degrees * math.pi / 180);

    final tip = radius * 0.58;
    final wing = radius * 0.34;
    final arrow = Path()
      ..moveTo(0, -tip)
      ..lineTo(wing, tip * 0.62)
      ..lineTo(0, tip * 0.24)
      ..lineTo(-wing, tip * 0.62)
      ..close();

    canvas
      ..drawPath(arrow, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _BearingArrowPainter oldDelegate) =>
      oldDelegate.degrees != degrees ||
      oldDelegate.color != color ||
      oldDelegate.ring != ring ||
      oldDelegate.isSelected != isSelected;
}
