import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/theme/themeData.dart';

// class MyAlertDialog extends StatelessWidget {
//   const MyAlertDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       elevation: 0,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//       ),
//       backgroundColor: Colors.grey.shade800,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: DarkColors.third,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Lottie.asset('assets/lottie/walking.json'),
//           ),
//           Text(
//             'هل تريد حقا الخروج',
//             style: titleMedium(context),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton(
//                 onPressed: () => SystemNavigator.pop(),
//                 child: const Text(
//                   'نعم',
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   'لا',
//                   style: TextStyle(
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



void showMyAlert({
  required BuildContext context,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        'تنبيه',
        style: titleMedium(context)
            .copyWith(fontSize: 20, color: Colors.red),
      ),
      content: Text(
        'هل أنت متأكد من الخروج من التطبيق',
        style: titleMedium(context).copyWith(fontSize: 14),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            exit(0);
          },
          child: Text(
            'نعم',
            style: titleMedium(context),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'لا',
            style: titleMedium(context),
          ),
        ),
      ],
    ),
  );
}
