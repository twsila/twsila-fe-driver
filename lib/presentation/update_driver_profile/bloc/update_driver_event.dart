part of 'update_driver_bloc.dart';

@immutable
abstract class UpdateDriverEvent {}

class splitAndOrganizeImagesList extends UpdateDriverEvent {
  final List<DriverImage> driverImagesList;

  splitAndOrganizeImagesList({required this.driverImagesList});
}
