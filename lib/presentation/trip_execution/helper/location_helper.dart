import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';

import '../../../app/constants.dart';

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
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units="
        "imperial&origins=${currentLocation.latitude},${currentLocation.longitude}&destinations=${destinationLocation.latitude}%2C,${currentLocation.longitude}&key=${Platform.isIOS ? Constants.GOOGLE_API_KEY_IOS : Constants.GOOGLE_API_KEY_ANDROID}");
    print(response.data);
  }
}
