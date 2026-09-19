import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// ملخّص التنزيلات: أرقام في صفوف نحيلة، بلا بطاقات ملوّنة.
///
/// كان الملخّص ستّ مربّعات بألوان مختلفة ونصوص إنجليزية. صار صفوفًا عربية
/// تفصلها شعرة، والأرقام بخطّ ثابت العرض حتى لا تهتزّ.
class DownloadSummaryWidget extends StatelessWidget {
  const DownloadSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final running = state.downloads
            .where((task) => task.status == DownloadTaskStatus.running)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryRow(
              label: context.l10n.downloadTotal,
              value: '${state.downloads.length}',
            ),
            _SummaryRow(
              label: context.l10n.downloadStatusActive,
              value: '${state.activeDownloads.length}',
            ),
            _SummaryRow(
              label: context.l10n.downloadStatusCompleted,
              value: '${state.completedDownloads.length}',
            ),
            _SummaryRow(
              label: context.l10n.downloadStatusPaused,
              value: '${state.pausedDownloads.length}',
            ),
            _SummaryRow(
              label: context.l10n.downloadStatusFailed,
              value: '${state.failedDownloads.length}',
              isLast: running.isEmpty,
            ),
            if (running.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 7.h),
                child: Row(
                  children: [
                    Text(
                      context.l10n.downloadInProgressNow,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: skin.hairline,
                      ),
                    ),
                  ],
                ),
              ),
              for (final task in running.take(3))
                _SummaryRow(
                  label: task.fileName,
                  value: '${state.getProgressForTask(task.taskId)}%',
                  isLast: true,
                ),
              if (running.length > 3)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
                  child: Text(
                    context.l10n.downloadAndMore(running.length - 3),
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.62),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

/// صفّ ملخّص: اسم على اليمين ورقم على اليسار.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              value,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
