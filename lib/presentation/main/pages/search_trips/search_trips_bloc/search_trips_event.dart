part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsEvent {}

class GetTripsTripModuleId extends SearchTripsEvent {
  final String tripTypeId;
  final DateFilter? dateFilter;
  final LocationFilter? locationFilter;
  final CurrentLocationFilter? currentLocation;
  final String? sortCriterion;

  GetTripsTripModuleId(
      {required this.tripTypeId,
      this.dateFilter,
      this.locationFilter,
      this.currentLocation,
      this.sortCriterion});
}

class getLookups extends SearchTripsEvent {
  getLookups();
}
