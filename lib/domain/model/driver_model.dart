// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

import '../../data/response/responses.dart';

Driver driverModelFromJson(String str) => Driver.fromJson(json.decode(str));

String driverModelToJson(Driver data) => json.encode(data.toJson());

class Driver {
  int id;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String gender;
  String dateOfBirth;
  String driverServiceType;
  String registrationStatus;
  DriverVehicleType vehicleType;
  DriverCarManufacturer carManufacturerType;
  DriverCarModel carModel;
  bool canTransportFurniture;
  bool canTransportGoods;
  bool canTransportFrozen;
  bool hasWaterTank;
  bool hasOtherTanks;
  bool hasPacking;
  bool hasLoading;
  bool hasAssembly;
  bool hasLifting;
  String plateNumber;
  List<DriverImage> images;
  double rating;
  bool acknowledged;
  String token;
  UserDevice? userDevice;
  String? tokenExpirationTime;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.driverServiceType,
    required this.registrationStatus,
    required this.vehicleType,
    required this.carManufacturerType,
    required this.carModel,
    required this.canTransportFurniture,
    required this.canTransportGoods,
    required this.canTransportFrozen,
    required this.hasWaterTank,
    required this.hasOtherTanks,
    required this.hasPacking,
    required this.hasLoading,
    required this.hasAssembly,
    required this.hasLifting,
    required this.plateNumber,
    required this.images,
    required this.rating,
    required this.acknowledged,
    required this.token,
    required this.userDevice,
    required this.tokenExpirationTime,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        driverServiceType: json["driverServiceType"],
        registrationStatus: json["registrationStatus"],
        vehicleType: DriverVehicleType.fromJson(json["vehicleType"]),
        carManufacturerType:
            DriverCarManufacturer.fromJson(json["carManufacturerType"]),
        carModel: DriverCarModel.fromJson(json["carModel"]),
        canTransportFurniture: json["canTransportFurniture"],
        canTransportGoods: json["canTransportGoods"],
        canTransportFrozen: json["canTransportFrozen"],
        hasWaterTank: json["hasWaterTank"],
        hasOtherTanks: json["hasOtherTanks"],
        hasPacking: json["hasPacking"],
        hasLoading: json["hasLoading"],
        hasAssembly: json["hasAssembly"],
        hasLifting: json["hasLifting"],
        plateNumber: json["plateNumber"],
        images: List<DriverImage>.from(
            json["images"].map((x) => DriverImage.fromJson(x))),
        rating: json["rating"],
        acknowledged: json["acknowledged"],
        token: json["token"] ?? "",
        userDevice: json["userDevice"] ??
            UserDevice(
                id: 0,
                registrationId: 'registrationId',
                deviceOs: 'deviceOs',
                appVersion: 'appVersion',
                userId: 0),
        tokenExpirationTime: json["tokenExpirationTime"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "driverServiceType": driverServiceType,
        "registrationStatus": registrationStatus,
        "vehicleType": vehicleType.toJson(),
        "carManufacturerType": carManufacturerType.toJson(),
        "carModel": carModel.toJson(),
        "canTransportFurniture": canTransportFurniture,
        "canTransportGoods": canTransportGoods,
        "canTransportFrozen": canTransportFrozen,
        "hasWaterTank": hasWaterTank,
        "hasOtherTanks": hasOtherTanks,
        "hasPacking": hasPacking,
        "hasLoading": hasLoading,
        "hasAssembly": hasAssembly,
        "hasLifting": hasLifting,
        "plateNumber": plateNumber,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "rating": rating,
        "acknowledged": acknowledged,
        "token": token,
        "userDevice": userDevice,
        "tokenExpirationTime": tokenExpirationTime,
      };
}

class DriverCarManufacturer {
  int id;
  String carManufacturer;

  DriverCarManufacturer({
    required this.id,
    required this.carManufacturer,
  });

  factory DriverCarManufacturer.fromJson(Map<String, dynamic> json) =>
      DriverCarManufacturer(
        id: json["id"],
        carManufacturer: json["carManufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturer": carManufacturer,
      };
}

class DriverCarModel {
  int id;
  DriverCarManufacturer carManufacturerId;
  String modelName;

  DriverCarModel({
    required this.id,
    required this.carManufacturerId,
    required this.modelName,
  });

  factory DriverCarModel.fromJson(Map<String, dynamic> json) => DriverCarModel(
        id: json["id"],
        carManufacturerId:
            DriverCarManufacturer.fromJson(json["carManufacturerId"]),
        modelName: json["modelName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "carManufacturerId": carManufacturerId.toJson(),
        "modelName": modelName,
      };
}

class DriverImage {
  int id;
  String imageName;

  DriverImage({
    required this.id,
    required this.imageName,
  });

  factory DriverImage.fromJson(Map<String, dynamic> json) => DriverImage(
        id: json["id"],
        imageName: json["imageName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageName": imageName,
      };
}

class DriverVehicleType {
  int id;
  String vehicleType;
  String driverServiceType;

  DriverVehicleType({
    required this.id,
    required this.vehicleType,
    required this.driverServiceType,
  });

  factory DriverVehicleType.fromJson(Map<String, dynamic> json) =>
      DriverVehicleType(
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

UserDevice userDeviceFromJson(String str) =>
    UserDevice.fromJson(json.decode(str));

String userDeviceToJson(UserDevice data) => json.encode(data.toJson());

class UserDevice {
  int id;
  String registrationId;
  String deviceOs;
  String appVersion;
  int userId;

  UserDevice({
    required this.id,
    required this.registrationId,
    required this.deviceOs,
    required this.appVersion,
    required this.userId,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) => UserDevice(
        id: json["id"],
        registrationId: json["registrationId"],
        deviceOs: json["deviceOs"],
        appVersion: json["appVersion"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registrationId": registrationId,
        "deviceOs": deviceOs,
        "appVersion": appVersion,
        "userId": userId,
      };
}
