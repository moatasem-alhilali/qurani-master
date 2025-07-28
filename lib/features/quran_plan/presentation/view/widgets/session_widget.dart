import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';

class SessionWidget extends StatelessWidget {
  const SessionWidget({
    required this.plan,
    required this.session,
    super.key,
  });

  final QuranPlan plan;
  final QuranPlanSession session;
  @override
  Widget build(BuildContext context) {
    final dateStr = session.completedAt != null
        ? DateFormat('yyyy-MM-dd – kk:mm').format(session.completedAt!)
        : '—';
    final isCompleted = session.completed;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompleted)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
              child: Text(
                'تم الإنجاز: $dateStr',
                style: context.bodyMedium?.copyWith(
                  color: context.gray2,
                  fontSize: 10.sp,
                ),
              ),
            ),
          CardWidget(
            // margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            // color: isCompleted ? Colors.green[50] : Colors.grey[50],
            child: ListTile(
              leading: CircleAvatar(
                radius: 10.r,
                backgroundColor:
                    isCompleted ? context.primaryColor : context.gray1,
                child: Text(
                  isCompleted ? '✓' : '?',
                  style: context.bodyMedium?.copyWith(
                    color: isCompleted ? context.onPrimaryColor : context.gray2,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              // title: Text(
              //   'جلسة ${session.sessionNumber}',
              //   style: context.bodyMedium,
              // ),
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
                          style: context.bodyMedium?.copyWith(
                            color: isCompleted
                                ? context.primaryColor
                                : context.gray1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
