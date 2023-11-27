import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../pages/service_registration_second_step.dart';

class RegistrationRequest {
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? driverServiceType;
  String? vehicleTypeId;
  String? carManufacturerTypeId;
  String? carModelId;
  String? carNotes;
  String? plateNumber;
  List<File>? driverImages;
  List<XFile>? carImages;

  bool? canTransportFurniture;
  bool? canTransportGoods;
  bool? canTransportFrozen;
  bool? hasWaterTank;
  bool? hasOtherTanks;
  bool? hasPacking;
  bool? hasLoading;
  bool? hasAssembly;
  bool? hasLifting;

  DocumentData? carDocumentPhotosData;
  DocumentData? carDriverLicensePhotosData;
  DocumentData? carOwnerNationalIdPhotosData;
  DocumentData? carDriverNationalIdPhotosData;

  bool? isAcknowledged;

  RegistrationRequest.empty();

  RegistrationRequest(
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.driverServiceType,
      this.vehicleTypeId,
      this.carManufacturerTypeId,
      this.carModelId,
      this.carNotes,
      this.carImages,
      this.plateNumber,
      this.driverImages,
      this.canTransportFurniture,
      this.canTransportGoods,
      this.canTransportFrozen,
      this.hasWaterTank,
      this.hasOtherTanks,
      this.hasPacking,
      this.hasLoading,
      this.hasAssembly,
      this.hasLifting,
      this.isAcknowledged,
      {this.carDocumentPhotosData,
      this.carDriverLicensePhotosData,
      this.carDriverNationalIdPhotosData,
      this.carOwnerNationalIdPhotosData});
}

