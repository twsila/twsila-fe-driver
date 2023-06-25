part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsEvent {}

class GetTripsTripModuleId extends SearchTripsEvent {
  final int tripTypeId;

  GetTripsTripModuleId(this.tripTypeId);
}
