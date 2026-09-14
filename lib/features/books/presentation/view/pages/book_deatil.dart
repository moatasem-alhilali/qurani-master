import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:quran_app/features/books/presentation/view/pages/read_book.dart';
import 'package:quran_app/features/books/presentation/view/widgets/book_row.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';

/// تفاصيل كتاب: ملفّاته ثم وصفه ومرجعه.
///
/// كانت الملفّات داخل `PageView` ببطاقات ملوّنة وصورة غلاف وهمية وزرّين
/// متجاورين. صارت صفوفًا: كلّ ملفّ سطر فيه حجمه وزرّا القراءة والتنزيل.
class BookDetail extends StatefulWidget {
  const BookDetail({super.key, this.data});

  final dynamic data;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
    _downloadService.init();
  }

  @override
  void dispose() {
    _downloadService.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final title = bookFieldOf(widget.data, 'title');
    final description = bookFieldOf(widget.data, 'description');
    final attachments = bookListOf(widget.data, 'attachments');
    final preparedBy = bookListOf(widget.data, 'prepared_by');
    final reference =
        preparedBy.isEmpty ? '' : bookFieldOf(preparedBy.first, 'title');

    return BlocProvider(
      create: (context) => BookBloc(
        repositoryImpl: sl.get<BookRepositoryImpl>(),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: title,
          body: ColoredBox(
            color: skin.ground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeSectionHeader(title: 'ملفّات الكتاب'),
                if (attachments.isEmpty)
                  const _InfoBlock(
                    title: 'لا توجد ملفّات',
                    body: 'لم تُرفق بهذا الكتاب ملفّات للتنزيل.',
                  )
                else
                  for (var i = 0; i < attachments.length; i++)
                    _AttachmentRow(
                      attachment: attachments[i],
                      index: i,
                      isLast: i == attachments.length - 1,
                      downloadService: _downloadService,
                    ),
                if (description.trim().isNotEmpty) ...[
                  skin.divider(),
                  const HomeSectionHeader(title: 'الوصف'),
                  _InfoBlock(body: description),
                ],
                if (reference.trim().isNotEmpty) ...[
                  skin.divider(),
                  const HomeSectionHeader(title: 'المرجع'),
                  _InfoBlock(body: reference),
                ],
                SizedBox(height: 22.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// صفّ ملفّ: وصفه وحجمه، وزرّا القراءة والتنزيل.
class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({
    required this.attachment,
    required this.index,
    required this.isLast,
    required this.downloadService,
  });

  final dynamic attachment;
  final int index;
  final bool isLast;
  final DownloadService downloadService;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final url = bookFieldOf(attachment, 'url');
    final size = bookFieldOf(attachment, 'size');
    final description = bookFieldOf(attachment, 'description').trim();
    final label = description.isEmpty ? 'الملفّ ${index + 1}' : description;

    return BookRow(
      title: label,
      subtitle: size,
      icon: AppIcons.book,
      isLast: isLast,
      onTap: url.isEmpty ? () {} : () => context.push(ReadBook(url: url)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (url.isNotEmpty)
            InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                downloadService.download(url, label);
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: AppIcon(
                  AppIcons.download,
                  color: skin.accent,
                  size: 15.sp,
                ),
              ),
            ),
          SizedBox(width: 2.w),
          AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
        ],
      ),
    );
  }
}

/// كتلة نصّ: عنوان اختياري ونصّ تحته، بلا بطاقة.
class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.body, this.title});

  final String? title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
          ],
          Text(
            body,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.88),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
