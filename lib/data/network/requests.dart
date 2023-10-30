import 'dart:io';

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

class GenerateOTPRequest {
  String phoneNumberWithCountryCode;

  GenerateOTPRequest(this.phoneNumberWithCountryCode);
}

class VerifyOTPRequest {
  String otp;
  String mobileNumber;

  VerifyOTPRequest(this.otp, this.mobileNumber);
}

class LogoutRequest {
  int userId;
  String registrationId;
  String language;

  LogoutRequest(this.userId, this.registrationId, this.language);
}

class UpdateProfileRequest {
  int driverId;
  String firstName;
  String lastName;
  String email;
  File? profilePhoto;

  UpdateProfileRequest(this.driverId, this.firstName, this.lastName, this.email,
      this.profilePhoto);
}

class AcceptOfferRequest {
  int userId;
  int tripId;

  AcceptOfferRequest(this.userId, this.tripId);
}

class AddOfferRequest {
  int userId;
  int tripId;
  int driverOffer;

  AddOfferRequest(this.userId, this.tripId, this.driverOffer);
}

class TripSummaryRequest {
  int userId;
  int tripId;

  TripSummaryRequest(this.userId, this.tripId);
}
