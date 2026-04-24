import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_library/quran_library.dart';

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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: context.surfaceColor,
          border: Border.all(
            color: isCompleted ? context.primaryColor.withValues(alpha: 0.5) : context.outline.withValues(alpha: 0.85),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
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
              final quranCtrl = QuranCtrl.instance;
              final uqIndex = quranCtrl.resolveAyahUq(
                surahNumber: session.fromSurahId,
                ayahNumber: session.fromAyahNumber,
              );
              final ayah = quranCtrl.getAyahByUq(uqIndex);

              int targetPage = 1;

              if (ayah.ayahUQNumber != 0) {
                targetPage = ayah.page;
                // Jump in controller so when user returns, controller is at the right page
                quranCtrl.jumpToPage(targetPage - 1);
                quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
              } else {
                final surah = quranCtrl.surahs.firstWhereOrNull(
                    (s) => s.surahNumber == session.fromSurahId);
                if (surah != null && surah.ayahs.isNotEmpty) {
                  targetPage = surah.ayahs.first.page;
                  quranCtrl.jumpToPage(targetPage - 1);
                }
              }

              context.push(
                ReadQuranScreen(
                  page: targetPage - 1,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final quranCtrl = QuranCtrl.instance;

                    final fromSurah = quranCtrl.surahs.firstWhereOrNull(
                        (s) => s.surahNumber == session.fromSurahId);
                    final toSurah = quranCtrl.surahs.firstWhereOrNull(
                        (s) => s.surahNumber == session.toSurahId);

                    return Text(
                      'من ${fromSurah?.arabicName ?? ''} الاية ${session.fromAyahNumber} \n'
                      'إلى ${toSurah?.arabicName ?? ''} الاية ${session.toAyahNumber}',
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
