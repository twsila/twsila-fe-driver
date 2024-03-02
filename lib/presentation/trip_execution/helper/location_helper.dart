import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../domain/model/destance_matrix_model.dart';

class LocationHelper {
  double distanceBetweenTwoLocationInMeters(
      {required double lat1,
      required double long1,
      required double lat2,
      required double long2}) {
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, long1, lat2, long2);
    return distanceInMeters;
  }

  Future<void> getArrivalTimeFromCurrentToLocation(
      {required LocationModel currentLocation,
      required LocationModel destinationLocation}) async {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    Dio dio = new Dio();
    var matrixUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLocation.latitude},${destinationLocation.longitude}&language=${_appPrefs.getAppLanguage()}&origins=${currentLocation.latitude},${currentLocation.longitude}&key=${Platform.isIOS ? Constants.GOOGLE_API_KEY_IOS : Constants.GOOGLE_API_KEY_ANDROID}';
    var response = await dio.get(matrixUrl);
    print(response.runtimeType);
    DistanceMatrix matrix = DistanceMatrix.fromJson(response.data);
    print("estimated time : ${matrix.elements?[0].duration!.text}" ?? "-");
  }

  String getCityName(Prediction prediction) {
    List<Terms> newTerms = prediction.terms!;
    newTerms.removeLast();
    return newTerms.last.value.toString();
  }

  Future<String> getCityNameByCoordinates(double lat, double long) async {
    var address = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(lat, long));
    String? cityName = address.first.locality;
    return cityName ?? "defaultCity";
  }
}
