import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdScreen extends StatelessWidget {
  const WirdScreen({required this.isMorning, super.key})
      : titleOverride = null,
        assetPath = JsonLoaderService.wirdsPath,
        filterByPeriod = true;

  const WirdScreen.custom({
    required String title,
    required this.assetPath,
    this.isMorning = true,
    this.filterByPeriod = false,
    super.key,
  }) : titleOverride = title;

  final bool isMorning;
  final String? titleOverride;
  final String assetPath;
  final bool filterByPeriod;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WirdBloc()
        ..add(
          LoadWirdEvent(
            isMorning: isMorning,
            assetPath: assetPath,
            filterByPeriod: filterByPeriod,
          ),
        ),
      child: AppScaffoldWidget(
        title: titleOverride ?? (isMorning ? 'الورد الصباحي' : 'الورد المسائي'),
        trailing: BlocBuilder<WirdBloc, WirdState>(
          builder: (context, state) {
            return GenericSearchAnchorAsync<WirdModel>(
              asyncSuggestions: (query) async {
                if (query.trim().isEmpty) return state.data ?? [];
                return state.data
                        ?.where((item) => _matchesQuery(item, query))
                        .toList() ??
                    [];
              },
              onSelected: (item) async {
                await CopyService.copyToClipboard(item.text);
              },
              hintText: 'بحث عن ذكر',
              suggestionBuilder: (context, item) =>
                  _SearchSuggestion(item: item),
            );
          },
        ),
        slivers: [
          BlocBuilder<WirdBloc, WirdState>(
            builder: (context, state) {
              return state.state.whenSliver<WirdModel>(
                onSuccess: () {
                  final data = state.data ?? [];
                  return SliverToBoxAdapter(
                    child: _WirdAudioList(items: data),
                  );
                },
                context: context,
                sliverList: state.data,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WirdAudioList extends StatefulWidget {
  const _WirdAudioList({required this.items});

  final List<WirdModel> items;

  @override
  State<_WirdAudioList> createState() => _WirdAudioListState();
}

class _WirdAudioListState extends State<_WirdAudioList> {
  AudioService? _audioService;
  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  final Map<int, int> _itemIndexToQueueIndex = {};
  final Map<int, int> _queueIndexToItemIndex = {};

  bool _isAudioInitializing = false;
  bool _isAudioReady = false;
  bool _isPlaying = false;
  ProcessingState _processingState = ProcessingState.idle;
  int? _activeItemIndex;

  String _audioSignature = '';
  int _setupToken = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_setupAudioQueue(widget.items));
  }

  @override
  void didUpdateWidget(covariant _WirdAudioList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextSignature = _buildAudioSignature(widget.items);
    if (nextSignature != _audioSignature) {
      unawaited(_setupAudioQueue(widget.items));
    }
  }

  @override
  void dispose() {
    unawaited(_disposeAudioPlayer());
    super.dispose();
  }

  String _buildAudioSignature(List<WirdModel> items) {
    return items
        .map((item) => item.audioUrl.trim())
        .where((url) => url.isNotEmpty)
        .join('|');
  }

  Future<void> _setupAudioQueue(List<WirdModel> items) async {
    final signature = _buildAudioSignature(items);
    if (_audioSignature == signature && _audioService != null) {
      return;
    }

    _audioSignature = signature;
    final setupId = ++_setupToken;

    if (mounted) {
      setState(() {
        _isAudioInitializing = true;
        _isAudioReady = false;
        _isPlaying = false;
        _processingState = ProcessingState.idle;
        _activeItemIndex = null;
        _itemIndexToQueueIndex.clear();
        _queueIndexToItemIndex.clear();
      });
    }

    await _disposeAudioPlayer();
    if (!mounted || setupId != _setupToken) return;

    final indexedAudioItems = widget.items.asMap().entries.where(
          (entry) => entry.value.audioUrl.trim().isNotEmpty,
        );

    if (indexedAudioItems.isEmpty) {
      if (mounted) {
        setState(() {
          _isAudioInitializing = false;
          _isAudioReady = false;
        });
      }
      return;
    }

    final audioUrls = <String>[];
    var queueIndex = 0;
    for (final entry in indexedAudioItems) {
      _itemIndexToQueueIndex[entry.key] = queueIndex;
      _queueIndexToItemIndex[queueIndex] = entry.key;
      audioUrls.add(entry.value.audioUrl.trim());
      queueIndex += 1;
    }

    final service = AudioService();

    try {
      await service.initAudiosNetworks(audioUrls);

      if (!mounted || setupId != _setupToken) {
        await service.audioPlayer.dispose();
        return;
      }

      _audioService = service;

      _indexSubscription =
          service.audioPlayer.currentIndexStream.listen((currentQueueIndex) {
        if (!mounted) return;

        setState(() {
          _activeItemIndex = _queueIndexToItemIndex[currentQueueIndex ?? -1];
        });
      });

      _playerStateSubscription =
          service.audioPlayer.playerStateStream.listen((playerState) {
        if (!mounted) return;

        final currentQueueIndex = service.audioPlayer.currentIndex;
        setState(() {
          _isPlaying = playerState.playing;
          _processingState = playerState.processingState;
          _activeItemIndex = _queueIndexToItemIndex[currentQueueIndex ?? -1];
        });
      });

      if (mounted) {
        setState(() {
          _isAudioInitializing = false;
          _isAudioReady = true;
        });
      }
    } catch (_) {
      await service.audioPlayer.dispose();

      if (mounted) {
        setState(() {
          _isAudioInitializing = false;
          _isAudioReady = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تهيئة الصوت للأذكار.')),
        );
      }
    }
  }

  Future<void> _disposeAudioPlayer() async {
    await _indexSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    _indexSubscription = null;
    _playerStateSubscription = null;

    final service = _audioService;
    _audioService = null;

    if (service == null) return;

    try {
      await service.audioPlayer.pause();
      await service.audioPlayer.dispose();
    } catch (_) {
      // no-op
    }
  }

  Future<void> _toggleAudio(int itemIndex) async {
    if (_isAudioInitializing || !_isAudioReady) {
      return;
    }

    final service = _audioService;
    final queueIndex = _itemIndexToQueueIndex[itemIndex];

    if (service == null || queueIndex == null) {
      return;
    }

    final player = service.audioPlayer;
    final currentState = player.playerState;
    final isCurrentItem = _activeItemIndex == itemIndex;
    final isCompleted =
        currentState.processingState == ProcessingState.completed;

    try {
      if (isCurrentItem && currentState.playing) {
        await player.pause();
        return;
      }

      if (isCurrentItem && !isCompleted) {
        await player.play();
        return;
      }

      await service.playSeek(queueIndex);
      await player.play();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تشغيل الملف الصوتي.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: List<Widget>.generate(items.length, (index) {
          final item = items[index];
          return _WirdItemCard(
            key: ValueKey('wird_${item.title}_$index'),
            item: item,
            index: index,
            hasAudio: _itemIndexToQueueIndex.containsKey(index),
            isAudioInitializing: _isAudioInitializing,
            isCurrentAudio: _activeItemIndex == index,
            isAudioPlaying: _isPlaying,
            audioProcessingState: _processingState,
            onAudioPressed: () => unawaited(_toggleAudio(index)),
          );
        }),
      ),
    );
  }
}

bool _matchesQuery(WirdModel item, String query) {
  final q = query.trim();
  return item.title.contains(q) ||
      item.text.contains(q) ||
      item.virtue.contains(q) ||
      item.source.contains(q) ||
      item.hadithText.contains(q);
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

class _SearchSuggestion extends StatelessWidget {
  const _SearchSuggestion({required this.item});

  final WirdModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.titleSmall,
      ),
      subtitle: Text(
        item.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.bodySmall,
      ),
    );
  }
}

class _WirdItemCard extends StatefulWidget {
  const _WirdItemCard({
    required this.item,
    required this.index,
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
  final bool hasAudio;
  final bool isAudioInitializing;
  final bool isCurrentAudio;
  final bool isAudioPlaying;
  final ProcessingState audioProcessingState;
  final VoidCallback onAudioPressed;

  @override
  State<_WirdItemCard> createState() => _WirdItemCardState();
}

class _WirdItemCardState extends State<_WirdItemCard> {
  late int remaining;
  bool showDetails = false;

  @override
  void initState() {
    super.initState();
    remaining = widget.item.counter;
  }

  @override
  void didUpdateWidget(covariant _WirdItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.counter != widget.item.counter) {
      remaining = widget.item.counter;
    }
  }

  void _decrement() {
    if (remaining == 0) return;
    setState(() {
      remaining -= 1;
    });
  }

  void _reset() {
    setState(() {
      remaining = widget.item.counter;
    });
  }

  Future<void> _openLink(String url) async {
    if (url.trim().isEmpty) return;
    await UrlLauncher.fLaunch(url);
  }

  Widget _buildAudioButton() {
    if (!widget.hasAudio) {
      return const IconButton.filledTonal(
        tooltip: 'لا يوجد ملف صوتي',
        onPressed: null,
        icon: Icon(Icons.volume_off_rounded),
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

    var icon = Icons.play_arrow_rounded;
    var tooltip = 'تشغيل الصوت';

    if (widget.isCurrentAudio && widget.isAudioPlaying) {
      icon = Icons.pause_rounded;
      tooltip = 'إيقاف مؤقت';
    } else if (isCompleted) {
      icon = Icons.replay_rounded;
      tooltip = 'إعادة التشغيل';
    }

    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: widget.onAudioPressed,
      icon: Icon(icon),
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
                  'المتبقي: $remaining / ${item.counter}',
                  style: context.titleSmall?.copyWith(
                    color: context.primaryColor,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('إعادة'),
                    ),
                    const SizedBox(width: 4),
                    FilledButton.icon(
                      onPressed: remaining == 0 ? null : _decrement,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(remaining == 0 ? 'تم' : 'قرأت مرة'),
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
                  icon: const Icon(Icons.copy_rounded),
                ),
                _buildAudioButton(),
                IconButton.filledTonal(
                  tooltip: 'المصدر',
                  onPressed: item.sourceUrl.trim().isEmpty
                      ? null
                      : () async => _openLink(item.sourceUrl),
                  icon: const Icon(Icons.link_rounded),
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
                    _InfoRow(title: 'الفضل', content: item.virtue),
                    const SizedBox(height: 8),
                    _InfoRow(title: 'المصدر', content: item.source),
                    const SizedBox(height: 8),
                    _InfoRow(
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        SelectableText(
          content,
          textDirection: TextDirection.rtl,
          style: context.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
