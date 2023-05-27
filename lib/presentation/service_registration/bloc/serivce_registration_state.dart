part of 'serivce_registration_bloc.dart';

@immutable
abstract class ServiceRegistrationState {}

class ServiceRegistrationInitial extends ServiceRegistrationState {}

class ServiceRegistrationLoading extends ServiceRegistrationState {}

class ServiceRegistrationSuccess extends ServiceRegistrationState {}

class ServiceRegistrationFail extends ServiceRegistrationState {}

class ServicesTypesSuccess extends ServiceRegistrationState {
  final ServiceTypeModel serviceTypeModel;

  ServicesTypesSuccess(this.serviceTypeModel);
}

class ServicesTypesFail extends ServiceRegistrationState {
  final String message;

  ServicesTypesFail(this.message);
}
