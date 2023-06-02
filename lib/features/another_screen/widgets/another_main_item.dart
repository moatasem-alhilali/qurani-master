// import 'package:flutter/material.dart';
// import 'package:quran_app/core/jsons/hisn_almuslim.dart';
// import 'package:quran_app/core/services/clip_board_services.dart';
// import 'package:quran_app/core/shared/export/export-shared.dart';

// class AnotherMainItem extends StatelessWidget {
//   const AnotherMainItem({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: husinAlMuslim.length,
//       itemBuilder: (context, index) {
//         String keyHusin = "";
//         String valueHusin = "";
//         String footnoteHusin = "";
//         husinAlMuslim.forEach((key, value) {
//           keyHusin = key;
//           valueHusin = value['text'][0];
//           footnoteHusin = value['footnote'][0];
//         });
//         return Container(
//           padding: const EdgeInsets.all(12),
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Theme.of(context).primaryColor,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       keyHusin,
//                       style: titleMedium(context),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.share_sharp),
//                       ),
//                       IconButton(
//                         onPressed: () async {
//                           await ClipBoardServices.copyText(
//                             text: "$keyHusin : $valueHusin",
//                             message: "تم النسخ بنجاح",
//                           );
//                         },
//                         icon: const Icon(Icons.copy_outlined),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               //
//               Text(
//                 valueHusin,
//                 style: titleSmall(context),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 footnoteHusin,
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
