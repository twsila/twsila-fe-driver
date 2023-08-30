part of 'rate_passenger_bloc.dart';

@immutable
abstract class RatePassengerEvent {}

class RatePassenger extends RatePassengerEvent {
  final int passengerId;
  final double rateNumber;

  RatePassenger(this.passengerId, this.rateNumber);
}
