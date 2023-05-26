part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent {}

class GetServiceTypes extends RegistrationEvent {
  GetServiceTypes();
}
