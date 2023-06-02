import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/offline_audio/cubit/offline_cubit.dart';
import 'package:quran_app/features/quran/presentation/model/surah_model.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

class AllSurahAudio extends StatefulWidget {
  const AllSurahAudio({
    super.key,
  });

  @override
  State<AllSurahAudio> createState() => _AllSurahAudioState();
}

class _AllSurahAudioState extends State<AllSurahAudio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "سور أخرى",
            style: titleMedium(context),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 114,
          itemBuilder: (context, index) {
            var data = surahData[index];
            return Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: SizeConfig.blockSizeVertical! * 10,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: _ItemDownloaded(
                data: data,
                indexSurah: index,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ItemDownloaded extends StatefulWidget {
  _ItemDownloaded({Key? key, this.data, this.indexSurah}) : super(key: key);
  SurahModel? data;
  int? indexSurah;

  @override
  State<_ItemDownloaded> createState() => _ItemDownloadedState();
}

class _ItemDownloadedState extends State<_ItemDownloaded> {
  int? current;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.indexSurah! + 1}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.data!.titleAr!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              "${widget.data!.count!}",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        BlocBuilder<OfflineCubit, OfflineState>(
          builder: (context, state) {
            return OfflineCubit.get(context).isDownload &&
                    current == widget.indexSurah
                ? Row(
                    children: [
                      Lottie.asset(
                        "assets/lottie/downloading.json",
                        height: SizeConfig.blockSizeVertical! * 5,
                        width: SizeConfig.blockSizeHorizontal! * 20,
                      ),
                      Text(
                        "${OfflineCubit.get(context).progress}%",
                        style: titleSmall(context),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () async {
                      //current
                      setState(() {
                        current = widget.indexSurah;
                      });
                      var currentAudioData = AudioPlayerHelper.currentAudioData;
                      //update
                      CurrentAudioModel updateCurrent = CurrentAudioModel(
                        countSurahVerse: surahData[widget.indexSurah!].count,
                        imageReader: currentAudioData.imageReader,
                        nameReader: currentAudioData.nameReader,
                        nameSurah: surahData[widget.indexSurah!].titleAr,
                        identifier: currentAudioData.identifier,
                        indexSurah: widget.indexSurah! + 1,
                      );
                      //save
                      AudioPlayerHelper.currentAudioData = updateCurrent;
                      AudioPlayerHelper.audioPlayerOnlineListen.stop();
                      await OfflineCubit.get(context).downloadAudio();

                      setState(() {
                        current = null;
                      });
                    },
                    icon: const Icon(Icons.download),
                  );
          },
        ),
      ],
    );
  }
}
