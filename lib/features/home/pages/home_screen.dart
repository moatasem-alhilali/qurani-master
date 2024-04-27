import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/features/another_screen/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer_home.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/surah_audio_only.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemPrayerHome(),
        SurahAudioOnly(),
        BaseHeder(text: "المميزات"),
        AnotherFeatures(),
      ],
    );
  }
}


// class _ITem extends StatelessWidget {
//   const _ITem({required this.onTap, this.image, this.title});
//   final void Function()? onTap;
//   final String? image;
//   final String? title;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(4),
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey),
//         ),
//         // height: context.getHight(25),
//         // width: context.getWidth(25),
//         child: Image.asset('assets/image/1.jpeg'),
//       ),
//     );
//   }
// }