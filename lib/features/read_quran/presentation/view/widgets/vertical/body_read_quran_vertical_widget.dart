// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_app/core/extensions/theme_context_extension.dart';
// import 'package:quran_app/core/failure/request_state.dart';
// import 'package:quran_app/core/util/my_extensions.dart';
// import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
// import 'package:quran_app/features/read_quran/presentation/view/widgets/vertical/read_quran_page_vertical_widget.dart';

// class BodyReadQuranVerticalWidget extends StatelessWidget {
//   const BodyReadQuranVerticalWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OldReadQuranBloc, OldReadQuranState>(
//       builder: (context, state) {
//         final pageController = context.read<OldReadQuranBloc>().pageController;
//         return SafeArea(
//           child: Container(
//             padding: context.customOrientation(
//               const EdgeInsets.symmetric(vertical: 8),
//               EdgeInsets.zero,
//             ) as EdgeInsetsGeometry,
//             color: context.primaryColor.withValues(alpha: 0.1),
//             height: context.getScreenHeight(),
//             child: state.loadQuranState == RequestState.loading
//                 ? const Center(
//                     child: CircularProgressIndicator.adaptive(),
//                   )
//                 : PageView.builder(
//                     itemCount: 604,
//                     controller: pageController,
//                     padEnds: false,
//                     onPageChanged: (val) async {
//                       context.read<OldReadQuranBloc>().add(
//                             OldSetLastPageReadEvent(page: val),
//                           );
//                     },
//                     // physics: const ClampingScrollPhysics(),
//                     itemBuilder: (_, index) {
//                       return Center(
//                         child: Stack(
//                           children: [
//                             // Align(
//                             //   alignment: Alignment.topCenter,
//                             //   child: HeaderReadQuranVerticalWidget(
//                             //     index: index,
//                             //   ),
//                             // ),
//                             Align(
//                               child: LayoutBuilder(
//                                 builder: (context, constraints) {
//                                   final width = constraints.maxWidth;
//                                   var horizontal = 30.0;
//                                   if (width <= 400) {
//                                     horizontal = 30.0;
//                                   }

//                                   if (width > 400) {
//                                     horizontal = 25.0;
//                                   }

//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         // horizontal: horizontal,
//                                         ),
//                                     child: ReadQuranPageVerticalWidget(
//                                       pageIndex: index,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
