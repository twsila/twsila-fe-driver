part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionEvent {}

class changeTripStatus extends TripExecutionEvent {
  final TripDetailsModel tripDetailsModel;

  changeTripStatus(this.tripDetailsModel);
}

class getTripSummary extends TripExecutionEvent {
  final int tripId;

  getTripSummary(this.tripId);
}

class getTripStatusForStepper extends TripExecutionEvent {
  final TripDetailsModel tripDetailsModel;

  getTripStatusForStepper({required this.tripDetailsModel});
}
