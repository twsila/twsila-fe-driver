import 'package:flutter/cupertino.dart';
import 'package:taxi_for_you/utils/location/user_current_location.dart';
import 'location_model.dart';

class MapsRepo {
  Future<LocationModel> getUserCurrentLocation() async {
    try {
      LocationModel currentLocation =
          await UserCurrentLocation().getCurrentLocation();
      return currentLocation;
    } catch (error) {
      throw FlutterError(error.toString());
    }
  }
}
