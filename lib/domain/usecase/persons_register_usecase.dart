import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class PersonsRegisterUseCase
    implements BaseUseCase<PersonsRegisterUseCaseInput, Authentication> {
  final Repository _repository;

  PersonsRegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      PersonsRegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.serviceType,
        input.serviceTypeCapacity,
        input.plateNumber,
        input.carBrandAndModel,
        input.notes,
        input.carDocumentImage,
        input.carOwnerLicenseImage,
        input.carOwnerIdentityCardImage,
        input.carDriverIdentityCardImage));
  }
}

class PersonsRegisterUseCaseInput {
  String serviceType;
  String serviceTypeCapacity;
  int plateNumber;
  String carBrandAndModel;
  String notes;
  String carDocumentImage;
  String carOwnerLicenseImage;
  String carOwnerIdentityCardImage;
  String carDriverIdentityCardImage;

  PersonsRegisterUseCaseInput(
      this.serviceType,
      this.serviceTypeCapacity,
      this.plateNumber,
      this.carBrandAndModel,
      this.notes,
      this.carDocumentImage,
      this.carOwnerLicenseImage,
      this.carOwnerIdentityCardImage,
      this.carDriverIdentityCardImage);
}
