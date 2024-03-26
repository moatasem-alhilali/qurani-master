import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/offline/data/offline_repository_imp.dart';
import 'package:quran_app/features/offline/presentation/bloc/offline_bloc.dart';
import 'package:quran_app/features/offline/presentation/view/widgets/audio_offline_sheet.dart';
import 'package:quran_app/features/offline/presentation/view/widgets/item_detail.dart';
import 'package:quran_app/features/offline/presentation/view/widgets/video_offline_sheet.dart';

class OfflineDetail extends StatelessWidget {
  OfflineDetail({super.key, this.data});
  final dynamic data;
  final PageController _controller = PageController();
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfflineBloc(
        repositoryImpl: sl.get<OfflineRepositoryImpl>(),
      )..add(InitOfflinePlayerEvent(data['type'])),
      child: BaseUiScreen(
        onRefresh: () async {},
        title: data['title'].toString().autoSize(
              context,
              maxLines: 2,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
        child: BlocBuilder<OfflineBloc, OfflineState>(
          builder: (context, state) {
            switch (state.getState) {
              case RequestState.defaults:
                return const CircularProgressIndicator();
              case RequestState.loading:
                return const CircularProgressIndicator();

              case RequestState.error:
                return const CircularProgressIndicator(
                  color: Colors.red,
                );

              case RequestState.success:
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    MyTextFormField(
                      controller: search,
                      hintText: "بحث",
                      suffixIcon: search.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                search.clear();
                                context
                                    .read<OfflineBloc>()
                                    .add(SetStateEvent());
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ).animate().fade()
                          : null,
                      onChanged: (text) {
                        _onSearchTextChanged(state.data);
                        context.read<OfflineBloc>().add(SetStateEvent());
                      },
                    ),
                    const Expanded(
                      child: BuildItemOffline(),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data) {
    final res = data
        .where((data) => data['title']
            .toString()
            .toLowerCase()
            .contains(search.text.toLowerCase()))
        .toList();
    return res;
  }
}

class BuildItemOffline extends StatelessWidget {
  const BuildItemOffline({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineBloc, OfflineState>(
      builder: (context, state) {
        switch (state.getState) {
          case RequestState.defaults:
            return const CircularProgressIndicator();
          case RequestState.loading:
            return const CircularProgressIndicator();

          case RequestState.error:
            return const CircularProgressIndicator(
              color: Colors.red,
            );

          case RequestState.success:
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                var allData = state.data[index];
                return BaseAnimate(
                  index: index,
                  child: ItemDetailOffline(
                    current: index,
                    data: allData,
                    onTap: () {
                      if (allData['type'] == "mp3") {
                        context.showBottomSheet(
                          child: AudioOfflineSheet(
                            data: allData,
                          ),
                        );
                        return;
                      }
                      if (allData['type'] == "mp4") {
                        context.showBottomSheet(
                          child: VideoOfflineSheet(
                            data: allData,
                          ),
                        );
                        return;
                      }
                    },
                  ),
                );
              },
            );
        }
      },
    );
  }
}
