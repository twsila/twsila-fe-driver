part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionState {}

class TripExecutionInitial extends TripExecutionState {}

class TripExecutionLoading extends TripExecutionState {}

class TripExecutionSuccess extends TripExecutionState {}

class TripStatusChangedSuccess extends TripExecutionState {}

class TripCurrentStepSuccess extends TripExecutionState {
  final TripStatusStepModel tripStatusStepModel;

  TripCurrentStepSuccess(this.tripStatusStepModel);
}

class TripSummarySuccess extends TripExecutionState {
  final TripDetailsModel tripDetailsModel;

  TripSummarySuccess(this.tripDetailsModel);
}

class TripExecutionFail extends TripExecutionState {
  final String message;

  TripExecutionFail(this.message);
}
