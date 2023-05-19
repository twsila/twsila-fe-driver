// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  String firstName;
  String lastName;
  String mobile;
  String email;
  String gender;
  String dateOfBirth;
  String token;
  UserDevice userDevice;
  String tokenExpirationTime;

  Driver({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.token,
    required this.userDevice,
    required this.tokenExpirationTime,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobile: json["mobile"],
    email: json["email"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"],
    token: json["token"],
    userDevice: UserDevice.fromJson(json["userDevice"]),
    tokenExpirationTime: json["tokenExpirationTime"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "mobile": mobile,
    "email": email,
    "gender": gender,
    "dateOfBirth": dateOfBirth,
    "token": token,
    "userDevice": userDevice.toJson(),
    "tokenExpirationTime": tokenExpirationTime,
  };
}

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
