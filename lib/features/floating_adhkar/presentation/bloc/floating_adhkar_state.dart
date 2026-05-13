part of 'floating_adhkar_bloc.dart';

enum FloatingAdhkarFeatureStatus {
  unsupported,
  permissionRequired,
  misconfigured,
  active,
  inactive,
}

extension FloatingAdhkarFeatureStatusX on FloatingAdhkarFeatureStatus {
  String get label {
    switch (this) {
      case FloatingAdhkarFeatureStatus.unsupported:
        return 'غير مدعومة';
      case FloatingAdhkarFeatureStatus.permissionRequired:
        return 'تحتاج صلاحية';
      case FloatingAdhkarFeatureStatus.misconfigured:
        return 'تحتاج تهيئة';
      case FloatingAdhkarFeatureStatus.active:
        return 'تعمل الآن';
      case FloatingAdhkarFeatureStatus.inactive:
        return 'متوقفة';
    }
  }
}

class FloatingAdhkarState extends Equatable {
  const FloatingAdhkarState({
    this.loadState = RequestState.initial,
    this.actionState = RequestState.initial,
    this.settings,
    this.counts = const FloatingAdhkarCounts(
      builtInCount: 0,
      customTotalCount: 0,
      customEnabledCount: 0,
    ),
    this.previewItem,
    this.builtInItems = const [],
    this.customSelectionMap = const {},
    this.isSupportedPlatform = false,
    this.usesIosReminders = false,
    this.hasOverlayPermission = false,
    this.isOverlayActive = false,
    this.errorMessage,
  });

  final RequestState loadState;
  final RequestState actionState;
  final FloatingAdhkarSettings? settings;
  final FloatingAdhkarCounts counts;
  final FloatingAdhkarItem? previewItem;
  final List<FloatingAdhkarItem> builtInItems;
  final Map<int, bool> customSelectionMap;
  final bool isSupportedPlatform;
  final bool usesIosReminders;
  final bool hasOverlayPermission;
  final bool isOverlayActive;
  final String? errorMessage;

  FloatingAdhkarFeatureStatus get status {
    if (!isSupportedPlatform) {
      return FloatingAdhkarFeatureStatus.unsupported;
    }
    if (!hasOverlayPermission) {
      return FloatingAdhkarFeatureStatus.permissionRequired;
    }

    final currentSettings = settings;
    if (currentSettings == null ||
        !currentSettings.hasAnySource ||
        (currentSettings.includeBuiltIn && counts.builtInCount == 0) ||
        (currentSettings.includeCustom && counts.customEnabledCount == 0)) {
      return FloatingAdhkarFeatureStatus.misconfigured;
    }

    if (currentSettings.enabled && isOverlayActive) {
      return FloatingAdhkarFeatureStatus.active;
    }

    return FloatingAdhkarFeatureStatus.inactive;
  }

  FloatingAdhkarState copyWith({
    RequestState? loadState,
    RequestState? actionState,
    FloatingAdhkarSettings? settings,
    FloatingAdhkarCounts? counts,
    FloatingAdhkarItem? previewItem,
    List<FloatingAdhkarItem>? builtInItems,
    Map<int, bool>? customSelectionMap,
    bool? isSupportedPlatform,
    bool? usesIosReminders,
    bool? hasOverlayPermission,
    bool? isOverlayActive,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearPreview = false,
  }) {
    return FloatingAdhkarState(
      loadState: loadState ?? this.loadState,
      actionState: actionState ?? this.actionState,
      settings: settings ?? this.settings,
      counts: counts ?? this.counts,
      previewItem: clearPreview ? null : previewItem ?? this.previewItem,
      builtInItems: builtInItems ?? this.builtInItems,
      customSelectionMap: customSelectionMap ?? this.customSelectionMap,
      isSupportedPlatform: isSupportedPlatform ?? this.isSupportedPlatform,
      usesIosReminders: usesIosReminders ?? this.usesIosReminders,
      hasOverlayPermission: hasOverlayPermission ?? this.hasOverlayPermission,
      isOverlayActive: isOverlayActive ?? this.isOverlayActive,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        actionState,
        settings,
        counts,
        previewItem,
        builtInItems,
        customSelectionMap,
        isSupportedPlatform,
        usesIosReminders,
        hasOverlayPermission,
        isOverlayActive,
        errorMessage,
      ];
}
