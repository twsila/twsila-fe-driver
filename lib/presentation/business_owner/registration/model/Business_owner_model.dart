import 'dart:io';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

class BusinessOwnerModel extends DriverBaseModel {
  String? entityName;
  String? taxNumber;
  String? nationalId;
  String? commercialNumber;
  List<File>? images;
  UserDevice? userDevice;

  BusinessOwnerModel({
    id,
    firstName,
    lastName,
    mobile,
    email,
    gender,
    this.taxNumber,
    this.entityName,
    this.nationalId,
    this.commercialNumber,
    this.userDevice,
  }) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobile = mobile;
    this.email = email;
    this.gender = gender;
    this.token = token;
    this.userDevice = userDevice;
    this.tokenExpirationTime = tokenExpirationTime;
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
    commercialNumber = json['commercialNumber'];
    token = json["token"];
    userDevice = json["userDevice"];
    tokenExpirationTime = json["tokenExpirationTime"];
    userDevice = json['userDevice'];
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
    data['entityName'] = entityName;
    data['commercialNumber'] = commercialNumber;
    if (userDevice != null) data['userDevice'] = userDevice!.toJson();
    return data;
  }
}
