import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rate_passenger_event.dart';
part 'rate_passenger_state.dart';

class RatePassengerBloc extends Bloc<RatePassengerEvent, RatePassengerState> {
  RatePassengerBloc() : super(RatePassengerInitial()) {
    on<RatePassengerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
