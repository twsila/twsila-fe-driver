part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}
class RegistrationFail extends RegistrationState {
  final String message;

  RegistrationFail(this.message);
}

