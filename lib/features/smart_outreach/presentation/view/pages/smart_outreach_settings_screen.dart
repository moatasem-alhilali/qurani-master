import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';

class SmartOutreachSettingsScreen extends StatefulWidget {
  const SmartOutreachSettingsScreen({super.key});

  @override
  State<SmartOutreachSettingsScreen> createState() =>
      _SmartOutreachSettingsScreenState();
}

class _SmartOutreachSettingsScreenState
    extends State<SmartOutreachSettingsScreen> {
  final SmartOutreachSettingsStore _store = sl<SmartOutreachSettingsStore>();
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _loading = true;
  int _ringTimeout = 20;
  int _hangupDelay = 30;
  int _delayBetweenCalls = 3;
  bool _stopOnFirstAnswered = false;
  bool _retryEnabled = false;
  bool _repeatCycle = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _ringTimeout = await _store.getDefaultRingTimeout();
    _hangupDelay = await _store.getDefaultHangupDelay();
    _delayBetweenCalls = await _store.getDefaultDelayBetweenCalls();
    _stopOnFirstAnswered = await _store.getDefaultStopOnFirstAnswered();
    _retryEnabled = await _store.getDefaultRetryEnabled();
    _repeatCycle = await _store.getDefaultRepeatCycle();

    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _store.saveDefaults(
      ringTimeout: _ringTimeout,
      hangupDelay: _hangupDelay,
      delayBetweenCalls: _delayBetweenCalls,
      stopOnFirstAnswered: _stopOnFirstAnswered,
      retryEnabled: _retryEnabled,
      repeatCycle: _repeatCycle,
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الإعدادات.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات المكالمات')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _SliderTile(
                  label: 'مدة انتظار الرد',
                  value: _ringTimeout.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 55,
                  suffix: '$_ringTimeoutث',
                  onChanged: (value) {
                    setState(() {
                      _ringTimeout = value.round();
                    });
                  },
                ),
                _SliderTile(
                  label: 'الانتظار بعد الرد',
                  value: _hangupDelay.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  suffix: '$_hangupDelayث',
                  onChanged: (value) {
                    setState(() {
                      _hangupDelay = value.round();
                    });
                  },
                ),
                _SliderTile(
                  label: 'الفاصل بين كل رقم',
                  value: _delayBetweenCalls.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  suffix: '$_delayBetweenCallsث',
                  onChanged: (value) {
                    setState(() {
                      _delayBetweenCalls = value.round();
                    });
                  },
                ),
                SwitchListTile(
                  value: _stopOnFirstAnswered,
                  onChanged: (value) {
                    setState(() {
                      _stopOnFirstAnswered = value;
                    });
                  },
                  title: const Text('إيقاف القائمة بعد أول رد'),
                ),
                SwitchListTile(
                  value: _retryEnabled,
                  onChanged: (value) {
                    setState(() {
                      _retryEnabled = value;
                    });
                  },
                  title: const Text('إعادة الاتصال إذا لم يتم الرد'),
                ),
                SwitchListTile(
                  value: _repeatCycle,
                  onChanged: (value) {
                    setState(() {
                      _repeatCycle = value;
                    });
                  },
                  title: const Text('إعادة البدء من أول القائمة بعد الانتهاء'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('حفظ الإعدادات'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'إذا توقفت القوائم عن العمل في الخلفية، اسمح للتطبيق '
                  'بالعمل من إعدادات البطارية.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _repository.openBatterySettings,
                  icon: const Icon(Icons.battery_saver_outlined),
                  label: const Text('السماح بالعمل في الخلفية'),
                ),
              ],
            ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(label)),
                Text(suffix),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
