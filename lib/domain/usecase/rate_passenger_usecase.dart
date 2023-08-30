import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/response/responses.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RatePassengerUseCase
    implements BaseUseCase<RatePassengerUseCaseInput, BaseResponse> {
  final Repository _repository;

  RatePassengerUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      RatePassengerUseCaseInput input) {
    return _repository.ratePassenger(input.passengerId, input.ratingNumber);
  }
}

class RatePassengerUseCaseInput {
  int passengerId;
  double ratingNumber;

  RatePassengerUseCaseInput(this.passengerId, this.ratingNumber);
}
