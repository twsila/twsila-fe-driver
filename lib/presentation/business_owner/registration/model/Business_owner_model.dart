import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

class BusinessOwnerModel extends DriverBaseModel {
  String? entityName;
  String? taxNumber;
  String? nationalId;
  String? commercialNumber;
  List<File>? images;
  List<DriverImage>? imagesFromApi;
  UserDevice? userDevice;
  XFile? profileImage;

  BusinessOwnerModel({
    id,
    firstName,
    lastName,
    mobile,
    email,
    gender,
    token,
    this.profileImage,
    this.taxNumber,
    this.entityName,
    this.nationalId,
    this.imagesFromApi,
    this.commercialNumber,
    this.userDevice,
  }) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobile = mobile;
    this.email = email;
    this.gender = gender;
    this.imagesFromApi = imagesFromApi;
    this.userDevice = userDevice;
    this.tokenExpirationTime = tokenExpirationTime;
    this.profileImage = profileImage;
    this.captainType = RegistrationConstants.businessOwner;
  }

  BusinessOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    entityName = json['entityName'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    commercialNumber = json['commercialNumber'];
    userDevice = json["userDevice"] != null ? UserDevice.fromJson(json["userDevice"]) : null;
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
  }

  BusinessOwnerModel.fromJsonDirect(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    entityName = json['entityName'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    commercialNumber = json['commercialNumber'];
    userDevice = json["userDevice"] != null ? UserDevice.fromJson(json["userDevice"]) : null;
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
  }

  BusinessOwnerModel.fromCachedJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    entityName = json['entityName'];
    accessToken = json["accessToken"];
    refreshToken = json["refreshToken"];
    commercialNumber = json['commercialNumber'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    userDevice = json["userDevice"];
    tokenExpirationTime = json["tokenExpirationTime"];
    captainType = RegistrationConstants.businessOwner;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['taxNumber'] = taxNumber;
    data['nationalId'] = nationalId;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['images'] = imagesFromApi;
    data['entityName'] = entityName;
    data['commercialNumber'] = commercialNumber;
    data['captainType'] = RegistrationConstants.businessOwner;
    if (userDevice != null) data['userDevice'] = userDevice!.toJson();
    return data;
  }
}
