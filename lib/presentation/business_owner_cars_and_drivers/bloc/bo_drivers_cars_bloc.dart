import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/usecase/add_driver_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/get_business_owner_drivers_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../domain/usecase/search_driver_mobile_usecase.dart';

part 'bo_drivers_cars_event.dart';

part 'bo_drivers_cars_state.dart';

class BoDriversCarsBloc extends Bloc<BoDriversCarsEvent, BoDriversCarsState> {
  BusinessOwnerDriversUseCase businessOwnerDriversUseCase;
  SearchDriversByMobileUseCase searchDriversByMobileUseCase;
  AddDriverForBOUseCase addDriverForBOUseCase;
  final AppPreferences appPreferences;

  BoDriversCarsBloc(
      {required this.businessOwnerDriversUseCase,
      required this.appPreferences,
      required this.searchDriversByMobileUseCase,
      required this.addDriverForBOUseCase})
      : super(BoDriversCarsInitial()) {
    on<GetDriversAndCars>(_getDriversAndCars);
    on<SearchDriversByMobile>(_searchDriversByMobile);
    on<addDriverForBusinessOwner>(_addDriverForBusinessOwner);
  }

  FutureOr<void> _getDriversAndCars(
      GetDriversAndCars event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    (await businessOwnerDriversUseCase.execute(
      BusinessOwnerDriversUseCaseInput(
          appPreferences.getCachedDriver()?.id ?? 0),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(BoDriversCarsFail(
                      failure.message, failure.code.toString()))
                }, (baseResponse) async {
      // right -> data (success)
      // content
      // emit success state

      emit(BoDriversCarsSuccess(baseResponse));
    });
  }

  FutureOr<void> _searchDriversByMobile(
      SearchDriversByMobile event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    (await searchDriversByMobileUseCase.execute(
      SearchDriversByMobileUseCaseInput(event.mobileNumber),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(SearchDriversFail(
                      failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      emit(SearchDriversSuccess(driversList));
    });
  }

  FutureOr<void> _addDriverForBusinessOwner(
      addDriverForBusinessOwner event, Emitter<BoDriversCarsState> emit) async {
    emit(BoDriversCarsLoading());
    (await addDriverForBOUseCase.execute(
      AddDriverForBOUseCaseInput(event.businessOwnerId, event.driverId),
    ))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(AddDriverFail(failure.message, failure.code.toString()))
                }, (driversList) async {
      // right -> data (success)
      // content
      // emit success state
      emit(AddDriversSuccess());
    });
  }
}
