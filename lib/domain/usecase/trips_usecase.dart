import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../data/network/failure.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class TripsUseCase implements BaseUseCase<TripsInput, List<TripModel>> {
  final Repository _repository;

  TripsUseCase(this._repository);

  @override
  Future<Either<Failure, List<TripModel>>> execute(TripsInput input) async {
    return await _repository.getTrips(input.tripModuleId, input.userId);
  }
}

class TripsInput {
  String tripModuleId;
  int userId;

  TripsInput(this.tripModuleId, this.userId);
}
