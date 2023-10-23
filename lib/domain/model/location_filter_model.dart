// To parse this JSON data, do
//
//     final locationFilter = locationFilterFromJson(jsonString);

import 'dart:convert';

LocationFilter locationFilterFromJson(String str) => LocationFilter.fromJson(json.decode(str));

String locationFilterToJson(LocationFilter data) => json.encode(data.toJson());

class LocationFilter {
  Destination pickup;
  Destination destination;

  LocationFilter({
    required this.pickup,
    required this.destination,
  });

  factory LocationFilter.fromJson(Map<String, dynamic> json) => LocationFilter(
    pickup: Destination.fromJson(json["pickup"]),
    destination: Destination.fromJson(json["destination"]),
  );

  Map<String, dynamic> toJson() => {
    "pickup": pickup.toJson(),
    "destination": destination.toJson(),
  };
}

class Destination {
  double latitude;
  double longitude;
  String cityName;

  Destination({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
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
