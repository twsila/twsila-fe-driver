class LoginRequest {
  String mobileNumber;
  String language;
  Map<String, dynamic> userDeviceDTO;

  LoginRequest(this.mobileNumber, this.language, this.userDeviceDTO);
}

class RegisterRequest {
  String serviceType;
  String serviceTypeCapacity;
  int plateNumber;
  String carBrandAndModel;
  String notes;
  String carDocumentImage;
  String carOwnerLicenseImage;
  String carOwnerIdentityCardImage;
  String carDriverIdentityCardImage;

  RegisterRequest(
      this.serviceType,
      this.serviceTypeCapacity,
      this.plateNumber,
      this.carBrandAndModel,
      this.notes,
      this.carDocumentImage,
      this.carOwnerLicenseImage,
      this.carOwnerIdentityCardImage,
      this.carDriverIdentityCardImage);
}

class GenerateFirebaseOTPRequest {
  String phoneNumberWithCountryCode;

  GenerateFirebaseOTPRequest(this.phoneNumberWithCountryCode);
}

class VerifyFirebaseOTPRequest {
  String verificationId;
  String code;

  VerifyFirebaseOTPRequest(this.verificationId, this.code);
}
