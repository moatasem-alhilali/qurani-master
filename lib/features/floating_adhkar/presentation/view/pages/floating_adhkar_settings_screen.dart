import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
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
    return AppScaffoldWidget(
      title: 'إعدادات الأذكار العائمة',
      showLargeHeader: false,
      initialOffset: null,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionCard(
              title: 'التشغيل العام',
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: _draft.enabled,
                    onChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(enabled: value);
                      });
                    },
                    title: const Text('تشغيل الميزة بالكامل'),
                    subtitle: const Text(
                      'عند التفعيل تبدأ الخدمة الخلفية '
                      'وتنتظر وقت العرض التالي.',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'معدل الظهور',
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _intervalOptions.map((value) {
                  return ChoiceChip(
                    label: Text(_formatIntervalLabel(value)),
                    selected: _draft.intervalMinutes == value,
                    onSelected: (_) {
                      setState(() {
                        _draft = _draft.copyWith(intervalMinutes: value);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'مدة بقاء الذكر ظاهرًا',
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _visibleOptions.map((value) {
                  return ChoiceChip(
                    label: Text('$value ث'),
                    selected: _draft.visibleSeconds == value,
                    onSelected: (_) {
                      setState(() {
                        _draft = _draft.copyWith(visibleSeconds: value);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'مصادر الأذكار',
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: _draft.includeBuiltIn,
                    onChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(includeBuiltIn: value);
                      });
                    },
                    title: const Text('إظهار الأذكار الافتراضية'),
                    subtitle: const Text(
                      'من المصدر الداخلي القصير والمنظم داخل التطبيق.',
                    ),
                  ),
                  SwitchListTile.adaptive(
                    value: _draft.includeCustom,
                    onChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(includeCustom: value);
                      });
                    },
                    title: const Text('إظهار أذكاري الخاصة'),
                    subtitle: const Text(
                      'يدخل ما أضفته بنفسك ضمن الدوران العشوائي.',
                    ),
                  ),
                  if (_draft.includeBuiltIn && _draft.includeCustom)
                    SwitchListTile.adaptive(
                      value: _draft.mixSources,
                      onChanged: (value) {
                        setState(() {
                          _draft = _draft.copyWith(mixSources: value);
                        });
                      },
                      title: const Text('الخلط بين المصدرين'),
                      subtitle: Text(
                        _draft.mixSources
                            ? 'يتم الاختيار من قائمة موحدة.'
                            : 'يتم التناوب بين الافتراضي والمخصص.',
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton(
              onPressed: _saveSettings,
              child: const Text('حفظ الإعدادات'),
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
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
    );
  }
}
