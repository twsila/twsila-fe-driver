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
  String driverServiceType;
  bool isSelected;

  VehicleModel(
      {required this.id,
      required this.vehicleType,
      required this.driverServiceType,
      this.isSelected = false});

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        vehicleType: json["vehicleType"],
        driverServiceType: json["driverServiceType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "driverServiceType": driverServiceType,
      };
}
