import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/audio/action_progress.dart';
import 'package:quran_app/core/widgets/audio/custom_progress.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/audios/data/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';

class SheetAudios extends StatelessWidget {
  const SheetAudios({super.key, this.baseData});
  final dynamic baseData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHight(70),
      child: BlocProvider(
        create: (context) => BaseAudioBloc(
          repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
        )..add(BaseAudioDetailEvent(baseData['api_url'])),
        child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
          builder: (context, state) {
            switch (state.famousBaseAudioState) {
              case RequestState.defaults:
                return const Center(child: CircularProgressIndicator());
              case RequestState.loading:
                return const Center(child: CircularProgressIndicator());

              case RequestState.error:
                return const Center(
                    child: CircularProgressIndicator(color: Colors.red));

              case RequestState.success:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: baseData['title'].toString().autoSize(context,
                          fontSize: 20, maxLines: 2, minFontSize: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: baseData['description'].toString().autoSize(
                            context,
                            color: Colors.grey,
                            maxLines: null,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(color: Colors.grey),
                    ),
                    ProgressAudio(
                        audioPlayer: state.audioPlayer ?? AudioPlayer()),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.baseAudioDetail.length,
                        itemBuilder: (context, index) {
                          var data = state.baseAudioDetail[index];
                          return _ItemDownloaded(
                            audioPlayer: state.audioPlayer,
                            current: index,
                            data: data,
                            baseData: baseData,
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class _ItemDownloaded extends StatelessWidget {
  _ItemDownloaded({
    Key? key,
    required this.current,
    this.data,
    this.audioPlayer,
    this.baseData,
  }) : super(key: key);
  dynamic data;
  dynamic baseData;
  int current;
  AudioPlayer? audioPlayer;
  @override
  Widget build(BuildContext context) {
    // logger.d(data);
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // height: context.getHight(8),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          if (data['description'] != null)
            Column(
              children: [
                data['description'].toString().autoSize(context, maxLines: 5),
                const SizedBox(height: 10),
                const Divider(),
              ],
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
                  builder: (context, state) {
                    switch (state.audioState) {
                      case RequestState.defaults:
                        return const CircularProgressIndicator();
                      case RequestState.loading:
                        return const CircularProgressIndicator();

                      case RequestState.error:
                        return const CircularProgressIndicator(
                            color: Colors.red);

                      case RequestState.success:
                        return Container(
                          height: context.getHight(6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FxColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ActionProgress(
                            onPressed: () {
                              context
                                  .read<BaseAudioBloc>()
                                  .add(SetStateEvent());
                            },
                            audioPlayer: audioPlayer!,
                            currentIndex: audioPlayer!.currentIndex!,
                            itemIndex: current,
                          ),
                        );
                    }
                  },
                ),
              ),
              _BtnDownload(data: data),
            ],
          ),
        ],
      ),
    );
  }
}

class _BtnDownload extends StatefulWidget {
  const _BtnDownload({
    required this.data,
  });

  final dynamic data;

  @override
  State<_BtnDownload> createState() => _BtnDownloadState();
}

class _BtnDownloadState extends State<_BtnDownload> {
  DownloadService downloadService = DownloadService();
  @override
  void initState() {
    super.initState();
    downloadService.init();
  }

  @override
  void dispose() {
    downloadService.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          final url = widget.data['url'];
          final description = widget.data['description'];
          downloadService.download(url, description);
        },
        child: Container(
          height: context.getHight(6),
          decoration: BoxDecoration(
            color: FxColors.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: widget.data['size'].toString().autoSize(context),
              ),
              Container(
                height: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FxColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Icon(Icons.download),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
