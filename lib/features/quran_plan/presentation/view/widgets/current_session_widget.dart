import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
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
    final isCompleted = session.completed;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CardWidget(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        // color: isCompleted ? Colors.green[50] : Colors.grey[50],
        child: ListTile(
          leading: CircleAvatar(
            radius: 10.r,
            backgroundColor: isCompleted ? context.primaryColor : context.gray1,
            child: Text(
              session.sessionNumber.toString(),
              style: context.bodyMedium?.copyWith(
                color: isCompleted ? context.onPrimaryColor : context.gray2,
                fontSize: 13.sp,
                // Add outline for the timer emoji when not completed
                shadows: !isCompleted
                    ? [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ]
                    : [],
              ),
            ),
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
            icon: Icon(
              Icons.circle_outlined,
              color: isCompleted ? context.primaryColor : context.gray1,
            ),
            onPressed: () {
              context.showCustomSnackbar(
                'سيتم إنهاء الجلسة ؟',
                style: SnackBarType.warning,
                actionLabel: 'تأكيد',
                duration: const Duration(seconds: 3),
                paddingBottom: 100,
                onAction: () {
                  context
                      .read<QuranPlanBloc>()
                      .add(CompleteSessionEvent(session.id!, plan.id!));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
