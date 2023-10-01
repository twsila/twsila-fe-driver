import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/service_type_model.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/general_response.dart';
import '../model/generate_otp_model.dart';
import '../model/logout_model.dart';
import '../model/service_status_model.dart';
import '../model/trip_details_model.dart';
import '../model/verify_otp_model.dart';

abstract class Repository {
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest);

  Future<Either<Failure, BusinessOwnerModel>> loginBO(
      LoginRequest loginRequest);

  Future<Either<Failure, List<ServiceTypeModel>>> registrationServiceTypes();

  Future<Either<Failure, List<CarModel>>> carBrandsAndModels();

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, RegistrationResponse>> register(
      RegistrationRequest registrationRequest);

  Future<Either<Failure, RegistrationBOResponse>> registerBO(
      BusinessOwnerModel businessOwnerModel);

  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest);

  Future<Either<Failure, VerifyOtpModel>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest);

  Future<Either<Failure, ServiceRegisterModel>> getServiceStatus(String userId);

  Future<Either<Failure, List<TripDetailsModel>>> getTrips(
      String tripTypeModuleId, int userId);

  Future<Either<Failure, List<TripDetailsModel>>> getMyTrips(
      String tripTypeModuleId, int userId);

  Future<Either<Failure, GeneralResponse>> acceptOffer(int userId, int tripId);

  Future<Either<Failure, GeneralResponse>> addOffer(
      int userId, int tripId, double driverOffer);

  Future<Either<Failure, BaseResponse>> changeTripStatus(
      int userId, int tripId, String tripStatus);

  Future<Either<Failure, TripDetailsModel>> tripSummary(int userId, int tripId);

  Future<Either<Failure, BaseResponse>> ratePassenger(
      int passengerId, double ratingNumber);

  Future<Either<Failure, BaseResponse>> UpdateProfile(
      UpdateProfileRequest updateProfileRequest);

  Future<Either<Failure, LogoutModel>> logout(LogoutRequest logoutRequest);

  Future<Either<Failure, LookupsModel>> getLookups();
}
