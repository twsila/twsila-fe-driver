part of 'trip_details_bloc.dart';

@immutable
abstract class TripDetailsEvent {}

class AcceptOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;

  AcceptOffer(this.userId, this.tripId);
}

class AddOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;
  final double driverOffer;

  AddOffer(this.userId, this.tripId, this.driverOffer);
}

class GetTripSummary extends TripDetailsEvent {
  final int userId;
  final int tripId;

  GetTripSummary(this.userId, this.tripId);
}
