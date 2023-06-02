// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:quran_app/core/shared/export/export-shared.dart';
// import 'package:quran_app/core/shared/resources/size_config.dart';
// import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';
// import 'package:quran_app/features/qiblah/qiblah_main.dart';
// import 'package:quran_app/features/quran_audio/presentation/pages/audio_home.dart';
// import 'package:quran_app/features/quran_reader_and_listen/pages/quran_reader_home.dart';
// import 'package:quran_app/features/sabih/pages/sabih_screen.dart';
// import 'package:quran_app/features/thikr/pages/thikr_mornning.dart';
// import 'package:quran_app/features/thikr/pages/thikr_night.dart';

// import '../../../core/shared/resources/assets_manager.dart';
// import '../../quran_audio/presentation/pages/download_page.dart';

// class Featuers extends StatelessWidget {
//   const Featuers({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             _Item(
//               onPressed: () {
//                 navigateTo(const TikrMorning(), context);
//               },
//               svg: AssetsManager.duas,
//               text: "أذكار الصباح",
//             ),
//             _Item(
//               svgSize: SizeConfig.blockSizeVertical! * 6,
//               onPressed: () {
//                 navigateTo(QiblahMain(), context);
//               },
//               svg: AssetsManager.kiblat,
//               text: "القبلة",
//             ),
//             _Item(
//               svgSize: SizeConfig.blockSizeVertical! * 6,
//               onPressed: () {
//                 navigateTo(PrayerTimeScreen(), context);
//               },
//               svg: AssetsManager.prayer_time,
//               text: "أوقات الصلاة",
//             ),
//           ],
//         ),

//         //
//         Row(
//           children: [
//             _Item(
//               onPressed: () {
//                 navigateTo(const TikrNight(), context);
//               },
//               svg: AssetsManager.duas,
//               text: "أذكار المساء",
//             ),
//             _Item(
//               onPressed: () {
//                 navigateTo(const SabihScreen(), context);
//               },
//               svg: AssetsManager.tasbih,
//               text: "التسبيح",
//             ),
//             _Item(
//               svgSize: SizeConfig.blockSizeVertical! * 5,
//               onPressed: () {},
//               svg: AssetsManager.allah,
//               text: "أسماء الله ",
//             ),
//           ],
//         ),

//         //
//         Row(
//           children: [
//             _Item(
//               onPressed: () {
//                 navigateTo(const AudioHome(), context);
//               },
//               svg: AssetsManager.quran,
//               text: "السماع",
//             ),
//             _Item(
//               onPressed: () {
//                 navigateTo(const DownloadPage(), context);
//               },
//               svg: AssetsManager.quran,
//               text: "التنزيلات",
//             ),
//             _Item(
//               onPressed: () {
//                 navigateTo(const QuranReaderHome(), context);
//               },
//               svg: AssetsManager.quran,
//               text: "السماع والقرأة",
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// class _Item extends StatelessWidget {
//   _Item({
//     super.key,
//     required this.onPressed,
//     required this.svg,
//     this.svgSize,
//     required this.text,
//   });

//   final String text;
//   final String svg;
//   double? svgSize;
//   final void Function() onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextButton(
//           style: TextButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             backgroundColor: ColorsManager.main,
//           ),
//           onPressed: onPressed,
//           child: Column(
//             children: [
//               SvgPicture.asset(svg, height: svgSize),
//               Text(
//                 text,
//                 style: titleSmall(context),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
