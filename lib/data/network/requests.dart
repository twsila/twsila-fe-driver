class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);
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

  VerifyFirebaseOTPRequest(this.verificationId,this.code);
}
