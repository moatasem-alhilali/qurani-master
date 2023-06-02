import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/offline_audio/cubit/offline_cubit.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/offline_audio/model/quran_audio_offline.dart';
import 'package:quran_app/features/offline_audio/pages/audio_detail_offline.dart';

import '../../quran_audio/ui/widgets/item_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioOffline extends StatelessWidget {
  const AudioOffline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return quranAudioDataGlobal.isEmpty
        ? Center(
            child: Text(
              "لايوجد لديك أصوات محملة بعد",
              style: titleMedium(context).copyWith(color: Colors.grey),
            ),
          )
        : BlocBuilder<OfflineCubit, OfflineState>(
            builder: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: quranAudioDataGlobal.length,
                itemBuilder: (context, index) {
                  var data = quranAudioDataGlobal[index];

                  return InkWell(
                    onTap: () async {
                      AudioPlayerHelper.initAudioPlayerDetail(
                        filePath: data.audio_path!,
                      );

                      navigateTo(
                        AudioDetailOffline(
                          data: data,
                        ),
                        context,
                      );
                    },
                    child: StyleContainer(
                      child: _item(data: data),
                    ),
                  );
                },
              );
            },
          );
  }
}

class _item extends StatelessWidget {
  _item({Key? key, this.data}) : super(key: key);
  QuranAudioModel? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data!.nameSurah!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'القارئ ${data!.nameReader!}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SvgPicture.asset(
            data!.imageReader!,
            height: SizeConfig.blockSizeVertical! * 10,
          ),
        ),
      ],
    );
  }
}
