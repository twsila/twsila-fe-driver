import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/logout_model.dart';
import 'package:taxi_for_you/domain/model/registration_response_model.dart';
import 'package:taxi_for_you/domain/model/requested_drivers_response.dart';
import 'package:taxi_for_you/domain/model/service_status_model.dart';
import 'package:taxi_for_you/domain/model/verify_otp_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../domain/model/general_response.dart';
import '../../domain/model/lookups_model.dart';
import '../../domain/model/registration_services_response.dart';
import '../network/app_api.dart';
import '../network/requests.dart';
import '../response/responses.dart';

abstract class RemoteDataSource {
  Future<BaseResponse> getCountriesLookup();

  Future<LoginResponse> login(LoginRequest loginRequest);

  Future<GeneralResponse> loginBO(LoginRequest loginRequest);

  Future<GenerateOtpModel> generateOtp(GenerateOTPRequest generateOTPRequest);

  Future<BaseResponse> verifyOtp(VerifyOTPRequest verifyOTPRequest);

  Future<RegistrationServicesTypesResponse> registrationServicesType();

  Future<CarBrandAndModelsModel> carBrandAndModel();

  Future<RegistrationResponse> registerCaptainWithPersonsService(
      RegistrationRequest registrationRequest);

  Future<RegistrationResponse> registerCaptainWithGoodsService(
      RegistrationRequest registrationRequest);

  Future<RegistrationBOResponse> registerBOWithService(
      BusinessOwnerModel businessOwnerModel);

  Future<ServiceRegisterModel> servicesStatus(String userId);

  Future<BaseResponse> tripsByModuleId(
      String endPoint,
      String tripTypeModuleId,
      int userId,
      Map<String, dynamic>? dateFilter,
      Map<String, dynamic>? locationFilter,
      Map<String, dynamic>? currentLocation,
      String? sortCriterion);

  Future<BaseResponse> myTripsByModuleId(
      String endPoint, String tripTypeModuleId, int userId);

  Future<GeneralResponse> acceptOffer(int userId, int tripId);

  Future<GeneralResponse> addOffer(int userId, int tripId, double driverOffer);

  Future<BaseResponse> changeTripStatus(
      int userId, int tripId, String tripStatus);

  Future<GeneralResponse> tripSummary(int userId, int tripId);

  Future<BaseResponse> ratePassenger(int passengerId, double rateNumber);

  Future<BaseResponse> updateProfile(UpdateProfileRequest updateProfileRequest);

  Future<BaseResponse> updateProfileWithoutPhoto(
      UpdateProfileRequest updateProfileRequest);

  Future<BaseResponse> updateBOProfile(
      UpdateProfileRequest updateProfileRequest);

  Future<BaseResponse> updateBOProfileWithoutPhoto(
      UpdateProfileRequest updateProfileRequest);

  Future<BaseResponse> getBODrivers(int businessOwnerId);

  Future<BaseResponse> searchDriversByMobile(int mobileNumber);

  Future<LookupsModel> getLookups();

  Future<LogoutModel> logout(LogoutRequest logoutRequest);

  Future<LogoutModel> boLogout(LogoutRequest logoutRequest);

  Future<ForgotPasswordResponse> forgotPassword(String email);

  Future<BaseResponse> addDriverForBO(int businessOwnerId, int driverId);

  Future<BaseResponse> boAssignDriverForTrip(
      int businessOwnerId, int driverId, int tripId);

  Future<BaseResponse> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId);

  Future<BaseResponse> boSuggestNewOffer(
      int businessOwnerId, int tripId, double newSuggestedOffer, int driverId);

  Future<BaseResponse> getGoodsServiceTypes();

  Future<BaseResponse> getPersonsVehicleTypes();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.login, loginRequest.mobileUserDeviceDTO);
  }

  @override
  Future<GeneralResponse> loginBO(LoginRequest loginRequest) async {
    return await _appServiceClient.loginBO(
        loginRequest.login, loginRequest.mobileUserDeviceDTO);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<GenerateOtpModel> generateOtp(
      GenerateOTPRequest generateOTPRequest) async {
    return await _appServiceClient
        .generateOtp(generateOTPRequest.phoneNumberWithCountryCode);
  }

  @override
  Future<BaseResponse> verifyOtp(VerifyOTPRequest verifyOTPRequest) async {
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

  @override
  Future<LogoutModel> logout(LogoutRequest logoutRequest) async {
    return await _appServiceClient.logout(logoutRequest.refreshToken);
  }

  @override
  Future<RegistrationResponse> registerCaptainWithPersonsService(
      RegistrationRequest registrationRequest) async {
    return await _appServiceClient.registerCaptainWithPersonService(
        registrationRequest.firstName!,
        registrationRequest.lastName!,
        registrationRequest.mobile!,
        registrationRequest.email!,
        registrationRequest.gender!,
        registrationRequest.dateOfBirth!,
        registrationRequest.serviceTypeParam!,
        registrationRequest.vehicleTypeId!,
        registrationRequest.carManufacturerTypeId!,
        registrationRequest.carModelId!,
        registrationRequest.plateNumber!,
        registrationRequest.isAcknowledged!,
        registrationRequest.vehicleShapeId.toString(),
        registrationRequest.driverImages!);
  }

  @override
  Future<RegistrationResponse> registerCaptainWithGoodsService(
      RegistrationRequest registrationRequest) async {
    return await _appServiceClient.registerCaptainWithGoodsService(
        registrationRequest.firstName!,
        registrationRequest.lastName!,
        registrationRequest.mobile!,
        registrationRequest.email!,
        registrationRequest.gender!,
        registrationRequest.dateOfBirth!,
        registrationRequest.serviceTypeParam!,
        registrationRequest.vehicleTypeId!,
        registrationRequest.carManufacturerTypeId!,
        registrationRequest.carModelId!,
        registrationRequest.canTransportFurniture!,
        registrationRequest.canTransportGoods!,
        registrationRequest.canTransportFrozen!,
        registrationRequest.hasWaterTank!,
        registrationRequest.hasOtherTanks!,
        registrationRequest.hasPacking!,
        registrationRequest.hasLoading!,
        registrationRequest.hasAssembly!,
        registrationRequest.hasLifting!,
        registrationRequest.plateNumber!,
        registrationRequest.isAcknowledged!,
        registrationRequest.vehicleShapeId.toString(),
        registrationRequest.driverImages!);
  }

  @override
  Future<RegistrationBOResponse> registerBOWithService(
      BusinessOwnerModel businessOwnerModel) async {
    return await _appServiceClient.registerBOWithService(
        businessOwnerModel.firstName!,
        businessOwnerModel.lastName!,
        businessOwnerModel.mobile!,
        businessOwnerModel.email!,
        businessOwnerModel.gender!,
        businessOwnerModel.entityName!,
        businessOwnerModel.taxNumber!,
        businessOwnerModel.nationalId!,
        businessOwnerModel.commercialNumber!,
        businessOwnerModel.images!);
  }

  @override
  Future<BaseResponse> tripsByModuleId(
      String endPoint,
      String tripTypeModuleId,
      int userId,
      Map<String, dynamic>? dateFilter,
      Map<String, dynamic>? locationFilter,
      Map<String, dynamic>? currentLocation,
      String? sortCriterion) async {
    return await _appServiceClient.getTripsByModuleId(
        endPoint,
        tripTypeModuleId,
        userId,
        dateFilter,
        locationFilter,
        currentLocation,
        sortCriterion);
  }

  @override
  Future<BaseResponse> myTripsByModuleId(
      String endPoint, String tripTypeModuleId, int userId) async {
    return await _appServiceClient.getMyTripsByModuleId(
        endPoint, tripTypeModuleId, userId);
  }

  @override
  Future<GeneralResponse> acceptOffer(int userId, int tripId) async {
    return await _appServiceClient.acceptOffer(userId, tripId);
  }

  @override
  Future<GeneralResponse> addOffer(
      int userId, int tripId, double driverOffer) async {
    return await _appServiceClient.addOffer(userId, tripId, driverOffer);
  }

  @override
  Future<GeneralResponse> tripSummary(int userId, int tripId) async {
    return await _appServiceClient.tripSummary(userId, tripId);
  }

  @override
  Future<LookupsModel> getLookups() async {
    return await _appServiceClient.getLookups();
  }

  @override
  Future<BaseResponse> changeTripStatus(
      int userId, int tripId, String tripStatus) async {
    return await _appServiceClient.changeTripStatus(userId, tripId, tripStatus);
  }

  @override
  Future<BaseResponse> ratePassenger(int passengerId, double rateNumber) async {
    return await _appServiceClient.ratePassenger(passengerId, rateNumber);
  }

  @override
  Future<BaseResponse> updateProfile(
      UpdateProfileRequest updateProfileRequest) async {
    return await _appServiceClient.updateProfile(
        updateProfileRequest.driverId,
        updateProfileRequest.firstName,
        updateProfileRequest.lastName,
        updateProfileRequest.email,
        updateProfileRequest.profilePhoto!);
  }

  @override
  Future<BaseResponse> updateProfileWithoutPhoto(
      UpdateProfileRequest updateProfileRequest) async {
    return await _appServiceClient.updateProfileWithoutPhoto(
      updateProfileRequest.driverId,
      updateProfileRequest.firstName,
      updateProfileRequest.lastName,
      updateProfileRequest.email,
    );
  }

  @override
  Future<BaseResponse> updateBOProfile(
      UpdateProfileRequest updateProfileRequest) async {
    return await _appServiceClient.updateBOProfile(
        updateProfileRequest.driverId,
        updateProfileRequest.firstName,
        updateProfileRequest.lastName,
        updateProfileRequest.email,
        updateProfileRequest.profilePhoto!);
  }

  @override
  Future<BaseResponse> updateBOProfileWithoutPhoto(
      UpdateProfileRequest updateProfileRequest) async {
    return await _appServiceClient.updateBOProfileWithoutPhoto(
        updateProfileRequest.driverId,
        updateProfileRequest.firstName,
        updateProfileRequest.lastName,
        updateProfileRequest.email);
  }

  @override
  Future<BaseResponse> getBODrivers(int businessOwnerId) async {
    return await _appServiceClient.getBODrivers(businessOwnerId);
  }

  @override
  Future<BaseResponse> searchDriversByMobile(int mobileNumber) async {
    return await _appServiceClient.searchDriversByMobile(mobileNumber);
  }

  @override
  Future<BaseResponse> addDriverForBO(int businessOwnerId, int driverId) async {
    return await _appServiceClient.addDriverForBO(businessOwnerId, driverId);
  }

  @override
  Future<LogoutModel> boLogout(LogoutRequest logoutRequest) async {
    return await _appServiceClient.boLogout(logoutRequest.refreshToken);
  }

  @override
  Future<BaseResponse> boAcceptOffer(
      int businessOwnerId, int tripId, int driverId) async {
    return await _appServiceClient.boAcceptNewOffer(
        businessOwnerId, tripId, driverId);
  }

  @override
  Future<BaseResponse> boAssignDriverForTrip(
      int businessOwnerId, int driverId, int tripId) async {
    return await _appServiceClient.boAssignDriverToTrip(
        businessOwnerId, driverId, tripId);
  }

  @override
  Future<BaseResponse> boSuggestNewOffer(int businessOwnerId, int tripId,
      double newSuggestedOffer, int driverId) async {
    return await _appServiceClient.boSuggestNewOffer(
        businessOwnerId, tripId, newSuggestedOffer, driverId);
  }

  @override
  Future<BaseResponse> getCountriesLookup() async {
    return await _appServiceClient.getCountriesLookup();
  }

  @override
  Future<BaseResponse> getGoodsServiceTypes() async {
    return await _appServiceClient.getGoodsServiceTypes();
  }

  @override
  Future<BaseResponse> getPersonsVehicleTypes() async {
    return await _appServiceClient.getPersonsVehicleTypes();
  }
}
