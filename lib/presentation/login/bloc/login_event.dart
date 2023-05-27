part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class MakeLoginEvent extends LoginEvent {
  String mobileNumber;
  String appLanguage;
  MakeLoginEvent(this.mobileNumber,this.appLanguage);
}

class CheckInputIsValidEvent extends LoginEvent {
  final String input;

  CheckInputIsValidEvent(this.input);
}
