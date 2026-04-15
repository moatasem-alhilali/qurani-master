part of 'next_prayer_countdown_widget.dart';

DateTime _resolveLocationNowFromOffset(int? offsetMinutes) {
  if (offsetMinutes == null) {
    return DateTime.now();
  }
  return DateTime.now().toUtc().add(Duration(minutes: offsetMinutes));
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatClock12(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
}

String _formatPrayerTime12(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final time = '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
  final period = date.hour < 12 ? '' : '';
  return '$time $period';
}

String _formatFallbackTime12(String input) {
  final normalized = input.trim();
  final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(normalized);
  if (match == null) {
    return normalized;
  }

  final hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');
  if (hour == null || minute == null || hour < 0 || hour > 23) {
    return normalized;
  }

  return _formatPrayerTime12(DateTime(2025, 1, 1, hour, minute));
}

String _buildCountdownLine(String prayerName, Duration remaining) {
  if (remaining.inSeconds <= 0) {
    return 'حان الآن وقت $prayerName';
  }

  final totalMinutes = remaining.inMinutes;
  if (totalMinutes < 1) {
    return '$prayerName بعد أقل من دقيقة';
  }

  if (totalMinutes < 60) {
    return '$prayerName بعد $totalMinutes دقيقة';
  }

  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes.remainder(60);
  if (minutes == 0) {
    return '$prayerName بعد $hours ساعة';
  }

  return '$prayerName بعد $hours س $minutes د';
}

IconData _iconForPrayer(Prayer prayer) {
  switch (prayer) {
    case Prayer.none:
      return Icons.access_time_rounded;
    case Prayer.fajr:
      return Icons.wb_twilight_rounded;
    case Prayer.sunrise:
      return Icons.wb_sunny_outlined;
    case Prayer.dhuhr:
      return Icons.light_mode_rounded;
    case Prayer.asr:
      return Icons.wb_sunny_rounded;
    case Prayer.maghrib:
      return Icons.brightness_5_rounded;
    case Prayer.isha:
      return Icons.nightlight_round;
  }
}

_ResolvedPrayerState _resolvePrayerStateFromList({
  required List<PrayerInfoModel> prayerTimes,
  required PrayerInfoModel? currentPrayerInfo,
  required PrayerInfoModel? nextPrayerInfo,
  required DateTime locationNow,
}) {
  PrayerInfoModel? currentPrayer;
  PrayerInfoModel? nextPrayer;

  if (prayerTimes.isNotEmpty) {
    PrayerInfoModel? computedCurrent;
    PrayerInfoModel? computedNext;

    for (final prayer in prayerTimes) {
      if (prayer.time.isAfter(locationNow)) {
        computedNext ??= prayer;
      } else {
        computedCurrent = prayer;
      }
    }

    if (computedNext == null) {
      final fajr = prayerTimes
          .where((p) => p.type == Prayer.fajr)
          .cast<PrayerInfoModel?>()
          .firstWhere(
            (p) => p != null,
            orElse: () => null,
          );
      if (fajr != null) {
        computedNext = PrayerInfoModel(
          id: fajr.id,
          type: fajr.type,
          name: fajr.name,
          description: fajr.description,
          time: fajr.time.add(const Duration(days: 1)),
        );
      }
    }

    currentPrayer = computedCurrent;
    nextPrayer = computedNext;
  }

  currentPrayer ??= currentPrayerInfo;
  nextPrayer ??= nextPrayerInfo;

  return _ResolvedPrayerState(
    currentPrayer: currentPrayer,
    nextPrayer: nextPrayer,
  );
}

bool _isSamePrayerOccurrence(
  PrayerInfoModel prayer,
  PrayerInfoModel? target,
) {
  if (target == null) return false;
  return prayer.type == target.type &&
      prayer.time.year == target.time.year &&
      prayer.time.month == target.time.month &&
      prayer.time.day == target.time.day &&
      prayer.time.hour == target.time.hour &&
      prayer.time.minute == target.time.minute;
}

bool _isNextPrayerTile(PrayerInfoModel prayer, PrayerInfoModel? nextPrayer) {
  if (_isSamePrayerOccurrence(prayer, nextPrayer)) return true;
  if (nextPrayer == null) return false;

  // Handles the end-of-day case where next prayer is tomorrow's Fajr.
  if (nextPrayer.type == Prayer.fajr && prayer.type == Prayer.fajr) {
    return true;
  }
  return false;
}

List<_PrayerMiniEntry> _buildPrayerEntries({
  required List<PrayerInfoModel> prayerTimes,
  required PrayerInfoModel? currentPrayer,
  required PrayerInfoModel? nextPrayer,
  required TimePrayerModel fallbackNextPrayer,
}) {
  if (prayerTimes.isNotEmpty) {
    return prayerTimes
        .map(
          (prayer) => _PrayerMiniEntry(
            name: prayer.name,
            time: _formatPrayerTime12(prayer.time),
            type: prayer.type,
            isCurrent: _isSamePrayerOccurrence(prayer, currentPrayer),
            isNext: _isNextPrayerTile(prayer, nextPrayer),
          ),
        )
        .toList();
  }

  return [
    _PrayerMiniEntry(
      name: fallbackNextPrayer.title,
      time: _formatFallbackTime12(fallbackNextPrayer.time),
      type: fallbackNextPrayer.type,
      isCurrent: false,
      isNext: true,
    ),
  ];
}
