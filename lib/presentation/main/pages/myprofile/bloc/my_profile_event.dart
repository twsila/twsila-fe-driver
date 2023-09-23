part of 'my_profile_bloc.dart';

@immutable
abstract class MyProfileEvent {}

class logoutEvent extends MyProfileEvent {
  final BuildContext context;
  logoutEvent(this.context);
}
