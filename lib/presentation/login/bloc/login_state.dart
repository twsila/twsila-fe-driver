part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  Driver driver;

  LoginSuccessState({required this.driver});
}

class LoginFailState extends LoginState {
  String message;

  LoginFailState(this.message);
}

class LoginIsAllInputValid extends LoginState {}

class LoginIsAllInputNotValid extends LoginState {}
