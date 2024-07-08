import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_driver_event.dart';
part 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  UpdateDriverBloc() : super(UpdateDriverInitial()) {
    on<UpdateDriverEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
