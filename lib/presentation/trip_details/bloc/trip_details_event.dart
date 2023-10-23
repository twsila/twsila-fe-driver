part of 'trip_details_bloc.dart';

@immutable
abstract class TripDetailsEvent {}

class AcceptOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;
  final String captainType;

  AcceptOffer(this.userId, this.tripId, this.captainType);
}

class AddOffer extends TripDetailsEvent {
  final int userId;
  final int tripId;
  final double driverOffer;
  final String captainType;

  AddOffer(this.userId, this.tripId, this.driverOffer, this.captainType);
}

class GetTripSummary extends TripDetailsEvent {
  final int userId;
  final int tripId;

  GetTripSummary(this.userId, this.tripId);
}
