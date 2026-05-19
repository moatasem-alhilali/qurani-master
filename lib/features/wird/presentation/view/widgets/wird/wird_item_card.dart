import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_info_row.dart';

class WirdItemCard extends StatefulWidget {
  const WirdItemCard({
    required this.item,
    required this.index,
    required this.remaining,
    required this.onDecrement,
    required this.onReset,
    required this.hasAudio,
    required this.isAudioInitializing,
    required this.isCurrentAudio,
    required this.isAudioPlaying,
    required this.audioProcessingState,
    required this.onAudioPressed,
    super.key,
  });

  final WirdModel item;
  final int index;
  final int remaining;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final bool hasAudio;
  final bool isAudioInitializing;
  final bool isCurrentAudio;
  final bool isAudioPlaying;
  final ProcessingState audioProcessingState;
  final VoidCallback onAudioPressed;

  @override
  State<WirdItemCard> createState() => _WirdItemCardState();
}

class _WirdItemCardState extends State<WirdItemCard> {
  bool showDetails = false;

  Future<void> _openLink(String url) async {
    if (url.trim().isEmpty) return;
    await UrlLauncher.fLaunch(url);
  }

  String _typeLabel(int type) {
    switch (type) {
      case 1:
        return 'صباح فقط';
      case 2:
        return 'مساء فقط';
      default:
        return 'صباح ومساء';
    }
  }

  Widget _buildAudioButton() {
    if (!widget.hasAudio) {
      return const IconButton.filledTonal(
        tooltip: 'لا يوجد ملف صوتي',
        onPressed: null,
        icon: AppIcon(AppIcons.mute),
      );
    }

    if (widget.isAudioInitializing) {
      return const IconButton.filledTonal(
        tooltip: 'تهيئة الصوت',
        onPressed: null,
        icon: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final isBuffering = widget.isCurrentAudio &&
        (widget.audioProcessingState == ProcessingState.loading ||
            widget.audioProcessingState == ProcessingState.buffering);

    if (isBuffering) {
      return const IconButton.filledTonal(
        tooltip: 'جاري التحميل',
        onPressed: null,
        icon: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final isCompleted = widget.isCurrentAudio &&
        widget.audioProcessingState == ProcessingState.completed;

    var icon = AppIcons.play;
    var tooltip = 'تشغيل الصوت';

    if (widget.isCurrentAudio && widget.isAudioPlaying) {
      icon = AppIcons.pause;
      tooltip = 'إيقاف مؤقت';
    } else if (isCompleted) {
      icon = AppIcons.replay;
      tooltip = 'إعادة التشغيل';
    }

    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: widget.onAudioPressed,
      icon: AppIcon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return BaseAnimate(
      index: widget.index,
      child: CardWidget(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  item.title,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      _typeLabel(item.type),
                      style: context.labelSmall?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(
              item.text,
              textDirection: TextDirection.rtl,
              style: context.bodyLarge?.copyWith(height: 1.8),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'المتبقي: ${widget.remaining} / ${item.counter}',
                  style: context.titleSmall?.copyWith(
                    color: context.primaryColor,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onReset,
                      icon: const AppIcon(AppIcons.refresh),
                      label: const Text('إعادة'),
                    ),
                    const SizedBox(width: 4),
                    FilledButton.icon(
                      onPressed:
                          widget.remaining == 0 ? null : widget.onDecrement,
                      icon: const AppIcon(AppIcons.checkSmall),
                      label: Text(widget.remaining == 0 ? 'تم' : 'قرأت مرة'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                IconButton.filledTonal(
                  tooltip: 'نسخ الذكر',
                  onPressed: () async {
                    await CopyService.copyToClipboard(item.text);
                  },
                  icon: const AppIcon(AppIcons.copy),
                ),
                _buildAudioButton(),
                IconButton.filledTonal(
                  tooltip: 'المصدر',
                  onPressed: item.sourceUrl.trim().isEmpty
                      ? null
                      : () async => _openLink(item.sourceUrl),
                  icon: const AppIcon(AppIcons.link),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  icon: Icon(
                    showDetails
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                  ),
                  label: Text(showDetails ? 'إخفاء التفاصيل' : 'عرض التفاصيل'),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 220),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(height: 18),
                    WirdInfoRow(title: 'الفضل', content: item.virtue),
                    const SizedBox(height: 8),
                    WirdInfoRow(title: 'المصدر', content: item.source),
                    const SizedBox(height: 8),
                    WirdInfoRow(
                      title: 'نص الحديث',
                      content: item.hadithText,
                    ),
                    if (item.wordExplanations.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'شرح مفردات مختارة',
                        style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...item.wordExplanations.map(
                        (word) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '• ${word.word}: ${word.meaning}',
                            textDirection: TextDirection.rtl,
                            style: context.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: showDetails
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}
