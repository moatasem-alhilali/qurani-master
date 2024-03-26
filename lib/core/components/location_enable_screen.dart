import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/components/base_progress_button.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class LocationEnableScreen extends StatelessWidget {
  const LocationEnableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FxColors.third,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "قد لا تعمل بعض وظائف التطبيق بشكل صحيح لان موقعك الجغرافي غير مفعل لذلك لن نكون قادرين على معرفة اوقات الصلاة الصحيحه قم بتفعيل موقعك الجغرافي لكي نعرض اوقات الصلاه الصحيحه حسب موقعك الجغرافي",
              textAlign: TextAlign.center,
              style: titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: FxColors.primary,
              ),
            ),
          ),
          MyProgressButton(
            text: "تفعيل الان",
            defaultColor: FxColors.third,
            isBorderColor: true,
            onPressed: () async {
              await Geolocator.openLocationSettings();
              await ServicesLocation.isLocationEnabled();
            },
          ),
        ],
      ),
    ).animate().fade();
  }
}
