part of 'next_prayer_countdown_widget.dart';

class _PrayerMiniEntry {
  const _PrayerMiniEntry({
    required this.name,
    required this.time,
    required this.type,
    required this.isCurrent,
    required this.isNext,
  });

  final String name;
  final String time;
  final Prayer type;
  final bool isCurrent;
  final bool isNext;

  /// اسم الصلاة بلغة الواجهة؛ [name] يبقى احتياطًا لغير الصلوات المعروفة.
  String displayName(L10n l10n) =>
      type == Prayer.none ? name : l10n.prayerName(type.name);
}

class _ResolvedPrayerState {
  const _ResolvedPrayerState({
    this.currentPrayer,
    this.nextPrayer,
  });

  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
}

class _LocationNoticeAction {
  const _LocationNoticeAction({
    required this.label,
    required this.onTap,
    this.isRefreshIcon = false,
  });

  final String label;
  final VoidCallback onTap;

  /// إذا كان [true] تُعرض أيقونة إعادة التحميل بدلاً من نص الزر.
  final bool isRefreshIcon;
}

class _LocationNoticeConfig {
  const _LocationNoticeConfig({
    required this.message,
    this.primaryAction,
    this.secondaryAction,
  });

  final String message;
  final _LocationNoticeAction? primaryAction;
  final _LocationNoticeAction? secondaryAction;
}
