// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:quran_app/core/shared/export/export-shared.dart';
// import 'package:quran_app/core/shared/resources/size_config.dart';

// class TimeLinePicker extends StatelessWidget {
//   const TimeLinePicker({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: SizeConfig.blockSizeVertical! * 15,
//       padding: const EdgeInsets.all(4),
//       margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DatePicker(
//         DateTime.now(),
//         width: 100,
//         initialSelectedDate: DateTime.now(),
//         selectionColor: ColorsManager.customPrimary,
//         deactivatedColor: ColorsManager.customPrimarySecondary,
//         onDateChange: (newDataTime) {
//           // setState(() {
//           //   selectedDateTime = newDataTime.toString();
//           // });
//         },
//         locale: "ar",
//         height: SizeConfig.blockSizeVertical! * 15,
//         selectedTextColor: Colors.grey,
//         dayTextStyle: titleSmall(context),
//         monthTextStyle: titleSmall(context),
//         dateTextStyle: titleSmall(context).copyWith(fontSize: 28),
//       ),
//     );
//   }
// }
