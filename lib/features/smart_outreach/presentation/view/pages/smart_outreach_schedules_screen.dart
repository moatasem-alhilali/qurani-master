import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_permission_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_settings_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_upsert_schedule_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_schedule_item_card.dart';

class SmartOutreachSchedulesScreen extends StatelessWidget {
  const SmartOutreachSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmartOutreachSchedulesBloc>(
      create: (_) => sl<SmartOutreachSchedulesBloc>()
        ..add(const LoadSmartOutreachSchedulesEvent()),
      child: const _SmartOutreachSchedulesView(),
    );
  }
}

class _SmartOutreachSchedulesView extends StatefulWidget {
  const _SmartOutreachSchedulesView();

  @override
  State<_SmartOutreachSchedulesView> createState() =>
      _SmartOutreachSchedulesViewState();
}

class _SmartOutreachSchedulesViewState
    extends State<_SmartOutreachSchedulesView> with WidgetsBindingObserver {
  final SmartOutreachPermissionService _permissionService =
      SmartOutreachPermissionService();

  SmartOutreachPermissionSnapshot? _permissionSnapshot;
  bool _isCheckingPermissions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensurePermissions(requestIfNeeded: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmartOutreachSchedulesBloc,
        SmartOutreachSchedulesState>(
      listener: (context, state) {
        if (state.validationErrors.isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.validationErrors.join('\n'))),
          );

        context
            .read<SmartOutreachSchedulesBloc>()
            .add(const ClearSmartOutreachScheduleFeedbackEvent());
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          title: 'المكالمات المجدولة',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context
                .read<SmartOutreachSchedulesBloc>()
                .add(const LoadSmartOutreachSchedulesEvent());
          },
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openUpsertScreen(context),
            child: const AppIcon(AppIcons.add),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    final permissionCard = _buildPermissionsCard();
    final enabledCount =
        state.schedules.where((bundle) => bundle.schedule.isEnabled).length;
    final contactsCount = state.schedules.fold<int>(
      0,
      (total, bundle) => total + bundle.contacts.length,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OutreachHero(
            total: state.schedules.length,
            enabled: enabledCount,
            contacts: contactsCount,
          ),
          if (permissionCard != null) ...[
            SizedBox(height: 10.h),
            permissionCard,
          ],
          SizedBox(height: 10.h),
          Row(
            children: <Widget>[
              Expanded(
                child: _QuickAction(
                  icon: AppIcons.clock,
                  label: 'السجل',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SmartOutreachCallLogsScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _QuickAction(
                  icon: AppIcons.settings,
                  label: 'الإعدادات',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SmartOutreachSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const _SectionHeader(
            title: 'قوائم الاتصال',
            subtitle: 'تشغيل سريع وتعديل مختصر لكل قائمة',
          ),
          SizedBox(height: 10.h),
          _buildContent(context, state),
          SizedBox(height: 38.h),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    if (state.loadState == RequestState.loading && state.schedules.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h),
        child: Center(
          child: CircularProgressIndicator(color: context.primaryColor),
        ),
      );
    }

    if (state.schedules.isEmpty) {
      return _EmptySchedulesCard(onTap: () => _openUpsertScreen(context));
    }

    return Column(
      children: state.schedules.asMap().entries.map((entry) {
        final index = entry.key;
        final bundle = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == state.schedules.length - 1 ? 0 : 10.h,
          ),
          child: SmartOutreachScheduleItemCard(
            bundle: bundle,
            onTap: () => _openUpsertScreen(context, bundle: bundle),
            onStart: () => _handleStartNow(context, bundle.schedule.id!),
            onDelete: () {
              context.read<SmartOutreachSchedulesBloc>().add(
                    DeleteSmartOutreachScheduleEvent(bundle.schedule.id!),
                  );
            },
            onToggle: (enabled) => _handleToggle(
              context,
              scheduleId: bundle.schedule.id!,
              enabled: enabled,
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _openUpsertScreen(
    BuildContext context, {
    SmartOutreachScheduleBundle? bundle,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: SmartOutreachUpsertScheduleScreen(initialBundle: bundle),
        ),
      ),
    );

    bloc.add(const LoadSmartOutreachSchedulesEvent(changeState: false));
  }

  Future<void> _openExecution(BuildContext context, int scheduleId) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SmartOutreachExecutionScreen(scheduleId: scheduleId),
      ),
    );
    if (context.mounted) {
      context
          .read<SmartOutreachSchedulesBloc>()
          .add(const LoadSmartOutreachSchedulesEvent(changeState: false));
    }
  }

  Future<void> _refreshPermissions() async {
    final status = await _permissionService.getCurrentStatus();
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionSnapshot = status;
    });
  }

  Future<bool> _ensurePermissions({required bool requestIfNeeded}) async {
    if (_isCheckingPermissions) {
      return _permissionSnapshot?.allGranted ?? false;
    }

    _isCheckingPermissions = true;
    try {
      final status = requestIfNeeded
          ? await _permissionService.requestRequiredPermissions()
          : await _permissionService.getCurrentStatus();

      if (!mounted) {
        return status.allGranted;
      }

      setState(() {
        _permissionSnapshot = status;
      });

      if (!status.allGranted) {
        _showPermissionsMessage(status);
      }

      return status.allGranted;
    } finally {
      _isCheckingPermissions = false;
    }
  }

  void _showPermissionsMessage(SmartOutreachPermissionSnapshot status) {
    final missing = status.missingPermissionLabels.join('، ');
    if (missing.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('لازم تفعيل هذه الصلاحيات أولًا: $missing'),
        ),
      );
  }

  Widget? _buildPermissionsCard() {
    final snapshot = _permissionSnapshot;
    if (snapshot == null || snapshot.allGranted) {
      return null;
    }

    final missing = snapshot.missingPermissionLabels.join('، ');

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: context.errorContainer.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: context.errorColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              AppIcon(
                AppIcons.shield,
                color: context.errorColor,
                size: 16.sp,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'الصلاحيات المطلوبة غير مكتملة',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Text(
            'لتشغيل المكالمات المجدولة بشكل صحيح، فعّل: $missing',
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 10.sp,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: <Widget>[
              Expanded(
                child: _PermissionButton(
                  label: 'منح الصلاحيات',
                  icon: AppIcons.shield,
                  filled: true,
                  onTap: () => _ensurePermissions(requestIfNeeded: true),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _PermissionButton(
                  label: 'الإعدادات',
                  icon: AppIcons.settings,
                  onTap: _permissionService.openSettings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartNow(BuildContext context, int scheduleId) async {
    final ready = await _ensurePermissions(requestIfNeeded: true);
    if (!ready || !context.mounted) {
      return;
    }
    await _openExecution(context, scheduleId);
  }

  Future<void> _handleToggle(
    BuildContext context, {
    required int scheduleId,
    required bool enabled,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();

    if (enabled) {
      final ready = await _ensurePermissions(requestIfNeeded: true);
      if (!ready || !context.mounted) {
        return;
      }
    }

    bloc.add(
      ToggleSmartOutreachScheduleEnabledEvent(
        scheduleId: scheduleId,
        enabled: enabled,
      ),
    );
  }
}

class _OutreachHero extends StatelessWidget {
  const _OutreachHero({
    required this.total,
    required this.enabled,
    required this.contacts,
  });

  final int total;
  final int enabled;
  final int contacts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: AppIcon(
                  AppIcons.phone,
                  color: context.primaryColor,
                  size: 18.sp,
                  strokeWidth: 1.55,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'صحبة الفجر',
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'قوائم اتصال هادئة ومنظمة',
                      style: TextStyle(
                        color: context.onSurfaceVariant,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _HeroStat(label: 'القوائم', value: '$total')),
              SizedBox(width: 8.w),
              Expanded(child: _HeroStat(label: 'المفعلة', value: '$enabled')),
              SizedBox(width: 8.w),
              Expanded(child: _HeroStat(label: 'الأرقام', value: '$contacts')),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14.r),
          border:
              Border.all(color: context.outlineVariant.withValues(alpha: 0.24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              color: context.primaryColor,
              size: 14.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 7.w),
            Text(
              label,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.onSurfaceVariant,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptySchedulesCard extends StatelessWidget {
  const _EmptySchedulesCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border:
            Border.all(color: context.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        children: [
          AppIcon(
            AppIcons.contacts,
            color: context.primaryColor,
            size: 24.sp,
            strokeWidth: 1.55,
          ),
          SizedBox(height: 9.h),
          Text(
            'لا توجد قوائم مكالمات حتى الآن.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'أضف قائمة وحدد الوقت والأرقام التي تريد الاتصال بها.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          _PermissionButton(
            label: 'إضافة قائمة',
            icon: AppIcons.add,
            filled: true,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _PermissionButton extends StatelessWidget {
  const _PermissionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: filled
              ? context.primaryColor
              : context.primaryColor.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              icon,
              color: filled ? context.onPrimaryColor : context.primaryColor,
              size: 13.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: filled ? context.onPrimaryColor : context.primaryColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
