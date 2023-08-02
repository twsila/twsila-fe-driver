import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/model/trip_model.dart';
import '../../../../../domain/usecase/trips_usecase.dart';

part 'my_trips_event.dart';

part 'my_trips_state.dart';

class MyTripsBloc extends Bloc<MyTripsEvent, MyTripsState> {
  TripsUseCase tripsUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  MyTripsBloc({required this.tripsUseCase}) : super(MyTripsInitial()) {
    on<GetTripsTripModuleId>(_getTripsByModuleId);
  }

  FutureOr<void> _getTripsByModuleId(
      GetTripsTripModuleId event, Emitter<MyTripsState> emit) async {
    emit(MyTripsLoading());
    (await tripsUseCase.execute(TripsInput(
            event.tripTypeId, _appPreferences.getCachedDriver()?.id ?? -1)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(MyTripsFailure(failure.message, failure.code.toString()))
                }, (trips) async {
      // right -> data (success)
      // content
      // emit success state

      emit(MyTripsSuccess(trips));
    });
  }
}
