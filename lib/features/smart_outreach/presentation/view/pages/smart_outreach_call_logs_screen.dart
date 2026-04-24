import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';

class SmartOutreachCallLogsScreen extends StatefulWidget {
  const SmartOutreachCallLogsScreen({
    this.scheduleId,
    super.key,
  });

  final int? scheduleId;

  @override
  State<SmartOutreachCallLogsScreen> createState() =>
      _SmartOutreachCallLogsScreenState();
}

class _SmartOutreachCallLogsScreenState
    extends State<SmartOutreachCallLogsScreen> {
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _loading = true;
  List<SmartOutreachCallLogEntry> _logs = const <SmartOutreachCallLogEntry>[];
  SmartOutreachCallStats? _stats;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });

    final logs = await _repository.getCallLogs(scheduleId: widget.scheduleId);
    final stats = await _repository.getCallStats();

    if (!mounted) {
      return;
    }

    setState(() {
      _logs = logs;
      _stats = stats;
      _loading = false;
    });
  }

  Future<void> _clear() async {
    if (widget.scheduleId == null) {
      await _repository.clearAllCallLogs();
    } else {
      await _repository.clearCallLogsForSchedule(widget.scheduleId!);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المكالمات'),
        actions: <Widget>[
          IconButton(
            onPressed: _loading ? null : _clear,
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'مسح السجل',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  if (_stats != null) ...<Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _StatCard(
                          label: 'الإجمالي',
                          value: '${_stats!.total}',
                        ),
                        _StatCard(
                          label: 'تم الرد',
                          value: '${_stats!.answered}',
                        ),
                        _StatCard(
                          label: 'لم يتم الرد',
                          value: '${_stats!.notAnswered}',
                        ),
                        _StatCard(
                          label: 'فشل',
                          value: '${_stats!.failed}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_logs.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('لا توجد نتائج بعد.'),
                      ),
                    )
                  else
                    ..._logs.map(_buildTile),
                ],
              ),
            ),
    );
  }

  Widget _buildTile(SmartOutreachCallLogEntry log) {
    final timeText =
        DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(log.calledAt);
    final subtitle = StringBuffer()
      ..writeln(timeText)
      ..write(_statusLabel(log.status));

    final reason = log.reason;
    if (reason != null && reason.trim().isNotEmpty) {
      subtitle
        ..writeln()
        ..write(reason.trim());
    }

    return Card(
      child: ListTile(
        leading: Icon(_statusIcon(log.status)),
        title: Text(log.number),
        subtitle: Text(subtitle.toString()),
        trailing: log.duration > 0 ? Text('${log.duration}ث') : null,
        isThreeLine: reason != null && reason.trim().isNotEmpty,
      ),
    );
  }

  static IconData _statusIcon(String status) {
    switch (status) {
      case 'answered':
        return Icons.call_received_outlined;
      case 'not_answered':
        return Icons.call_missed_outgoing_outlined;
      default:
        return Icons.call_end_outlined;
    }
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'answered':
        return 'تم الرد';
      case 'not_answered':
        return 'لم يتم الرد';
      case 'failed':
        return 'فشل الاتصال';
      default:
        return status;
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
