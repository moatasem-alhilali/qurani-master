import 'package:flutter/material.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';
import 'package:quran_app/l10n/l10n.dart';

class TravelPlacesRestrictedView extends StatelessWidget {
  const TravelPlacesRestrictedView({super.key});

  @override
  Widget build(BuildContext context) {
    return TravelerNotice(
      icon: AppIcons.mosque,
      message: context.l10n.travelerHalalRestricted,
    );
  }
}
