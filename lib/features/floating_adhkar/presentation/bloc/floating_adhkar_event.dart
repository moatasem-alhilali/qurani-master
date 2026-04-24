part of 'floating_adhkar_bloc.dart';

abstract class FloatingAdhkarEvent extends Equatable {
  const FloatingAdhkarEvent();

  @override
  List<Object?> get props => [];
}

class FloatingAdhkarLoadEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarLoadEvent();
}

class FloatingAdhkarToggleFeatureEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarToggleFeatureEvent(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class FloatingAdhkarUpdateSettingsEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarUpdateSettingsEvent(this.settings);

  final FloatingAdhkarSettings settings;

  @override
  List<Object?> get props => [settings];
}

class FloatingAdhkarSetCustomItemEnabledEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarSetCustomItemEnabledEvent({
    required this.subihId,
    required this.enabled,
  });

  final int subihId;
  final bool enabled;

  @override
  List<Object?> get props => [subihId, enabled];
}

class FloatingAdhkarSetBuiltInItemEnabledEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarSetBuiltInItemEnabledEvent({
    required this.itemId,
    required this.enabled,
  });

  final String itemId;
  final bool enabled;

  @override
  List<Object?> get props => [itemId, enabled];
}

class FloatingAdhkarUpdateBuiltInItemEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarUpdateBuiltInItemEvent({
    required this.itemId,
    required this.title,
    required this.text,
  });

  final String itemId;
  final String title;
  final String text;

  @override
  List<Object?> get props => [itemId, title, text];
}

class FloatingAdhkarDeleteBuiltInItemEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarDeleteBuiltInItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class FloatingAdhkarRestoreBuiltInItemEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarRestoreBuiltInItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class FloatingAdhkarResetBuiltInItemEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarResetBuiltInItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class FloatingAdhkarRequestOverlayPermissionEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarRequestOverlayPermissionEvent();
}

class FloatingAdhkarPreviewNowEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarPreviewNowEvent();
}

class FloatingAdhkarRefreshOverlayStatusEvent extends FloatingAdhkarEvent {
  const FloatingAdhkarRefreshOverlayStatusEvent();
}
