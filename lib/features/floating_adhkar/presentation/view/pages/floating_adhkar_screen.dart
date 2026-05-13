import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
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
                icon: const Icon(Icons.menu_book_rounded),
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
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: settings == null && state.loadState == RequestState.loading
              ? const Center(child: CircularProgressIndicator())
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusAndStatsHeader(state: state),
          SizedBox(height: 16.h),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.15)),
            ),
            child: SwitchListTile(
              secondary: Icon(
                Icons.power_settings_new_rounded,
                color: settings.enabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 22.r,
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
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _featureSubtitle(state),
                style: TextStyle(fontSize: 11.sp),
              ),
            ),
          ),

          SizedBox(height: 16.h),
          _PreviewCard(item: state.previewItem),
          SizedBox(height: 12.h),

          // Advanced Settings Toggle
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAdvancedSettings = !_showAdvancedSettings;
                });
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(
                      _showAdvancedSettings
                          ? Icons.settings_suggest_rounded
                          : Icons.settings_outlined,
                      size: 18.r,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'إعدادات متقدمة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _showAdvancedSettings
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_showAdvancedSettings) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.12)),
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.timer_outlined,
                    title: 'معدل الظهور',
                    subtitle: _formatIntervalText(settings.intervalMinutes),
                  ),
                  Divider(
                      height: 24.h,
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  if (!isIosReminderMode) ...[
                    _SettingsTile(
                      icon: Icons.visibility_outlined,
                      title: 'مدة بقاء الذكر',
                      subtitle: '${settings.visibleSeconds} ثانية',
                    ),
                    Divider(
                        height: 24.h,
                        color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  ],
                  _SettingsTile(
                    icon: Icons.merge_type_rounded,
                    title: 'مصادر الأذكار',
                    subtitle: _describeSources(settings),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 24.h),

          FilledButton.icon(
            onPressed: settings.enabled && state.hasOverlayPermission
                ? () {
                    context
                        .read<FloatingAdhkarBloc>()
                        .add(const FloatingAdhkarPreviewNowEvent());
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
            ),
            icon: Icon(Icons.play_circle_outline_rounded, size: 20.r),
            label: Text(isIosReminderMode ? 'إرسال ذكر الآن' : 'عرض ذكر الآن',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
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
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
                icon:
                    Icon(Icons.security_rounded, size: 20.r, color: Colors.red),
                label: Text(
                    isIosReminderMode
                        ? 'السماح بالإشعارات'
                        : 'منح الصلاحية المطلوبة',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
            ),
            icon: Icon(Icons.edit_note_rounded, size: 20.r),
            label: Text('إدارة الأذكار',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accent.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child:
                    Icon(Icons.layers_clear_rounded, color: accent, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة الخدمة',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _HeaderStatItem(
                  title: 'الافتراضية',
                  value: '${state.counts.builtInCount}',
                  icon: Icons.auto_awesome_rounded,
                ),
              ),
              Container(width: 1, height: 30.h, color: accent.withOpacity(0.1)),
              Expanded(
                child: _HeaderStatItem(
                  title: 'الخاصة',
                  value:
                      '${state.counts.customEnabledCount}/${state.counts.customTotalCount}',
                  icon: Icons.menu_book_rounded,
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
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 14.r,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18.r, color: Theme.of(context).primaryColor.withOpacity(0.8)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                      color: accent,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                source,
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
