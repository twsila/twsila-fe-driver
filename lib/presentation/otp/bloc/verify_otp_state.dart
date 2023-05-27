part of 'verify_otp_bloc.dart';

@immutable
abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class GenerateOtpSuccess extends VerifyOtpState {
  String otp;

  GenerateOtpSuccess(this.otp);
}

class GenerateOtpFail extends VerifyOtpState {
  final String message;
  final String code;

  GenerateOtpFail(this.message, this.code);
}

class VerifyOtpSuccess extends VerifyOtpState {}

class VerifyOtpFail extends VerifyOtpState {
  final String message;
  final String code;

  VerifyOtpFail(this.message, this.code);
}

class LoginSuccessState extends VerifyOtpState {
  final Driver driver;

  LoginSuccessState({required this.driver});
}

class LoginFailState extends VerifyOtpState {
  final String message;
  final String errorCode;

  LoginFailState(this.message, this.errorCode);
}
