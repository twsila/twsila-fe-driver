part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class ServicesTypesSuccess extends RegistrationState {
  final ServiceTypeModel serviceTypeModel;

  ServicesTypesSuccess(this.serviceTypeModel);
}
class RegistrationFail extends RegistrationState {}

