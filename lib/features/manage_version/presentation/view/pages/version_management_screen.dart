import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/features/manage_version/presentation/view/widgets/update_download_options_sheet.dart';

class VersionManagementScreen extends StatefulWidget {
  const VersionManagementScreen({super.key});

  @override
  State<VersionManagementScreen> createState() =>
      _VersionManagementScreenState();
}

class _VersionManagementScreenState extends State<VersionManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VersionBloc>().add(
          CheckForUpdatesEvent(forceRefresh: true, isManualCheck: true),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'إدارة الإصدارات',
      onRefresh: () async {
        context.read<VersionBloc>().add(
              CheckForUpdatesEvent(forceRefresh: true, isManualCheck: true),
            );
      },
      body: BlocConsumer<VersionBloc, VersionState>(
        listener: (context, state) {
          if (state.versionCheckState == RequestState.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: context.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final versionInfo = state.latestVersionInfo;
          final isLoading = state.versionCheckState == RequestState.loading;

          return Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusSummaryCard(state: state, isLoading: isLoading),
                SizedBox(height: 10.h),
                _VersionInfoCard(state: state, versionInfo: versionInfo),
                if (versionInfo != null) ...[
                  SizedBox(height: 10.h),
                  _ReleaseInfoCard(versionInfo: versionInfo),
                ],
                SizedBox(height: 10.h),
                _ActionsCard(
                  state: state,
                  versionInfo: versionInfo,
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  const _StatusSummaryCard({
    required this.state,
    required this.isLoading,
  });

  final VersionState state;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(context, state);

    return _CompactCard(
      child: Row(
        children: [
          _IconBadge(icon: status.icon, color: status.color),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: _titleStyle(context),
                ),
                SizedBox(height: 3.h),
                Text(
                  status.subtitle,
                  style: _subtitleStyle(context),
                ),
              ],
            ),
          ),
          if (isLoading)
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: context.primaryColor,
              ),
            )
          else
            _TinyPill(label: state.isConnected ? 'متصل' : 'بدون اتصال'),
        ],
      ),
    );
  }

  _StatusMeta _statusMeta(BuildContext context, VersionState state) {
    if (!state.isConnected) {
      return _StatusMeta(
        title: 'لا يوجد اتصال',
        subtitle: 'سيتم استخدام آخر بيانات محفوظة إن وجدت',
        icon: CupertinoIcons.wifi_slash,
        color: context.errorColor,
      );
    }
    if (state.isUpdateRequired) {
      return const _StatusMeta(
        title: 'تحديث ضروري',
        subtitle: 'يوجد إصدار مطلوب قبل متابعة الاستخدام',
        icon: CupertinoIcons.exclamationmark_triangle_fill,
        color: Colors.red,
      );
    }
    if (state.hasUpdateAvailable) {
      return const _StatusMeta(
        title: 'تحديث جديد متاح',
        subtitle: 'يمكنك تحميل الإصدار الأخير من الخيارات المتاحة',
        icon: CupertinoIcons.arrow_down_circle_fill,
        color: Colors.orange,
      );
    }
    return const _StatusMeta(
      title: 'أنت على آخر إصدار',
      subtitle: 'لا توجد تحديثات مطلوبة الآن',
      icon: CupertinoIcons.check_mark_circled_solid,
      color: Colors.green,
    );
  }
}

class _VersionInfoCard extends StatelessWidget {
  const _VersionInfoCard({
    required this.state,
    required this.versionInfo,
  });

  final VersionState state;
  final AppVersionModel? versionInfo;

  @override
  Widget build(BuildContext context) {
    return _CompactCard(
      child: Column(
        children: [
          _InfoRow(
            icon: CupertinoIcons.device_phone_portrait,
            label: 'الإصدار الحالي',
            value: state.currentVersion ??
                versionInfo?.currentVersion ??
                'غير محدد',
          ),
          _ThinDivider(),
          _InfoRow(
            icon: CupertinoIcons.cloud_download,
            label: 'آخر إصدار',
            value: versionInfo?.latestVersion ?? 'لم يتم الفحص بعد',
          ),
          if (versionInfo?.downloadSize?.trim().isNotEmpty ?? false) ...[
            _ThinDivider(),
            _InfoRow(
              icon: CupertinoIcons.archivebox,
              label: 'حجم التحميل',
              value: versionInfo!.downloadSize!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReleaseInfoCard extends StatelessWidget {
  const _ReleaseInfoCard({required this.versionInfo});

  final AppVersionModel versionInfo;

  @override
  Widget build(BuildContext context) {
    final notes = versionInfo.releaseNotes?.trim();

    return _CompactCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.doc_text_fill,
                color: context.primaryColor,
                size: 17.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'تفاصيل الإصدار',
                  style: _titleStyle(context),
                ),
              ),
              _TinyPill(label: versionInfo.updatePriority.displayText),
            ],
          ),
          if (notes?.isNotEmpty ?? false) ...[
            SizedBox(height: 8.h),
            Text(
              notes!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: _subtitleStyle(context).copyWith(height: 1.35),
            ),
          ],
          if (versionInfo.lastChecked != null) ...[
            SizedBox(height: 8.h),
            Text(
              'آخر فحص: ${_formatDateTime(versionInfo.lastChecked!)}',
              style: _captionStyle(context),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.state,
    required this.versionInfo,
    required this.isLoading,
  });

  final VersionState state;
  final AppVersionModel? versionInfo;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return _CompactCard(
      child: Column(
        children: [
          _ActionTile(
            icon: CupertinoIcons.refresh,
            title: 'فحص التحديثات',
            subtitle: 'جلب آخر بيانات من الخادم',
            enabled: !isLoading,
            onTap: () {
              context.read<VersionBloc>().add(
                    CheckForUpdatesEvent(
                      forceRefresh: true,
                      isManualCheck: true,
                    ),
                  );
            },
          ),
          if (state.hasUpdateAvailable && versionInfo != null) ...[
            _ThinDivider(),
            _ActionTile(
              icon: CupertinoIcons.arrow_down_circle,
              title: 'تحميل التحديث',
              subtitle: 'اختر منصة التحميل المناسبة',
              onTap: () => showUpdateDownloadOptionsSheet(
                context,
                versionInfo!,
              ),
            ),
            if (!state.isUpdateRequired) ...[
              _ThinDivider(),
              _ActionTile(
                icon: CupertinoIcons.forward_end,
                title: 'تخطي هذا الإصدار',
                subtitle: 'عدم عرض تنبيه لهذا الإصدار',
                onTap: () {
                  context.read<VersionBloc>().add(
                        SkipVersionEvent(version: versionInfo!.latestVersion),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تخطي هذا الإصدار'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ],
          _ThinDivider(),
          _ActionTile(
            icon: CupertinoIcons.trash,
            title: 'مسح الكاش',
            subtitle: 'حذف بيانات الإصدارات المحفوظة',
            onTap: () {
              context.read<VersionBloc>().add(ClearVersionCacheEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح ذاكرة التخزين المؤقت'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? context.primaryColor : context.onSurfaceVariant;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Row(
          children: [
            _IconBadge(
              icon: icon,
              color: color.withValues(alpha: enabled ? 1 : 0.45),
              size: 34.w,
              iconSize: 16.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _titleStyle(context).copyWith(
                      fontSize: 12.5.sp,
                      color: enabled
                          ? context.onSurfaceColor
                          : context.onSurfaceVariant.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _captionStyle(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.onSurfaceVariant.withValues(alpha: 0.32),
              size: 13.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: [
          _IconBadge(
            icon: icon,
            color: context.primaryColor,
            size: 34.w,
            iconSize: 16.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: _subtitleStyle(context),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _titleStyle(context).copyWith(fontSize: 12.5.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.surfaceColor,
            context.surfaceVariant.withValues(alpha: 0.42),
          ],
        ),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.82),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.05),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(13.w),
        child: child,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    this.size,
    this.iconSize,
  });

  final IconData icon;
  final Color color;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? 40.w;

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize ?? 18.sp,
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.16),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          color: context.primaryColor,
        ),
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      color: context.outline.withValues(alpha: 0.55),
    );
  }
}

class _StatusMeta {
  const _StatusMeta({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

TextStyle _titleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 13.5.sp,
    fontWeight: FontWeight.w800,
    color: context.onSurfaceColor,
  );
}

TextStyle _subtitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: 11.sp,
    color: context.onSurfaceVariant.withValues(alpha: 0.78),
    height: 1.25,
  );
}

TextStyle _captionStyle(BuildContext context) {
  return TextStyle(
    fontSize: 10.sp,
    color: context.onSurfaceVariant.withValues(alpha: 0.64),
  );
}

String _formatDateTime(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) return 'الآن';
  if (difference.inHours < 1) return 'منذ ${difference.inMinutes} دقيقة';
  if (difference.inDays < 1) return 'منذ ${difference.inHours} ساعة';
  return 'منذ ${difference.inDays} يوم';
}
