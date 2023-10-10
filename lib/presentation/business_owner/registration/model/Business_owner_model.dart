import 'dart:io';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

class BusinessOwnerModel extends DriverBaseModel {
  String? entityName;
  String? taxNumber;
  String? nationalId;
  String? commercialNumber;
  String? token;
  List<File>? images;
  List<DriverImage>? imagesFromApi;
  UserDevice? userDevice;

  BusinessOwnerModel({
    id,
    firstName,
    lastName,
    mobile,
    email,
    gender,
    token,
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
    this.token = token;
    this.userDevice = userDevice;
    this.tokenExpirationTime = tokenExpirationTime;
    this.captainType = RegistrationConstants.businessOwner;
  }

  BusinessOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['businessOwner']['id'];
    firstName = json['businessOwner']['firstName'];
    lastName = json['businessOwner']['lastName'];
    mobile = json['businessOwner']['mobile'];
    email = json['businessOwner']['email'];
    gender = json['businessOwner']['gender'];
    taxNumber = json['businessOwner']['taxNumber'];
    nationalId = json['businessOwner']['nationalId'];
    entityName = json['businessOwner']['entityName'];
    imagesFromApi = List<DriverImage>.from(
        json['businessOwner']["images"].map((x) => DriverImage.fromJson(x)));
    commercialNumber = json['businessOwner']['commercialNumber'];
    token = json['businessOwner']["token"];
    userDevice = UserDevice.fromJson(json["userDevice"]);
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
    commercialNumber = json['commercialNumber'];
    imagesFromApi = List<DriverImage>.from(
        json["images"].map((x) => DriverImage.fromJson(x)));
    token = json["token"];
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
    data['token'] = token;
    data['nationalId'] = nationalId;
    data['images'] = imagesFromApi;
    data['entityName'] = entityName;
    data['commercialNumber'] = commercialNumber;
    data['captainType'] = RegistrationConstants.businessOwner;
    if (userDevice != null) data['userDevice'] = userDevice!.toJson();
    return data;
  }
}
