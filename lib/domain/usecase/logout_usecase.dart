import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LogoutUseCase implements BaseUseCase<LogoutUseCaseInput, LogoutModel> {
  final Repository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutModel>> execute(LogoutUseCaseInput input) async {
    return await _repository.logout(
        LogoutRequest(input.userId, input.registrationId, input.language));
  }
}

class LogoutUseCaseInput {
  int userId;
  String registrationId;
  String language;

  LogoutUseCaseInput(this.userId, this.registrationId, this.language);
}class BoLogoutUseCase implements BaseUseCase<BoLogoutUseCaseInput, LogoutModel> {
  final Repository _repository;

  BoLogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutModel>> execute(BoLogoutUseCaseInput input) async {
    return await _repository.boLogout(
        LogoutRequest(input.userId, input.registrationId, input.language));
  }
}

class BoLogoutUseCaseInput {
  int userId;
  String registrationId;
  String language;

  BoLogoutUseCaseInput(this.userId, this.registrationId, this.language);
}
