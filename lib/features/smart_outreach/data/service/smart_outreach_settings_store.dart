import 'package:shared_preferences/shared_preferences.dart';

class SmartOutreachSettingsStore {
  static const _keyDefaultRingTimeout = 'smart_outreach_default_ring_timeout';
  static const _keyDefaultHangupDelay = 'smart_outreach_default_hangup_delay';
  static const _keyDefaultDelayBetween = 'smart_outreach_default_delay_between';
  static const _keyStopOnFirst = 'smart_outreach_default_stop_on_first';
  static const _keyRetryEnabled = 'smart_outreach_default_retry_enabled';
  static const _keyRepeatCycle = 'smart_outreach_default_repeat_cycle';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<int> getDefaultRingTimeout() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDefaultRingTimeout) ?? 20;
  }

  Future<int> getDefaultHangupDelay() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDefaultHangupDelay) ?? 30;
  }

  Future<int> getDefaultDelayBetweenCalls() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDefaultDelayBetween) ?? 3;
  }

  Future<bool> getDefaultStopOnFirstAnswered() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyStopOnFirst) ?? false;
  }

  Future<bool> getDefaultRetryEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyRetryEnabled) ?? false;
  }

  Future<bool> getDefaultRepeatCycle() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyRepeatCycle) ?? false;
  }

  Future<void> saveDefaults({
    required int ringTimeout,
    required int hangupDelay,
    required int delayBetweenCalls,
    required bool stopOnFirstAnswered,
    required bool retryEnabled,
    required bool repeatCycle,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyDefaultRingTimeout, ringTimeout);
    await prefs.setInt(_keyDefaultHangupDelay, hangupDelay);
    await prefs.setInt(_keyDefaultDelayBetween, delayBetweenCalls);
    await prefs.setBool(_keyStopOnFirst, stopOnFirstAnswered);
    await prefs.setBool(_keyRetryEnabled, retryEnabled);
    await prefs.setBool(_keyRepeatCycle, repeatCycle);
  }
}
