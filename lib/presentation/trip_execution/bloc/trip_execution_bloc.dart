import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/ext/enums.dart';

part 'trip_execution_event.dart';

part 'trip_execution_state.dart';

class TripExecutionBloc extends Bloc<TripExecutionEvent, TripExecutionState> {
  ChangeTripStatusUseCase changeTripStatusUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  TripExecutionBloc({required this.changeTripStatusUseCase})
      : super(TripExecutionInitial()) {
    on<changeTripStatus>(_changeTripStatus);
  }

  FutureOr<void> _changeTripStatus(
      changeTripStatus event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    (await changeTripStatusUseCase.execute(ChangeTripStatusUseCaseInput(
            _appPreferences.getCachedDriver()?.id ?? 0,
            event.tripId,
            event.tripStatus.name.toString())))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(TripExecutionFail(failure.message))
                }, (tripStatusResponse) async {
      // right -> data (success)
      // content
      // emit success state
      emit(TripExecutionSuccess());
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}
