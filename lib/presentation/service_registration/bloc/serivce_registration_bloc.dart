import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/car_brands_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/ServiceTypeModel.dart';
import '../../../domain/model/car_brand_models_model.dart';
import '../../../domain/usecase/registration_services_usecase.dart';

part 'serivce_registration_event.dart';

part 'serivce_registration_state.dart';

class ServiceRegistrationBloc
    extends Bloc<ServiceRegistrationEvent, ServiceRegistrationState> {
  RegistrationServiceUseCase registrationServiceUseCase;
  CarBrandsAndModelsUseCase carBrandsAndModelsUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  ServiceRegistrationBloc(
      {required this.registrationServiceUseCase,
      required this.carBrandsAndModelsUseCase})
      : super(ServiceRegistrationInitial()) {
    on<GetServiceTypes>(_getServicesTypes);
    on<GetCarBrandAndModel>(_getCarBrandsAndModels);
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
                }, (serviceTypeList) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      emit(ServicesTypesSuccess(serviceTypeList));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _getCarBrandsAndModels(
      GetCarBrandAndModel event, Emitter<ServiceRegistrationState> emit) async {
    emit(ServiceRegistrationLoading());
    (await carBrandsAndModelsUseCase.execute(CarBrandsAndModelsUseCaseInput()))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(CarBrandsAndModelsFail(failure.message))
                }, (carModelsList) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      emit(CarBrandsAndModelsSuccess(carModelsList));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}
