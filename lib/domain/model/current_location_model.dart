// To parse this JSON data, do
//
//     final currentLocationFilter = currentLocationFilterFromJson(jsonString);

import 'dart:convert';

CurrentLocationFilter currentLocationFilterFromJson(String str) => CurrentLocationFilter.fromJson(json.decode(str));

String currentLocationFilterToJson(CurrentLocationFilter data) => json.encode(data.toJson());

class CurrentLocationFilter {
  CurrentLocation currentLocation;

  CurrentLocationFilter({
    required this.currentLocation,
  });

  factory CurrentLocationFilter.fromJson(Map<String, dynamic> json) => CurrentLocationFilter(
    currentLocation: CurrentLocation.fromJson(json["currentLocation"]),
  );

  Map<String, dynamic> toJson() => {
    "currentLocation": currentLocation.toJson(),
  };
}

class CurrentLocation {
  double latitude;
  double longitude;
  String cityName;

  CurrentLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    cityName: json["cityName"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "cityName": cityName,
  };
}
