import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/app/app_prefs.dart';

import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../domain/usecase/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AppPreferences appPreferences = instance<AppPreferences>();

  LoginBloc() : super(LoginInitial()) {
    on<CheckInputIsValidEvent>(_checkInputStatus);
    on<MakeLoginEvent>(_makeLogin);
    on<MakeLoginBOEvent>(_makeBOLogin);
  }

  FutureOr<void> _makeLogin(
      MakeLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    LoginUseCase loginUseCase = instance<LoginUseCase>();
    UserDevice userDevice = await setUserDevice();
    (await loginUseCase.execute(
      LoginUseCaseInput(
        event.login,
        userDevice.toJson(),
      ),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(LoginFailState(failure.message, failure.code.toString()))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen
      print(driverModel);
      emit(LoginSuccessState(driver: driverModel));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _makeBOLogin(
      MakeLoginBOEvent event, Emitter<LoginState> emit) async {
    LoginBOUseCase loginBOUseCase = instance<LoginBOUseCase>();
    emit(LoginLoadingState());
    UserDevice userDevice = await setUserDevice();
    (await loginBOUseCase.execute(
      LoginBOUseCaseInput(
        event.login,
        userDevice.toJson(),
      ),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(LoginFailState(failure.message, failure.code.toString()))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      emit(LoginSuccessState(driver: driverModel));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _checkInputStatus(
      CheckInputIsValidEvent event, Emitter<LoginState> emit) async {
    if (event.input.length >= 6) {
      emit(LoginIsAllInputValid());
    } else {
      emit(LoginIsAllInputNotValid());
    }
  }

  Future<UserDevice> setUserDevice() async {
    late UserDevice userDevice;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String token = await appPreferences.getFCMToken() ?? '1';

    if (Platform.isIOS) {
      userDevice = UserDevice(
        deviceOs: 'iPhone',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    } else {
      userDevice = UserDevice(
        deviceOs: 'Android',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    }

    return userDevice;
  }
}
