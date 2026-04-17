import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';


part 'travel_athkar_event.dart';
part 'travel_athkar_state.dart';

class TravelAthkarBloc extends Bloc<TravelAthkarEvent, TravelAthkarState> {
  TravelAthkarBloc() : super(const TravelAthkarState()) {
    on<LoadAthkarEvent>(_onLoadAthkar);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<ResetCounterEvent>(_onResetCounter);
    on<SearchAthkarEvent>(_onSearchAthkar);
    on<UpdateDisplayModeEvent>(_onUpdateDisplayMode);
    on<UpdatePageIndexEvent>(_onUpdatePageIndex);

    add(LoadAthkarEvent());
  }

  Future<void> _onLoadAthkar(LoadAthkarEvent event, Emitter<TravelAthkarState> emit) async {
    emit(state.copyWith(status: TravelAthkarStatus.loading, clearErrorMessage: true));

    try {
      final jsonString = await rootBundle.loadString('assets/json/travel_azkar.json');
      final rawList = jsonDecode(jsonString);
      if (rawList is! List<dynamic>) throw const FormatException('Invalid travel azkar json');

      final items = rawList
          .whereType<Map<dynamic, dynamic>>()
          .map(Map<String, dynamic>.from)
          .map(TravelDhikrModel.fromJson)
          .where((item) => item.key.isNotEmpty)
          .toList();

      emit(state.copyWith(
        status: TravelAthkarStatus.success,
        allItems: items,
        filteredItems: items,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TravelAthkarStatus.failure,
        errorMessage: 'تعذر تحميل أذكار السفر.',
      ));
    }
  }

  void _onIncrementCounter(IncrementCounterEvent event, Emitter<TravelAthkarState> emit) {
    if (state.status != TravelAthkarStatus.success) return;

    final current = state.repeatCounts[event.item.key] ?? 0;
    final target = event.item.repeatCount;

    if (target != null && !event.item.isDynamicRepeat && current >= target) return;

    final updatedCounts = Map<String, int>.from(state.repeatCounts);
    updatedCounts[event.item.key] = current + 1;

    emit(state.copyWith(repeatCounts: updatedCounts));
  }

  void _onResetCounter(ResetCounterEvent event, Emitter<TravelAthkarState> emit) {
    if (state.status != TravelAthkarStatus.success) return;

    final updatedCounts = Map<String, int>.from(state.repeatCounts);
    updatedCounts[event.key] = 0;

    emit(state.copyWith(repeatCounts: updatedCounts));
  }

  void _onSearchAthkar(SearchAthkarEvent event, Emitter<TravelAthkarState> emit) {
    if (state.status != TravelAthkarStatus.success) return;
    
    final trimmedQuery = event.query.trim();
    if (trimmedQuery.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredItems: state.allItems, currentPageIndex: 0));
      return;
    }

    final filtered = state.allItems.where((item) => _matchesSearch(item, trimmedQuery)).toList();
    emit(state.copyWith(searchQuery: trimmedQuery, filteredItems: filtered, currentPageIndex: 0));
  }
  
  void _onUpdateDisplayMode(UpdateDisplayModeEvent event, Emitter<TravelAthkarState> emit) {
    emit(state.copyWith(displayMode: event.mode, currentPageIndex: 0));
  }

  void _onUpdatePageIndex(UpdatePageIndexEvent event, Emitter<TravelAthkarState> emit) {
    emit(state.copyWith(currentPageIndex: event.index));
  }

  bool _matchesSearch(TravelDhikrModel item, String query) {
    final triggerLabel = travelTriggerLabels[item.trigger] ?? item.trigger;
    return item.title.contains(query) ||
        item.text.contains(query) ||
        item.virtue.contains(query) ||
        triggerLabel.contains(query);
  }
}
