// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:quran_app/core/extensions/theme_context_extension.dart';
// import 'package:quran_app/core/util/my_extensions.dart';
// import 'package:quran_app/core/widgets/read_quran/bookmark_page_icon_widget.dart';
// import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';

// class HeaderReadQuranVerticalWidget extends StatelessWidget {
//   const HeaderReadQuranVerticalWidget({
//     required this.index,
//     super.key,
//   });
//   final int index;
//   @override
//   Widget build(BuildContext context) {
//     final quranCtrl = context.read<OldReadQuranBloc>().quranRH;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               BookmarkIconWidget(
//                 height: context.customOrientation(35.h, 55.h) as double,
//                 pageNumber: index,
//               ),
//               const Gap(16),
//               Text(
//                 "الصفحة ${convertNumbers('${index + 1}')}",
//                 style: TextStyle(
//                   fontSize: context.customOrientation(
//                     18.0,
//                     22.0,
//                   ) as double,
//                   // fontFamily: 'naskh',
//                   color: context.primaryColor,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 quranCtrl.getSurahNameFromPage(index),
//                 style: TextStyle(
//                   fontSize: context.customOrientation(18.0, 22.0) as double,
//                   // fontWeight: FontWeight.bold,
//                   // fontFamily: 'naskh',
//                   color: context.primaryColor,
//                 ),
//               ),
//             ],
//           ),
//           Divider(
//             color: context.primaryColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
