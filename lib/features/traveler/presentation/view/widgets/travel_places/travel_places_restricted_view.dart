import 'package:flutter/material.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

class TravelPlacesRestrictedView extends StatelessWidget {
  const TravelPlacesRestrictedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TravelerNotice(
      icon: AppIcons.mosque,
      message: 'لا يظهر بحث المطاعم الحلال في الدول الإسلامية،\n'
          'لأن مطاعمها حلال أصلًا.',
    );
  }
}
