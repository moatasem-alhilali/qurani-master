// import 'package:accordion/controllers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_app/features/setting/logic/method.dart';
// import 'package:quran_app/features/setting/widgets/about.dart';
// import 'package:quran_app/features/notification/pages/notification_screen.dart';
// import 'package:quran_app/features/setting/widgets/style_settings.dart';
// import 'package:quran_app/features/setting/widgets/thikr_size_seeting.dart';
// import 'package:quran_app/core/Home/cubit.dart';
// import 'package:quran_app/core/Home/state.dart';

// import 'package:quran_app/core/shared/export/export-shared.dart';
// import 'package:quran_app/core/shared/resources/assets_manager.dart';
// import 'package:quran_app/core/shared/resources/size_config.dart';
// import 'package:accordion/accordion.dart';

// class SettingScreen extends StatefulWidget {
//   SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var cubit = HomeCubit.get(context);
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Scaffold(
//             appBar: AppBar(),
//             body: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Accordion(
//                 scrollIntoViewOfItems: ScrollIntoViewOfItems.slow,
//                 headerBorderRadius: 7,
//                 maxOpenSections: 4,
//                 disableScrolling: true,
//                 headerBackgroundColorOpened: ColorsManager.customMain,
//                 scaleWhenAnimating: true,
//                 openAndCloseAnimation: true,
//                 contentBackgroundColor: ColorsManager.background,
//                 sectionOpeningHapticFeedback: SectionHapticFeedback.medium,
//                 sectionClosingHapticFeedback: SectionHapticFeedback.selection,
//                 children: [
//                   //
//                   AccordionSection(
//                     contentBorderColor: Colors.transparent,
//                     contentBorderRadius: 5,
//                     contentBorderWidth: 0,
//                     contentBackgroundColor: ColorsManager.background,
//                     isOpen: false,
//                     leftIcon: const Icon(
//                       Icons.notifications,
//                       color: Colors.white,
//                     ),
//                     header: Text(
//                       " الإشعارات",
//                       style: titleMedium(context),
//                     ),
//                     content: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _Container(
//                           text: 'هل تريد  ايقاف الاشعارات',
//                           iconchild: Switch(
//                             activeColor: Colors.red,
//                             value: ISNOT_NOTIFY,
//                             inactiveThumbColor: Colors.grey,
//                             onChanged: (val) {
//                               MethodSetting.unLockNoitification(val);
//                               setState(() {});
//                             },
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             navigateTo(ManageNotificationScreen(), context);
//                           },
//                           child: Text("إعداد الاشعارات"),
//                         ),
//                       ],
//                     ),
//                   ),

//                   //
//                   AccordionSection(
//                     contentBorderColor: Colors.transparent,
//                     contentBorderRadius: 5,
//                     contentBorderWidth: 0,
//                     contentBackgroundColor: ColorsManager.background,
//                     isOpen: false,
//                     leftIcon: const Icon(
//                       Icons.adb_outlined,
//                       color: Colors.white,
//                     ),
//                     header: Text(
//                       'حجم خط الأدعية والأذكار',
//                       style: titleMedium(context),
//                     ),
//                     content: ThikrSizeSetting(cubit: cubit),
//                   ),

//                   //
//                   AccordionSection(
//                     contentBorderColor: Colors.transparent,
//                     contentBorderRadius: 5,
//                     contentBorderWidth: 0,
//                     contentBackgroundColor: ColorsManager.background,
//                     isOpen: false,
//                     leftIcon: const Icon(
//                       Icons.adb_outlined,
//                       color: Colors.white,
//                     ),
//                     header: Text(
//                       'التنسيق والشكل',
//                       style: titleMedium(context),
//                     ),
//                     content: StyleSetting(),
//                   ),
//                   //
//                   AccordionSection(
//                     contentBorderColor: Colors.transparent,
//                     contentBorderRadius: 5,
//                     contentBorderWidth: 0,
//                     contentBackgroundColor: ColorsManager.background,
//                     isOpen: false,
//                     leftIcon: const Icon(
//                       Icons.adb_outlined,
//                       color: Colors.white,
//                     ),
//                     header: Text(
//                       ' حول التطبيق',
//                       style: titleMedium(context),
//                     ),
//                     content: Column(
//                       children: [
//                         about(
//                           icon: AssetsManager.person,
//                           content: "مطور تطبيقات موبايل",
//                           text: 'معتصم الهلالي',
//                           onTap: MethodSetting.lunchToFacebook,
//                         ),
//                         about(
//                           icon: AssetsManager.facebook,
//                           content: "حسابي الشخصي على فيسبوك",
//                           text: 'الفيسبوك',
//                           onTap: MethodSetting.lunchToFacebook,
//                         ),
//                         about(
//                           icon: AssetsManager.instagram,
//                           content: "حسابي الشخصي على الإنستاجرام",
//                           text: 'الإنستاجرام',
//                           onTap: () async {
//                             await MethodSetting.lunchToInstagram();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _Container extends StatelessWidget {
//   _Container({required this.text, this.onTap, this.iconchild});
//   void Function()? onTap;
//   String text;
//   Widget? iconchild;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: SizeConfig.blockSizeVertical! * 8,
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: ColorsManager.main,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             iconchild ?? const Icon(Icons.arrow_back_ios),
//             Text(
//               text,
//               style: titleMedium(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
