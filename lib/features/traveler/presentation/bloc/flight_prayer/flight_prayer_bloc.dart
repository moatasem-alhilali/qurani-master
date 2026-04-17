import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/features/traveler/data/services/flight_prayer_service.dart';

part 'flight_prayer_event.dart';
part 'flight_prayer_state.dart';

class FlightPrayerBloc extends Bloc<FlightPrayerEvent, FlightPrayerState> {
  FlightPrayerBloc(this._service) : super(const FlightPrayerInitial(remainingAttempts: 10)) {
    on<SearchFlightEvent>(_onSearchFlight);
  }

  final FlightPrayerService _service;
  int remainingAttempts = 10;
  FlightPrayerTimelineResult? lastResult;

  Future<void> _onSearchFlight(SearchFlightEvent event, Emitter<FlightPrayerState> emit) async {
    if (remainingAttempts <= 0) {
      emit(FlightPrayerFailure(
        errorMessage: 'انتهت المحاولات. أعد فتح الصفحة للمحاولة مجددًا.',
        remainingAttempts: remainingAttempts,
      ));
      return;
    }

    final normalized = FlightPrayerService.normalizeFlightNumber(event.rawFlightNumber);

    try {
      FlightPrayerService.validateFlightNumberOrThrow(normalized);
    } on FormatException {
      remainingAttempts--;
      emit(FlightPrayerFailure(
        errorMessage: 'رقم الرحلة غير صحيح. مثال: EK202 أو MS985',
        remainingAttempts: remainingAttempts,
      ));
      return;
    }

    emit(FlightPrayerLoading(remainingAttempts: remainingAttempts));

    try {
      final timeline = await _service.buildTimeline(flightNumber: normalized);
      lastResult = timeline;
      emit(FlightPrayerSuccess(
        result: timeline,
        remainingAttempts: remainingAttempts,
      ));
    } catch (_) {
      remainingAttempts--;
      emit(FlightPrayerFailure(
        errorMessage: 'تعذر جلب بيانات الرحلة حاليًا.',
        remainingAttempts: remainingAttempts,
      ));
    }
  }
}
