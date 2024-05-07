import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../domain/model/driver_model.dart';
import '../domain/model/models.dart';

class Constants {
  static const String baseUrl =
      "https://twsila-dev-service-f33wiujt7a-lm.a.run.app";
  static const String empty = "";
  static const String token = "";
  static const int zero = 0;
  static const int apiTimeOut = 60000;
  static const int onChangeDebounceMilliseconds = 800;
  static const String GOOGLE_API_KEY_ANDROID =
      "AIzaSyDudVHh73YAVrXD1CgiJPtIbFbquCmavlA";
  static const String GOOGLE_API_KEY_IOS =
      "AIzaSyD8KjkW8eLaDD3qeZIiPPDxqfdK8olftWs";
  static const String UPLOAD_DOCUMENTS_TYPE = "upload_documents_type";

  static const int IMAGE_QUALITY_COMPRESS = 25;
  static const String DRIVER_PHOTO_IMAGE_STRING = 'driver_photo.jpg';
  static const String BUSINESS_OWNER_PHOTO_IMAGE_STRING =
      'business_owner_photo.jpg';

  static const String dateFormatterString = "dd/MM/yyyy hh:mm:ss";

  static const int refreshCurrentLocationSeconds = 2;
  static const int MAXIMUM_MULTI_PIC_IMAGES = 4;

  static const int otpCountTime = 30;
  static const int otpSize = 6;
  static const bool showCursorOtpField = false;

  static List<CountryCodes> countryList = [
    CountryCodes(ImageAssets.saudiFlag, AppStrings.saudiCountryCode, 'SA',
        AppStrings.saudiArabia),
    CountryCodes(ImageAssets.egyptFlag, AppStrings.egyptCountryCode, 'EG',
        AppStrings.egypt)
  ];
}
class PaymentConstants {

  static const String TESTING_KEY = "pk_test_VzZuYND1H3pFgVYv9TLFwrK1mFuLGtELzAEjCQe3";
  static const String PRODUCTION_KEY = "sk_live_Ecy2VbCxLsULrzGjD1roctVCHKeW4d91mDwTzFSP";
}

class UserTypeConstants {
  static const String DRIVER = "DRIVER";
  static const String BUSINESS_OWNER = "BUSINESS_OWNER";
}

class EndPointsConstants {
  static const String loginPath = "/api/v1/auth/login";
  static const String refreshToken = "/api/v1/auth/refresh-token";
  static const String logoutPath = "/api/v1/auth/logout";
  static const String registration = "/drivers/register";
  static const String BoRegistration = "/bo/register";
  static const String otpGenerate = "/otp/generate";
  static const String otpValidate = "/otp/validate";

  static const String goodsServiceTypes = "/drivers/service-types";
  static const String personsVehicleTypes = "/drivers/vehicle-types";
  static const String carModels = "/drivers/car-model";
  static const String lookups = "/lookups";
  static const String countryLookup = "/lookups/country";
  static const String lookupByKey = "/lookups/by-key";

  static const List<String> cancelTokenApis = [
    logoutPath,
    loginPath,
    otpGenerate,
    refreshToken,
    otpValidate,
    registration,
    BoRegistration,
    goodsServiceTypes,
    personsVehicleTypes,
    carModels,
    lookups,
    countryLookup,
    lookupByKey
  ];
}

class TripTypeConstants {
  static const String carAidType = "CAR_AID";
  static const String drinkWaterType = "DRINK_WATER_TANK";
  static const String frozenType = "FROZEN";
  static const String furnitureType = "FURNITURE";
  static const String goodsType = "GOODS";
  static const String otherTankType = "OTHER_TANK";
  static const String personsType = "PERSONS";
}
class LookupKeys {
  static const String serviceType = "ServiceType";
  static const String tankType = "TankType";
}

class TripStatusConstants {
  static const String DRAFT = "DRAFT";
  static const String SUBMITTED = "SUBMITTED";
  static const String EVALUATION = "EVALUATION";
  static const String PAYMENT = "PAYMENT";
  static const String WAIT_FOR_TAKEOFF = "WAIT_FOR_TAKEOFF";
  static const String TAKEOFF = "TAKEOFF";
  static const String EXECUTED = "EXECUTED";
  static const String COMPLETED = "COMPLETED";
  static const String CANCELLED = "CANCELLED";
}

class EndPoints {
  static const String DriversTrips = "/drivers/offers/select-trip";
  static const String DriverMyTrips = "/drivers/offers/select-my-trip";
  static const String BusinessOwnerTrips = "/driver-acquisition/select-trip";
  static const String BusinessOwnerMyTrips =
      "/driver-acquisition/select-my-trip";
}
