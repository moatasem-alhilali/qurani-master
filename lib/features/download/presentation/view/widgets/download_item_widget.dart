import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/download/data/models/download_task_model.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';

class DownloadItemWidget extends StatelessWidget {
  const DownloadItemWidget({required this.task, super.key});
  final DownloadTaskModel task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final progress = state.getProgressForTask(task.taskId);

        return CardWidget(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.fileName,
                            style: context.titleMedium?.copyWith(
                              color: context.primaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.url,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusIcon(),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProgressSection(progress),
                const SizedBox(height: 12),
                _buildActionButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color color;

    switch (task.status) {
      case DownloadTaskStatus.running:
        iconData = Icons.download;
        color = Colors.blue;
      case DownloadTaskStatus.paused:
        iconData = Icons.pause_circle;
        color = Colors.orange;
      case DownloadTaskStatus.complete:
        iconData = Icons.check_circle;
        color = Colors.green;
      case DownloadTaskStatus.failed:
        iconData = Icons.error;
        color = Colors.red;
      case DownloadTaskStatus.canceled:
        iconData = Icons.cancel;
        color = Colors.grey;
      case DownloadTaskStatus.enqueued:
        iconData = Icons.schedule;
        color = Colors.amber;
      default:
        iconData = Icons.help;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 24);
  }

  Widget _buildProgressSection(int progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.statusText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (task.status == DownloadTaskStatus.running ||
                task.status == DownloadTaskStatus.enqueued)
              Text('$progress%'),
          ],
        ),
        const SizedBox(height: 8),
        if (task.status == DownloadTaskStatus.running ||
            task.status == DownloadTaskStatus.enqueued)
          LinearProgressIndicator(
            value: progress / 100.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              task.status == DownloadTaskStatus.running
                  ? Colors.blue
                  : Colors.amber,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ..._getActionButtons(context),
        const SizedBox(width: 8),
        _buildDeleteButton(context),
      ],
    );
  }

  List<Widget> _getActionButtons(BuildContext context) {
    switch (task.status) {
      case DownloadTaskStatus.running:
      case DownloadTaskStatus.enqueued:
        return [
          _buildActionButton(
            context,
            icon: Icons.pause,
            onPressed: () => context.read<DownloadBloc>().add(
                  PauseDownloadEvent(taskId: task.taskId),
                ),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            context,
            icon: Icons.cancel,
            onPressed: () => context.read<DownloadBloc>().add(
                  CancelDownloadEvent(taskId: task.taskId),
                ),
            color: Colors.red,
          ),
        ];

      case DownloadTaskStatus.paused:
        return [
          _buildActionButton(
            context,
            icon: Icons.play_arrow,
            onPressed: () => context.read<DownloadBloc>().add(
                  ResumeDownloadEvent(taskId: task.taskId),
                ),
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            context,
            icon: Icons.cancel,
            onPressed: () => context.read<DownloadBloc>().add(
                  CancelDownloadEvent(taskId: task.taskId),
                ),
            color: Colors.red,
          ),
        ];

      case DownloadTaskStatus.failed:
        return [
          _buildActionButton(
            context,
            icon: Icons.refresh,
            onPressed: () => context.read<DownloadBloc>().add(
                  RetryDownloadEvent(taskId: task.taskId),
                ),
            color: Colors.blue,
          ),
        ];

      case DownloadTaskStatus.complete:
        return [
          _buildActionButton(
            context,
            icon: Icons.open_in_new,
            onPressed: () => context.read<DownloadBloc>().add(
                  OpenDownloadedFileEvent(taskId: task.taskId),
                ),
            color: Colors.green,
          ),
        ];

      default:
        return [];
    }
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      iconSize: 20,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: const EdgeInsets.all(4),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          context.read<DownloadBloc>().add(
                RemoveDownloadTaskEvent(taskId: task.taskId),
              );
        } else if (value == 'delete_with_file') {
          context.read<DownloadBloc>().add(
                RemoveDownloadTaskEvent(taskId: task.taskId, deleteFile: true),
              );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 20),
              const SizedBox(width: 8),
              Text('حذف من القائمة', style: context.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete_with_file',
          child: Row(
            children: [
              const Icon(Icons.delete_forever, size: 20),
              const SizedBox(width: 8),
              Text('حذف الملف', style: context.bodyMedium),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: Colors.grey[600],
        size: 20,
      ),
    );
  }
}
