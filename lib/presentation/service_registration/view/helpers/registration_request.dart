import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/addiontal_serivces_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/services_card_widget.dart';

import '../pages/service_registration_second_step.dart';

class RegistrationRequest {
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? serviceTypeParam;
  String? vehicleTypeId;
  String? carManufacturerTypeId;
  String? carModelId;
  String? carNotes;
  String? tankType;
  String? plateNumber;
  String? vehicleShapeId;
  String? countryCode;
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

  AdditionalServicesModel? additionalServicesModel;

  bool? isAcknowledged;

  int? serviceModelId;

  RegistrationRequest.empty();

  RegistrationRequest(
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.serviceTypeParam,
      this.vehicleTypeId,
      this.carManufacturerTypeId,
      this.carModelId,
      this.tankType,
      this.carNotes,
      this.countryCode,
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
      this.carOwnerNationalIdPhotosData,
      this.vehicleShapeId,
      this.additionalServicesModel,this.serviceModelId});
}
