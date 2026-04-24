import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';

class SmartOutreachExecutionScreen extends StatefulWidget {
  const SmartOutreachExecutionScreen({
    required this.scheduleId,
    this.launchedFromNotification = false,
    super.key,
  });

  final int scheduleId;
  final bool launchedFromNotification;

  @override
  State<SmartOutreachExecutionScreen> createState() =>
      _SmartOutreachExecutionScreenState();
}

class _SmartOutreachExecutionScreenState
    extends State<SmartOutreachExecutionScreen> {
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _starting = true;
  String? _message;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      await _repository.startScheduleNow(widget.scheduleId);
      if (!mounted) {
        return;
      }
      setState(() {
        _starting = false;
        _message = widget.launchedFromNotification
            ? 'بدأت المكالمات من التنبيه.'
            : 'بدأت المكالمات الآن.';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _starting = false;
        _message = 'تعذر بدء المكالمات الآن. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بدء المكالمات')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_starting)
                const CircularProgressIndicator()
              else
                Icon(
                  Icons.phone_in_talk_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(height: 20),
              Text(
                _message ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'يمكنك إغلاق هذه الصفحة الآن ومراجعة النتيجة من سجل المكالمات.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _starting
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SmartOutreachCallLogsScreen(
                              scheduleId: widget.scheduleId,
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.history),
                label: const Text('عرض السجل'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
