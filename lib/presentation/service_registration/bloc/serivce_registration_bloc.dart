import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/ServiceTypeModel.dart';
import '../../../domain/usecase/registration_services_usecase.dart';

part 'serivce_registration_event.dart';

part 'serivce_registration_state.dart';

class ServiceRegistrationBloc
    extends Bloc<ServiceRegistrationEvent, ServiceRegistrationState> {
  RegistrationServiceUseCase registrationServiceUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  ServiceRegistrationBloc({required this.registrationServiceUseCase})
      : super(ServiceRegistrationInitial()) {
    on<GetServiceTypes>(_getServicesTypes);
  }

  FutureOr<void> _getServicesTypes(
      GetServiceTypes event, Emitter<ServiceRegistrationState> emit) async {
    emit(ServiceRegistrationLoading());
    (await registrationServiceUseCase
            .execute(RegistrationServiceUseCaseInput()))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(ServicesTypesFail(failure.message))
                }, (serviceTypes) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      emit(ServicesTypesSuccess(serviceTypes));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}
