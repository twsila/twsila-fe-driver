// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

VehicleModel vehicleModelFromJson(String str) =>
    VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  int id;
  String vehicleType;
  String serviceType;
  bool isSelected;

  VehicleModel(
      {required this.id,
      required this.vehicleType,
      required this.serviceType,
      this.isSelected = false});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        vehicleType: json["vehicleType"],
    serviceType: json["serviceType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "serviceType": serviceType,
      };
}
