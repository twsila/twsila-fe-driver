part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailState extends LoginState {}

class LoginIsAllInputValid extends LoginState {}

class LoginIsAllInputNotValid extends LoginState {}
