import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../../app/constants.dart';
import '../../domain/model/car_brand_models_model.dart';
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

  @POST("/customers/register")
  Future<AuthenticationResponse> register(
      @Field("user_name") String userName,
      @Field("country_mobile_code") String countryMobileCode,
      @Field("mobile_number") String mobileNumber,
      @Field("email") String email,
      @Field("password") String password,
      @Field("profile_picture") String profilePicture);

  @POST("/drivers/registration-status")
  Future<ServiceRegisterModel> serviceStatus(@Field("userId") String userId);

  @GET("/home")
  Future<HomeResponse> getHomeData();

  @GET("/storeDetails/1")
  Future<StoreDetailsResponse> getStoreDetails();
}
