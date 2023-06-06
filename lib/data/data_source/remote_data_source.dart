import 'dart:math';

import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';

import '../../domain/model/registration_services_response.dart';
import '../network/app_api.dart';
import '../network/requests.dart';
import '../response/responses.dart';

abstract class RemoteDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);

  Future<GenerateOtpModel> generateOtp(GenerateOTPRequest generateOTPRequest);

  Future<VerifyOtpModel> verifyOtp(VerifyOTPRequest verifyOTPRequest);

  Future<RegistrationServicesTypesResponse> registrationServicesType();

  Future<CarBrandAndModelsModel> carBrandAndModel();

  Future<AuthenticationResponse> register(RegisterRequest registerRequest);

  Future<ServiceRegisterModel> servicesStatus(String userId);

  Future<ForgotPasswordResponse> forgotPassword(String email);

  Future<HomeResponse> getHomeData();

  Future<StoreDetailsResponse> getStoreDetails();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(loginRequest.mobileNumber,
        loginRequest.language, loginRequest.userDeviceDTO);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<AuthenticationResponse> register(
      RegisterRequest registerRequest) async {
    return await _appServiceClient.register(
        "",
        "",
        "",
        "",
        "",
        ""
            "");
  }

  @override
  Future<HomeResponse> getHomeData() async {
    return await _appServiceClient.getHomeData();
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    return await _appServiceClient.getStoreDetails();
  }

  @override
  Future<GenerateOtpModel> generateOtp(
      GenerateOTPRequest generateOTPRequest) async {
    return await _appServiceClient
        .generateOtp(generateOTPRequest.phoneNumberWithCountryCode);
  }

  @override
  Future<VerifyOtpModel> verifyOtp(VerifyOTPRequest verifyOTPRequest) async {
    return await _appServiceClient.verifyOtp(verifyOTPRequest.mobileNumber,
        verifyOTPRequest.otp, verifyOTPRequest.otp);
  }

  @override
  Future<RegistrationServicesTypesResponse> registrationServicesType() async {
    return await _appServiceClient.registrationServices();
  }

  @override
  Future<CarBrandAndModelsModel> carBrandAndModel() async {
    return await _appServiceClient.carBrandsAndModels();
  }

  @override
  Future<ServiceRegisterModel> servicesStatus(String userId) async {
    return await _appServiceClient.serviceStatus(userId);
  }
}
