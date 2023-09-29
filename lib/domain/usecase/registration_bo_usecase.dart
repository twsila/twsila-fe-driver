import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegistrationBOUseCase
    implements BaseUseCase<BusinessOwnerModel, RegistrationResponse> {
  final Repository _repository;

  RegistrationBOUseCase(this._repository);

  @override
  Future<Either<Failure, RegistrationResponse>> execute(
      BusinessOwnerModel businessOwnerModel) async {
    return await _repository.registerBO(businessOwnerModel);
  }
}
