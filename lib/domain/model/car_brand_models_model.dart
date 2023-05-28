// To parse this JSON data, do
//
//     final carBrandAndModelsModel = carBrandAndModelsModelFromJson(jsonString);

import 'dart:convert';

CarBrandAndModelsModel carBrandAndModelsModelFromJson(String str) =>
    CarBrandAndModelsModel.fromJson(json.decode(str));

String carBrandAndModelsModelToJson(CarBrandAndModelsModel data) =>
    json.encode(data.toJson());

class CarBrandAndModelsModel {
  bool success;
  dynamic message;
  String dateTime;
  List<CarModel> result;

  CarBrandAndModelsModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory CarBrandAndModelsModel.fromJson(Map<String, dynamic> json) =>
      CarBrandAndModelsModel(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: List<CarModel>.from(
            json["result"].map((x) => CarModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class CarModel {
  int id;
  CarManufacturerId carManufacturerId;
  String carModel;

  CarModel({
    required this.id,
    required this.carManufacturerId,
    required this.carModel,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        carManufacturerId:
            CarManufacturerId.fromJson(json["carManufacturerId"]),
        carModel: json["carModel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturerId": carManufacturerId.toJson(),
        "carModel": carModel,
      };
}

class CarManufacturerId {
  int id;
  String carManufacturer;

  CarManufacturerId({
    required this.id,
    required this.carManufacturer,
  });

  factory CarManufacturerId.fromJson(Map<String, dynamic> json) =>
      CarManufacturerId(
        id: json["id"],
        carManufacturer: json["carManufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturer": carManufacturer,
      };
}
