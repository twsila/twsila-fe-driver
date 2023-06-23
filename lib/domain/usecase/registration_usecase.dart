import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegistrationUseCase
    implements BaseUseCase<RegistrationUseCaseInput, RegistrationResponse> {
  final Repository _repository;

  RegistrationUseCase(this._repository);

  @override
  Future<Either<Failure, RegistrationResponse>> execute(
      RegistrationUseCaseInput input) async {
    return await _repository.register(RegistrationRequest(
        input.firstName,
        input.lastName,
        input.mobile,
        input.email,
        input.gender,
        input.dateOfBirth,
        input.driverServiceType,
        input.vehicleTypeId,
        input.carManufacturerTypeId,
        input.carModelId,
        input.carNotes,
        input.plateNumber,
        input.driverImages,
        input.canTransportFurniture,
        input.canTransportGoods,
        input.canTransportFrozen,
        input.hasWaterTank,
        input.hasOtherTanks,
        input.hasPacking,
        input.hasLoading,
        input.hasAssembly,
        input.hasLifting,
        input.isAcknowledged));
  }
}

class RegistrationUseCaseInput {
  String firstName;
  String lastName;
  String mobile;
  String email;
  String gender;
  String dateOfBirth;
  String driverServiceType;
  String vehicleTypeId;
  String carManufacturerTypeId;
  String carModelId;
  String carNotes;
  String plateNumber;
  List<File> driverImages;

  bool? canTransportFurniture;
  bool? canTransportGoods;
  bool? canTransportFrozen;
  bool? hasWaterTank;
  bool? hasOtherTanks;
  bool? hasPacking;
  bool? hasLoading;
  bool? hasAssembly;
  bool? hasLifting;

  bool isAcknowledged;

  RegistrationUseCaseInput(
      {required this.firstName,
      required this.lastName,
      required this.mobile,
      required this.email,
      required this.gender,
      required this.dateOfBirth,
      required this.driverServiceType,
      required this.vehicleTypeId,
      required this.carManufacturerTypeId,
      required this.carModelId,
      required this.carNotes,
      required this.plateNumber,
      required this.driverImages,
      this.canTransportFurniture = false,
      this.canTransportGoods = false,
      this.canTransportFrozen = false,
      this.hasWaterTank = false,
      this.hasOtherTanks = false,
      this.hasPacking = false,
      this.hasLoading = false,
      this.hasAssembly = false,
      this.hasLifting = false,
      required this.isAcknowledged});
}
