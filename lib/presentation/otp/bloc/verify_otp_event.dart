part of 'verify_otp_bloc.dart';

@immutable
abstract class VerifyOtpEvent {}

class SendOtpEvent extends VerifyOtpEvent {
  final String mobileNumber;

  SendOtpEvent(this.mobileNumber);
}

class ReSendOtpEvent extends VerifyOtpEvent {
  final String mobileNumber;

  ReSendOtpEvent(this.mobileNumber);
}

class VerifyOtpBEEvent extends VerifyOtpEvent {
  final String mobileNumber;
  final String otpCode;

  VerifyOtpBEEvent(this.mobileNumber, this.otpCode);
}

class MakeLoginEvent extends VerifyOtpEvent {
  String mobileNumber;
  String appLanguage;

  MakeLoginEvent(this.mobileNumber, this.appLanguage);
}
