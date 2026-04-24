import 'package:equatable/equatable.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';

class FloatingAdhkarOverlayState extends Equatable {
  const FloatingAdhkarOverlayState({
    this.visible = false,
    this.currentItem,
    this.settings,
  });

  final bool visible;
  final FloatingAdhkarItem? currentItem;
  final FloatingAdhkarSettings? settings;

  FloatingAdhkarOverlayState copyWith({
    bool? visible,
    FloatingAdhkarItem? currentItem,
    FloatingAdhkarSettings? settings,
    bool clearCurrentItem = false,
  }) {
    return FloatingAdhkarOverlayState(
      visible: visible ?? this.visible,
      currentItem: clearCurrentItem ? null : currentItem ?? this.currentItem,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [visible, currentItem, settings];
}
