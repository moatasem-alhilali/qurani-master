part of 'wird_bloc.dart';

enum WirdDisplayMode { listView, pageView }

@immutable
class WirdState extends Equatable {
  const WirdState({
    this.data = const [],
    this.state = RequestState.initial,
    this.isAudioInitializing = false,
    this.isAudioReady = false,
    this.isPlaying = false,
    this.processingState = ProcessingState.idle,
    this.activeItemIndex,
    this.currentRepeatIndex = 0,
    this.currentRepeatTotal = 0,
    this.isQueueRepeated = false,
    this.itemsWithAudio = const {},
    this.displayMode = WirdDisplayMode.listView,
    this.currentPageIndex = 0,
    this.remainingCounters = const {},
  });

  final List<WirdModel>? data;
  final RequestState state;

  final bool isAudioInitializing;
  final bool isAudioReady;
  final bool isPlaying;
  final ProcessingState processingState;
  final int? activeItemIndex;
  final int currentRepeatIndex;
  final int currentRepeatTotal;
  final bool isQueueRepeated;
  final Set<int> itemsWithAudio;

  final WirdDisplayMode displayMode;
  final int currentPageIndex;
  final Map<int, int> remainingCounters;

  WirdState copyWith({
    List<WirdModel>? data,
    RequestState? state,
    bool? isAudioInitializing,
    bool? isAudioReady,
    bool? isPlaying,
    ProcessingState? processingState,
    int? activeItemIndex,
    int? currentRepeatIndex,
    int? currentRepeatTotal,
    bool? isQueueRepeated,
    Set<int>? itemsWithAudio,
    WirdDisplayMode? displayMode,
    int? currentPageIndex,
    Map<int, int>? remainingCounters,
  }) {
    return WirdState(
      data: data ?? this.data,
      state: state ?? this.state,
      isAudioInitializing: isAudioInitializing ?? this.isAudioInitializing,
      isAudioReady: isAudioReady ?? this.isAudioReady,
      isPlaying: isPlaying ?? this.isPlaying,
      processingState: processingState ?? this.processingState,
      activeItemIndex: activeItemIndex != null ? (activeItemIndex == -1 ? null : activeItemIndex) : this.activeItemIndex,
      currentRepeatIndex: currentRepeatIndex ?? this.currentRepeatIndex,
      currentRepeatTotal: currentRepeatTotal ?? this.currentRepeatTotal,
      isQueueRepeated: isQueueRepeated ?? this.isQueueRepeated,
      itemsWithAudio: itemsWithAudio ?? this.itemsWithAudio,
      displayMode: displayMode ?? this.displayMode,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      remainingCounters: remainingCounters ?? this.remainingCounters,
    );
  }

  @override
  List<Object?> get props => [
        data,
        state,
        isAudioInitializing,
        isAudioReady,
        isPlaying,
        processingState,
        activeItemIndex,
        currentRepeatIndex,
        currentRepeatTotal,
        isQueueRepeated,
        itemsWithAudio,
        displayMode,
        currentPageIndex,
        remainingCounters,
      ];
}
