import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../utils/ext/enums.dart';

part 'trip_execution_event.dart';

part 'trip_execution_state.dart';

class TripExecutionBloc extends Bloc<TripExecutionEvent, TripExecutionState> {
  TripExecutionBloc() : super(TripExecutionInitial()) {
    on<changeTripStatus>(_changeTripStatus);
  }

  FutureOr<void> _changeTripStatus(changeTripStatus event,
      Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    //   (await carBrandsAndModelsUseCase.execute(CarBrandsAndModelsUseCaseInput()))
    //       .fold(
    //           (failure) => {
    //         // left -> failure
    //         //emit failure state
    //
    //         emit(CarBrandsAndModelsFail(failure.message))
    //       }, (carModelsList) async {
    //     // right -> data (success)
    //     // content
    //     // emit success state
    //     // navigate to main screen
    //     print(registrationRequest.vehicleTypeId);
    //     emit(CarBrandsAndModelsSuccess(carModelsList));
    //     // isUserLoggedInSuccessfullyStreamController.add(true);
    //   });
    // }
  }
}