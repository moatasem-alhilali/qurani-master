import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/services/services_notification.dart';
import 'package:quran_app/core/services/tasks_notification.dart';

import 'package:quran_app/features/home_screen/widgets/surah_audio.dart';
import 'package:quran_app/features/home_screen/widgets/custom_featuers.dart';
import 'package:quran_app/features/home_screen/widgets/next_player.dart';
import 'package:quran_app/features/home_screen/widgets/thikr_slider.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/home_screen/widgets/reader_slider.dart';

import '../../notification/pages/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      customAppBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "طمأنينة",
                    style: titleMedium(context),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                navigateTo(const ManageNotificationScreen(), context);
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: const [
          //next player
          NextPlayer(),

          //
          ReaderSlider(),

          //surah audio
          SurahAudio(),

          //another feather
          CustomFeatures(),
          //random ayah
          ThikrSlider(),
        ],
      ),
    );
  }
}
