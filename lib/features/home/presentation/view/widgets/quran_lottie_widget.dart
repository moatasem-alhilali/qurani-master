// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:quran_app/core/components/glass_card_widget.dart';
// import 'package:quran_app/core/extensions/colors_extension.dart';
// import 'package:quran_app/core/extensions/text_styles_extension.dart';
// import 'package:quran_app/core/util/my_extensions.dart';
// import 'package:quran_app/core/widgets/images/image_widget.dart';
// import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
// import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
// import 'package:quran_app/gen/assets.gen.dart';

// class QuranLottieWidget extends StatelessWidget {
//   const QuranLottieWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ReadQuranBloc, ReadQuranState>(
//       builder: (context, state) {
//         // format data useing intl
//         final date = DateTime.parse(
//             state.lastReadQuranInfo?.date ?? DateTime.now().toIso8601String());
//         final formattedDate =
//             DateFormat('dd MMMM yyyy HH:mm', 'ar_EG').format(date);
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: SizedBox(
//             // height: 70.h,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: ImageWidget(
//                     Assets.image.readingQuran.path,
//                     fit: BoxFit.cover,
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       // color: context.primaryColor,

//                       borderRadius: BorderRadius.circular(10.r),
//                       gradient: LinearGradient(
//                         begin: Alignment.topRight,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.black.withOpacity(0.8),
//                           Colors.black.withOpacity(0.6),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (state.lastReadQuranInfo != null)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'اكمل من حيث توقفت',
//                                 style: context.titleMedium?.copyWith(
//                                   fontSize: 18.sp,
//                                   color: context.onPrimaryColor,
//                                 ),
//                               ),
//                               Gap(5.h),
//                               Text(
//                                 'توقفت عند سورة ${state.lastReadQuranInfo?.surah} صفحة ( ${state.lastReadQuranInfo?.page} ) ',
//                                 style: context.labelMedium?.copyWith(
//                                   fontSize: 10.sp,
//                                   color: context.onPrimaryColor,
//                                 ),
//                               ),
//                               Gap(5.h),
//                               Text(
//                                 'التاريخ $formattedDate',
//                                 style: context.labelMedium?.copyWith(
//                                   fontSize: 10.sp,
//                                   color: context.onPrimaryColor,
//                                 ),
//                               ),
//                               Gap(5.h),
//                             ],
//                           )
//                         else
//                           Text(
//                             'لم تقرأ القرآن بعد',
//                             style: context.labelMedium?.copyWith(
//                               fontSize: 10.sp,
//                               color: context.onPrimaryColor,
//                             ),
//                           ),
//                         GlassCardWidget(
//                           // padding: EdgeInsets.symmetric(
//                           //   horizontal: 12.w,
//                           //   vertical: 4.h,
//                           // ),
//                           child: TextButton(
//                             onPressed: () {
//                               context.push(const ReadQuranScreen());
//                             },
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w,
//                                 vertical: 4.h,
//                               ),
//                               minimumSize: Size(100.w, 20.h),
//                               maximumSize: Size(100.w, 20.h),
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: Text(
//                               state.lastReadQuranInfo != null
//                                   ? 'اكمل القراءة'
//                                   : 'ابدأ القراءة',
//                               style: context.labelMedium?.copyWith(
//                                 fontSize: 10.sp,
//                                 color: context.onPrimaryColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
