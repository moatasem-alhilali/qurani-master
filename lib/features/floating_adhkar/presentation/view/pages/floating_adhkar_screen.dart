import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_my_adhkar_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_settings_screen.dart';

class FloatingAdhkarScreen extends StatelessWidget {
  const FloatingAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FloatingAdhkarBloc, FloatingAdhkarState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null || message.trim().isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final settings = state.settings;

        return AppScaffoldWidget(
          title: 'الأذكار العشوائية العائمة',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context
                .read<FloatingAdhkarBloc>()
                .add(const FloatingAdhkarLoadEvent());
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'إدارة الأذكار',
                onPressed: () {
                  context.push(
                    BlocProvider.value(
                      value: context.read<FloatingAdhkarBloc>(),
                      child: const FloatingAdhkarMyAdhkarScreen(),
                    ),
                  );
                },
                icon: const AppIcon(AppIcons.bookOpen, size: 15),
              ),
              IconButton(
                tooltip: 'الإعدادات',
                onPressed: settings == null
                    ? null
                    : () {
                        context.push(
                          BlocProvider.value(
                            value: context.read<FloatingAdhkarBloc>(),
                            child: const FloatingAdhkarSettingsScreen(),
                          ),
                        );
                      },
                icon: const AppIcon(AppIcons.sliders, size: 15),
              ),
            ],
          ),
          body: settings == null && state.loadState == RequestState.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : _Body(state: state),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.state});
  final FloatingAdhkarState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _showAdvancedSettings = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final settings = state.settings;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    final isIosReminderMode = state.usesIosReminders;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusAndStatsHeader(state: state),
          SizedBox(height: 10.h),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
              ),
            ),
            child: SwitchListTile(
              secondary: AppIcon(
                AppIcons.power,
                color: settings.enabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 15.r,
                strokeWidth: 1.55,
              ),
              value: settings.enabled,
              onChanged: state.isSupportedPlatform
                  ? (value) {
                      context.read<FloatingAdhkarBloc>().add(
                            FloatingAdhkarToggleFeatureEvent(value),
                          );
                    }
                  : null,
              title: Text(
                isIosReminderMode
                    ? 'تشغيل تذكيرات iPhone'
                    : 'تشغيل الخدمة العائمة',
                style:
                    TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _featureSubtitle(state),
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
          ),

          SizedBox(height: 10.h),
          _PreviewCard(item: state.previewItem),
          SizedBox(height: 10.h),

          // Advanced Settings Toggle
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAdvancedSettings = !_showAdvancedSettings;
                });
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 11.w),
                child: Row(
                  children: [
                    AppIcon(
                      AppIcons.settings,
                      size: 13.r,
                      strokeWidth: 1.55,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'إعدادات متقدمة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    const Spacer(),
                    AppIcon(
                      _showAdvancedSettings ? AppIcons.up : AppIcons.down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 13.r,
                      strokeWidth: 1.55,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_showAdvancedSettings) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                ),
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: AppIcons.clock,
                    title: 'معدل الظهور',
                    subtitle: _formatIntervalText(settings.intervalMinutes),
                  ),
                  Divider(
                    height: 18.h,
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.08),
                  ),
                  if (!isIosReminderMode) ...[
                    _SettingsTile(
                      icon: AppIcons.eye,
                      title: 'مدة بقاء الذكر',
                      subtitle: '${settings.visibleSeconds} ثانية',
                    ),
                    Divider(
                      height: 18.h,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.08),
                    ),
                  ],
                  _SettingsTile(
                    icon: AppIcons.source,
                    title: 'مصادر الأذكار',
                    subtitle: _describeSources(settings),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16.h),

          FilledButton.icon(
            onPressed: settings.enabled && state.hasOverlayPermission
                ? () {
                    context
                        .read<FloatingAdhkarBloc>()
                        .add(const FloatingAdhkarPreviewNowEvent());
                  }
                : null,
            style: FilledButton.styleFrom(
              minimumSize: Size.fromHeight(38.h),
              padding: EdgeInsets.symmetric(vertical: 0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.r),
              ),
            ),
            icon: const AppIcon(AppIcons.play, size: 13),
            label: Text(
              isIosReminderMode ? 'إرسال ذكر الآن' : 'عرض ذكر الآن',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 12.h),

          if (state.isSupportedPlatform && !state.hasOverlayPermission)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<FloatingAdhkarBloc>().add(
                        const FloatingAdhkarRequestOverlayPermissionEvent(),
                      );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(38.h),
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.45)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                ),
                icon: const AppIcon(
                  AppIcons.security,
                  size: 13,
                  color: Colors.red,
                ),
                label: Text(
                  isIosReminderMode
                      ? 'السماح بالإشعارات'
                      : 'منح الصلاحية المطلوبة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          OutlinedButton.icon(
            onPressed: () {
              context.push(
                BlocProvider.value(
                  value: context.read<FloatingAdhkarBloc>(),
                  child: const FloatingAdhkarMyAdhkarScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.r),
              ),
            ),
            icon: const AppIcon(AppIcons.noteEdit, size: 13),
            label: Text(
              'إدارة الأذكار',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

String _featureSubtitle(FloatingAdhkarState state) {
  if (!state.isSupportedPlatform) {
    return 'غير مدعوم على هذه المنصة';
  }
  if (state.usesIosReminders) {
    return 'إرسال أذكار متكررة كتنبيهات على iPhone';
  }
  return 'عرض ذكر عشوائي فوق التطبيقات';
}

String _describeSources(FloatingAdhkarSettings settings) {
  if (settings.includeBuiltIn && settings.includeCustom) {
    return settings.mixSources
        ? 'دمج بين الافتراضي والمخصص'
        : 'تناوب بين الافتراضي والمخصص';
  }
  if (settings.includeBuiltIn) {
    return 'الأذكار الافتراضية فقط';
  }
  if (settings.includeCustom) {
    return 'أذكار المستخدم فقط';
  }
  return 'لا يوجد مصدر مفعّل';
}

String _formatIntervalText(int minutes) {
  if (minutes == 1) {
    return 'كل دقيقة';
  }

  return 'كل $minutes دقائق';
}

class _StatusAndStatsHeader extends StatelessWidget {
  const _StatusAndStatsHeader({required this.state});

  final FloatingAdhkarState state;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).primaryColor;
    final status = state.status;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: AppIcon(
                  AppIcons.layers,
                  color: accent,
                  size: 13.r,
                  strokeWidth: 1.55,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة الخدمة',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 11.h),
          Row(
            children: [
              Expanded(
                child: _HeaderStatItem(
                  title: 'الافتراضية',
                  value: '${state.counts.builtInCount}',
                  icon: AppIcons.tasbih,
                ),
              ),
              Container(
                width: 1,
                height: 26.h,
                color: accent.withValues(alpha: 0.08),
              ),
              Expanded(
                child: _HeaderStatItem(
                  title: 'الخاصة',
                  value:
                      '${state.counts.customEnabledCount}/${state.counts.customTotalCount}',
                  icon: AppIcons.bookOpen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStatItem extends StatelessWidget {
  const _HeaderStatItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: 11.5.r,
              strokeWidth: 1.55,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.70),
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(
          icon,
          size: 12.5.r,
          strokeWidth: 1.55,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.80),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                subtitle,
                style:
                    TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.item});

  final FloatingAdhkarItem? item;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).primaryColor;
    final text = item?.text.trim().isNotEmpty ?? false
        ? item!.text
        : 'اللهم أعني على ذكرك وشكرك وحسن عبادتك';
    final title = item?.title ?? 'معاينة شكل البطاقة';
    final source = item?.sourceLabel ?? 'افتراضي';

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                source,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 9.5.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
