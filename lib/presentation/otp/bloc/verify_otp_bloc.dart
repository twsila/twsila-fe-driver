import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/generate_otp_usecase.dart';
import 'package:taxi_for_you/domain/usecase/login_usecase.dart';
import 'package:taxi_for_you/domain/usecase/verify_otp_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<SendOtpEvent>(_sendOtp);
    on<ReSendOtpEvent>(_reSendOtp);
    on<VerifyOtpBEEvent>(_verifyOtp);
  }

  FutureOr<void> _sendOtp(
      SendOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    GenerateOtpUseCase generateOtpUseCase = instance<GenerateOtpUseCase>();
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
    GenerateOtpUseCase generateOtpUseCase = instance<GenerateOtpUseCase>();
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
    VerifyOtpUseCase verifyOtpUseCase = instance<VerifyOtpUseCase>();
    emit(VerifyOtpLoading());
    (await verifyOtpUseCase.execute(VerifyOtpUseCaseInput(
            event.mobileNumber, event.otpCode, event.generatedOtp)))
        .fold(
            (failure) => {
                  emit(VerifyOtpFail(failure.message, failure.code.toString()))
                }, (generateOtp) {
      emit(VerifyOtpSuccess());
    });
  }
}
