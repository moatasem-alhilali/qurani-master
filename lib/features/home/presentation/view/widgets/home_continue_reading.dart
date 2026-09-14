import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/data/surah_label.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_library/quran_library.dart';

/// عدد صفحات المصحف — يُستخدم لقياس نسبة ما قُرئ.
const _kMushafPages = 604;

class _LastRead {
  const _LastRead({required this.page, required this.surahName});

  final int page;
  final String surahName;
}

/// «تكملة القراءة»: صفّ واحد يُرجع القارئ إلى آخر صفحة وقف عندها،
/// وتحته خطّ رفيع يقيس موضعه من المصحف كاملاً.
class HomeContinueReading extends StatefulWidget {
  const HomeContinueReading({super.key});

  @override
  State<HomeContinueReading> createState() => _HomeContinueReadingState();
}

class _HomeContinueReadingState extends State<HomeContinueReading> {
  late Future<_LastRead?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_LastRead?> _load() async {
    try {
      await QuranLibrary.quranCtrl.ensureCoreDataLoaded();
      final page = QuranLibrary().currentPageNumber;
      if (page < 1 || page > _kMushafPages) {
        return null;
      }
      final surah =
          QuranLibrary().getCurrentSurahDataByPageNumber(pageNumber: page);
      return _LastRead(page: page, surahName: surah.arabicName);
    } catch (_) {
      // المكتبة لم تُهيَّأ بعد أو البيانات غير متاحة — نعرض بداية القراءة.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_LastRead?>(
      future: _future,
      builder: (context, snapshot) {
        final skin = AppSkin.of(context);
        final lastRead = snapshot.data;
        final hasProgress = lastRead != null && lastRead.page > 1;

        return InkWell(
          onTap: () => context.push(
            ReadQuranScreen(page: hasProgress ? lastRead.page - 1 : 0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
            child: Column(
              children: [
                Row(
                  children: [
                    AppIcon(
                      AppIcons.quran,
                      color: skin.accent,
                      size: 17.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hasProgress ? 'تكملة القراءة' : 'ابدأ القراءة',
                            style: TextStyle(
                              color: skin.ink,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            hasProgress
                                ? '${surahLabel(lastRead.surahName)} · '
                                    'صفحة ${lastRead.page}'
                                : 'من سورة الفاتحة · صفحة ١',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasProgress)
                      // الكسر يُقلب في الاتجاه العربي فيُقرأ «٦٠٤ / ٣»؛
                      // نثبّت اتجاهه من اليسار لليمين.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          '${lastRead.page} / $_kMushafPages',
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.62),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    AppIcon(
                      AppIcons.chevronLeft,
                      color: skin.accent,
                      size: 15.sp,
                    ),
                  ],
                ),
                if (hasProgress) ...[
                  SizedBox(height: 7.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: lastRead.page / _kMushafPages,
                      minHeight: 3.h,
                      backgroundColor: skin.hairline,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
