import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';

class FloatingAdhkarSettingsScreen extends StatefulWidget {
  const FloatingAdhkarSettingsScreen({super.key});

  @override
  State<FloatingAdhkarSettingsScreen> createState() =>
      _FloatingAdhkarSettingsScreenState();
}

class _FloatingAdhkarSettingsScreenState
    extends State<FloatingAdhkarSettingsScreen> {
  late FloatingAdhkarSettings _draft;

  static const List<int> _intervalOptions = [1, 5, 10, 15, 30, 45, 60, 90, 120];
  static const List<int> _visibleOptions = [10, 15, 20, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    final state = context.read<FloatingAdhkarBloc>().state;
    _draft = state.settings ?? FloatingAdhkarSettings.defaults();
  }

  @override
  Widget build(BuildContext context) {
    final isIosReminderMode =
        context.watch<FloatingAdhkarBloc>().state.usesIosReminders;

    return AppScaffoldWidget(
      title: isIosReminderMode
          ? 'إعدادات تذكيرات الأذكار'
          : 'إعدادات الأذكار العائمة',
      showLargeHeader: false,
      initialOffset: null,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                ),
              ),
              child: SwitchListTile(
                dense: true,
                secondary: AppIcon(
                  AppIcons.power,
                  color: _draft.enabled
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 13.r,
                  strokeWidth: 1.55,
                ),
                value: _draft.enabled,
                onChanged: (value) {
                  setState(() {
                    _draft = _draft.copyWith(enabled: value);
                  });
                },
                title: Text(
                  'تشغيل الميزة بالكامل',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isIosReminderMode
                      ? 'عند التفعيل يتم جدولة تنبيهات أذكار على iPhone'
                      : 'عند التفعيل تبدأ الخدمة الخلفية في الظهور',
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            _SectionCard(
              title: isIosReminderMode ? 'توقيت التذكير' : 'توقيت الظهور',
              icon: AppIcons.clock,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isIosReminderMode
                        ? 'معدل تكرار التنبيه:'
                        : 'معدل تكرار الظهور:',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _intervalOptions.map((value) {
                      final selected = _draft.intervalMinutes == value;
                      return ChoiceChip(
                        label: Text(
                          _formatIntervalLabel(value),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: selected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        selected: selected,
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (_) {
                          setState(() {
                            _draft = _draft.copyWith(intervalMinutes: value);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (!isIosReminderMode) ...[
                    Divider(
                      height: 20.h,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.08),
                    ),
                    Text(
                      'مدة بقاء الذكر (بالثواني):',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _visibleOptions.map((value) {
                        final selected = _draft.visibleSeconds == value;
                        return ChoiceChip(
                          label: Text(
                            '$value ث',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: selected
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                            ),
                          ),
                          selected: selected,
                          selectedColor: Theme.of(context).primaryColor,
                          onSelected: (_) {
                            setState(() {
                              _draft = _draft.copyWith(visibleSeconds: value);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10.h),
            _SectionCard(
              title: 'مصادر الأذكار',
              icon: AppIcons.source,
              child: Column(
                children: [
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: _draft.includeBuiltIn,
                    onChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(includeBuiltIn: value);
                      });
                    },
                    title: Text(
                      'الأذكار الافتراضية',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'المصدر الداخلي الأساسي للتطبيق',
                      style: TextStyle(fontSize: 11.sp),
                    ),
                  ),
                  Divider(
                    height: 12.h,
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  ),
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: _draft.includeCustom,
                    onChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(includeCustom: value);
                      });
                    },
                    title: Text(
                      'أذكاري الخاصة',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'الأذكار التي قمت بإضافتها يدوياً',
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                  if (_draft.includeBuiltIn && _draft.includeCustom) ...[
                    Divider(
                      height: 12.h,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.05),
                    ),
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _draft.mixSources,
                      onChanged: (value) {
                        setState(() {
                          _draft = _draft.copyWith(mixSources: value);
                        });
                      },
                      title: Text(
                        'الخلط بين المصادر',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _draft.mixSources
                            ? 'يتم الاختيار من قائمة موحدة.'
                            : 'يتم التناوب بين الافتراضي والمخصص.',
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: _saveSettings,
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(38.h),
                padding: EdgeInsets.symmetric(vertical: 0.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              icon: const AppIcon(AppIcons.save, size: 13),
              label: Text(
                'حفظ الإعدادات',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    if (!_draft.hasAnySource) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فعّل مصدرًا واحدًا على الأقل قبل الحفظ.'),
        ),
      );
      return;
    }

    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarUpdateSettingsEvent(_draft),
        );
    Navigator.of(context).pop();
  }

  String _formatIntervalLabel(int minutes) {
    if (minutes == 1) {
      return 'كل دقيقة';
    }

    return 'كل $minutes دقائق';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final HugeIconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: accent.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(
                icon,
                size: 12.5.r,
                color: accent,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 7.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 11.h),
          child,
        ],
      ),
    );
  }
}
