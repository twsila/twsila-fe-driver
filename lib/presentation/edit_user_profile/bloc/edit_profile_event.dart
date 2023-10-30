part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileDataEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final File? profilePhoto;

  EditProfileDataEvent(
      this.firstName, this.lastName, this.email, this.profilePhoto);
}
