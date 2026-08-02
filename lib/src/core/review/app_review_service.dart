import 'package:in_app_review/in_app_review.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/main.dart';

/// App rating / review handling for both stores.
///
/// There are two intentionally different paths, and mixing them up is the most
/// common rating mistake:
///
///  1. [requestReviewIfAppropriate] — the **automatic, native in-app review**
///     (Apple `SKStoreReviewController` / Google Play In-App Review via the
///     `in_app_review` plugin). It shows a small sheet *inside* the app. The OS
///     decides whether to actually display it and heavily throttles it
///     (iOS: max 3 prompts / 365 days; Play has its own quota). You cannot force
///     it and cannot know if it appeared — so it must only ever be fired at a
///     natural, positive moment, never from a button.
///
///  2. [openStoreListing] — the **explicit "Rate us" button**. It always sends
///     the user to the store page (App Store review composer on iOS), which is
///     deterministic. A button must use this, because the in-app API above may
///     silently do nothing, which would feel broken for an explicit tap.
///
/// On top of the OS throttling we apply our own conservative policy so the
/// automatic prompt only reaches genuinely engaged users and never nags:
///  - at least [_minDaysSinceInstall] days since first launch,
///  - at least [_minAppOpens] app opens,
///  - at least [_cooldownDays] days since the last prompt,
///  - never more than [_maxPrompts] prompts total (matches iOS' yearly cap),
///  - never after the user already tapped the manual "Rate us" button,
///  - only while connected to the internet.
class AppReviewService {
  AppReviewService({InAppReview? inAppReview, CacheService? cacheService})
      : _inAppReview = inAppReview ?? InAppReview.instance,
        _cacheService = cacheService ?? CacheService();

  final InAppReview _inAppReview;
  final CacheService _cacheService;

  /// The numeric App Store id for this app (required to open the iOS listing).
  static const String _iosAppStoreId = '1626263854';

  // ─────────────────────────────── Policy knobs ──────────────────────────────
  static const int _minDaysSinceInstall = 3;
  static const int _minAppOpens = 4;
  static const int _cooldownDays = 90;
  static const int _maxPrompts = 3;

  // ─────────────────────────────── Storage keys ──────────────────────────────
  static const String _kFirstOpenMs = 'review_first_open_ms';
  static const String _kOpenCount = 'review_open_count';
  static const String _kLastPromptMs = 'review_last_prompt_ms';
  static const String _kPromptCount = 'review_prompt_count';
  static const String _kUserRated = 'review_user_rated';

  /// Records install date (first time only) and increments the launch counter.
  /// Call once per app start.
  Future<void> registerAppOpen() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (_cacheService.getInt(_kFirstOpenMs) == null) {
        await _cacheService.setInt(_kFirstOpenMs, now);
      }
      final count = (_cacheService.getInt(_kOpenCount) ?? 0) + 1;
      await _cacheService.setInt(_kOpenCount, count);
    } catch (e) {
      logger.w('registerAppOpen failed silently: $e');
    }
  }

  /// Fires the native in-app review sheet — but only if every policy condition
  /// is met and the platform reports the API as available. Safe to call often;
  /// it short-circuits locally before touching the OS.
  Future<void> requestReviewIfAppropriate() async {
    try {
      if (!_isEligible()) return;
      if (!ISCONNECTED) return;

      final isAvailable = await _inAppReview.isAvailable();
      if (!isAvailable) return;

      await _inAppReview.requestReview();
      await _recordPromptShown();
    } catch (e) {
      logger.w('In-app review request skipped: $e');
    }
  }

  /// Explicit "Rate us" action: opens the store listing (App Store review
  /// composer on iOS). Marks the user as rated so the automatic prompt stops.
  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(appStoreId: _iosAppStoreId);
      await _cacheService.setBool(_kUserRated, true);
    } catch (e) {
      logger.w('Open store listing failed: $e');
    }
  }

  bool _isEligible() {
    // Already sent to rate manually → never auto-prompt again.
    if (_cacheService.getBool(_kUserRated) ?? false) return false;

    // Respect our own yearly-style cap.
    final promptCount = _cacheService.getInt(_kPromptCount) ?? 0;
    if (promptCount >= _maxPrompts) return false;

    final firstOpenMs = _cacheService.getInt(_kFirstOpenMs);
    if (firstOpenMs == null) return false;

    final now = DateTime.now();
    final installDate = DateTime.fromMillisecondsSinceEpoch(firstOpenMs);
    if (now.difference(installDate).inDays < _minDaysSinceInstall) return false;

    final opens = _cacheService.getInt(_kOpenCount) ?? 0;
    if (opens < _minAppOpens) return false;

    final lastPromptMs = _cacheService.getInt(_kLastPromptMs);
    if (lastPromptMs != null) {
      final lastPrompt = DateTime.fromMillisecondsSinceEpoch(lastPromptMs);
      if (now.difference(lastPrompt).inDays < _cooldownDays) return false;
    }

    return true;
  }

  Future<void> _recordPromptShown() async {
    await _cacheService.setInt(
      _kLastPromptMs,
      DateTime.now().millisecondsSinceEpoch,
    );
    await _cacheService.setInt(
      _kPromptCount,
      (_cacheService.getInt(_kPromptCount) ?? 0) + 1,
    );
  }
}
