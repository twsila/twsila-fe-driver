part of 'search_trips_bloc.dart';

@immutable
abstract class SearchTripsState {}

class SearchTripsInitial extends SearchTripsState {}

class SearchTripsLoading extends SearchTripsState {}

class SearchTripsSuccess extends SearchTripsState {
  final List<TripModel> trips;

  SearchTripsSuccess(this.trips);
}

class SearchTripsFailure extends SearchTripsState {
  String message;
  String code;

  SearchTripsFailure(this.message, this.code);
}
