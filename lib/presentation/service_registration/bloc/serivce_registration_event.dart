part of 'serivce_registration_bloc.dart';

@immutable
abstract class ServiceRegistrationEvent {}

class GetServiceTypes extends ServiceRegistrationEvent {
  GetServiceTypes();
}
