import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/trip_details_model.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_status_step_model.dart';
import '../../../domain/usecase/trip_summary_usecase.dart';
import '../../../utils/ext/enums.dart';

part 'trip_execution_event.dart';

part 'trip_execution_state.dart';

class TripExecutionBloc extends Bloc<TripExecutionEvent, TripExecutionState> {
  ChangeTripStatusUseCase changeTripStatusUseCase;
  TripSummaryUseCase tripSummaryUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  static List<TripStatusStepModel> tripStatusSteps = [
    TripStatusStepModel(0, TripStatus.WAIT_FOR_TAKEOFF.name),
    TripStatusStepModel(1, TripStatus.TAKEOFF.name),
    TripStatusStepModel(2, TripStatus.EXECUTED.name),
    TripStatusStepModel(3, TripStatus.COMPLETED.name),
  ];

  TripExecutionBloc(
      {required this.changeTripStatusUseCase, required this.tripSummaryUseCase})
      : super(TripExecutionInitial()) {
    on<getTripStatusForStepper>(_getTripStatusForStepper);
    on<changeTripStatus>(_changeTripStatus);
    on<getTripSummary>(_getTripSummary);
  }

  FutureOr<void> _changeTripStatus(
      changeTripStatus event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    TripStatusStepModel nextStep = await _getNextStep(event.tripDetailsModel);
    (await changeTripStatusUseCase.execute(ChangeTripStatusUseCaseInput(
            _appPreferences.getCachedDriver()?.id ?? 0,
            event.tripDetailsModel.tripDetails.tripId!,
            nextStep.tripStatus)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(TripExecutionFail(failure.message))
                }, (tripStatusResponse) async {
      // right -> data (success)
      // content
      // emit success state
      emit(TripStatusChangedSuccess());
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _getTripSummary(
      getTripSummary event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    (await tripSummaryUseCase.execute(TripSummaryInput(
            _appPreferences.getCachedDriver()?.id ?? -1, event.tripId)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(TripExecutionFail(failure.message))
                }, (tripModel) async {
      // right -> data (success)
      // content
      // emit success state
      emit(TripSummarySuccess(tripModel));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _getTripStatusForStepper(
      getTripStatusForStepper event, Emitter<TripExecutionState> emit) async {
    emit(TripExecutionLoading());
    try {
      TripStatusStepModel tripStatusStepModel = tripStatusSteps.singleWhere(
          (element) =>
              element.tripStatus ==
              event.tripDetailsModel.tripDetails.tripStatus);

      emit(TripCurrentStepSuccess(tripStatusStepModel));
    } catch (e) {
      emit(TripCurrentStepSuccess(tripStatusSteps.first));
    }
  }

  Future<TripStatusStepModel> _getNextStep(
      TripDetailsModel tripDetailsModel) async {
    String tripStatus = tripDetailsModel.tripDetails.tripStatus!;
    try {
      TripStatusStepModel currentStep = tripStatusSteps
          .firstWhere((tripStep) => tripStep.tripStatus == tripStatus);

      if (currentStep.stepIndex == 3) {
        return currentStep;
      } else {
        TripStatusStepModel nextStep = tripStatusSteps.firstWhere(
            (tripStep) => tripStep.stepIndex == currentStep.stepIndex + 1);
        return nextStep;
      }
    } catch (e) {
      return tripStatusSteps.first;
    }
  }
}
