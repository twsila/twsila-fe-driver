part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionEvent {}

class changeTripStatus extends TripExecutionEvent {
  final TripStatus tripStatus;

  changeTripStatus(this.tripStatus);
}
