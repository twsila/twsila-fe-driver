import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_for_you/domain/model/service_type_model.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/generate_otp_model.dart';
import '../model/logout_model.dart';
import '../model/models.dart';
import '../model/service_status_model.dart';
import '../model/verify_otp_model.dart';

abstract class Repository {
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest);

  Future<Either<Failure, List<ServiceTypeModel>>> registrationServiceTypes();

  Future<Either<Failure, List<CarModel>>> carBrandsAndModels();

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, RegistrationResponse>> register(
      RegistrationRequest registrationRequest);


  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest);

  Future<Either<Failure, VerifyOtpModel>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest);

  Future<Either<Failure, ServiceRegisterModel>> getServiceStatus(String userId);

  Future<Either<Failure, List<TripModel>>> getTrips(int tripTypeModuleId,int userId);

  Future<Either<Failure, LogoutModel>> logout(LogoutRequest logoutRequest);
}
