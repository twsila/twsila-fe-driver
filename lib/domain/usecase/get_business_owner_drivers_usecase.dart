import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';

import '../../data/network/failure.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class BusinessOwnerDriversUseCase
    implements BaseUseCase<BusinessOwnerDriversUseCaseInput, BaseResponse> {
  final Repository _repository;

  BusinessOwnerDriversUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      BusinessOwnerDriversUseCaseInput input) async {
    return await _repository.getBODrivers(input.businessOwnerId);
  }
}

class BusinessOwnerDriversUseCaseInput {
  int businessOwnerId;

  BusinessOwnerDriversUseCaseInput(this.businessOwnerId);
}
