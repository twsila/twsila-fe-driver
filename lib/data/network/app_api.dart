import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:taxi_for_you/domain/model/general_response.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../../app/constants.dart';
import '../../domain/model/car_brand_models_model.dart';
import '../../domain/model/logout_model.dart';
import '../../domain/model/registration_services_response.dart';
import '../../domain/model/service_status_model.dart';
import '../response/responses.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/drivers/login")
  Future<LoginResponse> login(
      @Field("mobile") String mobile,
      @Field("language") String language,
      @Field("userDeviceDTO") Map<String, dynamic> userDeviceDTO);

  @POST("/bo/login")
  Future<GeneralResponse> loginBO(
      @Field("mobile") String mobile,
      @Field("language") String language,
      @Field("userDeviceDTO") Map<String, dynamic> userDeviceDTO);

  @POST("/otp/generate")
  Future<GenerateOtpModel> generateOtp(
    @Field("mobile") String mobile,
  );

  @POST("/otp/validate")
  Future<VerifyOtpModel> verifyOtp(
    @Field("mobile") String mobile,
    @Field("userOtp") String userOtp,
    @Field("generatedOtp") String generatedOtp,
  );

  @GET("/drivers/vehicle-types")
  Future<RegistrationServicesTypesResponse> registrationServices();

  @GET("/drivers/car-model")
  Future<CarBrandAndModelsModel> carBrandsAndModels();

  @POST("/customers/forgotPassword")
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);

  @POST("/drivers/register")
  @MultiPart()
  Future<RegistrationResponse> registerCaptainWithService(
      @Part(name: "firstName") String firstName,
      @Part(name: "lastName") String lastName,
      @Part(name: "mobile") String mobile,
      @Part(name: "email") String email,
      @Part(name: "gender") String gender,
      @Part(name: "dateOfBirth") String dateOfBirth,
      @Part(name: "driverServiceType") String driverServiceType,
      @Part(name: "vehicleType.id") String vehicleTypeId,
      @Part(name: "carManufacturerType.id") String carManufacturerTypeId,
      @Part(name: "carModel.id") String carModelId,
      @Part(name: "canTransportFurniture") bool canTransportFurniture,
      @Part(name: "canTransportGoods") bool canTransportGoods,
      @Part(name: "canTransportFrozen") bool canTransportFrozen,
      @Part(name: "hasWaterTank") bool hasWaterTank,
      @Part(name: "hasPacking") bool hasPacking,
      @Part(name: "hasLoading") bool hasLoading,
      @Part(name: "hasAssembly") bool hasAssembly,
      @Part(name: "hasLifting") bool hasLifting,
      @Part(name: "plateNumber") String plateNumber,
      @Part(name: "isAcknowledged") bool isAcknowledged,
      @Part(name: "driverImages") List<File> driverImages);

  @POST("/drivers/registration-status")
  Future<ServiceRegisterModel> serviceStatus(@Field("userId") String userId);

  @POST("/drivers/offers/select-trip")
  Future<BaseResponse> getTripsByModuleId(
      @Field("tripModelType") String tripModelType,
      @Field("userId") int userId);

  @POST("/drivers/offers/select-my-trip")
  Future<BaseResponse> getMyTripsByModuleId(
      @Field("tripModelType") String tripModelType,
      @Field("userId") int userId);

  @POST("/drivers/offers/add")
  Future<GeneralResponse> addOffer(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
    @Field("driverOffer") double driverOffer,
  );

  @PUT("/drivers/offers/accept")
  Future<GeneralResponse> acceptOffer(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
  );

  @POST("/drivers/trip-summary")
  Future<GeneralResponse> tripSummary(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
  );

  @GET("/lookups")
  Future<LookupsModel> getLookups();

  @POST("/drivers/logout")
  Future<LogoutModel> logout(
    @Field("userId") int userId,
    @Field("registrationId") String registrationId,
    @Field("language") String language,
  );

  @POST("/drivers/trips/change-status")
  Future<BaseResponse> changeTripStatus(
    @Field("userId") int userId,
    @Field("tripId") int tripId,
    @Field("tripStatus") String tripStatus,
  );

  @POST("/passengers/trips/rate")
  Future<BaseResponse> ratePassenger(
    @Field("PassengerId") int passengerId,
    @Field("rating") double rateNumber,
  );

  @POST("/drivers/register")
  @MultiPart()
  Future<BaseResponse> updateProfile(
    @Part(name: "driverId") int driverId,
    @Part(name: "firstName") String firstName,
    @Part(name: "lastName") String lastName,
    @Part(name: "email") String email,
    @Part(name: "profilePhoto") File profilePhoto,
  );
}
