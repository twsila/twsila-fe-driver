part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class MakeLoginEvent extends LoginEvent {
  String mobileNumber;
  MakeLoginEvent(this.mobileNumber);
}

class CheckInputIsValidEvent extends LoginEvent {
  final String input;

  CheckInputIsValidEvent(this.input);
}
