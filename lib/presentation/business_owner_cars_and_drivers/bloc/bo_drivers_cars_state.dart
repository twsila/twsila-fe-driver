part of 'bo_drivers_cars_bloc.dart';

@immutable
abstract class BoDriversCarsState {}

class BoDriversCarsInitial extends BoDriversCarsState {}

class BoDriversCarsLoading extends BoDriversCarsState {}

class BoDriversCarsSuccess extends BoDriversCarsState {
  final BaseResponse baseResponse;

  BoDriversCarsSuccess(this.baseResponse);
}

class SearchDriversSuccess extends BoDriversCarsState {
  final List<Driver> drivers;

  SearchDriversSuccess(this.drivers);
}

class AddDriversSuccess extends BoDriversCarsState {
  AddDriversSuccess();
}

class BoDriversCarsFail extends BoDriversCarsState {
  final String message;
  final String code;

  BoDriversCarsFail(this.message, this.code);
}

class SearchDriversFail extends BoDriversCarsState {
  final String message;
  final String code;

  SearchDriversFail(this.message, this.code);
}
class AddDriverFail extends BoDriversCarsState {
  final String message;
  final String code;

  AddDriverFail(this.message, this.code);
}
