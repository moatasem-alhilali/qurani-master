import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/audio/action_progress.dart';
import 'package:quran_app/core/widgets/audio/custom_progress.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class BaseAudioDetail extends StatelessWidget {
  BaseAudioDetail({super.key, this.data});
  final dynamic data;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BaseAudioBloc(
        repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
      )..add(BaseAudioDetailEvent(data['api_url'] as String)),
      child: BaseHomeWidget(
        isScroll: false,
        title: data['title'].toString(),
        body: BlocBuilder<BaseAudioBloc, BaseAudioState>(
          builder: (context, state) {
            return state.famousBaseAudioState.handle<dynamic>(
              onSuccess: () => Column(
                children: [
                  ProgressAudio(
                    audioPlayer: state.audioPlayer ?? AudioPlayer(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.baseAudioDetail.length,
                      itemBuilder: (context, index) {
                        final surahs =
                            context.read<ReadQuranBloc>().quranRH.surahs;

                        final data = surahs[index];

                        final dataSurah = state.baseAudioDetail[index];
                        return _ItemDownloaded(
                          audioPlayer: state.audioPlayer,
                          data: data,
                          current: index,
                          dataSurah: dataSurah,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemDownloaded extends StatelessWidget {
  const _ItemDownloaded({
    required this.current,
    this.data,
    this.dataSurah,
    this.audioPlayer,
    super.key,
  });
  final Surah? data;
  final dynamic dataSurah;
  final int current;
  final AudioPlayer? audioPlayer;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      height: context.getHight(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: context.primaryScheme,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
              builder: (context, state) {
                switch (state.audioState) {
                  case RequestState.initial:
                    return const CircularProgressIndicator();
                  case RequestState.loading:
                    return const CircularProgressIndicator();

                  case RequestState.error:
                    return const CircularProgressIndicator(color: Colors.red);

                  case RequestState.success:
                    return ActionProgress(
                      onPressed: () {
                        context.read<BaseAudioBloc>().add(SetStateEvent());
                      },
                      audioPlayer: audioPlayer!,
                      currentIndex: audioPlayer!.currentIndex!,
                      itemIndex: current,
                    );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data!.arabicName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  ' | ',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${data!.ayahs.length}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _BtnDownload(data: dataSurah, title: data!.arabicName),
        ],
      ),
    );
  }
}

class _BtnDownload extends StatefulWidget {
  const _BtnDownload({required this.data, required this.title});

  final dynamic data;
  final dynamic title;

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
    return InkWell(
      onTap: () {
        final url = widget.data['url'] as String;
        final description = widget.title as String;
        downloadService.download(url, description);
      },
      child: Container(
        decoration: const BoxDecoration(
          // color: DarkColors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Text(
              widget.data['size'] as String,
              style: titleMedium(context),
            ),
            const SizedBox(width: 10),
            Container(
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryScheme,
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
    );
  }
}
