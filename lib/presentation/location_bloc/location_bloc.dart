import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';

import '../../utils/resources/strings_manager.dart';
import '../trip_execution/helper/location_helper.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<getCurrentLocation>(_getCurrentLocation);
  }

  FutureOr<void> _getCurrentLocation(
      getCurrentLocation event, Emitter<LocationState> emit) async {
    emit(LoginLoadingState());
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(CurrentLocationFailState(
          AppStrings.locationDisabled.tr(), LocationPermission.denied));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(CurrentLocationFailState(
            AppStrings.locationDenied.tr(), permission));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(CurrentLocationFailState(
          AppStrings.locationPermissionIsPermanentlyDenied.tr(), permission));
    }

    Position currentLocation = await Geolocator.getCurrentPosition();
    LocationModel locationModel = LocationModel(
      locationName: "",
      // locationName: first.addressLine!,
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
    var currentCityName = await LocationHelper().getCityNameByCoordinates(
        locationModel.latitude, locationModel.longitude);
    locationModel.cityName = currentCityName;

    emit(CurrentLocationSuccessState(locationModel));
  }
}
