import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/generate_otp_usecase.dart';
import 'package:taxi_for_you/domain/usecase/login_usecase.dart';
import 'package:taxi_for_you/domain/usecase/verify_otp_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpUseCase verifyOtpUseCase;
  GenerateOtpUseCase generateOtpUseCase;
  LoginUseCase loginUseCase;

  final AppPreferences _appPreferences = instance<AppPreferences>();

  VerifyOtpBloc(
      {required this.verifyOtpUseCase,
      required this.generateOtpUseCase,
      required this.loginUseCase})
      : super(VerifyOtpInitial()) {
    on<SendOtpEvent>(_sendOtp);
    on<ReSendOtpEvent>(_reSendOtp);
    on<VerifyOtpBEEvent>(_verifyOtp);
    on<MakeLoginEvent>(_makeLogin);
  }

  FutureOr<void> _sendOtp(
      SendOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());

    (await generateOtpUseCase
            .execute(GenerateOtpUseCaseInput(event.mobileNumber)))
        .fold(
            (failure) => {
                  emit(
                      GenerateOtpFail(failure.message, failure.code.toString()))
                }, (generateOtp) {
      emit(GenerateOtpSuccess(generateOtp.result.otp));
    });
  }

  FutureOr<void> _reSendOtp(
      ReSendOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    (await generateOtpUseCase
            .execute(GenerateOtpUseCaseInput(event.mobileNumber)))
        .fold(
            (failure) => {
                  emit(
                      GenerateOtpFail(failure.message, failure.code.toString()))
                }, (generateOtp) {
      emit(GenerateOtpSuccess(generateOtp.result.otp));
    });
  }

  FutureOr<void> _verifyOtp(
      VerifyOtpBEEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    (await verifyOtpUseCase
            .execute(VerifyOtpUseCaseInput(event.mobileNumber, event.otpCode)))
        .fold(
            (failure) => {
                  emit(VerifyOtpFail(failure.message, failure.code.toString()))
                }, (generateOtp) {

      emit(VerifyOtpSuccess());
    });
  }

  FutureOr<void> _makeLogin(
      MakeLoginEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    (await loginUseCase.execute(LoginUseCaseInput(
            event.mobileNumber, event.appLanguage, {
      "registrationId": "asda8sd84asd",
      "deviceOs": "android",
      "appVersion": "2.3,23"
    })))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(LoginFailState(failure.message, failure.code.toString()))
                }, (driverModel) {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      // _appPreferences.setUserLoggedIn();
      // _appPreferences.setDriver(driverModel);
      emit(LoginSuccessState(driver: driverModel));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}
