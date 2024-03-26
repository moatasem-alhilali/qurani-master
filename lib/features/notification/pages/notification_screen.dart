import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/notification/widgets/rememper_athan.dart';
import 'package:quran_app/features/notification/widgets/tikr_every_day.dart';

class ManageNotificationScreen extends StatelessWidget {
  const ManageNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BaseHome(
      
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            //Tikr Every Day
            TikrEveryDay(),

            //Athan Tathkir
            AthanTathkir(),

          ],
        ),
      );
  }
}
