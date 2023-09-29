import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';

part 'my_profile_event.dart';

part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  LogoutUseCase logoutUseCase;

  final AppPreferences _appPreferences = instance<AppPreferences>();

  MyProfileBloc({required this.logoutUseCase}) : super(MyProfileInitial()) {
    on<logoutEvent>(_makeLogout);
  }

  FutureOr<void> _makeLogout(
      logoutEvent event, Emitter<MyProfileState> emit) async {
    emit(MyProfileLoading());
    (await logoutUseCase.execute(LogoutUseCaseInput(
            _appPreferences.getCachedDriver()!.id!,
            _appPreferences.getCachedDriver()!.userDevice!.registrationId!,
            _appPreferences.getAppLanguage())))
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
