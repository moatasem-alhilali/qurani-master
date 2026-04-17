import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/data/services/traveler_country_policy.dart';
import 'package:quran_app/features/traveler/data/services/traveler_places_service.dart';

part 'travel_places_event.dart';
part 'travel_places_state.dart';

class TravelPlacesBloc extends Bloc<TravelPlacesEvent, TravelPlacesState> {
  TravelPlacesBloc({required this.placeType}) 
      : super(TravelPlacesState.initial(
          radiusMeters: placeType == TravelerPlaceType.mosque ? 3000 : 5000,
        )) {
    on<BootstrapPlacesEvent>(_onBootstrap);
    on<LoadNearbyPlacesEvent>(_onLoadNearbyPlaces);
    on<SelectPlaceEvent>(_onSelectPlace);
    on<ChangeRadiusEvent>(_onChangeRadius);

    add(BootstrapPlacesEvent());
  }

  final TravelerPlaceType placeType;

  Future<void> _onBootstrap(BootstrapPlacesEvent event, Emitter<TravelPlacesState> emit) async {
    emit(state.copyWith(
      isLoadingLocation: true,
      isRestrictedForCountry: false,
      clearErrorMessage: true,
    ));

    final hasAccess = await _ensureLocationAccess(emit);
    if (!hasAccess) {
      emit(state.copyWith(isLoadingLocation: false));
      return;
    }

    try {
      final location = await TravelerPlacesService.resolveCurrentLocation();
      final restricted = placeType == TravelerPlaceType.halalRestaurant &&
          TravelerCountryPolicy.isIslamicCountryCode(location.isoCountryCode);

      emit(state.copyWith(
        locationContext: location,
        isRestrictedForCountry: restricted,
        isLoadingLocation: false,
      ));

      if (restricted) return;

      add(LoadNearbyPlacesEvent());
    } catch (_) {
      emit(state.copyWith(
        isLoadingLocation: false,
        errorMessage: 'تعذر تحديد موقعك الحالي. حاول مرة أخرى.',
      ));
    }
  }

  Future<bool> _ensureLocationAccess(Emitter<TravelPlacesState> emit) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(errorMessage: 'خدمة الموقع غير مفعلة. فعّلها لإظهار النتائج القريبة.'));
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      emit(state.copyWith(errorMessage: 'يجب منح صلاحية الموقع حتى تعمل هذه الميزة.'));
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(errorMessage: 'تم رفض صلاحية الموقع نهائيًا. افتح إعدادات التطبيق.'));
      return false;
    }

    return true;
  }

  Future<void> _onLoadNearbyPlaces(LoadNearbyPlacesEvent event, Emitter<TravelPlacesState> emit) async {
    final location = state.locationContext;
    if (location == null) return;

    emit(state.copyWith(isLoadingPlaces: true, clearErrorMessage: true));

    try {
      final places = await TravelerPlacesService.fetchNearbyPlaces(
        placeType: placeType,
        latitude: location.latitude,
        longitude: location.longitude,
        radiusMeters: state.radiusMeters,
      );

      final selectedPlace = places.isEmpty ? null : places.first;
      
      emit(state.copyWith(
        places: places,
        selectedPlace: selectedPlace,
        isLoadingPlaces: false,
        clearSelectedPlace: places.isEmpty,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoadingPlaces: false,
        errorMessage: 'تعذر جلب النتائج القريبة الآن. حاول مجددًا.',
      ));
    }
  }

  void _onSelectPlace(SelectPlaceEvent event, Emitter<TravelPlacesState> emit) {
    emit(state.copyWith(selectedPlace: event.place, clearSelectedPlace: false));
  }

  void _onChangeRadius(ChangeRadiusEvent event, Emitter<TravelPlacesState> emit) {
    if (state.radiusMeters == event.radius) return;
    emit(state.copyWith(radiusMeters: event.radius));
    add(LoadNearbyPlacesEvent());
  }
}
