import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_model.dart';

part 'search_trips_event.dart';

part 'search_trips_state.dart';

class SearchTripsBloc extends Bloc<SearchTripsEvent, SearchTripsState> {
  TripsUseCase tripsUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  SearchTripsBloc({required this.tripsUseCase}) : super(SearchTripsInitial()) {
    on<GetTripsTripModuleId>(_getTripsByModuleId);
  }

  FutureOr<void> _getTripsByModuleId(
      GetTripsTripModuleId event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());
    (await tripsUseCase.execute(TripsInput(
            event.tripTypeId, _appPreferences.getCachedDriver()?.id ?? -1)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(SearchTripsFailure(
                      failure.message, failure.code.toString()))
                }, (trips) async {
      // right -> data (success)
      // content
      // emit success state

      emit(SearchTripsSuccess(trips));
    });
  }
}
