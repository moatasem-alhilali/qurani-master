import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
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
    return BlocProvider.value(
      value: context.read<RadioBloc>(),
      child: Stack(
        children: [
          AppScaffoldWidget(
            title: 'الإذاعة',
            initialOffset: 0,
            body: BlocConsumer<RadioBloc, RadioState>(
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
                  return const RadioStationsLoadingView();
                }

                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 120.h),
                  child: Column(
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
                      SizedBox(height: 16.h),
                      Text(
                        'المحطات المتاحة',
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...state.stations.map(
                        (station) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: RadioStationTile(
                            station: station,
                            isCurrent: state.currentStation?.id == station.id,
                            isPlayingCurrent:
                                state.currentStation?.id == station.id &&
                                    state.isPlaying,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: RadioMiniPlayerWidget(),
          ),
        ],
      ),
    );
  }
}
