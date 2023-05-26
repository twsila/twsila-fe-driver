import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/ServiceTypeModel.dart';
import '../../../domain/usecase/registration_services_usecase.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationServiceUseCase registrationServiceUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  RegistrationBloc({required this.registrationServiceUseCase})
      : super(RegistrationInitial()) {
    on<GetServiceTypes>(_getServicesTypes);
  }

  FutureOr<void> _getServicesTypes(
      GetServiceTypes event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    (await registrationServiceUseCase
            .execute(RegistrationServiceUseCaseInput()))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  // emit(LoginFailState(failure.message))
                }, (driverModel) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      RegistrationFail();
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}
