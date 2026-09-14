import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_hero_card.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_station_tile.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_stations_loading_view.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_mini_player_widget.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider.value(
      value: context.read<RadioBloc>(),
      // نُلبس الشاشة أرضية «طمأنينة» حتى لا يظهر رأس الصفحة بلون الثيم القديم
      // فوق محتوى بلون آخر.
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: Stack(
          children: [
            AppScaffoldWidget(
              title: 'الإذاعة',
              initialOffset: 0,
              body: ColoredBox(
                color: skin.ground,
                child: BlocConsumer<RadioBloc, RadioState>(
                  listenWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage &&
                      current.errorMessage != null,
                  listener: (context, state) {
                    final message = state.errorMessage;
                    if (message == null) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  builder: (context, state) {
                    if (state.loadState == RequestState.loading &&
                        state.stations.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: const RadioStationsLoadingView(),
                      );
                    }

                    final stations = state.stations;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioHeroCard(
                          station: state.currentStation,
                          isPlaying: state.isPlaying,
                          onOpenNowPlaying: state.currentStation == null
                              ? null
                              : RadioPlayerUiManager.instance.openBox,
                        ),
                        skin.divider(),
                        const HomeSectionHeader(title: 'المحطات المتاحة'),
                        for (var i = 0; i < stations.length; i++)
                          RadioStationTile(
                            station: stations[i],
                            isCurrent:
                                state.currentStation?.id == stations[i].id,
                            isPlayingCurrent:
                                state.currentStation?.id == stations[i].id &&
                                    state.isPlaying,
                            isLast: i == stations.length - 1,
                          ),
                        // فسحة أسفل القائمة حتى لا يغطّي المشغّل آخر محطة.
                        SizedBox(height: 110.h),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RadioMiniPlayerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
