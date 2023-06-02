import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/theme/themeData.dart';

import '../widgets/audio_downloaded.dart';

class OfflineAudioScreen extends StatelessWidget {
  const OfflineAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHome(
          customAppBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  "الأصوات المحملة",
                  style: titleMedium(context),
                ),
              ],
            ),
          ),
          body: Column(
            children: const [
              AudioOffline(),
            ],
          ),
        );
  }
}
