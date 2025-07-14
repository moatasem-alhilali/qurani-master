import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/location_enable_screen.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/data/extension/extension.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_animations.dart';

class PrayersHomeWidget extends StatelessWidget {
  const PrayersHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (!CacheConfig.hasInitLocal && !serviceEnabled) {
          return const LocationEnableScreen();
        }

        return Column(
          children: [
            const BaseHederWidget(text: 'اوقات الصلاة'),
            SizedBox(
              width: double.infinity,
              height: context.getHight(18),
              child: Builder(
                builder: (context) {
                  switch (state.prayerState) {
                    case RequestState.initial:
                    case RequestState.loading:
                      return ShimmerWidget(
                        child: _buildList(PrayerInfoModel.dummy(), null),
                      );
                    case RequestState.error:
                      return const SizedBox();

                    case RequestState.success:
                      final prayers = state.prayerList;
                      final currentType = state.currentPrayer?.type;

                      return _buildList(prayers, currentType);
                  }
                },
              ),
            ),
          ],
        ).animate().fade();
      },
    );
  }

  ListView _buildList(List<PrayerInfoModel> prayers, Prayer? currentType) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final data = prayers[index];
        final isCurrent = data.type == currentType;

        return BaseAnimate(
          index: index,
          child: _ItemPrayer(
            data: TimePrayerModel(
              id: 200 + index,
              type: data.type,
              title: data.name,
              time: data.time12,
              image: data.type.imageAsset,
              content: '',
              color: isCurrent ? Colors.white : Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}

class _ItemPrayer extends StatefulWidget {
  const _ItemPrayer({
    required this.data,
    super.key,
  });

  final TimePrayerModel data;

  @override
  State<_ItemPrayer> createState() => _ItemPrayerState();
}

class _ItemPrayerState extends State<_ItemPrayer> {
  bool isMaxLine = false;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      width: 95.w,
      margin: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      padding: EdgeInsets.symmetric(horizontal: 1.sp, vertical: 8.sp),
      child: InkWell(
        onTap: () {
          context.push(const PrayerTimeScreen());
          setState(() {
            isMaxLine = !isMaxLine;
          });
        },
        child: Column(
          children: [
            Expanded(
              child: PrayerTimeAnimationWidget(
                prayerType: widget.data.type,
                size: 60,
                isActive: widget.data.color == Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.data.title,
              style: titleMedium(context),
            ),
            const SizedBox(height: 5),
            Text(
              widget.data.time,
              style: titleMedium(context).copyWith(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
