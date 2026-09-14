import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfx/pdfx.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

/// قارئ الكتب (PDF).
///
/// كانت الشاشة تفتح صندوقًا فارغًا بحدّ رمادي لأن العارض كان معطّلاً. صارت
/// تعرض الملفّ نفسه على أرضية التطبيق، وإن تعذّر فتحه ظهر سطر واحد يشرح
/// السبب ويعرض فتحه خارج التطبيق.
class ReadBook extends StatefulWidget {
  const ReadBook({super.key, this.url = ''});

  final String url;

  @override
  State<ReadBook> createState() => _ReadBookState();
}

class _ReadBookState extends State<ReadBook> {
  PdfController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _controller = PdfController(document: PdfDocument.openData(_load()));
    } else {
      _failed = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<Uint8List> _load() async {
    final response = await Dio().get<List<int>>(
      widget.url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? <int>[]);
  }

  void _markFailed() {
    if (!_failed && mounted) {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final controller = _controller;

    return Scaffold(
      backgroundColor: skin.ground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(url: widget.url),
            Divider(height: 1, thickness: 1, color: skin.hairline),
            Expanded(
              child: (_failed || controller == null)
                  ? _OpenOutsideNote(url: widget.url)
                  : PdfView(
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      backgroundDecoration: BoxDecoration(color: skin.ground),
                      onDocumentError: (_) => _markFailed(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شريط علوي نحيل: رجوع وعنوان، بلا ظلّ ولا ارتفاع.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
      child: Row(
        children: [
          IconButton(
            onPressed: context.pop,
            tooltip: 'رجوع',
            icon: AppIcon(AppIcons.backRight, color: skin.ink, size: 18.sp),
          ),
          Expanded(
            child: Text(
              'قراءة الكتاب',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (url.isNotEmpty)
            InkWell(
              onTap: () => UrlLauncherUtils.launchWebUrl(url),
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: AppIcon(AppIcons.share, color: skin.accent, size: 15.sp),
              ),
            ),
        ],
      ),
    );
  }
}

/// بديل العارض عند تعذّره: سطر واحد وزرّ فتح خارجي.
class _OpenOutsideNote extends StatelessWidget {
  const _OpenOutsideNote({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.book, color: skin.accent, size: 22.sp),
            SizedBox(height: 10.h),
            Text(
              'تعذّر عرض الكتاب داخل التطبيق',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (url.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                'يمكنك فتحه خارج التطبيق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: () => UrlLauncherUtils.launchWebUrl(url),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: skin.iconChip,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'فتح خارج التطبيق',
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
