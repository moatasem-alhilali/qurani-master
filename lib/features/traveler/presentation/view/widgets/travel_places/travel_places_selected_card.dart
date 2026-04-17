import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';

class TravelPlacesSelectedCard extends StatelessWidget {
  const TravelPlacesSelectedCard({
    required this.selected,
    super.key,
  });

  final TravelerPlace selected;

  Future<void> _openDirections(BuildContext context) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${selected.latitude},${selected.longitude}&travelmode=driving';
    await _openUrl(context, url);
  }

  Future<void> _openPlace(BuildContext context) async {
    final query = Uri.encodeComponent(
      '${selected.name} ${selected.latitude},${selected.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    await _openUrl(context, url);
  }

  Future<void> _openPhone(BuildContext context, String phoneNumber) async {
    final launched = await UrlLauncherUtils.launchPhone(phoneNumber);
    if (!context.mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('تعذر فتح تطبيق الاتصال.')));
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!context.mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط.')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selected.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '${selected.distanceLabel} • ${selected.walkingEtaLabel}',
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            selected.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor.withValues(alpha: 0.65),
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              FilledButton(
                onPressed: () => _openDirections(context),
                child: const Text('الاتجاه'),
              ),
              OutlinedButton(
                onPressed: () => _openPlace(context),
                child: const Text('Google Maps'),
              ),
              if ((selected.phone ?? '').trim().isNotEmpty)
                OutlinedButton(
                  onPressed: () => _openPhone(context, selected.phone!),
                  child: const Text('اتصال'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
