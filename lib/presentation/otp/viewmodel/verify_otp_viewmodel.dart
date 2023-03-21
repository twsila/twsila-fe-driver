import 'dart:async';

import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/domain/usecase/verify_otp_usecase.dart';
import 'package:taxi_for_you/presentation/base/baseviewmodel.dart';

import '../../../domain/model/models.dart';
import '../../../domain/usecase/generate_otp_usecase.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class VerifyOTPViewModel extends BaseViewModel
    with VerifyOTPViewModelInputs, VerifyOTPViewModelOutputs {
  // stream controllers outputs
  StreamController phoneNumberStreamController =
      StreamController<String>.broadcast();
  StreamController codeStreamController = StreamController<String>.broadcast();

  StreamController isCodeIsSentStreamController = StreamController<bool>();

  StreamController isCodeIsVerifiedStreamController = StreamController<bool>();

  GenerateOtpUseCase _generateOtpUseCase;
  VerifyOtpUseCase _verifyOtpUseCase;
  GenerateOtpUseCaseInput generateOtpUseCaseInput = GenerateOtpUseCaseInput("");
  VerifyOtpUseCaseInput verifyOtpUseCaseInput = VerifyOtpUseCaseInput("", "");
  static FirebaseCodeSent firebaseCodeSent = FirebaseCodeSent("", 0);
  static String phoneNumber = "";

  VerifyOTPViewModel(this._generateOtpUseCase, this._verifyOtpUseCase);

  //OnBoarding ViewModel Inputs
  @override
  void dispose() {
    phoneNumberStreamController.close();
    codeStreamController.close();
    isCodeIsSentStreamController.close();
    isCodeIsVerifiedStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  generateOtp() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    (await _generateOtpUseCase.execute(
            GenerateOtpUseCaseInput(generateOtpUseCaseInput.phoneNumber)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      isCodeIsSentStreamController.add(true);
    });
  }

  @override
  Sink get inputCode => codeStreamController.sink;

  @override
  Sink get inputPhoneNumber => phoneNumberStreamController.sink;

  @override
  Stream<bool> get outputIsCodeSent =>
      isCodeIsSentStreamController.stream.map((isCodeIsSent) => isCodeIsSent);

  @override
  Stream<bool> get outputIsCodeVerified =>
      isCodeIsVerifiedStreamController.stream
          .map((isCodeIsVerified) => isCodeIsVerified);

  @override
  verifyOtp() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    (await _verifyOtpUseCase.execute(VerifyOtpUseCaseInput(
            verifyOtpUseCaseInput.verificationId, verifyOtpUseCaseInput.code)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      isCodeIsVerifiedStreamController.add(true);
    });
  }

  @override
  setCode(String code) {
    inputCode.add(code);
    verifyOtpUseCaseInput.code = code;
  }

  @override
  setPhoneNumber(String phoneNumber) {
    inputPhoneNumber.add(phoneNumber);
    generateOtpUseCaseInput.phoneNumber = phoneNumber;
  }
}

// inputs mean that "Orders" that our view model will receive from view
abstract class VerifyOTPViewModelInputs {
  Sink get inputPhoneNumber;

  Sink get inputCode;

  setPhoneNumber(String phoneNumber);

  setCode(String code);

  generateOtp();

  verifyOtp();
}

abstract class VerifyOTPViewModelOutputs {
  Stream<bool> get outputIsCodeSent;

  Stream<bool> get outputIsCodeVerified;
}
