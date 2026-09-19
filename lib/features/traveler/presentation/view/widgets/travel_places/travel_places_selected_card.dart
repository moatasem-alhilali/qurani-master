import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';
import 'package:quran_app/l10n/l10n.dart';

/// المكان المختار — العنصر الوحيد المرتفع في شاشة الخريطة.
///
/// ما دام هو وحده يرتفع، فالعين تقع عليه أوّلًا بلا منافس: بقيّة الشاشة
/// خريطة وصفوف نحيلة.
class TravelPlacesSelectedCard extends StatelessWidget {
  const TravelPlacesSelectedCard({required this.selected, super.key});

  final TravelerPlace selected;

  Future<void> _openDirections(BuildContext context) async {
    final url = 'https://www.google.com/maps/dir/?api=1'
        '&destination=${selected.latitude},${selected.longitude}'
        '&travelmode=driving';
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
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.travelerOpenPhoneFailed)),
      );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!context.mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.travelerOpenLinkFailed)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasPhone = (selected.phone ?? '').trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 11.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
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
              color: skin.ink,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${selected.distanceLabel(context.l10n)} · '
            '${selected.walkingEtaLabel(context.l10n)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.accent,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          Text(
            selected.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              TravelerPillButton(
                label: context.l10n.travelerDirections,
                icon: AppIcons.direction,
                filled: true,
                onTap: () => _openDirections(context),
              ),
              TravelerPillButton(
                label: context.l10n.travelerGoogleMaps,
                icon: AppIcons.mapPin,
                onTap: () => _openPlace(context),
              ),
              if (hasPhone)
                TravelerPillButton(
                  label: context.l10n.travelerCall,
                  icon: AppIcons.phone,
                  onTap: () => _openPhone(context, selected.phone!),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
