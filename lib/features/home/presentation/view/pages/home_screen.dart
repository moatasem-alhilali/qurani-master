import 'package:flutter/material.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/dd.dart';

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
    return AppSliverWidget(
      hasAppBar: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            // horizontal: 16,
            ),
        child: Column(
          children: [
            SizedBox(
              height: context.fullHeight,
              child: const PrayerHomePage(),
            ),
            // const QuranLottieWidget(),
            // Amazing Prayer Countdown Widget
            // BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
            //   builder: (context, state) {
            //     if (state.prayerState == RequestState.success &&
            //         state.nextPrayer != null) {
            //       // Calculate remaining time
            //       final remainingTime =
            //           state.nextPrayer!.time.difference(DateTime.now());
            //       final safeRemainingTime =
            //           remainingTime.isNegative ? Duration.zero : remainingTime;

            //       // Create TimePrayerModel from the next prayer
            //       final nextPrayerModel = TimePrayerModel(
            //         id: 999,
            //         title: state.nextPrayer!.name,
            //         time: state.nextPrayer!.time12,
            //         type: state.nextPrayer!.type,
            //         image: state.nextPrayer!.type.imageAsset,
            //         content: state.nextPrayer!.description,
            //         color: Colors.blue,
            //       );

            //       return NextPrayerCountdownWidget(
            //         nextPrayer: nextPrayerModel,
            //         remainingTime: safeRemainingTime,
            //       );
            //     }
            //     return const SizedBox();
            //   },
            // ),

            // // const CurrentPrayerHomeWidget(),
            // // const PrayersHomeWidget(),

            // const BaseHederWidget(text: 'المميزات'),
            // const AnotherFeatures(),

            // const BaseHederWidget(text: 'المكتبة'),
            // SizedBox(
            //   height: context.getHight(20),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: ListView(
            //       scrollDirection: Axis.horizontal,
            //       children: [
            //         FeatureCardIconWidget(
            //           title: 'المكتبة الشاملة',
            //           icon: const Icon(Icons.book),
            //           onTap: () {
            //             context.push(
            //               const CategoryScreen(),
            //             );
            //           },
            //           maxLines: 1,
            //           width: context.getWidth(90),
            //           height: context.getHight(18),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
