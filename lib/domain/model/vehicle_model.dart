// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

import 'goods_service_type_model.dart';

VehicleModel vehicleModelFromJson(String str) =>
    VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  int id;
  String vehicleType;
  String serviceType;
  List<NumberOfPassenger> numberOfPassengers;
  List<VehicleShape> vehicleShapes;
  VehicleIcon? icon;
  bool? isSelected;

  VehicleModel(
      {required this.id,
      required this.vehicleType,
      required this.serviceType,
      required this.numberOfPassengers,
      required this.vehicleShapes, this.icon,
      this.isSelected = false});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        vehicleType: json["vehicleType"],
        serviceType: json["serviceType"],
        numberOfPassengers: List<NumberOfPassenger>.from(
            json["numberOfPassengers"]
                .map((x) => NumberOfPassenger.fromJson(x))),
        vehicleShapes: List<VehicleShape>.from(json["vehicleShapes"]
            .map((x) => VehicleShape.fromJson(x))),
        icon: json["icon"]!=null ? VehicleIcon.fromJson(json["icon"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "serviceType": serviceType,
        "numberOfPassengers":
            List<dynamic>.from(numberOfPassengers.map((x) => x.toJson())),
        "vehicleShapes": List<dynamic>.from(vehicleShapes.map((x) => x)),
        "icon": icon!.toJson(),
      };
}

class VehicleIcon {
  int id;
  String url;

  VehicleIcon({
    required this.id,
    required this.url,
  });

  factory VehicleIcon.fromJson(Map<String, dynamic> json) => VehicleIcon(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class NumberOfPassenger {
  int id;
  int numberOfPassengers;
  bool? isSelected;

  NumberOfPassenger({
    required this.id,
    required this.numberOfPassengers,
    this.isSelected = false,
  });

  factory NumberOfPassenger.fromJson(Map<String, dynamic> json) =>
      NumberOfPassenger(
        id: json["id"],
        numberOfPassengers: json["numberOfPassengers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numberOfPassengers": numberOfPassengers,
      };
}

