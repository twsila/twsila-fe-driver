import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/driver_model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, DriverBaseModel> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, DriverBaseModel>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(
        LoginRequest(input.mobileNumber, input.language, input.userDeviceDTO));
  }
}

class LoginUseCaseInput {
  String mobileNumber;
  String language;
  Map<String, dynamic> userDeviceDTO;

  LoginUseCaseInput(this.mobileNumber, this.language, this.userDeviceDTO);
}

class LoginBOUseCase
    implements BaseUseCase<LoginBOUseCaseInput, DriverBaseModel> {
  final Repository _repository;

  LoginBOUseCase(this._repository);

  @override
  Future<Either<Failure, DriverBaseModel>> execute(
      LoginBOUseCaseInput input) async {
    return await _repository.loginBO(
        LoginRequest(input.mobileNumber, input.language, input.userDeviceDTO));
  }
}

class LoginBOUseCaseInput {
  String mobileNumber;
  String language;
  Map<String, dynamic> userDeviceDTO;

  LoginBOUseCaseInput(this.mobileNumber, this.language, this.userDeviceDTO);
}
