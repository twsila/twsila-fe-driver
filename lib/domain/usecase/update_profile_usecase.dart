import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/repository/repository.dart';
import 'package:taxi_for_you/domain/usecase/base_usecase.dart';

import '../../data/network/failure.dart';

class UpdateProfileUseCase
    implements BaseUseCase<UpdateProfileUseCaseInput, BaseResponse> {
  final Repository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      UpdateProfileUseCaseInput input) async {
    return await _repository.UpdateProfile(UpdateProfileRequest(input.userId,
        input.firstName, input.lastName, input.email, input.profilePhoto));
  }
}

class UpdateBOProfileUseCase
    implements BaseUseCase<UpdateProfileUseCaseInput, BaseResponse> {
  final Repository _repository;

  UpdateBOProfileUseCase(this._repository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      UpdateProfileUseCaseInput input) async {
    return await _repository.UpdateBOProfile(UpdateProfileRequest(input.userId,
        input.firstName, input.lastName, input.email, input.profilePhoto));
  }
}

class UpdateProfileUseCaseInput {
  int userId;
  String firstName;
  String lastName;
  String email;
  File? profilePhoto;

  UpdateProfileUseCaseInput(this.userId, this.firstName, this.lastName,
      this.email, this.profilePhoto);
}
