part of 'my_trips_bloc.dart';

@immutable
abstract class MyTripsEvent {}
class GetTripsTripModuleId extends MyTripsEvent {
  final int tripTypeId;

  GetTripsTripModuleId(this.tripTypeId);
}
