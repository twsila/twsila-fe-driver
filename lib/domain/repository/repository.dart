import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/ServiceTypeModel.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/generate_otp_model.dart';
import '../model/models.dart';
import '../model/verify_otp_model.dart';

abstract class Repository {
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest);

  Future<Either<Failure, List<ServiceTypeModel>>> registrationServiceTypes();

  Future<Either<Failure, List<CarModel>>> carBrandsAndModels();

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);

  Future<Either<Failure, HomeObject>> getHomeData();

  Future<Either<Failure, StoreDetails>> getStoreDetails();

  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest);

  Future<Either<Failure, VerifyOtpModel>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest);
}
