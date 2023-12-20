import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../utils/resources/constants_manager.dart';

part 'my_profile_event.dart';

part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  MyProfileBloc() : super(MyProfileInitial()) {
    on<logoutEvent>(_makeLogout);
  }

  FutureOr<void> _makeLogout(
      logoutEvent event, Emitter<MyProfileState> emit) async {
    emit(MyProfileLoading());
    LogoutUseCase logoutUseCase = instance<LogoutUseCase>();
    BoLogoutUseCase boLogoutUseCase = instance<BoLogoutUseCase>();
    if (_appPreferences.getCachedDriver()!.captainType ==
        RegistrationConstants.captain) {
      (await logoutUseCase.execute(LogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) => {
                    // left -> failure
                    //emit failure state

                    emit(MyProfileFail(failure.message))
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    } else {
      (await boLogoutUseCase.execute(BoLogoutUseCaseInput(
              _appPreferences.getCachedDriver()!.refreshToken!)))
          .fold(
              (failure) => {
                    // left -> failure
                    //emit failure state

                    emit(MyProfileFail(failure.message))
                  }, (logoutModel) async {
        // right -> data (success)
        _appPreferences.removeCachedDriver();
        _appPreferences.setUserLoggedOut(event.context);
        emit(LoggedOutSuccessfully());
      });
    }
  }
}
