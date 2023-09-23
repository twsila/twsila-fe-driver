import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

class BusinessOwnerModel {
  int? userid;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? gender;
  String? entityName;
  String? taxNumber;
  String? nationalId;
  String? commercialNumber;
  List<XFile>? images;
  UserDevice? userDevice;

  BusinessOwnerModel({
    this.userid,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.gender,
    this.taxNumber,
    this.entityName,
    this.nationalId,
    this.commercialNumber,
    this.userDevice,
  });

  BusinessOwnerModel.fromJson(Map<String, dynamic> json) {
    userid = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    taxNumber = json['taxNumber'];
    nationalId = json['nationalId'];
    entityName = json['entityName'];
    commercialNumber = json['commercialNumber'];
    if (json['userDevice'] != null) UserDevice.fromJson(json['userDevice']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (userid != null) data['id'] = userid;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['mobile'] = mobileNumber;
    data['gender'] = gender;
    data['taxNumber'] = taxNumber;
    data['nationalId'] = nationalId;
    data['entityName'] = entityName;
    data['commercialNumber'] = commercialNumber;
    if (userDevice != null) data['userDevice'] = userDevice!.toJson();
    return data;
  }
}
