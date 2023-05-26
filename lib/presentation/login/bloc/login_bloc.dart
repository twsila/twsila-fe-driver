import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/presentation/common/state_renderer/state_renderer.dart';
import 'package:taxi_for_you/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../domain/usecase/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginUseCase loginUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<CheckInputIsValidEvent>(_checkInputStatus);
    on<MakeLoginEvent>(_makeLogin);
  }

  FutureOr<void> _makeLogin(
      MakeLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
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

                  emit(LoginFailState(failure.message))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      LoginSuccessState(driver: driverModel);
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
}
