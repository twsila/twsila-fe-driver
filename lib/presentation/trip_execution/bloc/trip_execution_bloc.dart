import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trip_execution_event.dart';
part 'trip_execution_state.dart';

class TripExecutionBloc extends Bloc<TripExecutionEvent, TripExecutionState> {
  TripExecutionBloc() : super(TripExecutionInitial()) {
    on<TripExecutionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
