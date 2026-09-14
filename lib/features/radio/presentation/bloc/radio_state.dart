part of 'radio_bloc.dart';

class RadioState extends Equatable {
  const RadioState({
    this.loadState = RequestState.initial,
    this.stations = const [],
    this.currentStation,
    this.playbackStatus = RadioPlaybackStatus.idle,
    this.errorMessage,
    this.errorTick = 0,
  });

  final RequestState loadState;
  final List<RadioStationModel> stations;
  final RadioStationModel? currentStation;
  final RadioPlaybackStatus playbackStatus;
  final String? errorMessage;

  /// يزداد مع كل خطأ جديد.
  ///
  /// بدونه كان الخطأ نفسه لا يظهر إلا مرّة واحدة: `listenWhen` يقارن النصّ،
  /// فمحاولة تشغيل فاشلة مرّتين تُظهر رسالة واحدة ثم صمتًا.
  final int errorTick;

  bool get isPlaying => playbackStatus == RadioPlaybackStatus.playing;
  bool get isLoadingPlayback => playbackStatus == RadioPlaybackStatus.loading;
  bool get hasActiveStation => currentStation != null;

  /// هل «الجهاز» مُشغَّل؟
  ///
  /// عليه يتوقّف سلوك المؤشّر: إن كان يعمل فتدوير القرص ينقل البثّ مباشرة كما
  /// في راديو حقيقي، وإن كان مطفأً فالتدوير تصفّح صامت بلا اتصال بالشبكة.
  bool get isPowered =>
      currentStation != null &&
      (playbackStatus == RadioPlaybackStatus.playing ||
          playbackStatus == RadioPlaybackStatus.loading ||
          playbackStatus == RadioPlaybackStatus.paused);

  List<RadioStationModel> get reciters =>
      stations.where((s) => s.kind == RadioStationKind.reciter).toList();

  List<RadioStationModel> get programs =>
      stations.where((s) => s.kind == RadioStationKind.program).toList();

  /// موضع المحطة الحالية في القائمة — هو نفسه موضع القرص.
  int get currentIndex {
    final station = currentStation;
    if (station == null) return 0;
    final index = stations.indexWhere((item) => item.id == station.id);
    return index < 0 ? 0 : index;
  }

  RadioState copyWith({
    RequestState? loadState,
    List<RadioStationModel>? stations,
    RadioStationModel? currentStation,
    RadioPlaybackStatus? playbackStatus,
    String? errorMessage,
    int? errorTick,
    bool clearStation = false,
    bool clearError = false,
  }) {
    return RadioState(
      loadState: loadState ?? this.loadState,
      stations: stations ?? this.stations,
      // بلا العلم الصريح لا سبيل لإرجاع الحقل إلى null: `x ?? this.x` يُبقي
      // القديم دائمًا.
      currentStation:
          clearStation ? null : (currentStation ?? this.currentStation),
      playbackStatus: playbackStatus ?? this.playbackStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorTick: errorTick ?? this.errorTick,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        stations,
        currentStation,
        playbackStatus,
        errorMessage,
        errorTick,
      ];
}
