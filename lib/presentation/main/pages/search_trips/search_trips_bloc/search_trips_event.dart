part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsEvent {}

class GetTripsTripModuleId extends SearchTripsEvent {
  final String tripTypeId;

  GetTripsTripModuleId(this.tripTypeId);
}

class getLookups extends SearchTripsEvent {
  getLookups();
}
