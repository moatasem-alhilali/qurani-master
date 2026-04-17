import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_library/quran_library.dart';

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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
                  // البحث عن الآية المحددة للحصول على معلوماتها
                  final quranLibrary = QuranLibrary();

                  try {
                    // الحصول على معلومات السورة (using 1-based indexing as per README)
                    final surahInfo = quranLibrary.getSurahInfo(
                      surahNumber: session.fromSurahId,
                    );

                    // البحث عن الآية في السورة باستخدام اسم السورة ورقم الآية
                    final searchQuery = surahInfo.name;
                    final searchResults = quranLibrary.search(searchQuery);

                    // البحث عن الآية المحددة في نتائج البحث
                    AyahModel? targetAyah;
                    for (final ayah in searchResults) {
                      if (ayah.surahNumber == session.fromSurahId &&
                          ayah.ayahNumber == session.fromAyahNumber) {
                        targetAyah = ayah;
                        break;
                      }
                    }

                    if (targetAyah != null) {
                      // استخدام jumpToAyah للانتقال إلى الآية المحددة
                      quranLibrary.jumpToAyah(
                        targetAyah.page,
                        targetAyah.ayahUQNumber,
                      );
                    } else {
                      // إذا لم نجد الآية، انتقل إلى بداية السورة
                      quranLibrary.jumpToSurah(session.fromSurahId);
                    }

                    final page = quranLibrary.currentPageNumber;

                    context.push(
                      ReadQuranScreen(
                        page: page,
                      ),
                    );
                  } catch (e) {
                    // في حالة حدوث خطأ، انتقل إلى بداية السورة
                    final quranLibrary = QuranLibrary()
                      ..jumpToSurah(session.fromSurahId);
                    final page = quranLibrary.currentPageNumber;

                    context.push(
                      ReadQuranScreen(
                        page: page,
                      ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final quranLibrary = QuranLibrary();

                        // Get surah information using QuranLibrary (1-based indexing)
                        final fromSurah = quranLibrary.getSurahInfo(
                          surahNumber: session.fromSurahId,
                        );
                        final toSurah = quranLibrary.getSurahInfo(
                          surahNumber: session.toSurahId,
                        );

                        return Text(
                          'من ${fromSurah.name} الاية ${session.fromAyahNumber} \n'
                          'إلى ${toSurah.name} الاية ${session.toAyahNumber}',
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
