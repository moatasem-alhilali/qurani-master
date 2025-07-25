import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';

class CurrentSessionWidget extends StatelessWidget {
  const CurrentSessionWidget({
    required this.plan,
    required this.session,
    super.key,
  });

  final QuranPlan plan;
  final QuranPlanSession session;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      // color: isCompleted ? Colors.green[50] : Colors.grey[50],
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.menu_book,
            color: Colors.white,
          ),
        ),
        title: Text(
          'جلسة ${session.sessionNumber}',
          style: context.bodyMedium,
        ),
        subtitle: StyleButtonWrap(
          onTap: () {
            final quranState = context.read<ReadQuranBloc>().state;
            final page = quranState.getFirstPageOfSurah(
              session.fromSurahId,
              ayahNumber: session.fromAyahNumber,
            );
            context.push(
              ReadQuranScreen(
                page: page,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ReadQuranBloc, ReadQuranState>(
                builder: (context, stateQuran) {
                  final fromAyah = stateQuran.surahs.firstWhere(
                    (surah) => surah.id == session.fromSurahId,
                  );
                  final toAyah = stateQuran.surahs.firstWhere(
                    (surah) => surah.id == session.toSurahId,
                  );
                  return Text(
                    'من ${fromAyah.nameAr} الاية ${session.fromAyahNumber} \n إلى ${toAyah.nameAr} الاية ${session.toAyahNumber}',
                    style: context.bodyMedium,
                  );
                },
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.menu_book,
            color: Colors.blue,
          ),
          onPressed: () {
            context
                .read<QuranPlanBloc>()
                .add(CompleteSessionEvent(session.id!, plan.id!));
          },
        ),
      ),
    );
  }
}
