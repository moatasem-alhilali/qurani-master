import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state/request_state_extension.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/surah_quran/surah_quran_bloc.dart';

class SurahBlocWrapperWidget extends StatelessWidget {
  const SurahBlocWrapperWidget({
    required this.builder,
    super.key,
  });
  final Widget Function(List<NewSurahModel> surah) builder;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurahQuranBloc()..add(LoadSurahEvent()),
      child: BlocBuilder<SurahQuranBloc, SurahQuranState>(
        builder: (context, readQuranState) {
          return readQuranState.loadQuranState.when<NewSurahModel>(
            onSuccess: () {
              final surahs = readQuranState.surahs;
              return builder(surahs);
            },
            list: readQuranState.surahs,
          );
        },
      ),
    );
  }
}
