import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/notification/notification_orchestrator_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/daily_wird/data/repo/daily_wird_repository.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_sync.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:timezone/timezone.dart' as tz;

class LocaleState extends Equatable {
  const LocaleState({required this.language, required this.confirmed});

  final AppLanguage language;

  /// هل اختار المستخدم لغته؟ `false` في أوّل فتح — وحينها تظهر شاشة الاختيار.
  final bool confirmed;

  Locale get locale => language.locale;

  @override
  List<Object?> get props => [language, confirmed];
}

/// لغة الواجهة: المصدر الوحيد لها في التطبيق.
///
/// - أوّل فتح: لا لغة محفوظة ← [LocaleState.confirmed] = false، ويُقترح أنسب لغة
///   لجهاز المستخدم.
/// - أثناء الاختيار ([preview]): الواجهة تتبدّل حيًّا ولا شيء يُحفظ.
/// - [confirm] أو [change] من الإعدادات: تُحفظ في [L10nService.storageKey]، ومنه
///   تقرأ الإشعارات والودجات ومهامّ الخلفية.
/// - بعد الحفظ يُعاد بناء ما كُتب مسبقًا بلغة سابقة ولا تراه الواجهة: الإشعارات
///   المجدولة ونصوص ودجات الشاشة الرئيسية ([onLanguageSaved]).
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({CacheService? cache, Future<void> Function()? onLanguageSaved})
      : _cache = cache ?? CacheService(),
        _onLanguageSaved = onLanguageSaved ?? refreshLocalizedOutputs,
        super(_initialState(cache ?? CacheService())) {
    Intl.defaultLocale = state.language.code;
  }

  final CacheService _cache;
  final Future<void> Function() _onLanguageSaved;

  /// الإشعارات مجدولة بنصوصها سلفًا، والودجات تحمل نصوصها في بياناتها؛ كلاهما
  /// يبقى بلغته القديمة ما لم يُعَد بناؤه.
  static Future<void> refreshLocalizedOutputs() async {
    HomeWidgetSync.requestSync();
    if (sl.isRegistered<NotificationOrchestratorService>()) {
      await sl<NotificationOrchestratorService>().rescheduleAllNotifications();
    }
    if (sl.isRegistered<DailyWirdRepository>()) {
      await sl<DailyWirdRepository>().syncReminderSchedules();
    }
  }

  static LocaleState _initialState(CacheService cache) {
    final saved = AppLanguage.fromCode(cache.getString(L10nService.storageKey));
    if (saved != null) {
      return LocaleState(language: saved, confirmed: true);
    }
    return LocaleState(
      language: AppLanguage.suggestFor(
        PlatformDispatcher.instance.locales,
        // TimeZoneService يضبطه قبل runApp من اسم منطقة الجهاز.
        timeZoneName: tz.local.name,
      ),
      confirmed: false,
    );
  }

  /// يعرض اللغة دون حفظها — شاشة الاختيار الأولى.
  void preview(AppLanguage language) {
    _apply(language, confirmed: state.confirmed);
  }

  /// يثبّت اللغة المعروضة ويُنهي شاشة الاختيار الأولى.
  Future<void> confirm() async {
    await _cache.setString(L10nService.storageKey, state.language.code);
    _apply(state.language, confirmed: true);
    // قد يكون الإقلاع جدول الإشعارات بالعربية قبل أن يختار المستخدم.
    unawaited(_onLanguageSaved());
  }

  /// تغيير اللغة من الإعدادات: يُحفظ فورًا.
  Future<void> change(AppLanguage language) async {
    if (language == state.language && state.confirmed) return;
    await _cache.setString(L10nService.storageKey, language.code);
    _apply(language, confirmed: true);
    unawaited(_onLanguageSaved());
  }

  void _apply(AppLanguage language, {required bool confirmed}) {
    Intl.defaultLocale = language.code;
    emit(LocaleState(language: language, confirmed: confirmed));
  }
}
