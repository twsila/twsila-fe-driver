part of 'trip_execution_bloc.dart';

@immutable
abstract class TripExecutionState {}

class TripExecutionInitial extends TripExecutionState {}

class TripExecutionLoading extends TripExecutionState {}

class TripExecutionSuccess extends TripExecutionState {}

class TripExecutionFail extends TripExecutionState {
  final String message;

  TripExecutionFail(this.message);
}
