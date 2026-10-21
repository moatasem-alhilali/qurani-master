import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_scheduler.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_settings_store.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_source.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// اسم المصدر ووصفه بلغة الواجهة.
extension AyahReminderSourceLabel on AyahReminderSource {
  String label(L10n l10n) => switch (this) {
        AyahReminderSource.continueReading => l10n.ayahReminderSourceContinue,
        AyahReminderSource.random => l10n.ayahReminderSourceRandom,
      };

  String hint(L10n l10n) => switch (this) {
        AyahReminderSource.continueReading =>
          l10n.ayahReminderSourceContinueHint,
        AyahReminderSource.random => l10n.ayahReminderSourceRandomHint,
      };
}

/// صفّ «مصدر الآية» تحت صفّ إشعار آية اليوم.
///
/// صفٌّ ظاهر لا خيارٌ مدفون في نافذة الجدولة: المصدر هو ما يحدّد قيمة
/// الإشعار كلّه، فمن يشغّله يحتاج أن يراه في الموضع نفسه.
class AyahReminderSourceRow extends StatefulWidget {
  const AyahReminderSourceRow({required this.isLast, super.key});

  final bool isLast;

  @override
  State<AyahReminderSourceRow> createState() => _AyahReminderSourceRowState();
}

class _AyahReminderSourceRowState extends State<AyahReminderSourceRow> {
  final AyahReminderSettingsStore _store = AyahReminderSettingsStore();

  late AyahReminderSource _source = _store.readSource();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsRow(
      icon: AppIcons.quran,
      title: l10n.ayahReminderSourceTitle,
      subtitle: _source.label(l10n),
      isLast: widget.isLast,
      onTap: _openPicker,
    );
  }

  Future<void> _openPicker() async {
    final l10n = context.l10n;

    final picked = await showSettingsSheet<AyahReminderSource>(
      context: context,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SettingsSheetHeader(title: l10n.ayahReminderSourceTitle),
          for (final source in AyahReminderSource.values)
            SettingsRow(
              icon: source == _source ? AppIcons.check : AppIcons.quran,
              title: source.label(l10n),
              subtitle: source.hint(l10n),
              active: source == _source,
              isLast: source == AyahReminderSource.values.last,
              onTap: () => Navigator.of(sheetContext).pop(source),
            ),
          SizedBox(height: 10.h),
        ],
      ),
    );

    if (picked == null || picked == _source) return;

    await _store.writeSource(picked);
    // الطابور المجدول مبنيّ على المصدر القديم، فيُعاد بناؤه الآن لا عند
    // إقلاع التطبيق المقبل.
    await sl<AyahReminderScheduler>().reschedule();

    if (!mounted) return;
    setState(() => _source = picked);
  }
}
