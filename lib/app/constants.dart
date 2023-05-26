import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../domain/model/models.dart';

class Constants {
  static const String baseUrl =
      "https://twsila-dev-service-f33wiujt7a-lm.a.run.app";
  static const String empty = "";
  static const String token = "NO TOKEN SAVED";
  static const int zero = 0;
  static const int apiTimeOut = 60000;
  static const String GOOGLE_API_KEY =
      "AIzaSyCuu1VQ3jSSyDLG0m7qBxLGR1xqv6wVm1w";
  static const String UPLOAD_DOCUMENTS_TYPE = "upload_documents_type";

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
